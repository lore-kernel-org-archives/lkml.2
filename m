Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2LEMxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:53:24 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53762 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171Ab2LEMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:53:22 -0500
Message-ID: <50BF43BF.3050506@ilyx.ru>
Date: Wed, 05 Dec 2012 16:53:19 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH -next 2/2] tty: Correct tty buffer flush.
References: <50BF0A56.9050209@ilyx.ru>
In-Reply-To: <50BF0A56.9050209@ilyx.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
Only flush the data for ldisc(tty->buf.head->read = tty->buf.head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 7602df8..8a3333d 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -119,11 +119,14 @@ static void __tty_buffer_flush(struct tty_port *port)
 	struct tty_bufhead *buf = &port->buf;
 	struct tty_buffer *thead;
 
-	while ((thead = buf->head) != NULL) {
-		buf->head = thead->next;
-		tty_buffer_free(port, thead);
+	if (unlikely(buf->head == NULL))
+		return;
+	while ((thead = buf->head->next) != NULL) {
+		tty_buffer_free(port, buf->head);
+		buf->head = thead;
 	}
-	buf->tail = NULL;
+	WARN_ON(buf->head != buf->tail);
+	buf->head->read = buf->head->commit;
 }
 
 /**
