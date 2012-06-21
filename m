Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab2FUUZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760220Ab2FUUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:25:21 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 9/9] PCI: integrate 'pci_fixup_final' quirks into hot-plug
	paths
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:25:10 -0600
Message-ID: <20120621202510.16865.77324.stgit@amt.stowe>
In-Reply-To: <20120621202415.16865.6226.stgit@amt.stowe>
References: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI's final quirks (pci_fixup_final) are currently invoked by
pci_apply_final_quirk() which traverses the platform's list of PCI
devices.  The calling mechanism limits the quirk invocations to a single
instance during boot.  As such, hot-plugable devices do not have their
associated final quirks called upon hot-plug events.

This series implements a interim solution[1] to integrate pci_fixup_final
quirks into the various hot-plug event paths.

As I intend for the global variable introduced by this patch to be
temporary I purposely chose not to include its 'extern' declaration within
a header file (i.e. include/linux/pci.h).


[1] I intended to come up with a single, uniform, solution that would
satisfy both the boot path and the various hot-plug event paths with
respect to final quirks.  From an architectural perspective, the proper
placement for the final quirks is somewhere just prior to, or within, the
device_add path.

I originally started with that approach but eventually realized that there
are issues with moving the quirks into the device_add path with respect to
the boot path.  Currently, the boot path scans the PCI devices, adds the
devices, assigns resources, and then call the final quirks whereas the
hot-plug paths scan, assign resources, and then add the devices which is
better sequencing with respect to the assignment of resources and the
addition of devices.

All of this suggests that we should change PCI device setup in the boot
path to be more like hot-plug: scan, assign resources, (final fixups),
then add.  While I think that is the correct approach, and something that
we should be addressing, it will require a lot of work.  So until that
occurs, this series should serve as a stop-gap solution for the interim by
keeping the current boot path sequencing in place and then adding the
final quirk processing into the device_add path for hot-plug events via a
(temporary) global variable qualifier.

When the boot path's PCI device setup is addressed we should end up with a
single, uniform, device_add based solution for applying final quirks
by:
  o  removing 'fs_initcall_sync(pci_apply_final_quirks);',
  o  removing the global variable 'pci_fixup_final_inited' and all
     of its usages,
  o  renaming, and moving, the 'pci_cache_line_size' related code
     currently embedded in 'pci_apply_final_quirks()'.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/bus.c    |    4 ++++
 drivers/pci/quirks.c |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4ce5ef2..b511bd4 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -164,6 +164,10 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 int pci_bus_add_device(struct pci_dev *dev)
 {
 	int retval;
+	extern bool pci_fixup_final_inited;
+
+	if (pci_fixup_final_inited)
+		pci_fixup_device(pci_fixup_final, dev);
 	retval = device_add(&dev->dev);
 	if (retval)
 		return retval;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 815c009..79c3351 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3030,6 +3030,22 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_fixup_device);
 
+
+/*
+ * The global variable 'pci_fixup_final_inited' is being used as a interim
+ * solution for calling the final quirks only during hot-plug events (not
+ * during boot processing).
+ *
+ * When the boot path's PCI device setup sequencing is addressed, we can
+ * remove the instance, and usages of, 'pci_fixup_final_inited' along with
+ * removing 'fs_initcall_sync(pci_apply_final_quirks);' and end up with a
+ * single, uniform, solution that satisfies both the boot path and the
+ * various hot-plug event paths.
+ *
+ * ToDo: Remove 'pci_fixup_final_inited'
+ */
+bool pci_fixup_final_inited;
+
 static int __init pci_apply_final_quirks(void)
 {
 	struct pci_dev *dev = NULL;
@@ -3060,6 +3076,8 @@ static int __init pci_apply_final_quirks(void)
 			pci_cache_line_size = pci_dfl_cache_line_size;
 		}
 	}
+	pci_fixup_final_inited = 1;
+
 	if (!pci_cache_line_size) {
 		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
 		       cls << 2, pci_dfl_cache_line_size << 2);

