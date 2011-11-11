Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1KKJre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:47:34 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34769 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1KKJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:47:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH v2 6/7] TTY: move debug checking out of tty_release
Date: Fri, 11 Nov 2011 10:47:23 +0100
Message-Id: <1321004843-21255-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-6-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-6-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to taint the tty_release code with paranoia
checking. So move it out of line to a separate function. Making thus
tty_release more readable.

[v2] don't introduce a hard to reproduce use after free (scheduled work would
     need to preempt the current thread)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |  101 ++++++++++++++++++++++++++++----------------------
 1 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 76e66ff..b874b6d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1557,6 +1557,62 @@ static void release_tty(struct tty_struct *tty, int idx)
 }
 
 /**
+ *	tty_release_checks - check a tty before real release
+ *	@tty: tty to check
+ *	@o_tty: link of @tty (if any)
+ *	@idx: index of the tty
+ *
+ *	Performs some paranoid checking before true release of the @tty.
+ *	This is a no-op unless TTY_PARANOIA_CHECK is defined.
+ */
+static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
+		int idx)
+{
+#ifdef TTY_PARANOIA_CHECK
+	if (idx < 0 || idx >= tty->driver->num) {
+		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
+				  "free (%s)\n", tty->name);
+		return -1;
+	}
+
+	/* not much to check for devpts */
+	if (tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)
+		return 0;
+
+	if (tty != tty->driver->ttys[idx]) {
+		printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
+		       "for (%s)\n", idx, tty->name);
+		return -1;
+	}
+	if (tty->termios != tty->driver->termios[idx]) {
+		printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
+		       "for (%s)\n",
+		       idx, tty->name);
+		return -1;
+	}
+	if (tty->driver->other) {
+		if (o_tty != tty->driver->other->ttys[idx]) {
+			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
+					  "not o_tty for (%s)\n",
+			       idx, tty->name);
+			return -1;
+		}
+		if (o_tty->termios != tty->driver->other->termios[idx]) {
+			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
+					  "not o_termios for (%s)\n",
+			       idx, tty->name);
+			return -1;
+		}
+		if (o_tty->link != tty) {
+			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
+			return -1;
+		}
+	}
+#endif
+	return 0;
+}
+
+/**
  *	tty_release		-	vfs callback for close
  *	@inode: inode of tty
  *	@filp: file pointer for handle to tty
@@ -1598,59 +1654,16 @@ int tty_release(struct inode *inode, struct file *filp)
 	devpts = (tty->driver->flags & TTY_DRIVER_DEVPTS_MEM) != 0;
 	o_tty = tty->link;
 
-#ifdef TTY_PARANOIA_CHECK
-	if (idx < 0 || idx >= tty->driver->num) {
-		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
-				  "free (%s)\n", tty->name);
+	if (tty_release_checks(tty, o_tty, idx)) {
 		tty_unlock();
 		return 0;
 	}
-	if (!devpts) {
-		if (tty != tty->driver->ttys[idx]) {
-			tty_unlock();
-			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
-			       "for (%s)\n", idx, tty->name);
-			return 0;
-		}
-		if (tty->termios != tty->driver->termios[idx]) {
-			tty_unlock();
-			printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
-			       "for (%s)\n",
-			       idx, tty->name);
-			return 0;
-		}
-	}
-#endif
 
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "tty_release_dev of %s (tty count=%d)...",
 	       tty_name(tty, buf), tty->count);
 #endif
 
-#ifdef TTY_PARANOIA_CHECK
-	if (tty->driver->other &&
-	     !(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
-		if (o_tty != tty->driver->other->ttys[idx]) {
-			tty_unlock();
-			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
-					  "not o_tty for (%s)\n",
-			       idx, tty->name);
-			return 0 ;
-		}
-		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			tty_unlock();
-			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
-					  "not o_termios for (%s)\n",
-			       idx, tty->name);
-			return 0;
-		}
-		if (o_tty->link != tty) {
-			tty_unlock();
-			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
-			return 0;
-		}
-	}
-#endif
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
-- 
1.7.7


