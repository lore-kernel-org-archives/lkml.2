Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817Ab2FDU2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:28:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2FDU1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:52 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] um: remove line_ioctl()
Date: Mon,  4 Jun 2012 22:27:34 +0200
Message-Id: <1338841657-30358-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

line_ioctl() has no real function.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c          |   86 ---------------------------------------
 arch/um/drivers/line.h          |    2 -
 arch/um/drivers/ssl.c           |    1 -
 arch/um/drivers/stdio_console.c |    1 -
 4 files changed, 0 insertions(+), 90 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index fb6e4ea..131129a 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -221,92 +221,6 @@ void line_set_termios(struct tty_struct *tty, struct ktermios * old)
 	/* nothing */
 }
 
-static const struct {
-	int  cmd;
-	char *level;
-	char *name;
-} tty_ioctls[] = {
-	/* don't print these, they flood the log ... */
-	{ TCGETS,      NULL,       "TCGETS"      },
-	{ TCSETS,      NULL,       "TCSETS"      },
-	{ TCSETSW,     NULL,       "TCSETSW"     },
-	{ TCFLSH,      NULL,       "TCFLSH"      },
-	{ TCSBRK,      NULL,       "TCSBRK"      },
-
-	/* general tty stuff */
-	{ TCSETSF,     KERN_DEBUG, "TCSETSF"     },
-	{ TCGETA,      KERN_DEBUG, "TCGETA"      },
-	{ TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
-	{ TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
-	{ TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
-
-	/* linux-specific ones */
-	{ TIOCLINUX,   KERN_INFO,  "TIOCLINUX"   },
-	{ KDGKBMODE,   KERN_INFO,  "KDGKBMODE"   },
-	{ KDGKBTYPE,   KERN_INFO,  "KDGKBTYPE"   },
-	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
-};
-
-int line_ioctl(struct tty_struct *tty, unsigned int cmd,
-				unsigned long arg)
-{
-	int ret;
-	int i;
-
-	ret = 0;
-	switch(cmd) {
-#ifdef TIOCGETP
-	case TIOCGETP:
-	case TIOCSETP:
-	case TIOCSETN:
-#endif
-#ifdef TIOCGETC
-	case TIOCGETC:
-	case TIOCSETC:
-#endif
-#ifdef TIOCGLTC
-	case TIOCGLTC:
-	case TIOCSLTC:
-#endif
-	/* Note: these are out of date as we now have TCGETS2 etc but this
-	   whole lot should probably go away */
-	case TCGETS:
-	case TCSETSF:
-	case TCSETSW:
-	case TCSETS:
-	case TCGETA:
-	case TCSETAF:
-	case TCSETAW:
-	case TCSETA:
-	case TCXONC:
-	case TCFLSH:
-	case TIOCOUTQ:
-	case TIOCINQ:
-	case TIOCGLCKTRMIOS:
-	case TIOCSLCKTRMIOS:
-	case TIOCPKT:
-	case TIOCGSOFTCAR:
-	case TIOCSSOFTCAR:
-		return -ENOIOCTLCMD;
-#if 0
-	case TCwhatever:
-		/* do something */
-		break;
-#endif
-	default:
-		for (i = 0; i < ARRAY_SIZE(tty_ioctls); i++)
-			if (cmd == tty_ioctls[i].cmd)
-				break;
-		if (i == ARRAY_SIZE(tty_ioctls)) {
-			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
-			       __func__, tty->name, cmd);
-		}
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-	return ret;
-}
-
 void line_throttle(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index 5b3d4fb..6c3b252 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -69,8 +69,6 @@ extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
 extern int line_write_room(struct tty_struct *tty);
-extern int line_ioctl(struct tty_struct *tty, unsigned int cmd,
-				unsigned long arg);
 extern void line_throttle(struct tty_struct *tty);
 extern void line_unthrottle(struct tty_struct *tty);
 
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index e09801a..a39d53e 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -129,7 +129,6 @@ static const struct tty_operations ssl_ops = {
 	.flush_buffer 		= line_flush_buffer,
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
-	.ioctl 	 		= line_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
 #if 0
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 7663541..5cefdba 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -112,7 +112,6 @@ static const struct tty_operations console_ops = {
 	.flush_buffer 		= line_flush_buffer,
 	.flush_chars 		= line_flush_chars,
 	.set_termios 		= line_set_termios,
-	.ioctl 	 		= line_ioctl,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
 };
-- 
1.7.7.3

