Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0GKVUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:20:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0GKVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 09/12] mtd: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:19:00 +0200
Message-Id: <1278883143-29035-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2UxQanKpRWuMSqP+v7DmkUmNDTo+dTJWYYaod3qt7X3
 1D3Cx0lrpNi3FQvqUKtEoDY4u+pUBDMGStgKLRyHqFTAWWmK5l
 0/dUilJ0GDJVoP70LVvyO4cHvkwAGEcmpaM4JXBAQ/qhfuDMrU
 KXjd4dlvBvPNTHwh6qMz/oyxs+u8i7WdO4wpx+hQoNN4EQgWO0
 QVn5YpyFupLH4w59GoEig==
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
index 91c8013..cdb6106 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -12,7 +12,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/backing-dev.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
@@ -23,6 +23,7 @@
 #include <asm/uaccess.h>
 
 #define MTD_INODE_FS_MAGIC 0x11307854
+static DEFINE_MUTEX(mtd_mutex);
 static struct vfsmount *mtd_inode_mnt __read_mostly;
 
 /*
@@ -76,7 +77,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && (minor & 1))
 		return -EACCES;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	mtd = get_mtd_device(NULL, devnum);
 
 	if (IS_ERR(mtd)) {
@@ -124,7 +125,7 @@ static int mtd_open(struct inode *inode, struct file *file)
 	file->private_data = mfi;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 	return ret;
 } /* mtd_open */
 
@@ -838,9 +839,9 @@ static long mtd_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 	ret = mtd_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
@@ -864,7 +865,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = compat_ptr(arg);
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&mtd_mutex);
 
 	switch (cmd) {
 	case MEMWRITEOOB32:
@@ -899,7 +900,7 @@ static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 		ret = mtd_ioctl(file, cmd, (unsigned long)argp);
 	}
 
-	unlock_kernel();
+	mutex_unlock(&mtd_mutex);
 
 	return ret;
 }
-- 
1.7.1

