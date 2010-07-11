Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0GKVTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:19:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab0GKVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:19:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-cris-kernel@axis.com,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 07/12] cris: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:18:58 +0200
Message-Id: <1278883143-29035-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8+W02cLE/PziwHRjEz3uR7KgGP+xs5XwjqK4dMDALea
 k+J2QRtHdLRYzSDxROR+rsIRzlRsbcpPYSE7d0jbdkOLShxmPY
 6zxebj2hs1PVjzG3Nw3WZuBZuGZOlRwwsLVW/6T5fLBmOkDNR8
 JkLwHe/9tHUn/mGZgOR0SRjodeYo4Ywc0beNtx8RkXmEZ8uAkc
 TXhWreKXFfsYmKMuLhFiA==
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
Cc: linux-cris-kernel@axis.com
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/drivers/eeprom.c    |    2 --
 arch/cris/arch-v10/drivers/i2c.c       |    2 --
 arch/cris/arch-v32/drivers/cryptocop.c |    2 --
 arch/cris/arch-v32/drivers/i2c.c       |   12 ++++++------
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/eeprom.c b/arch/cris/arch-v10/drivers/eeprom.c
index c340550..5047a33 100644
--- a/arch/cris/arch-v10/drivers/eeprom.c
+++ b/arch/cris/arch-v10/drivers/eeprom.c
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
 #include "i2c.h"
@@ -376,7 +375,6 @@ int __init eeprom_init(void)
 /* Opens the device. */
 static int eeprom_open(struct inode * inode, struct file * file)
 {
-  cycle_kernel_lock();
   if(iminor(inode) != EEPROM_MINOR_NR)
      return -ENXIO;
   if(imajor(inode) != EEPROM_MAJOR_NR)
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index a8737a8..f34fe71 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -14,7 +14,6 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -566,7 +565,6 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 static int
 i2c_open(struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index b70fb34..9f80da0 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -11,7 +11,6 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 
@@ -2307,7 +2306,6 @@ static int cryptocop_open(struct inode *inode, struct file *filp)
 {
 	int p = iminor(inode);
 
-	cycle_kernel_lock();
 	if (p != CRYPTOCOP_MINOR) return -EINVAL;
 
 	filp->private_data = NULL;
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 2fd6a74..5a3e900 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -32,7 +32,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/etraxi2c.h>
 
@@ -47,6 +47,7 @@
 #define D(x)
 
 #define I2C_MAJOR 123  /* LOCAL/EXPERIMENTAL */
+static DEFINE_MUTEX(i2c_mutex);
 static const char i2c_name[] = "i2c";
 
 #define CLOCK_LOW_TIME            8
@@ -636,7 +637,6 @@ i2c_readreg(unsigned char theSlave, unsigned char theReg)
 static int
 i2c_open(struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -665,11 +665,11 @@ i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				 I2C_ARGREG(arg),
 				 I2C_ARGVALUE(arg)));
 
-			lock_kernel();
+			mutex_lock(&i2c_mutex);
 			ret = i2c_writereg(I2C_ARGSLAVE(arg),
 					    I2C_ARGREG(arg),
 					    I2C_ARGVALUE(arg));
-			unlock_kernel();
+			mutex_unlock(&i2c_mutex);
 			return ret;
 
 		case I2C_READREG:
@@ -679,9 +679,9 @@ i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			D(printk("i2cr %d %d ",
 				I2C_ARGSLAVE(arg),
 				I2C_ARGREG(arg)));
-			lock_kernel();
+			mutex_lock(&i2c_mutex);
 			val = i2c_readreg(I2C_ARGSLAVE(arg), I2C_ARGREG(arg));
-			unlock_kernel();
+			mutex_unlock(&i2c_mutex);
 			D(printk("= %d\n", val));
 			return val;
 		}
-- 
1.7.1

