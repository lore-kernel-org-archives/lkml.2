Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0FCAPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:15:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348Ab0FCAPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:15:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: [RFC 4/5] BKL: use no BKL in llseek
Date: Thu,  3 Jun 2010 02:13:18 +0200
Message-Id: <1275523999-27462-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275523999-27462-1-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/zWAqHC8Md1ptshj/ooneksLwMJ2i4KAaB6Z7
 Sb0b02f96gmdpQYVAHSNAJQT+oy+6VOf4PgiNNjGdFHvWF6zdq
 3qXlKDoDR9S0BqDQoP4Uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have shown that the BKL in default_llseek and other
llseek operations never protects against concurrent access
from another function:

* Most drivers never access f_pos
* Most drivers that access f_pos have their own
  llseek function
* Those drivers that use default_llseek and still
  access f_pos from outside do so without taking the BKL.
* No file system uses default_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pnp/isapnp/proc.c |    6 +++---
 drivers/usb/core/inode.c  |    1 -
 drivers/zorro/proc.c      |    6 +++---
 fs/read_write.c           |    4 ++--
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index 3f94eda..cc22c7c 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -32,7 +32,7 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 {
 	loff_t new = -1;
 
-	lock_kernel();
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
 	switch (whence) {
 	case 0:
 		new = off;
@@ -45,10 +45,10 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 		break;
 	}
 	if (new < 0 || new > 256) {
-		unlock_kernel();
+		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 		return -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 	return (file->f_pos = new);
 }
 
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 1a27618..70b1d42 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -39,7 +39,6 @@
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/usb/hcd.h>
 #include <asm/byteorder.h>
 #include "usb.h"
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index 3c7046d..8e4c505 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -23,7 +23,7 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 {
 	loff_t new = -1;
 
-	lock_kernel();
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
 	switch (whence) {
 	case 0:
 		new = off;
@@ -36,10 +36,10 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 		break;
 	}
 	if (new < 0 || new > sizeof(struct ConfigDev)) {
-		unlock_kernel();
+		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 		return -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 	return (file->f_pos = new);
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 9c04852..31c0be7 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -124,7 +124,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 
-	lock_kernel();
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
@@ -145,7 +145,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 		retval = offset;
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 	return retval;
 }
 EXPORT_SYMBOL(default_llseek);
-- 
1.7.0.4

