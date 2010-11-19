Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0KSV6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:53 -0500
Received: from kroah.org ([198.145.64.141]:45177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465Ab0KSV6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:48 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215642.698580675@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alon Ziv <alon-git@nolaviz.org>
Subject: [48/82] USB: opticon: Fix long-standing bugs in opticon driver
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alon Ziv <alon+git@nolaviz.org>

commit 97cd8dc4ca9a1a5efb2cc38758e01492e3b013e2 upstream.

The bulk-read callback had two bugs:
a) The bulk-in packet's leading two zeros were returned (and the two last
   bytes truncated)
b) The wrong URB was transmitted for the second (and later) read requests,
   causing further reads to return the entire packet (including leading
   zeros)

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/opticon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -96,8 +96,8 @@ static void opticon_bulk_callback(struct
 			/* real data, send it to the tty layer */
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				tty_insert_flip_string(tty, data,
-							       data_length);
+				tty_insert_flip_string(tty, data + 2,
+						       data_length);
 				tty_flip_buffer_push(tty);
 				tty_kref_put(tty);
 			}
@@ -130,7 +130,7 @@ exit:
 						  priv->bulk_address),
 				  priv->bulk_in_buffer, priv->buffer_size,
 				  opticon_bulk_callback, priv);
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
 		if (result)
 			dev_err(&port->dev,
 			    "%s - failed resubmitting read urb, error %d\n",


