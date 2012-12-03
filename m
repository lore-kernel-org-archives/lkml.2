Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2LCJzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:55:09 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53063 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204Ab2LCJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:55:07 -0500
Message-ID: <50BC76E9.2070703@ilyx.ru>
Date: Mon, 03 Dec 2012 13:54:49 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] tty: Correct tty buffer flush.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never release last (struct tty_buffer) in the active buffer.
Only flush data for ldisc(tty->buf.head->read = tty->buf.head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.
Test program and bug report you can see:
https://lkml.org/lkml/2012/11/29/368

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6c9b7cd..4f02f9c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_buffer *thead;
 
-	while ((thead = tty->buf.head) != NULL) {
-		tty->buf.head = thead->next;
-		tty_buffer_free(tty, thead);
+	if (tty->buf.head == NULL)
+		return;
+	while ((thead = tty->buf.head->next) != NULL) {
+		tty_buffer_free(tty, tty->buf.head);
+		tty->buf.head = thead;
 	}
-	tty->buf.tail = NULL;
+	WARN_ON(tty->buf.head != tty->buf.tail);
+	tty->buf.head->read = tty->buf.head->commit;
 }
 
 /**
