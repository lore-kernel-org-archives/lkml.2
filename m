Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0ELSrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:47:33 -0400
Received: from sous-sol.org ([216.99.217.87]:55672 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754771Ab0ELSrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:47:32 -0400
Date: Wed, 12 May 2010 11:47:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: greg@kroah.com, jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: [RFC PATCH] sysfs: bin_attr permission checking
Message-ID: <20100512184713.GV28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
check to verify privileges before allowing a user to read device
dependent config space.  This is meant to protect from an unprivileged
user potentially locking up the box.

When assigning a PCI device directly to a guest with libvirt and KVM, the 
sysfs config space file is chown'd to the user that the KVM guest will
run as.  The guest needs to have full access to the device's config
space since it's responsible for driving the device.  However, despite
being the owner of the sysfs file, the CAP_SYS_ADMIN check will not
allow read access beyond the config header.

This patch adds a new bin_attr->read_file() callback which adds a struct
file to the normal argument list.  This allows an implementation such as
PCI config space bin_attr read_file handler to check both inode
permission as well as privileges to determine whether to allow
privileged actions through the handler.

This is just RFC, although I've tested that it does allow the chown +
read to work as expected.  Any other ideas of how to handle this are
welcome.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/pci-sysfs.c |   13 ++++++++-----
 fs/sysfs/bin.c          |   16 +++++++++-------
 include/linux/sysfs.h   |    2 ++
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
+#include <linux/fs.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -356,16 +357,18 @@ boot_vga_show(struct device *dev, struct
 struct device_attribute vga_attr = __ATTR_RO(boot_vga);
 
 static ssize_t
-pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
-		char *buf, loff_t off, size_t count)
+pci_read_config(struct file *file, struct kobject *kobj,
+		struct bin_attribute *bin_attr, char *buf, loff_t off,
+		size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
+	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int size = 64;
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN)) {
+	if (capable(CAP_SYS_ADMIN) || is_owner_or_cap(inode)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
@@ -924,7 +927,7 @@ static struct bin_attribute pci_config_a
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = PCI_CFG_SPACE_SIZE,
-	.read = pci_read_config,
+	.read_file = pci_read_config,
 	.write = pci_write_config,
 };
 
@@ -934,7 +937,7 @@ static struct bin_attribute pcie_config_
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = PCI_CFG_SPACE_EXP_SIZE,
-	.read = pci_read_config,
+	.read_file = pci_read_config,
 	.write = pci_write_config,
 };
 
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -46,9 +46,9 @@ struct bin_buffer {
 };
 
 static int
-fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
+fill_read(struct file *file, char *buffer, loff_t off, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
@@ -58,7 +58,9 @@ fill_read(struct dentry *dentry, char *b
 		return -ENODEV;
 
 	rc = -EIO;
-	if (attr->read)
+	if (attr->read_file)
+		rc = attr->read_file(file, kobj, attr, buffer, off, count);
+	else if (attr->read)
 		rc = attr->read(kobj, attr, buffer, off, count);
 
 	sysfs_put_active_two(attr_sd);
@@ -70,8 +72,7 @@ static ssize_t
 read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	struct bin_buffer *bb = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
-	int size = dentry->d_inode->i_size;
+	int size = file->f_path.dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
@@ -92,7 +93,7 @@ read(struct file *file, char __user *use
 
 	mutex_lock(&bb->mutex);
 
-	count = fill_read(dentry, bb->buffer, offs, count);
+	count = fill_read(file, bb->buffer, offs, count);
 	if (count < 0) {
 		mutex_unlock(&bb->mutex);
 		goto out_free;
@@ -405,7 +406,8 @@ static int open(struct inode * inode, st
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
 		goto err_out;
-	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
+	if ((file->f_mode & FMODE_READ) &&
+	    !(attr->read || attr->read_file || attr->mmap))
 		goto err_out;
 
 	error = -ENOMEM;
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -66,6 +66,8 @@ struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
 	void			*private;
+	ssize_t (*read_file)(struct file *,struct kobject *, struct bin_attribute *,
+			char *, loff_t, size_t);
 	ssize_t (*read)(struct kobject *, struct bin_attribute *,
 			char *, loff_t, size_t);
 	ssize_t (*write)(struct kobject *, struct bin_attribute *,
