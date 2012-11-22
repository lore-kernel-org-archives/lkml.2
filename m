Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2KVWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2KVSdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 40/83] USB: usb_wwan: fix bulk-urb allocation
Date: Wed, 21 Nov 2012 16:42:02 -0800
Message-Id: <20121122004217.089503376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 8e493ca1767d4951ed1322abaa74d6edbca29918 upstream.

Make sure we do not allocate urbs if we do not have a bulk endpoint.

Legacy code used incorrect assumption to test for bulk endpoints.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb_wwan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -455,9 +455,6 @@ static struct urb *usb_wwan_setup_urb(st
 	struct usb_serial *serial = port->serial;
 	struct urb *urb;
 
-	if (endpoint == -1)
-		return NULL;	/* endpoint not needed */
-
 	urb = usb_alloc_urb(0, GFP_KERNEL);	/* No ISO */
 	if (urb == NULL) {
 		dbg("%s: alloc for endpoint %d failed.", __func__, endpoint);
@@ -487,6 +484,9 @@ int usb_wwan_port_probe(struct usb_seria
 	init_usb_anchor(&portdata->delayed);
 
 	for (i = 0; i < N_IN_URB; i++) {
+		if (!port->bulk_in_size)
+			break;
+
 		buffer = (u8 *)__get_free_page(GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error;
@@ -499,8 +499,8 @@ int usb_wwan_port_probe(struct usb_seria
 		portdata->in_urbs[i] = urb;
  	}
 	for (i = 0; i < N_OUT_URB; i++) {
-		if (port->bulk_out_endpointAddress == -1)
-			continue;
+		if (!port->bulk_out_size)
+			break;
 
 		buffer = kmalloc(OUT_BUFLEN, GFP_KERNEL);
 		if (!buffer)


