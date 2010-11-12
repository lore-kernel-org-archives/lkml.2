Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0KLLPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:15:41 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:54836 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab0KLLPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:15:38 -0500
Subject: [PATCH 14/17] staging/vme_user: mark user-space buffers with __user
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:15:34 +0000
Message-ID: <20101112111534.11631.85228.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
[martyn.welch@ge.com: modified to remove checkpatch warnings]
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 5d3a39b..3638148 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -129,8 +129,9 @@ static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
 
 static int vme_user_open(struct inode *, struct file *);
 static int vme_user_release(struct inode *, struct file *);
-static ssize_t vme_user_read(struct file *, char *, size_t, loff_t *);
-static ssize_t vme_user_write(struct file *, const char *, size_t, loff_t *);
+static ssize_t vme_user_read(struct file *, char __user *, size_t, loff_t *);
+static ssize_t vme_user_write(struct file *, const char __user *, size_t,
+	loff_t *);
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
@@ -246,7 +247,7 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
  * page) transfers will lock the user space buffer into memory and then
  * transfer the data directly from the user space buffers out to VME.
  */
-static ssize_t resource_from_user(unsigned int minor, const char *buf,
+static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
 	size_t count, loff_t *ppos)
 {
 	ssize_t retval;
@@ -293,7 +294,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	return retval;
 }
 
-static ssize_t buffer_from_user(unsigned int minor, const char *buf,
+static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	size_t count, loff_t *ppos)
 {
 	void *image_ptr;
@@ -312,7 +313,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char *buf,
 	return retval;
 }
 
-static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
+static ssize_t vme_user_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
@@ -356,8 +357,8 @@ static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
 	return retval;
 }
 
-static ssize_t vme_user_write(struct file *file, const char *buf, size_t count,
-			 loff_t *ppos)
+static ssize_t vme_user_write(struct file *file, const char __user *buf,
+			size_t count, loff_t *ppos)
 {
 	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
 	ssize_t retval;
@@ -455,6 +456,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 	unsigned int minor = MINOR(inode->i_rdev);
 	int retval;
 	dma_addr_t pci_addr;
+	void __user *argp = (void __user *)arg;
 
 	statistics.ioctls++;
 
@@ -474,7 +476,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 				&master.size, &master.aspace,
 				&master.cycle, &master.dwidth);
 
-			copied = copy_to_user((char *)arg, &master,
+			copied = copy_to_user(argp, &master,
 				sizeof(struct vme_master));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy to "
@@ -487,8 +489,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 		case VME_SET_MASTER:
 
-			copied = copy_from_user(&master, (char *)arg,
-				sizeof(master));
+			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy from "
 					"userspace\n");
@@ -518,7 +519,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 				&slave.size, &pci_addr, &slave.aspace,
 				&slave.cycle);
 
-			copied = copy_to_user((char *)arg, &slave,
+			copied = copy_to_user(argp, &slave,
 				sizeof(struct vme_slave));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy to "
@@ -531,8 +532,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 		case VME_SET_SLAVE:
 
-			copied = copy_from_user(&slave, (char *)arg,
-				sizeof(slave));
+			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
 				printk(KERN_WARNING "Partial copy from "
 					"userspace\n");


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
