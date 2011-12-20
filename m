Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1LTDUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1LTDT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:19:56 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] kvm: Device assignment permission checks
To: avi@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 19 Dec 2011 20:19:53 -0700
Message-ID: <20111220031953.11829.74427.stgit@bling.home>
In-Reply-To: <20111220030826.11829.9141.stgit@bling.home>
References: <20111220030826.11829.9141.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only allow KVM device assignment to attach to devices which:

 - Are not bridges
 - Have BAR resources (assume others are special devices)
 - The user has permissions to use

Assigning a bridge is a configuration error, it's not supported, and
typically doesn't result in the behavior the user is expecting anyway.
Devices without BAR resources are typically chipset components that
also don't have host drivers.  We don't want users to hold such devices
captive or cause system problems by fencing them off into an iommu
domain.  We determine "permission to use" by testing whether the user
has access to the PCI sysfs resource files.  By default a normal user
will not have access to these files, so it provides a good indication
that an administration agent has granted the user access to the device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/assigned-dev.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index a251a28..faec641 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/namei.h>
 #include "irq.h"
 
 static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
@@ -483,9 +484,11 @@ out:
 static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 				      struct kvm_assigned_pci_dev *assigned_dev)
 {
-	int r = 0, idx;
+	int r = 0, idx, i;
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
+	u8 header_type;
+	bool bar_found = false;
 
 	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
 		return -EINVAL;
@@ -516,6 +519,56 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 		r = -EINVAL;
 		goto out_free;
 	}
+
+	/* Don't allow bridges to be assigned */
+	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
+	if ((header_type & PCI_HEADER_TYPE) != PCI_HEADER_TYPE_NORMAL) {
+		r = -EPERM;
+		goto out_put;
+	}
+
+	/* We want to test whether the caller has been granted permissions to
+	 * use this device.  To be able to configure and control the device,
+	 * the user needs access to PCI configuration space and BAR resources.
+	 * These are accessed through PCI sysfs.  PCI config space is often
+	 * passed to the process calling this ioctl via file descriptor, so we
+	 * can't rely on access to that file.  We can check for permissions
+	 * on each of the BAR resource files, which is a pretty clear
+	 * indicator that the user has been granted access to the device. */
+	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++) {
+		char buf[64];
+		struct path path;
+		struct inode *inode;
+
+		if (!pci_resource_len(dev, i))
+			continue;
+
+		/* Per sysfs-rules, sysfs is always at /sys */
+		snprintf(buf, sizeof(buf), "/sys/bus/pci/devices/%04x:%02x:"
+			 "%02x.%d/resource%d", pci_domain_nr(dev->bus),
+			 dev->bus->number, PCI_SLOT(dev->devfn),
+			 PCI_FUNC(dev->devfn), i);
+
+		r = kern_path(buf, LOOKUP_FOLLOW, &path);
+		if (r)
+			goto out_put;
+
+		inode = path.dentry->d_inode;
+
+		r = inode_permission(inode, MAY_READ | MAY_WRITE | MAY_ACCESS);
+		path_put(&path);
+		if (r)
+			goto out_put;
+
+		bar_found = true;
+	}
+
+	/* If no resources, probably something special */
+	if (!bar_found) {
+		r = -EPERM;
+		goto out_put;
+	}
+
 	if (pci_enable_device(dev)) {
 		printk(KERN_INFO "%s: Could not enable PCI device\n", __func__);
 		r = -EBUSY;

