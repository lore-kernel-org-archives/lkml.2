Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0GKVT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:19:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0GKVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 11/12] ipmi: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:19:02 +0200
Message-Id: <1278883143-29035-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ggGPnegGOAuCeO246a65EQIQ9KaTf+QZERYuhFKNVKg
 gAJH49k2kKLo/2QFHi6ASf8GsLtKzid3+xh0oNTElAtwqXeAO1
 LfkVeiLGYwLpNQDfECkf6atXeRAk3BAvQWxQvXY87qfBOzeepL
 nopKDE+VPue3W+ZEgUV9KLvAuvKf/L32pJ57kpXyci+VBnoenL
 XLipE72AeT10TShTVkGSQ==
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
Cc: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net
---
 drivers/char/ipmi/ipmi_devintf.c  |   14 +++++++-------
 drivers/char/ipmi/ipmi_watchdog.c |    8 ++++----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index d8ec92a..44833de 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -44,7 +44,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 
 struct ipmi_file_private
 {
@@ -59,6 +58,7 @@ struct ipmi_file_private
 	unsigned int         default_retry_time_ms;
 };
 
+static DEFINE_MUTEX(ipmi_mutex);
 static void file_receive_handler(struct ipmi_recv_msg *msg,
 				 void                 *handler_data)
 {
@@ -102,9 +102,9 @@ static int ipmi_fasync(int fd, struct file *file, int on)
 	struct ipmi_file_private *priv = file->private_data;
 	int                      result;
 
-	lock_kernel(); /* could race against open() otherwise */
+	mutex_lock(&ipmi_mutex); /* could race against open() otherwise */
 	result = fasync_helper(fd, file, on, &priv->fasync_queue);
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 
 	return (result);
 }
@@ -125,7 +125,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
 	if (!priv)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&ipmi_mutex);
 	priv->file = file;
 
 	rv = ipmi_create_user(if_num,
@@ -150,7 +150,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
 	priv->default_retry_time_ms = 0;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 	return rv;
 }
 
@@ -639,9 +639,9 @@ static long ipmi_unlocked_ioctl(struct file   *file,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ipmi_mutex);
 	ret = ipmi_ioctl(file, cmd, data);
-	unlock_kernel();
+	mutex_unlock(&ipmi_mutex);
 
 	return ret;
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 82bcdb2..d80b8c9 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -35,7 +35,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ipmi.h>
 #include <linux/ipmi_smi.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/watchdog.h>
 #include <linux/miscdevice.h>
 #include <linux/init.h>
@@ -149,6 +149,7 @@
 #define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
 #endif
 
+static DEFINE_MUTEX(ipmi_watchdog_mutex);
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 static ipmi_user_t watchdog_user;
@@ -736,9 +737,9 @@ static long ipmi_unlocked_ioctl(struct file *file,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&ipmi_watchdog_mutex);
 	ret = ipmi_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&ipmi_watchdog_mutex);
 
 	return ret;
 }
@@ -832,7 +833,6 @@ static int ipmi_open(struct inode *ino, struct file *filep)
 		if (test_and_set_bit(0, &ipmi_wdog_open))
 			return -EBUSY;
 
-		cycle_kernel_lock();
 
 		/*
 		 * Don't start the timer now, let it start on the
-- 
1.7.1

