Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2JAIKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:10:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2JAIKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:10:45 -0400
Date: Mon, 1 Oct 2012 10:10:29 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v3 -tip 2/5] x86, MSI: Allocate as many multiple IRQs as
 requested
Message-ID: <c588272d963c0f73957cc4b104291f8b19e7454f.1349074231.git.agordeev@redhat.com>
References: <cover.1349074231.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1349074231.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple MSIs are enabled with pci_enable_msi_block() the number of
allocated IRQs 'nvec' is rounded up to the nearest value of power of two.
That could lead to a condition when number of requested and used IRQs is
less than number of actually allocated IRQs.

This fix introduces 'msi_desc::nvec' field to address the above issue -
when non-zero, it holds the number of allocated IRQs. Otherwise, the old
method is used.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |   16 +++++++---------
 drivers/pci/msi.c              |   10 ++++++++--
 include/linux/msi.h            |    1 +
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5cb13c..84d632b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3088,16 +3088,12 @@ static inline void destroy_irqs(unsigned int irq, unsigned int count)
 }
 
 static inline int
-can_create_pow_of_two_irqs(unsigned int from, unsigned int count)
+can_create_irqs(unsigned int from, unsigned int count)
 {
-	if ((count > 1) && (count % 2))
-		return -EINVAL;
-
-	for (; count; count = count / 2) {
+	for (; count; count = count - 1) {
 		if (!irq_can_alloc_irqs(from, count))
 			return count;
 	}
-
 	return -ENOSPC;
 }
 
@@ -3279,8 +3275,7 @@ int setup_msi_irqs(struct pci_dev *dev, int nvec)
 	if (nvec > 1 && !irq_remapping_enabled)
 		return 1;
 
-	nvec = __roundup_pow_of_two(nvec);
-	ret = can_create_pow_of_two_irqs(nr_irqs_gsi, nvec);
+	ret = can_create_irqs(nr_irqs_gsi, nvec);
 	if (ret != nvec)
 		return ret;
 
@@ -3288,11 +3283,13 @@ int setup_msi_irqs(struct pci_dev *dev, int nvec)
 	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
 	WARN_ON(msidesc->irq);
 	WARN_ON(msidesc->msi_attrib.multiple);
+	WARN_ON(msidesc->nvec);
 
 	node = dev_to_node(&dev->dev);
 	irq = __create_irqs(nr_irqs_gsi, nvec, node);
 	if (irq == 0)
 		return -ENOSPC;
+	msidesc->nvec = nvec;
 
 	if (!irq_remapping_enabled) {
 		ret = setup_msi_irq(dev, msidesc, irq, 0);
@@ -3301,7 +3298,7 @@ int setup_msi_irqs(struct pci_dev *dev, int nvec)
 		return 0;
 	}
 
-	msidesc->msi_attrib.multiple = ilog2(nvec);
+	msidesc->msi_attrib.multiple = ilog2(__roundup_pow_of_two(nvec));
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
 			index = msi_alloc_remapped_irq(dev, irq, nvec);
@@ -3329,6 +3326,7 @@ error:
 	 */
 	msidesc->irq = 0;
 	msidesc->msi_attrib.multiple = 0;
+	msidesc->nvec = 0;
 
 	return ret;
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a825d78..f0752d1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -79,7 +79,10 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 		int i, nvec;
 		if (entry->irq == 0)
 			continue;
-		nvec = 1 << entry->msi_attrib.multiple;
+		if (entry->nvec)
+			nvec = entry->nvec;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
 		for (i = 0; i < nvec; i++)
 			arch_teardown_msi_irq(entry->irq + i);
 	}
@@ -336,7 +339,10 @@ static void free_msi_irqs(struct pci_dev *dev)
 		int i, nvec;
 		if (!entry->irq)
 			continue;
-		nvec = 1 << entry->msi_attrib.multiple;
+		if (entry->nvec)
+			nvec = entry->nvec;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
 		for (i = 0; i < nvec; i++)
 			BUG_ON(irq_has_action(entry->irq + i));
 	}
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ce93a34..6f4dfba 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -35,6 +35,7 @@ struct msi_desc {
 
 	u32 masked;			/* mask bits */
 	unsigned int irq;
+	unsigned int nvec;
 	struct list_head list;
 
 	union {
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
