Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0IXAUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:20:15 -0400
Received: from ns2.cypress.com ([157.95.67.5]:50305 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0IXAUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:20:14 -0400
Subject: [PATCH] west bridge, cyasgadget fix for usb_gadget_probe_driver
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Thu, 23 Sep 2010 17:20:00 -0700
Message-Id: <1285287600.17888.2.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the west bridge cyasgadget driver in order to allow for
compilation against the linux-next tree. This changes
usb_gadget_register_driver to usb_gadget_probe_driver and updates this
function based on the new function definition (bind call).

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-20 23:40:58.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-23 16:54:32.000000000 -0700
@@ -1882,9 +1882,8 @@ static void cyas_ep0_start(
  * disconnect is reported.  then a host may connect again, or
  * the driver might get unbound.
  */
-int usb_gadget_register_driver(
-				struct usb_gadget_driver *driver
-				)
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
+		int (*bind)(struct usb_gadget *))
 {
 	cyasgadget *dev = cy_as_gadget_controller ;
 	int		retval;
@@ -1898,7 +1897,7 @@ int usb_gadget_register_driver(
 	* "must not be used in normal operation"
 	*/
 	if (!driver
-		|| !driver->bind
+		|| !bind
 		|| !driver->unbind
 		|| !driver->setup)
 		return -EINVAL;
@@ -1919,7 +1918,7 @@ int usb_gadget_register_driver(
 	cyas_usb_reset(dev) ; /* External usb */
 	cyas_usb_reinit(dev) ; /* Internal */
 
-	retval = driver->bind(&dev->gadget);
+	retval = bind(&dev->gadget);
 	if (retval) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s bind to driver %s --> %d\n",
@@ -1938,7 +1937,7 @@ int usb_gadget_register_driver(
 
 	return 0;
 }
-EXPORT_SYMBOL(usb_gadget_register_driver);
+EXPORT_SYMBOL(usb_gadget_probe_driver);
 
 static void cyasgadget_nuke(
 							cyasgadget_ep *an_ep


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

