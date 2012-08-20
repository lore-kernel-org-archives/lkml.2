Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2HTD7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:59:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2HTD71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:59:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Ferrell <mferrell@uplogix.com>
Subject: [ 30/32] usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
Date: Sun, 19 Aug 2012 20:57:26 -0700
Message-Id: <20120820035652.053100835@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Ferrell <mferrell@uplogix.com>

commit 5c263b92f828af6a8cf54041db45ceae5af8f2ab upstream.

 * Use the buffer content length as opposed to the total buffer size.  This can
   be a real problem when using the mos7840 as a usb serial-console as all
   kernel output is truncated during boot.

Signed-off-by: Mark Ferrell <mferrell@uplogix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1189,9 +1189,12 @@ static int mos7840_chars_in_buffer(struc
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


