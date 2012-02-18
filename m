Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2BRTmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 14:42:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52392 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2BRTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 14:42:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 20:42:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: do not disable local IRQs while handling
 requests
Message-ID: <20120218204200.759e2dd1@stein>
In-Reply-To: <20120218201139.38f03f4b@stein>
References: <20120218195339.13d36f44@stein>
	<20120218195445.564114ea@stein>
	<20120218201139.38f03f4b@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_core_handle_request() is called by the low-level driver in tasklet
context or process context, and fw_core_add/remove_address_handler() is
called by mid- or high-level code in process context.  So convert
address_handler_lock accesses from those which disable local IRQs to
ones which just disable local softIRQs.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Only lightly tested without lockdep; I have yet to boot back into a
lockdep-enabled kernel.

Also to do:  Convert accesses of other locks of this kind, e.g. in
isochronous I/O handlers, and convert high-level code too.

 drivers/firewire/core-transaction.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -565,7 +565,6 @@ int fw_core_add_address_handler(struct f
 				const struct fw_address_region *region)
 {
 	struct fw_address_handler *other;
-	unsigned long flags;
 	int ret = -EBUSY;
 
 	if (region->start & 0xffff000000000003ULL ||
@@ -575,7 +574,7 @@ int fw_core_add_address_handler(struct f
 	    handler->length == 0)
 		return -EINVAL;
 
-	spin_lock_irqsave(&address_handler_lock, flags);
+	spin_lock_bh(&address_handler_lock);
 
 	handler->offset = region->start;
 	while (handler->offset + handler->length <= region->end) {
@@ -594,7 +593,7 @@ int fw_core_add_address_handler(struct f
 		}
 	}
 
-	spin_unlock_irqrestore(&address_handler_lock, flags);
+	spin_unlock_bh(&address_handler_lock);
 
 	return ret;
 }
@@ -608,11 +607,9 @@ EXPORT_SYMBOL(fw_core_add_address_handle
  */
 void fw_core_remove_address_handler(struct fw_address_handler *handler)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&address_handler_lock, flags);
+	spin_lock_bh(&address_handler_lock);
 	list_del(&handler->link);
-	spin_unlock_irqrestore(&address_handler_lock, flags);
+	spin_unlock_bh(&address_handler_lock);
 }
 EXPORT_SYMBOL(fw_core_remove_address_handler);
 
@@ -829,7 +826,6 @@ static void handle_exclusive_region_requ
 					    unsigned long long offset)
 {
 	struct fw_address_handler *handler;
-	unsigned long flags;
 	int tcode, destination, source;
 
 	destination = HEADER_GET_DESTINATION(p->header[0]);
@@ -838,7 +834,7 @@ static void handle_exclusive_region_requ
 	if (tcode == TCODE_LOCK_REQUEST)
 		tcode = 0x10 + HEADER_GET_EXTENDED_TCODE(p->header[3]);
 
-	spin_lock_irqsave(&address_handler_lock, flags);
+	spin_lock_bh(&address_handler_lock);
 	handler = lookup_enclosing_address_handler(&address_handler_list,
 						   offset, request->length);
 	if (handler)
@@ -847,7 +843,7 @@ static void handle_exclusive_region_requ
 					  p->generation, offset,
 					  request->data, request->length,
 					  handler->callback_data);
-	spin_unlock_irqrestore(&address_handler_lock, flags);
+	spin_unlock_bh(&address_handler_lock);
 
 	if (!handler)
 		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
@@ -859,7 +855,6 @@ static void handle_fcp_region_request(st
 				      unsigned long long offset)
 {
 	struct fw_address_handler *handler;
-	unsigned long flags;
 	int tcode, destination, source;
 
 	if ((offset != (CSR_REGISTER_BASE | CSR_FCP_COMMAND) &&
@@ -881,7 +876,7 @@ static void handle_fcp_region_request(st
 		return;
 	}
 
-	spin_lock_irqsave(&address_handler_lock, flags);
+	spin_lock_bh(&address_handler_lock);
 	list_for_each_entry(handler, &address_handler_list, link) {
 		if (is_enclosing_handler(handler, offset, request->length))
 			handler->address_callback(card, NULL, tcode,
@@ -891,7 +886,7 @@ static void handle_fcp_region_request(st
 						  request->length,
 						  handler->callback_data);
 	}
-	spin_unlock_irqrestore(&address_handler_lock, flags);
+	spin_unlock_bh(&address_handler_lock);
 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
