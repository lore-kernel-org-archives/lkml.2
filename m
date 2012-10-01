Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab2JAXd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:33:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35139 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab2JAXAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:22 -0400
Message-Id: <20121001225202.952908501@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Ferrell <mferrell@uplogix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 126/180] usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Ferrell <mferrell@uplogix.com>

commit 5c263b92f828af6a8cf54041db45ceae5af8f2ab upstream.

 * Use the buffer content length as opposed to the total buffer size.  This can
   be a real problem when using the mos7840 as a usb serial-console as all
   kernel output is truncated during boot.

Signed-off-by: Mark Ferrell <mferrell@uplogix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/mos7840.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 9fdcee2..61829b8 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1181,9 +1181,12 @@ static int mos7840_chars_in_buffer(struct tty_struct *tty)
 	}
 
 	spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-	for (i = 0; i < NUM_URBS; ++i)
-		if (mos7840_port->busy[i])
-			chars += URB_TRANSFER_BUFFER_SIZE;
+	for (i = 0; i < NUM_URBS; ++i) {
+		if (mos7840_port->busy[i]) {
+			struct urb *urb = mos7840_port->write_urb_pool[i];
+			chars += urb->transfer_buffer_length;
+		}
+	}
 	spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 	dbg("%s - returns %d", __func__, chars);
 	return chars;
-- 
1.7.2.1.45.g54fbc



