Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0FAU7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:59:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab0FAUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 16/31] tty: Move the vt_tty field from the vc_data into the standard tty_port
Date: Tue,  1 Jun 2010 22:52:56 +0200
Message-Id: <1275425591-8803-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QIQlfnyO0TKjLVBkThOGf6f+6J6n59SBDQxO
 m6RDLFC9W4CifUIIOpmclLSBEROskwiyNmEwd86Zk35KJVi9JN
 PNQMOxztZihN5BPyLijsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This takes all the tty references through the expected interface points so
we can refcount them.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/keyboard.c        |   10 +++++-----
 drivers/char/vt.c              |   10 +++++-----
 drivers/char/vt_ioctl.c        |    2 +-
 include/linux/console_struct.h |    1 -
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 54109dc..ec733f1 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -299,7 +299,7 @@ int kbd_rate(struct kbd_repeat *rep)
  */
 static void put_queue(struct vc_data *vc, int ch)
 {
-	struct tty_struct *tty = vc->vc_tty;
+	struct tty_struct *tty = vc->port.tty;
 
 	if (tty) {
 		tty_insert_flip_char(tty, ch, 0);
@@ -309,7 +309,7 @@ static void put_queue(struct vc_data *vc, int ch)
 
 static void puts_queue(struct vc_data *vc, char *cp)
 {
-	struct tty_struct *tty = vc->vc_tty;
+	struct tty_struct *tty = vc->port.tty;
 
 	if (!tty)
 		return;
@@ -485,7 +485,7 @@ static void fn_show_ptregs(struct vc_data *vc)
 
 static void fn_hold(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->vc_tty;
+	struct tty_struct *tty = vc->port.tty;
 
 	if (rep || !tty)
 		return;
@@ -563,7 +563,7 @@ static void fn_inc_console(struct vc_data *vc)
 
 static void fn_send_intr(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->vc_tty;
+	struct tty_struct *tty = vc->port.tty;
 
 	if (!tty)
 		return;
@@ -1162,7 +1162,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 	int rc;
 
-	tty = vc->vc_tty;
+	tty = vc->port.tty;
 
 	if (tty && (!tty->driver_data)) {
 		/* No driver data? Strange. Okay we fix it then. */
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 8c77ecb..2f50056 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -961,12 +961,12 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
  *	Resize a virtual console as seen from the console end of things. We
  *	use the common vc_do_resize methods to update the structures. The
  *	caller must hold the console sem to protect console internals and
- *	vc->vc_tty
+ *	vc->port.tty
  */
 
 int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int rows)
 {
-	return vc_do_resize(vc->vc_tty, vc, cols, rows);
+	return vc_do_resize(vc->port.tty, vc, cols, rows);
 }
 
 /**
@@ -2795,12 +2795,12 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 			struct vc_data *vc = vc_cons[currcons].d;
 
 			/* Still being freed */
-			if (vc->vc_tty) {
+			if (vc->port.tty) {
 				release_console_sem();
 				return -ERESTARTSYS;
 			}
 			tty->driver_data = vc;
-			vc->vc_tty = tty;
+			vc->port.tty = tty;
 
 			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
@@ -2828,7 +2828,7 @@ static void con_shutdown(struct tty_struct *tty)
 	struct vc_data *vc = tty->driver_data;
 	BUG_ON(vc == NULL);
 	acquire_console_sem();
-	vc->vc_tty = NULL;
+	vc->port.tty = NULL;
 	release_console_sem();
 	tty_shutdown(tty);
 }
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..625f77d 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1367,7 +1367,7 @@ void vc_SAK(struct work_struct *work)
 	acquire_console_sem();
 	vc = vc_con->d;
 	if (vc) {
-		tty = vc->vc_tty;
+		tty = vc->port.tty;
 		/*
 		 * SAK should also work in all raw modes and reset
 		 * them properly.
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 57e83f1..3364898 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -58,7 +58,6 @@ struct vc_data {
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
-	struct tty_struct *vc_tty;		/* TTY we are attached to */
 	/* data for manual vt switching */
 	struct vt_mode	vt_mode;
 	struct pid 	*vt_pid;
-- 
1.7.0.4

