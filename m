Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0INTy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:54:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0INTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:54:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <David.Woodhouse@intel.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 2/7] mtd: autoconvert trivial BKL users to private mutex
Date: Tue, 14 Sep 2010 21:53:37 +0200
Message-Id: <1284494022-7346-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:YrqtCej/xmeBVGs9wwvl/hqeCHn7JRy8uaKIIi+8yBi
 RqQGeWTOiqgZI80I3tAYnGzRZwFeb/hbkQdf+Z58K/5RZvvLd8
 X3+9oOgwqxZcqz1O/7/xt+8ikxg8Nvhb/nx1shkgDKDI+5m/Bx
 LWbxfi/rd23hOPyufwN0ym8Qm4YF8ZHR2cRenH915FGSE9Zq3A
 r04PZSV+E376qTYKmQXHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these files use the big kernel lock in a trivial
way to serialize their private file operations,
typically resulting from an earlier semi-automatic
pushdown from VFS.

None of these drivers appears to want to lock against
other code, and they all use the BKL as the top-level
lock in their file operations, meaning that there
is no lock-order inversion problem.

Consequently, we can remove the BKL completely,
replacing it with a per-file mutex in every case.
Using a scripted approach means we can avoid
typos.

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/mtdchar.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a825002..5ef4548 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -26,7 +26,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/backing-dev.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
@@ -37,6 +37,7 @@
 #include <asm/uaccess.h>
 
 #define MTD_INODE_FS_MAGIC 0x11307854
+static DEFINE_MUTEX(mtd_mutex);
 static struct vfsmount *mtd_inode_mnt __read_mostly;
 
 /*
@@ -90,7 +91,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && (minor & 1))
 		return -EACCES;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	mtd = get_mtd_device(NULL, devnum);
 
 	if (IS_ERR(mtd)) {
@@ -138,7 +139,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	file->private_data = mfi;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 	return ret;
 } /* mtd_open */
 
@@ -866,9 +867,9 @@ static long mtd_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	ret = mtd_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
@@ -892,7 +893,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = compat_ptr(arg);
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 
 	switch (cmd) {
 	case MEMWRITEOOB32:
@@ -927,7 +928,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 		ret = mtd_ioctl(file, cmd, (unsigned long)argp);
 	}
 
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
-- 
1.7.1

