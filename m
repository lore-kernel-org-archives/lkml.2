Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2DBL4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48084 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2DBLzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 34/69] TTY: tty3270, add tty_port
Date: Mon,  2 Apr 2012 13:54:18 +0200
Message-Id: <1333367693-3244-35-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use tty from that. This means, we convert most of the users to
accept tty_port instead. This is not racy and ensures the tty to be
properly refcounted.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/keyboard.c |   30 ++++++++++++++------------
 drivers/s390/char/keyboard.h |   14 +++++++++---
 drivers/s390/char/tty3270.c  |   48 ++++++++++++++++++------------------------
 3 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index 8065881..7ef9cfd 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -199,7 +199,7 @@ handle_diacr(struct kbd_data *kbd, unsigned int ch)
 	if (ch == ' ' || ch == d)
 		return d;
 
-	kbd_put_queue(kbd->tty, d);
+	kbd_put_queue(kbd->port, d);
 	return ch;
 }
 
@@ -221,7 +221,7 @@ k_self(struct kbd_data *kbd, unsigned char value)
 {
 	if (kbd->diacr)
 		value = handle_diacr(kbd, value);
-	kbd_put_queue(kbd->tty, value);
+	kbd_put_queue(kbd->port, value);
 }
 
 /*
@@ -239,7 +239,7 @@ static void
 k_fn(struct kbd_data *kbd, unsigned char value)
 {
 	if (kbd->func_table[value])
-		kbd_puts_queue(kbd->tty, kbd->func_table[value]);
+		kbd_puts_queue(kbd->port, kbd->func_table[value]);
 }
 
 static void
@@ -257,20 +257,20 @@ k_spec(struct kbd_data *kbd, unsigned char value)
  * but we need only 16 bits here
  */
 static void
-to_utf8(struct tty_struct *tty, ushort c) 
+to_utf8(struct tty_port *port, ushort c)
 {
 	if (c < 0x80)
 		/*  0******* */
-		kbd_put_queue(tty, c);
+		kbd_put_queue(port, c);
 	else if (c < 0x800) {
 		/* 110***** 10****** */
-		kbd_put_queue(tty, 0xc0 | (c >> 6));
-		kbd_put_queue(tty, 0x80 | (c & 0x3f));
+		kbd_put_queue(port, 0xc0 | (c >> 6));
+		kbd_put_queue(port, 0x80 | (c & 0x3f));
 	} else {
 		/* 1110**** 10****** 10****** */
-		kbd_put_queue(tty, 0xe0 | (c >> 12));
-		kbd_put_queue(tty, 0x80 | ((c >> 6) & 0x3f));
-		kbd_put_queue(tty, 0x80 | (c & 0x3f));
+		kbd_put_queue(port, 0xe0 | (c >> 12));
+		kbd_put_queue(port, 0x80 | ((c >> 6) & 0x3f));
+		kbd_put_queue(port, 0x80 | (c & 0x3f));
 	}
 }
 
@@ -283,7 +283,7 @@ kbd_keycode(struct kbd_data *kbd, unsigned int keycode)
 	unsigned short keysym;
 	unsigned char type, value;
 
-	if (!kbd || !kbd->tty)
+	if (!kbd)
 		return;
 
 	if (keycode >= 384)
@@ -323,7 +323,7 @@ kbd_keycode(struct kbd_data *kbd, unsigned int keycode)
 #endif
 		(*k_handler[type])(kbd, value);
 	} else
-		to_utf8(kbd->tty, keysym);
+		to_utf8(kbd->port, keysym);
 }
 
 /*
@@ -457,6 +457,7 @@ do_kdgkb_ioctl(struct kbd_data *kbd, struct kbsentry __user *u_kbs,
 
 int kbd_ioctl(struct kbd_data *kbd, unsigned int cmd, unsigned long arg)
 {
+	struct tty_struct *tty;
 	void __user *argp;
 	unsigned int ct;
 	int perm;
@@ -467,7 +468,10 @@ int kbd_ioctl(struct kbd_data *kbd, unsigned int cmd, unsigned long arg)
 	 * To have permissions to do most of the vt ioctls, we either have
 	 * to be the owner of the tty, or have CAP_SYS_TTY_CONFIG.
 	 */
-	perm = current->signal->tty == kbd->tty || capable(CAP_SYS_TTY_CONFIG);
+	tty = tty_port_tty_get(kbd->port);
+	/* FIXME this test is pretty racy */
+	perm = current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG);
+	tty_kref_put(tty);
 	switch (cmd) {
 	case KDGKBTYPE:
 		return put_user(KB_101, (char __user *)argp);
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index 7e736aa..f682f4e 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -21,7 +21,7 @@ typedef void (fn_handler_fn)(struct kbd_data *);
  */
 
 struct kbd_data {
-	struct tty_struct *tty;
+	struct tty_port *port;
 	unsigned short **key_maps;
 	char **func_table;
 	fn_handler_fn **fn_handler;
@@ -42,16 +42,24 @@ int kbd_ioctl(struct kbd_data *, unsigned int, unsigned long);
  * Helper Functions.
  */
 static inline void
-kbd_put_queue(struct tty_struct *tty, int ch)
+kbd_put_queue(struct tty_port *port, int ch)
 {
+	struct tty_struct *tty = tty_port_tty_get(port);
+	if (!tty)
+		return;
 	tty_insert_flip_char(tty, ch, 0);
 	tty_schedule_flip(tty);
+	tty_kref_put(tty);
 }
 
 static inline void
-kbd_puts_queue(struct tty_struct *tty, char *cp)
+kbd_puts_queue(struct tty_port *port, char *cp)
 {
+	struct tty_struct *tty = tty_port_tty_get(port);
+	if (!tty)
+		return;
 	while (*cp)
 		tty_insert_flip_char(tty, *cp++, 0);
 	tty_schedule_flip(tty);
+	tty_kref_put(tty);
 }
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 1f4aff7..10ec690 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -61,7 +61,7 @@ struct tty3270_line {
  */
 struct tty3270 {
 	struct raw3270_view view;
-	struct tty_struct *tty;		/* Pointer to tty structure */
+	struct tty_port port;
 	void **freemem_pages;		/* Array of pages used for freemem. */
 	struct list_head freemem;	/* List of free memory for strings. */
 
@@ -449,10 +449,9 @@ tty3270_rcl_add(struct tty3270 *tp, char *input, int len)
 static void
 tty3270_rcl_backward(struct kbd_data *kbd)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(kbd->port, struct tty3270, port);
 	struct string *s;
 
-	tp = kbd->tty->driver_data;
 	spin_lock_bh(&tp->view.lock);
 	if (tp->inattr == TF_INPUT) {
 		if (tp->rcl_walk && tp->rcl_walk->prev != &tp->rcl_lines)
@@ -477,9 +476,8 @@ tty3270_rcl_backward(struct kbd_data *kbd)
 static void
 tty3270_exit_tty(struct kbd_data *kbd)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(kbd->port, struct tty3270, port);
 
-	tp = kbd->tty->driver_data;
 	raw3270_deactivate_view(&tp->view);
 }
 
@@ -489,10 +487,9 @@ tty3270_exit_tty(struct kbd_data *kbd)
 static void
 tty3270_scroll_forward(struct kbd_data *kbd)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(kbd->port, struct tty3270, port);
 	int nr_up;
 
-	tp = kbd->tty->driver_data;
 	spin_lock_bh(&tp->view.lock);
 	nr_up = tp->nr_up - tp->view.rows + 2;
 	if (nr_up < 0)
@@ -512,10 +509,9 @@ tty3270_scroll_forward(struct kbd_data *kbd)
 static void
 tty3270_scroll_backward(struct kbd_data *kbd)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(kbd->port, struct tty3270, port);
 	int nr_up;
 
-	tp = kbd->tty->driver_data;
 	spin_lock_bh(&tp->view.lock);
 	nr_up = tp->nr_up + tp->view.rows - 2;
 	if (nr_up + tp->view.rows - 2 > tp->nr_lines)
@@ -575,13 +571,10 @@ tty3270_read_tasklet(struct raw3270_request *rrq)
 	raw3270_request_add_data(tp->kreset, &kreset_data, 1);
 	raw3270_start(&tp->view, tp->kreset);
 
-	/* Emit input string. */
-	if (tp->tty) {
-		while (len-- > 0)
-			kbd_keycode(tp->kbd, *input++);
-		/* Emit keycode for AID byte. */
-		kbd_keycode(tp->kbd, 256 + tp->input->string[0]);
-	}
+	while (len-- > 0)
+		kbd_keycode(tp->kbd, *input++);
+	/* Emit keycode for AID byte. */
+	kbd_keycode(tp->kbd, 256 + tp->input->string[0]);
 
 	raw3270_request_reset(rrq);
 	xchg(&tp->read, rrq);
@@ -691,6 +684,7 @@ tty3270_alloc_view(void)
 	INIT_LIST_HEAD(&tp->update);
 	INIT_LIST_HEAD(&tp->rcl_lines);
 	tp->rcl_max = 20;
+	tty_port_init(&tp->port);
 	setup_timer(&tp->timer, (void (*)(unsigned long)) tty3270_update,
 		    (unsigned long) tp);
 	tasklet_init(&tp->readlet,
@@ -802,14 +796,14 @@ static void
 tty3270_release(struct raw3270_view *view)
 {
 	struct tty3270 *tp = container_of(view, struct tty3270, view);
-	struct tty_struct *tty;
+	struct tty_struct *tty = tty_port_tty_get(&tp->port);
 
-	tty = tp->tty;
 	if (tty) {
 		tty->driver_data = NULL;
-		tp->tty = tp->kbd->tty = NULL;
+		tty_port_tty_set(&tp->port, NULL);
 		tty_hangup(tty);
 		raw3270_put_view(&tp->view);
+		tty_kref_put(tty);
 	}
 }
 
@@ -869,8 +863,8 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 		tty->winsize.ws_row = tp->view.rows - 2;
 		tty->winsize.ws_col = tp->view.cols;
 		tty->low_latency = 0;
-		tp->tty = tty;
-		tp->kbd->tty = tty;
+		/* why to reassign? */
+		tty_port_tty_set(&tp->port, tty);
 		tp->inattr = TF_INPUT;
 		return 0;
 	}
@@ -900,7 +894,7 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 		return rc;
 	}
 
-	tp->tty = tty;
+	tty_port_tty_set(&tp->port, tty);
 	tty->low_latency = 0;
 	tty->driver_data = tp;
 	tty->winsize.ws_row = tp->view.rows - 2;
@@ -914,7 +908,7 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 	for (i = 0; i < tp->view.rows - 2; i++)
 		tty3270_blank_line(tp);
 
-	tp->kbd->tty = tty;
+	tp->kbd->port = &tp->port;
 	tp->kbd->fn_handler[KVAL(K_INCRCONSOLE)] = tty3270_exit_tty;
 	tp->kbd->fn_handler[KVAL(K_SCROLLBACK)] = tty3270_scroll_backward;
 	tp->kbd->fn_handler[KVAL(K_SCROLLFORW)] = tty3270_scroll_forward;
@@ -938,7 +932,7 @@ tty3270_close(struct tty_struct *tty, struct file * filp)
 		return;
 	if (tp) {
 		tty->driver_data = NULL;
-		tp->tty = tp->kbd->tty = NULL;
+		tty_port_tty_set(&tp->port, NULL);
 		raw3270_put_view(&tp->view);
 	}
 }
@@ -1387,7 +1381,7 @@ tty3270_escape_sequence(struct tty3270 *tp, char ch)
 			tty3270_lf(tp);
 			break;
 		case 'Z':		/* Respond ID. */
-			kbd_puts_queue(tp->tty, "\033[?6c");
+			kbd_puts_queue(&tp->port, "\033[?6c");
 			break;
 		case '7':		/* Save cursor position. */
 			tp->saved_cx = tp->cx;
@@ -1433,11 +1427,11 @@ tty3270_escape_sequence(struct tty3270 *tp, char ch)
 	tp->esc_state = ESnormal;
 	if (ch == 'n' && !tp->esc_ques) {
 		if (tp->esc_par[0] == 5)		/* Status report. */
-			kbd_puts_queue(tp->tty, "\033[0n");
+			kbd_puts_queue(&tp->port, "\033[0n");
 		else if (tp->esc_par[0] == 6) {	/* Cursor report. */
 			char buf[40];
 			sprintf(buf, "\033[%d;%dR", tp->cy + 1, tp->cx + 1);
-			kbd_puts_queue(tp->tty, buf);
+			kbd_puts_queue(&tp->port, buf);
 		}
 		return;
 	}
-- 
1.7.9.2


