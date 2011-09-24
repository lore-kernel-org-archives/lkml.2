Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1IXIvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 04:51:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:51900 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1IXIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:51:34 -0400
Subject: [PATCH] Support compat_ioctl get/set termios_locked
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 Sep 2011 10:51:24 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316854289.1696.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a Fedora 15 (x86) on an x86_64 kernel, in the boot process
plymouthd complains about those two missing ioctls:
[    2.581783] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005457){t:'T';sz:0} arg(ffb6a5d0) on /dev/tty1
[    2.581803] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005456){t:'T';sz:0} arg(ffb6a680) on /dev/tty1

both ioctl functions work on the 'struct termios', which has the same
size (36 bytes) on x86 and x86_64, so it's just a matter of converting the
pointer from userland.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 drivers/tty/n_tty.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 39d6ab6..24843da 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -40,6 +40,7 @@
 #include <linux/tty.h>
 #include <linux/timer.h>
 #include <linux/ctype.h>
+#include <linux/compat.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -2095,6 +2096,20 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 	}
 }
 
+#ifdef CONFIG_COMPAT
+static long n_tty_compat_ioctl(struct tty_struct *tty, struct file *file,
+		              unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case TIOCGLCKTRMIOS:
+	case TIOCSLCKTRMIOS:
+		return tty_mode_ioctl(tty, file, cmd, (unsigned long) compat_ptr(arg));
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#endif
+
 struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.magic           = TTY_LDISC_MAGIC,
 	.name            = "n_tty",
@@ -2105,6 +2120,9 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.read            = n_tty_read,
 	.write           = n_tty_write,
 	.ioctl           = n_tty_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl    = n_tty_compat_ioctl,
+#endif
 	.set_termios     = n_tty_set_termios,
 	.poll            = n_tty_poll,
 	.receive_buf     = n_tty_receive_buf,
-- 
1.7.6.2


