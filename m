Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2DBLzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:52 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48049 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 29/69] TTY: sclp_vt220, add tty_port
Date: Mon,  2 Apr 2012 13:54:13 +0200
Message-Id: <1333367693-3244-30-git-send-email-jslaby@suse.cz>
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
 drivers/s390/char/sclp_vt220.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index b635472..25cf2e8 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -56,8 +56,7 @@ struct sclp_vt220_sccb {
 /* Structures and data needed to register tty driver */
 static struct tty_driver *sclp_vt220_driver;
 
-/* The tty_struct that the kernel associated with us */
-static struct tty_struct *sclp_vt220_tty;
+static struct tty_port sclp_vt220_port;
 
 /* Lock to protect internal data from concurrent access */
 static spinlock_t sclp_vt220_lock;
@@ -116,6 +115,7 @@ static struct sclp_register sclp_vt220_register = {
 static void
 sclp_vt220_process_queue(struct sclp_vt220_request *request)
 {
+	struct tty_struct *tty;
 	unsigned long flags;
 	void *page;
 
@@ -141,8 +141,10 @@ sclp_vt220_process_queue(struct sclp_vt220_request *request)
 	if (request == NULL && sclp_vt220_flush_later)
 		sclp_vt220_emit_current();
 	/* Check if the tty needs a wake up call */
-	if (sclp_vt220_tty != NULL) {
-		tty_wakeup(sclp_vt220_tty);
+	tty = tty_port_tty_get(&sclp_vt220_port);
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
 	}
 }
 
@@ -460,11 +462,12 @@ sclp_vt220_write(struct tty_struct *tty, const unsigned char *buf, int count)
 static void
 sclp_vt220_receiver_fn(struct evbuf_header *evbuf)
 {
+	struct tty_struct *tty = tty_port_tty_get(&sclp_vt220_port);
 	char *buffer;
 	unsigned int count;
 
 	/* Ignore input if device is not open */
-	if (sclp_vt220_tty == NULL)
+	if (tty == NULL)
 		return;
 
 	buffer = (char *) ((addr_t) evbuf + sizeof(struct evbuf_header));
@@ -478,10 +481,11 @@ sclp_vt220_receiver_fn(struct evbuf_header *evbuf)
 		/* Send input to line discipline */
 		buffer++;
 		count--;
-		tty_insert_flip_string(sclp_vt220_tty, buffer, count);
-		tty_flip_buffer_push(sclp_vt220_tty);
+		tty_insert_flip_string(tty, buffer, count);
+		tty_flip_buffer_push(tty);
 		break;
 	}
+	tty_kref_put(tty);
 }
 
 /*
@@ -491,7 +495,7 @@ static int
 sclp_vt220_open(struct tty_struct *tty, struct file *filp)
 {
 	if (tty->count == 1) {
-		sclp_vt220_tty = tty;
+		tty_port_tty_set(&sclp_vt220_port, tty);
 		tty->driver_data = kmalloc(SCLP_VT220_BUF_SIZE, GFP_KERNEL);
 		if (tty->driver_data == NULL)
 			return -ENOMEM;
@@ -511,7 +515,7 @@ static void
 sclp_vt220_close(struct tty_struct *tty, struct file *filp)
 {
 	if (tty->count == 1) {
-		sclp_vt220_tty = NULL;
+		tty_port_tty_set(&sclp_vt220_port, NULL);
 		kfree(tty->driver_data);
 		tty->driver_data = NULL;
 	}
@@ -635,9 +639,9 @@ static int __init __sclp_vt220_init(int num_pages)
 	INIT_LIST_HEAD(&sclp_vt220_empty);
 	INIT_LIST_HEAD(&sclp_vt220_outqueue);
 	init_timer(&sclp_vt220_timer);
+	tty_port_init(&sclp_vt220_port);
 	sclp_vt220_current_request = NULL;
 	sclp_vt220_buffered_chars = 0;
-	sclp_vt220_tty = NULL;
 	sclp_vt220_flush_later = 0;
 
 	/* Allocate pages for output buffering */
-- 
1.7.9.2


