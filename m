Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0FAVRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:17:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab0FAVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:17:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Willem Riede <osst@riede.org>,
       =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] scsi/st: remove BKL from open
Date: Tue,  1 Jun 2010 23:16:54 +0200
Message-Id: <1275427014-9801-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX18JpkRRI9b5hfmUk2PlefpI+fFYpE8oCFFUszS
 opEEwQOjzGyKcc4uKDF906+50vT2Uh0pV0s18gc6pL6iafJMZn
 J7/LpoakJycbOk+w8+x0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The st_open function is serialized through the st_dev_arr_lock
and the STp->in_use flag, so there is no race that the BKL
can protect against in the driver itself, and the function
does not access any global state outside of the driver that
might be protected with the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Willem Riede <osst@riede.org>
Cc: "Kai Mäkisara" <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: osst-users@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
 drivers/scsi/st.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 24211d0..8d4c4bb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -39,7 +39,6 @@ static const char *verstr = "20081215";
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
@@ -1180,7 +1179,6 @@ static int st_open(struct inode *inode, struct file *filp)
 	int dev = TAPE_NR(inode);
 	char *name;
 
-	lock_kernel();
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if that
@@ -1188,10 +1186,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	 */
 	filp->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 
-	if (!(STp = scsi_tape_get(dev))) {
-		unlock_kernel();
+	if (!(STp = scsi_tape_get(dev)))
 		return -ENXIO;
-	}
 
 	write_lock(&st_dev_arr_lock);
 	filp->private_data = STp;
@@ -1200,7 +1196,6 @@ static int st_open(struct inode *inode, struct file *filp)
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
 		scsi_tape_put(STp);
-		unlock_kernel();
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
@@ -1249,14 +1244,12 @@ static int st_open(struct inode *inode, struct file *filp)
 			retval = (-EIO);
 		goto err_out;
 	}
-	unlock_kernel();
 	return 0;
 
  err_out:
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
 	scsi_tape_put(STp);
-	unlock_kernel();
 	return retval;
 
 }
-- 
1.7.0.4

