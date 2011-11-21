Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1KUSyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:54:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab1KUSyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:54:21 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 3/3] x86/PCI: Convert maintaining FW-assigned BIOS BAR
	values to use a list
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Mon, 21 Nov 2011 11:54:19 -0700
Message-ID: <20111121185419.9603.27982.stgit@amt.stowe>
In-Reply-To: <20111121185401.9603.34587.stgit@amt.stowe>
References: <20111121185401.9603.34587.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

This patch converts the underlying maintenance aspects of FW-assigned
BIOS BAR values from a statically allocated array within struct pci_dev
to a list of temporary, stand alone, entries.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/i386.c     |    4 +++-
 drivers/pci/setup-res.c |   24 +++++++++++++++++++++---
 include/linux/pci.h     |    1 -
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index bfb9d6a..f9bfd19 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -260,7 +260,8 @@ static void __init pcibios_allocate_resources(int pass)
 					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
 					/* We'll assign a new address later */
-					dev->fw_addr[idx] = r->start;
+					pcibios_save_fw_addr(dev,
+							idx, r->start);
 					r->end -= r->start;
 					r->start = 0;
 				}
@@ -306,6 +307,7 @@ static int __init pcibios_assign_resources(void)
 	}
 
 	pci_assign_unassigned_resources();
+	pcibios_fw_addr_list_del();
 
 	return 0;
 }
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index cdfed4f..b28750e 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -157,16 +157,34 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	return ret;
 }
 
+/*
+ * Generic function that returns a value indicating that the device's
+ * original BIOS BAR address was not saved and so is not available for
+ * reinstatement.
+ *
+ * Can be over-ridden by architecture specific code that implements
+ * reinstatement functionality rather than leaving it disabled when
+ * normal allocation attempts fail.
+ */
+resource_size_t __weak pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
+{
+	return 0;
+}
+
 static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev, 
 		int resno, resource_size_t size)
 {
 	struct resource *root, *conflict;
-	resource_size_t start, end;
+	resource_size_t fw_addr, start, end;
 	int ret = 0;
 
+	fw_addr = pcibios_retrieve_fw_addr(dev, resno);
+	if (!fw_addr)
+		return 1;
+
 	start = res->start;
 	end = res->end;
-	res->start = dev->fw_addr[resno];
+	res->start = fw_addr;
 	res->end = res->start + size - 1;
 
 	root = pci_find_parent_resource(dev, res);
@@ -270,7 +288,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	 * where firmware left it.  That at least has a chance of
 	 * working, which is better than just leaving it disabled.
 	 */
-	if (ret < 0 && dev->fw_addr[resno])
+	if (ret < 0)
 		ret = pci_revert_fw_address(res, dev, resno, size);
 
 	if (!ret) {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4545d23..273539b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -299,7 +299,6 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
-	resource_size_t	fw_addr[DEVICE_COUNT_RESOURCE]; /* FW-assigned addr */
 
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */

