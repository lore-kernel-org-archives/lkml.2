Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1D3OSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:18:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:55518 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1D3OSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:18:44 -0400
Subject: [PATCH] Support compat_ioctl get/set termios_locked
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 16:18:32 +0200
Message-ID: <1304173112.11652.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

plymouth complains about those two missing ioctls.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 drivers/tty/n_tty.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 428f4fe..8d1073f 100644
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
@@ -2088,6 +2089,20 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
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
@@ -2098,6 +2113,9 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
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
1.7.4.4


