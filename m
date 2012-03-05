Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2CEOCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:02:17 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34756 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2CENxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net
Subject: [PATCH 67/68] TTY: isdn/gigaset, do not set tty->driver_data to NULL
Date: Mon,  5 Mar 2012 14:52:54 +0100
Message-Id: <1330955575-26641-68-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close the window in open where driver_data is reset to NULL on each
open. It could cause other processes to get invalid retval from the
tty->ops operations because of the checks all over the code.

With this change we may do other cleanups. Now, the only valid check
for tty->driver_data != NULL is in close. This can happen only if open
fails at gigaset_get_cs_by_tty or try_module_get. The rest of checks
in various tty->ops->* are invalid as driver_data cannot be NULL
there. The same holds for cs->open_count. So remove them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: gigaset307x-common@lists.sourceforge.net
---
 drivers/isdn/gigaset/interface.c |  105 +++++---------------------------------
 1 file changed, 14 insertions(+), 91 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 7e54577..040f5f9 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -151,8 +151,6 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 	gig_dbg(DEBUG_IF, "%d+%d: %s()",
 		tty->driver->minor_start, tty->index, __func__);
 
-	tty->driver_data = NULL;
-
 	cs = gigaset_get_cs_by_tty(tty);
 	if (!cs || !try_module_get(cs->driver->owner))
 		return -ENODEV;
@@ -178,12 +176,11 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 
 static void if_close(struct tty_struct *tty, struct file *filp)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	unsigned long flags;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
+	if (!cs) { /* happens if we didn't find cs in open */
+		printk(KERN_DEBUG "%s: no cardstate\n", __func__);
 		return;
 	}
 
@@ -211,18 +208,12 @@ static void if_close(struct tty_struct *tty, struct file *filp)
 static int if_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	int retval = -ENODEV;
 	int int_arg;
 	unsigned char buf[6];
 	unsigned version[4];
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s(0x%x)", cs->minor_index, __func__, cmd);
 
 	if (mutex_lock_interruptible(&cs->mutex))
@@ -231,9 +222,7 @@ static int if_ioctl(struct tty_struct *tty,
 	if (!cs->connected) {
 		gig_dbg(DEBUG_IF, "not connected");
 		retval = -ENODEV;
-	} else if (!cs->open_count)
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else {
+	} else {
 		retval = 0;
 		switch (cmd) {
 		case GIGASET_REDIR:
@@ -285,15 +274,9 @@ static int if_ioctl(struct tty_struct *tty,
 
 static int if_tiocmget(struct tty_struct *tty)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	int retval;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	if (mutex_lock_interruptible(&cs->mutex))
@@ -309,16 +292,10 @@ static int if_tiocmget(struct tty_struct *tty)
 static int if_tiocmset(struct tty_struct *tty,
 		       unsigned int set, unsigned int clear)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	int retval;
 	unsigned mc;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s(0x%x, 0x%x)",
 		cs->minor_index, __func__, set, clear);
 
@@ -341,16 +318,10 @@ static int if_tiocmset(struct tty_struct *tty,
 
 static int if_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	struct cmdbuf_t *cb;
 	int retval;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	if (mutex_lock_interruptible(&cs->mutex))
@@ -361,11 +332,6 @@ static int if_write(struct tty_struct *tty, const unsigned char *buf, int count)
 		retval = -ENODEV;
 		goto done;
 	}
-	if (!cs->open_count) {
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-		retval = -ENODEV;
-		goto done;
-	}
 	if (cs->mstate != MS_LOCKED) {
 		dev_warn(cs->dev, "can't write to unlocked device\n");
 		retval = -EBUSY;
@@ -397,15 +363,9 @@ done:
 
 static int if_write_room(struct tty_struct *tty)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	int retval = -ENODEV;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return -ENODEV;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	if (mutex_lock_interruptible(&cs->mutex))
@@ -414,9 +374,7 @@ static int if_write_room(struct tty_struct *tty)
 	if (!cs->connected) {
 		gig_dbg(DEBUG_IF, "not connected");
 		retval = -ENODEV;
-	} else if (!cs->open_count)
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else if (cs->mstate != MS_LOCKED) {
+	} else if (cs->mstate != MS_LOCKED) {
 		dev_warn(cs->dev, "can't write to unlocked device\n");
 		retval = -EBUSY;
 	} else
@@ -429,23 +387,15 @@ static int if_write_room(struct tty_struct *tty)
 
 static int if_chars_in_buffer(struct tty_struct *tty)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	int retval = 0;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return 0;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	mutex_lock(&cs->mutex);
 
 	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");
-	else if (!cs->open_count)
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
 	else if (cs->mstate != MS_LOCKED)
 		dev_warn(cs->dev, "can't write to unlocked device\n");
 	else
@@ -458,13 +408,7 @@ static int if_chars_in_buffer(struct tty_struct *tty)
 
 static void if_throttle(struct tty_struct *tty)
 {
-	struct cardstate *cs;
-
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return;
-	}
+	struct cardstate *cs = tty->driver_data;
 
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
@@ -472,8 +416,6 @@ static void if_throttle(struct tty_struct *tty)
 
 	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");	/* nothing to do */
-	else if (!cs->open_count)
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
 	else
 		gig_dbg(DEBUG_IF, "%s: not implemented\n", __func__);
 
@@ -482,13 +424,7 @@ static void if_throttle(struct tty_struct *tty)
 
 static void if_unthrottle(struct tty_struct *tty)
 {
-	struct cardstate *cs;
-
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return;
-	}
+	struct cardstate *cs = tty->driver_data;
 
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
@@ -496,8 +432,6 @@ static void if_unthrottle(struct tty_struct *tty)
 
 	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");	/* nothing to do */
-	else if (!cs->open_count)
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
 	else
 		gig_dbg(DEBUG_IF, "%s: not implemented\n", __func__);
 
@@ -506,18 +440,12 @@ static void if_unthrottle(struct tty_struct *tty)
 
 static void if_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	struct cardstate *cs;
+	struct cardstate *cs = tty->driver_data;
 	unsigned int iflag;
 	unsigned int cflag;
 	unsigned int old_cflag;
 	unsigned int control_state, new_state;
 
-	cs = (struct cardstate *) tty->driver_data;
-	if (!cs) {
-		pr_err("%s: no cardstate\n", __func__);
-		return;
-	}
-
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
 	mutex_lock(&cs->mutex);
@@ -527,11 +455,6 @@ static void if_set_termios(struct tty_struct *tty, struct ktermios *old)
 		goto out;
 	}
 
-	if (!cs->open_count) {
-		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-		goto out;
-	}
-
 	iflag = tty->termios->c_iflag;
 	cflag = tty->termios->c_cflag;
 	old_cflag = old ? old->c_cflag : cflag;
-- 
1.7.9.2


