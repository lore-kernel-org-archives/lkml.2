Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1I1RiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:38:13 -0400
Received: from www17.your-server.de ([213.133.104.17]:44291 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1I1RiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:38:12 -0400
Subject: Re: [PATCH] Support compat_ioctl get/set termios_locked
From: Thomas Meyer <thomas@m3y3r.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 28 Sep 2011 19:37:58 +0200
In-Reply-To: <2272244.eQGJoCfPBm@wuerfel>
References: <1316854289.1696.6.camel@localhost.localdomain>
	 <2272244.eQGJoCfPBm@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317231482.1724.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 25.09.2011, 13:11 +0200 schrieb Arnd Bergmann:
> Hi Thomas,
> 
> This looks ok for n_tty, but the same commands are supported for some
> (all?) other tty line disciplines as well, and they remain broken
> after your patch.
> 
> I think it would be better to handle this in the common tty_compat_ioctl()
> function before calling into the line discipline's compat_ioctl function.
> 

>From a91ed2e890a61a1fa382b6434a3c95774bd1d3da Mon Sep 17 00:00:00 2001
From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 24 Sep 2011 10:36:39 +0200
Subject: [PATCH] Support compat_ioctl get/set termios_locked

When running a Fedora 15 (x86) on an x86_64 kernel, in the boot process
plymouthd complains about those two missing ioctls:
[    2.581783] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005457){t:'T';sz:0} arg(ffb6a5d0) on /dev/tty1
[    2.581803] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005456){t:'T';sz:0} arg(ffb6a680) on /dev/tty1

both ioctl functions work on the 'struct termios' resp. 'struct termios2',
which has the same size (36 bytes resp. 44 bytes) on x86 and x86_64,
so it's just a matter of converting the pointer from userland.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 drivers/tty/tty_io.c    |    3 +++
 drivers/tty/tty_ioctl.c |   17 +++++++++++++++++
 include/linux/tty.h     |    2 ++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4f1fc81..983f29a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2716,6 +2716,9 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 	ld = tty_ldisc_ref_wait(tty);
 	if (ld->ops->compat_ioctl)
 		retval = ld->ops->compat_ioctl(tty, file, cmd, arg);
+	else
+		n_tty_compat_ioctl_helper(tty, file, cmd, arg);
+
 	tty_ldisc_deref(ld);
 
 	return retval;
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 53f2442..9314d93 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/compat.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1179,3 +1180,19 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 	}
 }
 EXPORT_SYMBOL(n_tty_ioctl_helper);
+
+#ifdef CONFIG_COMPAT
+long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case TIOCGLCKTRMIOS:
+	case TIOCSLCKTRMIOS:
+		return tty_mode_ioctl(tty, file, cmd, (unsigned long) compat_ptr(arg));
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL(n_tty_compat_ioctl_helper);
+#endif
+
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5f2ede8..ddac668 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -581,6 +581,8 @@ extern int __init tty_init(void);
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
+extern long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg);
 
 /* serial.c */
 
-- 
1.7.6.2


