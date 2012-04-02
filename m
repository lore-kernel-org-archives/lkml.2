Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2DBL4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:03 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48047 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 28/69] TTY: sclp_tty, add tty_port
Date: Mon,  2 Apr 2012 13:54:12 +0200
Message-Id: <1333367693-3244-29-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port will hold tty buffers in the future. So we need to have it
even here. The only needed member here is tty, so let us store it in
the structure now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/sclp_tty.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 40a9d69..e66a75b 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -48,7 +48,7 @@ static struct sclp_buffer *sclp_ttybuf;
 /* Timer for delayed output of console messages. */
 static struct timer_list sclp_tty_timer;
 
-static struct tty_struct *sclp_tty;
+static struct tty_port sclp_port;
 static unsigned char sclp_tty_chars[SCLP_TTY_BUF_SIZE];
 static unsigned short int sclp_tty_chars_count;
 
@@ -64,7 +64,7 @@ static int sclp_tty_columns = 80;
 static int
 sclp_tty_open(struct tty_struct *tty, struct file *filp)
 {
-	sclp_tty = tty;
+	tty_port_tty_set(&sclp_port, tty);
 	tty->driver_data = NULL;
 	tty->low_latency = 0;
 	return 0;
@@ -76,7 +76,7 @@ sclp_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	if (tty->count > 1)
 		return;
-	sclp_tty = NULL;
+	tty_port_tty_set(&sclp_port, NULL);
 }
 
 /*
@@ -108,6 +108,7 @@ sclp_tty_write_room (struct tty_struct *tty)
 static void
 sclp_ttybuf_callback(struct sclp_buffer *buffer, int rc)
 {
+	struct tty_struct *tty;
 	unsigned long flags;
 	void *page;
 
@@ -126,8 +127,10 @@ sclp_ttybuf_callback(struct sclp_buffer *buffer, int rc)
 		spin_unlock_irqrestore(&sclp_tty_lock, flags);
 	} while (buffer && sclp_emit_buffer(buffer, sclp_ttybuf_callback));
 	/* check if the tty needs a wake up call */
-	if (sclp_tty != NULL) {
-		tty_wakeup(sclp_tty);
+	tty = tty_port_tty_get(&sclp_port);
+	if (tty != NULL) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
 	}
 }
 
@@ -326,21 +329,22 @@ sclp_tty_flush_buffer(struct tty_struct *tty)
 static void
 sclp_tty_input(unsigned char* buf, unsigned int count)
 {
+	struct tty_struct *tty = tty_port_tty_get(&sclp_port);
 	unsigned int cchar;
 
 	/*
 	 * If this tty driver is currently closed
 	 * then throw the received input away.
 	 */
-	if (sclp_tty == NULL)
+	if (tty == NULL)
 		return;
-	cchar = ctrlchar_handle(buf, count, sclp_tty);
+	cchar = ctrlchar_handle(buf, count, tty);
 	switch (cchar & CTRLCHAR_MASK) {
 	case CTRLCHAR_SYSRQ:
 		break;
 	case CTRLCHAR_CTRL:
-		tty_insert_flip_char(sclp_tty, cchar, TTY_NORMAL);
-		tty_flip_buffer_push(sclp_tty);
+		tty_insert_flip_char(tty, cchar, TTY_NORMAL);
+		tty_flip_buffer_push(tty);
 		break;
 	case CTRLCHAR_NONE:
 		/* send (normal) input to line discipline */
@@ -348,13 +352,14 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 		    (strncmp((const char *) buf + count - 2, "^n", 2) &&
 		     strncmp((const char *) buf + count - 2, "\252n", 2))) {
 			/* add the auto \n */
-			tty_insert_flip_string(sclp_tty, buf, count);
-			tty_insert_flip_char(sclp_tty, '\n', TTY_NORMAL);
+			tty_insert_flip_string(tty, buf, count);
+			tty_insert_flip_char(tty, '\n', TTY_NORMAL);
 		} else
-			tty_insert_flip_string(sclp_tty, buf, count - 2);
-		tty_flip_buffer_push(sclp_tty);
+			tty_insert_flip_string(tty, buf, count - 2);
+		tty_flip_buffer_push(tty);
 		break;
 	}
+	tty_kref_put(tty);
 }
 
 /*
@@ -543,7 +548,7 @@ sclp_tty_init(void)
 		sclp_tty_tolower = 1;
 	}
 	sclp_tty_chars_count = 0;
-	sclp_tty = NULL;
+	tty_port_init(&sclp_port);
 
 	rc = sclp_register(&sclp_input_event);
 	if (rc) {
-- 
1.7.9.2


