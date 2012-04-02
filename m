Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2DBL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:42 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48193 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2DBLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 33/69] TTY: tty3270, push tty down to tty3270_do_write
Date: Mon,  2 Apr 2012 13:54:17 +0200
Message-Id: <1333367693-3244-34-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we do not need to access tp->tty there. It is going away.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/tty3270.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index bb1514a..1f4aff7 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1509,12 +1509,13 @@ tty3270_escape_sequence(struct tty3270 *tp, char ch)
  * String write routine for 3270 ttys
  */
 static void
-tty3270_do_write(struct tty3270 *tp, const unsigned char *buf, int count)
+tty3270_do_write(struct tty3270 *tp, struct tty_struct *tty,
+		const unsigned char *buf, int count)
 {
 	int i_msg, i;
 
 	spin_lock_bh(&tp->view.lock);
-	for (i_msg = 0; !tp->tty->stopped && i_msg < count; i_msg++) {
+	for (i_msg = 0; !tty->stopped && i_msg < count; i_msg++) {
 		if (tp->esc_state != 0) {
 			/* Continue escape sequence. */
 			tty3270_escape_sequence(tp, buf[i_msg]);
@@ -1591,10 +1592,10 @@ tty3270_write(struct tty_struct * tty,
 	if (!tp)
 		return 0;
 	if (tp->char_count > 0) {
-		tty3270_do_write(tp, tp->char_buf, tp->char_count);
+		tty3270_do_write(tp, tty, tp->char_buf, tp->char_count);
 		tp->char_count = 0;
 	}
-	tty3270_do_write(tp, buf, count);
+	tty3270_do_write(tp, tty, buf, count);
 	return count;
 }
 
@@ -1625,7 +1626,7 @@ tty3270_flush_chars(struct tty_struct *tty)
 	if (!tp)
 		return;
 	if (tp->char_count > 0) {
-		tty3270_do_write(tp, tp->char_buf, tp->char_count);
+		tty3270_do_write(tp, tty, tp->char_buf, tp->char_count);
 		tp->char_count = 0;
 	}
 }
-- 
1.7.9.2


