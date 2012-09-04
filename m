Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2IDPzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab2IDPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:37 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 02/11] PCI: Lock down BAR access in secure boot environments
Date: Tue,  4 Sep 2012 11:55:08 -0400
Message-Id: <1346774117-2277-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1346774117-2277-1-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any hardware that can potentially generate DMA has to be locked down from
userspace in order to avoid it being possible for an attacker to cause
arbitrary kernel behaviour. Default to paranoid - in future we can
potentially relax this for sufficiently IOMMU-isolated devices.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/pci-sysfs.c | 9 +++++++++
 drivers/pci/proc.c      | 8 +++++++-
 drivers/pci/syscall.c   | 2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 6869009..a1ad0f7 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -542,6 +542,9 @@ pci_write_config(struct file* filp, struct kobject *kobj,
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	if (off > dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
@@ -844,6 +847,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	resource_size_t start, end;
 	int i;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
 			break;
@@ -951,6 +957,9 @@ pci_write_resource_io(struct file *filp, struct kobject *kobj,
 		      struct bin_attribute *attr, char *buf,
 		      loff_t off, size_t count)
 {
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 27911b5..01d4753 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -135,6 +135,9 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	int size = dp->size;
 	int cnt;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -211,6 +214,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 #endif /* HAVE_PCI_MMAP */
 	int ret = 0;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	switch (cmd) {
 	case PCIIOC_CONTROLLER:
 		ret = pci_domain_nr(dev->bus);
@@ -251,7 +257,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	struct pci_filp_private *fpriv = file->private_data;
 	int i, ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_SECURE_FIRMWARE))
 		return -EPERM;
 
 	/* Make sure the caller is mapping a real resource for this device */
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index e1c1ec5..a778ba9 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -92,7 +92,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 	u32 dword;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SECURE_FIRMWARE))
 		return -EPERM;
 
 	dev = pci_get_bus_and_slot(bus, dfn);
-- 
1.7.11.4

