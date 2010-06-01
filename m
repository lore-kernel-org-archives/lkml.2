Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab0FAVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:06:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab0FAVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:04:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 6/6] usb/mon: kill BKL usage
Date: Tue,  1 Jun 2010 23:04:45 +0200
Message-Id: <1275426285-9088-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19lGFvnioH05nDtP4ZJlhy2NkqZUVNPGaeAaJk
 TBNzDIkIBPYSrLmC35d2AUJjuse5C7IJHNymlv1EQaQuYqW5D6
 vbTWiZwNgZ6GpIdtjYatg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compat_ioctl does not use the BKL, so I assume that
the native function does not need it either.

The open function is already protected by the
driver's mutex, the BKL is probably not needed
here either.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/mon/mon_bin.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 61c76b1..1be0b9f 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -646,17 +646,14 @@ static int mon_bin_open(struct inode *inode, struct file *file)
 	size_t size;
 	int rc;
 
-	lock_kernel();
 	mutex_lock(&mon_lock);
 	if ((mbus = mon_bus_lookup(iminor(inode))) == NULL) {
 		mutex_unlock(&mon_lock);
-		unlock_kernel();
 		return -ENODEV;
 	}
 	if (mbus != &mon_bus0 && mbus->u_bus == NULL) {
 		printk(KERN_ERR TAG ": consistency error on open\n");
 		mutex_unlock(&mon_lock);
-		unlock_kernel();
 		return -ENODEV;
 	}
 
@@ -689,7 +686,6 @@ static int mon_bin_open(struct inode *inode, struct file *file)
 
 	file->private_data = rp;
 	mutex_unlock(&mon_lock);
-	unlock_kernel();
 	return 0;
 
 err_allocbuff:
@@ -698,7 +694,6 @@ err_allocvec:
 	kfree(rp);
 err_alloc:
 	mutex_unlock(&mon_lock);
-	unlock_kernel();
 	return rc;
 }
 
@@ -954,7 +949,7 @@ static int mon_bin_queued(struct mon_reader_bin *rp)
 
 /*
  */
-static int mon_bin_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long mon_bin_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct mon_reader_bin *rp = file->private_data;
 	// struct mon_bus* mbus = rp->r.m_bus;
@@ -1094,19 +1089,6 @@ static int mon_bin_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static long mon_bin_unlocked_ioctl(struct file *file, unsigned int cmd,
-				   unsigned long arg)
-{
-	int ret;
-
-	lock_kernel();
-	ret = mon_bin_ioctl(file, cmd, arg);
-	unlock_kernel();
-
-	return ret;
-}
-
-
 #ifdef CONFIG_COMPAT
 static long mon_bin_compat_ioctl(struct file *file,
     unsigned int cmd, unsigned long arg)
@@ -1250,7 +1232,7 @@ static const struct file_operations mon_fops_binary = {
 	.read =		mon_bin_read,
 	/* .write =	mon_text_write, */
 	.poll =		mon_bin_poll,
-	.unlocked_ioctl = mon_bin_unlocked_ioctl,
+	.unlocked_ioctl = mon_bin_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
-- 
1.7.0.4

