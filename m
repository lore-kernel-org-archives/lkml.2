Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0JZBMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:09 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:41012 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0JZBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:07 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 16/30] staging/vme_user: mark user-space buffers with __user
Date: Mon, 25 Oct 2010 21:11:02 -0400
Message-Id: <1288055476-19438-17-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index ead30d2..a7b97be 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -129,8 +129,8 @@ static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
 
 static int vme_user_open(struct inode *, struct file *);
 static int vme_user_release(struct inode *, struct file *);
-static ssize_t vme_user_read(struct file *, char *, size_t, loff_t *);
-static ssize_t vme_user_write(struct file *, const char *, size_t, loff_t *);
+static ssize_t vme_user_read(struct file *, char __user *, size_t, loff_t *);
+static ssize_t vme_user_write(struct file *, const char __user *, size_t, loff_t *);
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
@@ -246,7 +246,7 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
  * page) transfers will lock the user space buffer into memory and then
  * transfer the data directly from the user space buffers out to VME.
  */
-static ssize_t resource_from_user(unsigned int minor, const char *buf,
+static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
 	size_t count, loff_t *ppos)
 {
 	ssize_t retval;
@@ -293,7 +293,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	return retval;
 }
 
-static ssize_t buffer_from_user(unsigned int minor, const char *buf,
+static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	size_t count, loff_t *ppos)
 {
 	void *image_ptr;
@@ -312,7 +312,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char *buf,
 	return retval;
 }
 
-static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
+static ssize_t vme_user_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
@@ -356,7 +356,7 @@ static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
 	return retval;
 }
 
-static ssize_t vme_user_write(struct file *file, const char *buf, size_t count,
+static ssize_t vme_user_write(struct file *file, const char __user *buf, size_t count,
 			 loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
@@ -455,6 +455,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 	unsigned int minor = MINOR(inode->i_rdev);
 	int retval;
 	dma_addr_t pci_addr;
+	void __user *argp = (void __user *)arg;
 
 	statistics.ioctls++;
 
@@ -474,8 +475,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 				&master.size, &master.aspace,
 				&master.cycle, &master.dwidth);
 
-			copied = copy_to_user((char *)arg, &master,
-				sizeof(struct vme_master));
+			copied = copy_to_user(argp, &master, sizeof(struct vme_master));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy to "
 					"userspace\n");
@@ -487,8 +487,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 		case VME_SET_MASTER:
 
-			copied = copy_from_user(&master, (char *)arg,
-				sizeof(master));
+			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy from "
 					"userspace\n");
@@ -518,8 +517,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 				&slave.size, &pci_addr, &slave.aspace,
 				&slave.cycle);
 
-			copied = copy_to_user((char *)arg, &slave,
-				sizeof(struct vme_slave));
+			copied = copy_to_user(argp, &slave, sizeof(struct vme_slave));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy to "
 					"userspace\n");
@@ -531,8 +529,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 		case VME_SET_SLAVE:
 
-			copied = copy_from_user(&slave, (char *)arg,
-				sizeof(slave));
+			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy from "
 					"userspace\n");
-- 
1.7.1

