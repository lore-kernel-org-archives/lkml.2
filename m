Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2DBL4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:19 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48066 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2DBLzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 32/69] TTY: tty3270, get rid of ugly aliasing
Date: Mon,  2 Apr 2012 13:54:16 +0200
Message-Id: <1333367693-3244-33-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blah, do not assume that raw3270_view is at the beginning of tty3270.
Use proper types and container_of wherever needed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/tty3270.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index f3837da..bb1514a 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -324,9 +324,8 @@ tty3270_blank_line(struct tty3270 *tp)
 static void
 tty3270_write_callback(struct raw3270_request *rq, void *data)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(rq->view, struct tty3270, view);
 
-	tp = (struct tty3270 *) rq->view;
 	if (rq->rc != 0) {
 		/* Write wasn't successful. Refresh all. */
 		tp->update_flags = TTY_UPDATE_ALL;
@@ -537,11 +536,10 @@ static void
 tty3270_read_tasklet(struct raw3270_request *rrq)
 {
 	static char kreset_data = TW_KR;
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(rrq->view, struct tty3270, view);
 	char *input;
 	int len;
 
-	tp = (struct tty3270 *) rrq->view;
 	spin_lock_bh(&tp->view.lock);
 	/*
 	 * Two AID keys are special: For 0x7d (enter) the input line
@@ -596,9 +594,10 @@ tty3270_read_tasklet(struct raw3270_request *rrq)
 static void
 tty3270_read_callback(struct raw3270_request *rq, void *data)
 {
+	struct tty3270 *tp = container_of(rq->view, struct tty3270, view);
 	raw3270_get_view(rq->view);
 	/* Schedule tasklet to pass input to tty. */
-	tasklet_schedule(&((struct tty3270 *) rq->view)->readlet);
+	tasklet_schedule(&tp->readlet);
 }
 
 /*
@@ -635,9 +634,8 @@ tty3270_issue_read(struct tty3270 *tp, int lock)
 static int
 tty3270_activate(struct raw3270_view *view)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(view, struct tty3270, view);
 
-	tp = (struct tty3270 *) view;
 	tp->update_flags = TTY_UPDATE_ALL;
 	tty3270_set_timer(tp, 1);
 	return 0;
@@ -646,9 +644,8 @@ tty3270_activate(struct raw3270_view *view)
 static void
 tty3270_deactivate(struct raw3270_view *view)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(view, struct tty3270, view);
 
-	tp = (struct tty3270 *) view;
 	del_timer(&tp->timer);
 }
 
@@ -804,10 +801,9 @@ tty3270_free_screen(struct tty3270 *tp)
 static void
 tty3270_release(struct raw3270_view *view)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = container_of(view, struct tty3270, view);
 	struct tty_struct *tty;
 
-	tp = (struct tty3270 *) view;
 	tty = tp->tty;
 	if (tty) {
 		tty->driver_data = NULL;
@@ -823,8 +819,9 @@ tty3270_release(struct raw3270_view *view)
 static void
 tty3270_free(struct raw3270_view *view)
 {
-	tty3270_free_screen((struct tty3270 *) view);
-	tty3270_free_view((struct tty3270 *) view);
+	struct tty3270 *tp = container_of(view, struct tty3270, view);
+	tty3270_free_screen(tp);
+	tty3270_free_view(tp);
 }
 
 /*
@@ -833,14 +830,13 @@ tty3270_free(struct raw3270_view *view)
 static void
 tty3270_del_views(void)
 {
-	struct tty3270 *tp;
 	int i;
 
 	for (i = 0; i < tty3270_max_index; i++) {
-		tp = (struct tty3270 *)
+		struct raw3270_view *view =
 			raw3270_find_view(&tty3270_fn, i + RAW3270_FIRSTMINOR);
-		if (!IS_ERR(tp))
-			raw3270_del_view(&tp->view);
+		if (!IS_ERR(view))
+			raw3270_del_view(view);
 	}
 }
 
@@ -858,16 +854,17 @@ static struct raw3270_fn tty3270_fn = {
 static int
 tty3270_open(struct tty_struct *tty, struct file * filp)
 {
+	struct raw3270_view *view;
 	struct tty3270 *tp;
 	int i, rc;
 
 	if (tty->count > 1)
 		return 0;
 	/* Check if the tty3270 is already there. */
-	tp = (struct tty3270 *)
-		raw3270_find_view(&tty3270_fn,
+	view = raw3270_find_view(&tty3270_fn,
 				  tty->index + RAW3270_FIRSTMINOR);
-	if (!IS_ERR(tp)) {
+	if (!IS_ERR(view)) {
+		tp = container_of(view, struct tty3270, view);
 		tty->driver_data = tp;
 		tty->winsize.ws_row = tp->view.rows - 2;
 		tty->winsize.ws_col = tp->view.cols;
@@ -881,7 +878,7 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 		tty3270_max_index = tty->index + 1;
 
 	/* Quick exit if there is no device for tty->index. */
-	if (PTR_ERR(tp) == -ENODEV)
+	if (PTR_ERR(view) == -ENODEV)
 		return -ENODEV;
 
 	/* Allocate tty3270 structure on first open. */
@@ -935,11 +932,10 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 static void
 tty3270_close(struct tty_struct *tty, struct file * filp)
 {
-	struct tty3270 *tp;
+	struct tty3270 *tp = tty->driver_data;
 
 	if (tty->count > 1)
 		return;
-	tp = (struct tty3270 *) tty->driver_data;
 	if (tp) {
 		tty->driver_data = NULL;
 		tp->tty = tp->kbd->tty = NULL;
-- 
1.7.9.2


