Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0INTxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:53:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0INTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:53:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@ozlabs.org
Subject: [PATCH 3/7] mac: autoconvert trivial BKL users to private mutex
Date: Tue, 14 Sep 2010 21:53:38 +0200
Message-Id: <1284494022-7346-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EkXNbgIEtujFRPMIkrNtBKM7fHwUDttbXqpkK5dFysi
 7dz7IctKVucbfj2GhzAXW8q6K+VNLA1lEJuQfI8qk4zk/bNGMJ
 LWSY7Ks23EKi1FKCHWu/Yz4C6YE30YODhpwUlooc7Ei5tZqMGV
 8y0X9XGZBFZxoKnQN2V0CA3IyVLtCBZKz+w/yB2KR6C9o4OEL6
 5i6ktar68UlXFLuU8bEwQ==
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
---
 drivers/macintosh/adb.c     |   10 +++++-----
 drivers/macintosh/smu.c     |    6 +++---
 drivers/macintosh/via-pmu.c |   11 ++++++-----
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 1c4ee6e..e75e3be 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -24,7 +24,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
 #include <linux/pmu.h>
@@ -55,6 +54,7 @@ extern struct adb_driver adb_iop_driver;
 extern struct adb_driver via_pmu_driver;
 extern struct adb_driver macio_adb_driver;
 
+static DEFINE_MUTEX(adb_mutex);
 static struct adb_driver *adb_driver_list[] = {
 #ifdef CONFIG_ADB_MACII
 	&via_macii_driver,
@@ -647,7 +647,7 @@ static int adb_open(struct inode *inode, struct file *file)
 	struct adbdev_state *state;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&adb_mutex);
 	if (iminor(inode) > 0 || adb_controller == NULL) {
 		ret = -ENXIO;
 		goto out;
@@ -665,7 +665,7 @@ static int adb_open(struct inode *inode, struct file *file)
 	state->inuse = 1;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&adb_mutex);
 	return ret;
 }
 
@@ -674,7 +674,7 @@ static int adb_release(struct inode *inode, struct file *file)
 	struct adbdev_state *state = file->private_data;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&adb_mutex);
 	if (state) {
 		file->private_data = NULL;
 		spin_lock_irqsave(&state->lock, flags);
@@ -687,7 +687,7 @@ static int adb_release(struct inode *inode, struct file *file)
 			spin_unlock_irqrestore(&state->lock, flags);
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&adb_mutex);
 	return 0;
 }
 
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index e58c3d3..290cb32 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -19,7 +19,6 @@
  *    the userland interface
  */
 
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -97,6 +96,7 @@ struct smu_device {
  * I don't think there will ever be more than one SMU, so
  * for now, just hard code that
  */
+static DEFINE_MUTEX(smu_mutex);
 static struct smu_device	*smu;
 static DEFINE_MUTEX(smu_part_access);
 static int smu_irq_inited;
@@ -1095,12 +1095,12 @@ static int smu_open(struct inode *inode, struct file *file)
 	pp->mode = smu_file_commands;
 	init_waitqueue_head(&pp->wait);
 
-	lock_kernel();
+	mutex_lock(&smu_mutex);
 	spin_lock_irqsave(&smu_clist_lock, flags);
 	list_add(&pp->list, &smu_clist);
 	spin_unlock_irqrestore(&smu_clist_lock, flags);
 	file->private_data = pp;
-	unlock_kernel();
+	mutex_unlock(&smu_mutex);
 
 	return 0;
 }
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 2d17e76..7b8b1de 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -18,7 +18,7 @@
  *
  */
 #include <stdarg.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -73,6 +73,7 @@
 /* How many iterations between battery polls */
 #define BATTERY_POLLING_COUNT	2
 
+static DEFINE_MUTEX(pmu_info_proc_mutex);
 static volatile unsigned char __iomem *via;
 
 /* VIA registers - spaced 0x200 bytes apart */
@@ -2078,7 +2079,7 @@ pmu_open(struct inode *inode, struct file *file)
 	pp->rb_get = pp->rb_put = 0;
 	spin_lock_init(&pp->lock);
 	init_waitqueue_head(&pp->wait);
-	lock_kernel();
+	mutex_lock(&pmu_info_proc_mutex);
 	spin_lock_irqsave(&all_pvt_lock, flags);
 #if defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_PMAC_BACKLIGHT)
 	pp->backlight_locker = 0;
@@ -2086,7 +2087,7 @@ pmu_open(struct inode *inode, struct file *file)
 	list_add(&pp->list, &all_pmu_pvt);
 	spin_unlock_irqrestore(&all_pvt_lock, flags);
 	file->private_data = pp;
-	unlock_kernel();
+	mutex_unlock(&pmu_info_proc_mutex);
 	return 0;
 }
 
@@ -2343,9 +2344,9 @@ static long pmu_unlocked_ioctl(struct file *filp,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&pmu_info_proc_mutex);
 	ret = pmu_ioctl(filp, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&pmu_info_proc_mutex);
 
 	return ret;
 }
-- 
1.7.1

