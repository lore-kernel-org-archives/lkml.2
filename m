Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0KSVrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:47:47 -0500
Received: from kroah.org ([198.145.64.141]:51875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab0KSVpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:40 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:12 2010
Message-Id: <20101119214412.471207712@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alon Ziv <alon-git@nolaviz.org>
Subject: [37/45] USB: opticon: Fix long-standing bugs in opticon driver
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -99,8 +99,8 @@ static void opticon_bulk_callback(struct
 				available_room = tty_buffer_request_room(tty,
 								data_length);
 				if (available_room) {
-					tty_insert_flip_string(tty, data,
-							       available_room);
+					tty_insert_flip_string(tty, data + 2,
+							       data_length);
 					tty_flip_buffer_push(tty);
 				}
 				tty_kref_put(tty);
@@ -134,7 +134,7 @@ exit:
 						  priv->bulk_address),
 				  priv->bulk_in_buffer, priv->buffer_size,
 				  opticon_bulk_callback, priv);
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
 		if (result)
 			dev_err(&port->dev,
 			    "%s - failed resubmitting read urb, error %d\n",


