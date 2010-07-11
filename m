Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0GKVTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:19:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0GKVTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 01/12] staging: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:18:52 +0200
Message-Id: <1278883143-29035-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UvzNflUcvjMm3n8IYZx4bETQyAH+bsvNUH1nfRuzqrh
 ypKbctmCKZgri3rS5cZEw89CFfr62WpKfRRO+GjrbGwx3RgHJ0
 NDn7UH4j8z/js6Sm2vMiut/0lqRht2hNVsWSIJC+uWPXMX4ryw
 zVTlC1lQsaIImJvbbqNW8Xjrrt9T6NRcWF3GWk9Syg6WTY+gPi
 RWTfJq/CnrmaEyK+GypYQ==
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
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    9 +++++----
 drivers/staging/dt3155/dt3155_drv.c       |    6 ++++--
 drivers/staging/vme/devices/vme_user.c    |    7 ++++---
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a4ec891..e4b9caa 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -15,11 +15,12 @@
   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************/
 
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include "crystalhd_lnx.h"
 
+static DEFINE_MUTEX(chd_dec_mutex);
 static struct class *crystalhd_class;
 
 static struct crystalhd_adp *g_adp_info;
@@ -279,16 +280,16 @@ static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 		return -ENODATA;
 	}
 
-	lock_kernel();
+	mutex_lock(&chd_dec_mutex);
 	cproc = crystalhd_get_cmd_proc(&adp->cmds, cmd, uc);
 	if (!cproc) {
 		BCMLOG_ERR("Unhandled command: %d\n", cmd);
-		unlock_kernel();
+		mutex_unlock(&chd_dec_mutex);
 		return -EINVAL;
 	}
 
 	ret = chd_dec_api_cmd(adp, ua, uc->uid, cmd, cproc);
-	unlock_kernel();
+	mutex_unlock(&chd_dec_mutex);
 	return ret;
 }
 
diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 40ef97f..fdfde1f 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -59,6 +59,7 @@ extern void printques(int);
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/poll.h>
@@ -78,6 +79,7 @@ extern void printques(int);
 MODULE_LICENSE("GPL");
 
 /* Error variable.  Zero means no error. */
+static DEFINE_MUTEX(dt3155_mutex);
 int dt3155_errno = 0;
 
 #ifndef PCI_DEVICE_ID_INTEL_7116
@@ -841,9 +843,9 @@ dt3155_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&dt3155_mutex);
 	ret = dt3155_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&dt3155_mutex);
 
 	return ret;
 }
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bc16fc0..73a67a8 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -31,7 +31,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 #include <asm/io.h>
@@ -40,6 +40,7 @@
 #include "../vme.h"
 #include "vme_user.h"
 
+static DEFINE_MUTEX(vme_user_mutex);
 static char driver_name[] = "vme_user";
 
 static int bus[USER_BUS_MAX];
@@ -560,9 +561,9 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&vme_user_mutex);
 	ret = vme_user_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&vme_user_mutex);
 
 	return ret;
 }
-- 
1.7.1

