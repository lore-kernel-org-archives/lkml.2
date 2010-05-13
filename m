Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0EMCaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:30:07 -0400
Received: from sous-sol.org ([216.99.217.87]:42042 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542Ab0EMCaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:30:04 -0400
Date: Wed, 12 May 2010 18:29:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: greg@kroah.com, jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: [PATCH 2/2] pci: allow sysfs file owner to read device dependent
 config space
Message-ID: <20100513012957.GB28034@sequoia.sous-sol.org>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513012857.GA28034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
check to verify privileges before allowing a user to read device
dependent config space.  This is meant to protect from an unprivileged
user potentially locking up the box.

When assigning a PCI device directly to a guest with libvirt and KVM,
the sysfs config space file is chown'd to the unprivileged user that
the KVM guest will run as.  The guest needs to have full access to the
device's config space since it's responsible for driving the device.
However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
check will not allow read access beyond the config header.

With this patch the sysfs file owner is also considered privileged enough
to read all of the config space.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/pci-sysfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index ad44557..8a6fcc0 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -21,6 +21,7 @@
 #include <linux/stat.h>
 #include <linux/topology.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
@@ -362,12 +363,13 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 		char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int size = 64;
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN)) {
+	if (capable(CAP_SYS_ADMIN) || is_owner_or_cap(inode)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
-- 
1.6.5.2

