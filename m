Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0IPRsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:48:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab0IPRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/12] BKL: Remove BKL from autofs4
Date: Thu, 16 Sep 2010 19:46:17 +0200
Message-Id: <1284659185-8942-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hjbWwdPZXUtxtOumVgCFvKLHRmEJUwuCzpk8G1cp3/4
 Z0T/TbrxriI0JJWs2hMLfKYIYxiN+rIpQIs9lrdb1FfdDLvt4P
 Weehm9HDMFKMmJEiV4AsJMR6lA+aRKfsqXCx9zXgeqNF4/4r1d
 xUf8k6X7lFWXyFJuKCpjq5UgURK1c7AB+PlvVIDNlOiHyfMut4
 1+maLiFOksz6Rw0M+HyVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs4 uses the BKL only to guard its ioctl operations.
This can be trivially converted to use a mutex, as we have
done with most device drivers before.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 fs/autofs4/root.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cb1bd38..9dd29c2 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -19,7 +19,7 @@
 #include <linux/param.h>
 #include <linux/time.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include "autofs_i.h"
 
@@ -978,15 +978,17 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	}
 }
 
+static DEFINE_MUTEX(autofs4_ioctl_mutex);
+
 static long autofs4_root_ioctl(struct file *filp,
 			       unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	struct inode *inode = filp->f_dentry->d_inode;
 
-	lock_kernel();
+	mutex_lock(&autofs4_ioctl_mutex);
 	ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&autofs4_ioctl_mutex);
 
 	return ret;
 }
@@ -998,13 +1000,13 @@ static long autofs4_root_compat_ioctl(struct file *filp,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&autofs4_ioctl_mutex);
 	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
 			(unsigned long)compat_ptr(arg));
-	unlock_kernel();
+	mutex_unlock(&autofs4_ioctl_mutex);
 
 	return ret;
 }
-- 
1.7.1

