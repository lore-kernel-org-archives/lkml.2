Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2LEIs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:48:28 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53622 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab2LEIsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:48:23 -0500
Message-ID: <50BF0A56.9050209@ilyx.ru>
Date: Wed, 05 Dec 2012 12:48:22 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH -next 2/2] tty: Correct tty buffer flush.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty: Correct tty buffer flush.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
 drivers/tty/tty_buffer.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

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
