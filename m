Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0D1MhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:37:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0D1MhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:37:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] pktcdvd: improve BKL and compat_ioctl.c usage
Date: Wed, 28 Apr 2010 14:36:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "=?iso-8859-15?q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Peter Osterlund <petero2@telia.com>,
       Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@elte.hu>
References: <20100427150629.cb526876.sfr@canb.auug.org.au> <201004271102.35904.arnd@arndb.de> <20100428162209.cc9b2487.sfr@canb.auug.org.au>
In-Reply-To: <20100428162209.cc9b2487.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004281436.42183.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FSAuflHnBBhCNrFz5G4yz6OWYN/4uZ1+VZa7
 owkbzy4Ub6Wepfz05LlS5YzKQnuGmPtwD/a7vj8D1cWoHNi3P/
 gwVbpdwMpBWWkgcQFQg8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pktcdvd driver uses proper locking and does not need the
BKL in the ioctl and llseek functions of the character device,
so kill both. Moving the compat_ioctl handling from common code
into the driver itself fixes build problems when CONFIG_BLOCK is
disabled.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Wednesday 28 April 2010, Stephen Rothwell wrote:
 
> My fixes tree is here: ssh://master.kernel.org/~sfr/next-fixes.git it
> currently only contains your pktcdvd patch.  My understanding was that
> this patch was a fix for a build problem with Linus' tree.

Ah, I had forgotten that this was still needed and Jens or Peter
obviously never picked it up.

Linus, could you merge this now to fix building with CONFIG_BLOCK
disabled? It's fallout of a patch c5ecc484c "pktcdvd: use BIO list
management functions", but I fixed it because the problem appeared
in compat_ioctl handling. It now came up because the patch conflicted
with the BKL pushdown, which the original patch does as a side-effect.

	Arnd

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ddf1942..8a549db 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -48,6 +48,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/kthread.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
@@ -2984,7 +2985,7 @@ static void pkt_get_status(struct pkt_ctrl_command *ctrl_cmd)
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3021,10 +3022,20 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static long pkt_ctl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return pkt_ctl_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
-	.owner	 = THIS_MODULE,
+	.open		= nonseekable_open,
+	.unlocked_ioctl	= pkt_ctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= pkt_ctl_compat_ioctl,
+#endif
+	.owner		= THIS_MODULE,
 };
 
 static struct miscdevice pkt_misc = {
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c32a1b6..641640d 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -102,7 +102,6 @@
 #include <linux/nbd.h>
 #include <linux/random.h>
 #include <linux/filter.h>
-#include <linux/pktcdvd.h>
 
 #include <linux/hiddev.h>
 
@@ -1126,8 +1125,6 @@ COMPATIBLE_IOCTL(PPGETMODE)
 COMPATIBLE_IOCTL(PPGETPHASE)
 COMPATIBLE_IOCTL(PPGETFLAGS)
 COMPATIBLE_IOCTL(PPSETFLAGS)
-/* pktcdvd */
-COMPATIBLE_IOCTL(PACKET_CTRL_CMD)
 /* Big A */
 /* sparc only */
 /* Big Q for sound/OSS */
