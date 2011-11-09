Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1KIUdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:36 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37363 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 7/7] TTY: open/release, cleanup printks
Date: Wed,  9 Nov 2011 21:33:24 +0100
Message-Id: <1320870804-23687-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* use __func__ instead of hardcoded names (tty_release_dev is a
  non-existant function)
* add missing \n's
* unwrap for better grepping

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |   56 +++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 0fdddd3..943a8947 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1570,8 +1570,8 @@ static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
 {
 #ifdef TTY_PARANOIA_CHECK
 	if (idx < 0 || idx >= tty->driver->num) {
-		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
-				  "free (%s)\n", tty->name);
+		printk(KERN_DEBUG "%s: bad idx when trying to free (%s)\n",
+				__func__, tty->name);
 		return -1;
 	}
 
@@ -1580,31 +1580,28 @@ static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
 		return 0;
 
 	if (tty != tty->driver->ttys[idx]) {
-		printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
-		       "for (%s)\n", idx, tty->name);
+		printk(KERN_DEBUG "%s: driver.table[%d] not tty for (%s)\n",
+				__func__, idx, tty->name);
 		return -1;
 	}
 	if (tty->termios != tty->driver->termios[idx]) {
-		printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
-		       "for (%s)\n",
-		       idx, tty->name);
+		printk(KERN_DEBUG "%s: driver.termios[%d] not termios for (%s)\n",
+				__func__, idx, tty->name);
 		return -1;
 	}
 	if (tty->driver->other) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
-			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
-					  "not o_tty for (%s)\n",
-			       idx, tty->name);
+			printk(KERN_DEBUG "%s: other->table[%d] not o_tty for (%s)\n",
+					__func__, idx, tty->name);
 			return -1;
 		}
 		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
-					  "not o_termios for (%s)\n",
-			       idx, tty->name);
+			printk(KERN_DEBUG "%s: other->termios[%d] not o_termios for (%s)\n",
+					__func__, idx, tty->name);
 			return -1;
 		}
 		if (o_tty->link != tty) {
-			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
+			printk(KERN_DEBUG "%s: bad pty pointers\n", __func__);
 			return -1;
 		}
 	}
@@ -1639,11 +1636,11 @@ int tty_release(struct inode *inode, struct file *filp)
 	int	idx;
 	char	buf[64];
 
-	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
+	if (tty_paranoia_check(tty, inode, __func__))
 		return 0;
 
 	tty_lock();
-	check_tty_count(tty, "tty_release_dev");
+	check_tty_count(tty, __func__);
 
 	__tty_fasync(-1, filp, 0);
 
@@ -1658,8 +1655,8 @@ int tty_release(struct inode *inode, struct file *filp)
 	}
 
 #ifdef TTY_DEBUG_HANGUP
-	printk(KERN_DEBUG "tty_release_dev of %s (tty count=%d)...",
-	       tty_name(tty, buf), tty->count);
+	printk(KERN_DEBUG "%s: %s (tty count=%d)...\n", __func__,
+			tty_name(tty, buf), tty->count);
 #endif
 
 	if (tty->ops->close)
@@ -1717,8 +1714,8 @@ int tty_release(struct inode *inode, struct file *filp)
 		if (!do_sleep)
 			break;
 
-		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
-				    "active!\n", tty_name(tty, buf));
+		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
+				__func__, tty_name(tty, buf));
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
 		schedule();
@@ -1731,15 +1728,14 @@ int tty_release(struct inode *inode, struct file *filp)
 	 */
 	if (pty_master) {
 		if (--o_tty->count < 0) {
-			printk(KERN_WARNING "tty_release_dev: bad pty slave count "
-					    "(%d) for %s\n",
-			       o_tty->count, tty_name(o_tty, buf));
+			printk(KERN_WARNING "%s: bad pty slave count (%d) for %s\n",
+				__func__, o_tty->count, tty_name(o_tty, buf));
 			o_tty->count = 0;
 		}
 	}
 	if (--tty->count < 0) {
-		printk(KERN_WARNING "tty_release_dev: bad tty->count (%d) for %s\n",
-		       tty->count, tty_name(tty, buf));
+		printk(KERN_WARNING "%s: bad tty->count (%d) for %s\n",
+				__func__, tty->count, tty_name(tty, buf));
 		tty->count = 0;
 	}
 
@@ -1788,7 +1784,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	}
 
 #ifdef TTY_DEBUG_HANGUP
-	printk(KERN_DEBUG "freeing tty structure...");
+	printk(KERN_DEBUG "%s: freeing tty structure...\n", __func__);
 #endif
 	/*
 	 * Ask the line discipline code to release its structures
@@ -1965,12 +1961,12 @@ retry_open:
 
 	tty_add_file(tty, filp);
 
-	check_tty_count(tty, "tty_open");
+	check_tty_count(tty, __func__);
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
 		noctty = 1;
 #ifdef TTY_DEBUG_HANGUP
-	printk(KERN_DEBUG "opening %s...", tty->name);
+	printk(KERN_DEBUG "%s: opening %s...\n", __func__, tty->name);
 #endif
 	if (tty->ops->open)
 		retval = tty->ops->open(tty, filp);
@@ -1984,8 +1980,8 @@ retry_open:
 
 	if (retval) {
 #ifdef TTY_DEBUG_HANGUP
-		printk(KERN_DEBUG "error %d in opening %s...", retval,
-		       tty->name);
+		printk(KERN_DEBUG "%s: error %d in opening %s...\n", __func__,
+				retval, tty->name);
 #endif
 		tty_unlock(); /* need to call tty_release without BTM */
 		tty_release(inode, filp);
-- 
1.7.7


