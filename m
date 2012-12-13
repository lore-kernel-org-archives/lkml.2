Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2LMOyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:54:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2LMOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 074/241] USB: usb_wwan: fix bulk-urb allocation
Date: Thu, 13 Dec 2012 11:57:19 -0200
Message-Id: <1355407206-17100-75-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 8e493ca1767d4951ed1322abaa74d6edbca29918 upstream.

Make sure we do not allocate urbs if we do not have a bulk endpoint.

Legacy code used incorrect assumption to test for bulk endpoints.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: backport for 3.5: allocation splitted in attach (in
  usb_wwan_setup_urbs and usb_wwan_startup), so patch two
  locations with the size checking. ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/usb_wwan.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index f35971d..da28535 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -453,9 +453,6 @@ static struct urb *usb_wwan_setup_urb(struct usb_serial *serial, int endpoint,
 {
 	struct urb *urb;
 
-	if (endpoint == -1)
-		return NULL;	/* endpoint not needed */
-
 	urb = usb_alloc_urb(0, GFP_KERNEL);	/* No ISO */
 	if (urb == NULL) {
 		dbg("%s: alloc for endpoint %d failed.", __func__, endpoint);
@@ -483,6 +480,9 @@ static void usb_wwan_setup_urbs(struct usb_serial *serial)
 
 		/* Do indat endpoints first */
 		for (j = 0; j < N_IN_URB; ++j) {
+			if (!port->bulk_in_size)
+				break;
+
 			portdata->in_urbs[j] = usb_wwan_setup_urb(serial,
 								  port->
 								  bulk_in_endpointAddress,
@@ -496,6 +496,9 @@ static void usb_wwan_setup_urbs(struct usb_serial *serial)
 
 		/* outdat endpoints */
 		for (j = 0; j < N_OUT_URB; ++j) {
+			if (!port->bulk_out_size)
+				break;
+
 			portdata->out_urbs[j] = usb_wwan_setup_urb(serial,
 								   port->
 								   bulk_out_endpointAddress,
@@ -529,6 +532,9 @@ int usb_wwan_startup(struct usb_serial *serial)
 		init_usb_anchor(&portdata->delayed);
 
 		for (j = 0; j < N_IN_URB; j++) {
+			if (!port->bulk_in_size)
+				break;
+
 			buffer = (u8 *) __get_free_page(GFP_KERNEL);
 			if (!buffer)
 				goto bail_out_error;
@@ -536,6 +542,9 @@ int usb_wwan_startup(struct usb_serial *serial)
 		}
 
 		for (j = 0; j < N_OUT_URB; j++) {
+			if (!port->bulk_out_size)
+				break;
+
 			buffer = kmalloc(OUT_BUFLEN, GFP_KERNEL);
 			if (!buffer)
 				goto bail_out_error2;
-- 
1.7.9.5

