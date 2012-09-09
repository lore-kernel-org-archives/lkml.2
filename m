Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2IIXih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:38:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51055 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab2IIXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:50 -0400
Message-Id: <20120909224153.245950226@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Ferrell <mferrell@uplogix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 17/95] usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Ferrell <mferrell@uplogix.com>

commit 5c263b92f828af6a8cf54041db45ceae5af8f2ab upstream.

 * Use the buffer content length as opposed to the total buffer size.  This can
   be a real problem when using the mos7840 as a usb serial-console as all
   kernel output is truncated during boot.

Signed-off-by: Mark Ferrell <mferrell@uplogix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1191,9 +1191,12 @@ static int mos7840_chars_in_buffer(struc
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


