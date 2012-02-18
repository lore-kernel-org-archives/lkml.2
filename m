Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2BRSzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:55:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52134 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2BRSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:54:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 19:54:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] firewire: core: fix race at address_handler
 unregistration
Message-ID: <20120218195445.564114ea@stein>
In-Reply-To: <20120218195339.13d36f44@stein>
References: <20120218195339.13d36f44@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following unlikely but possible race:

CPU 1                             CPU 2
------------------------------------------------------------------------
AR-request tasklet
    lookup handler
                                  unregister handler
				  free handler->callback_data or handler
    call handler->callback

The application which registered the handler has no way to stop nodes
sending new requests to their address range, hence cannot prevent this
race.

Fix it simply by extending the address_handler_lock-protected region
from only around the lookup to around both lookup and call.  We only
need to do so in the exclusive region handler; the FCP region handler
already holds the lock around the handler->callback call.

Alas this removes the current ability to execute the callback in
parallel on different CPUs if it was called for different FireWire cards
at the same time.  (For a single card, the handler is already
serialized.)  If this loss of a rather obscure feature is not tolerable,
a more complex fix would be required:  Add a handler reference counter;
wait in fw_core_remove_address_handler() for this conter to become zero.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -602,6 +602,9 @@ EXPORT_SYMBOL(fw_core_add_address_handle
 
 /**
  * fw_core_remove_address_handler() - unregister an address handler
+ *
+ * When fw_core_remove_address_handler() returns, @handler->callback() is
+ * guaranteed to not run on any CPU anymore.
  */
 void fw_core_remove_address_handler(struct fw_address_handler *handler)
 {
@@ -838,16 +841,16 @@ static void handle_exclusive_region_requ
 	spin_lock_irqsave(&address_handler_lock, flags);
 	handler = lookup_enclosing_address_handler(&address_handler_list,
 						   offset, request->length);
-	spin_unlock_irqrestore(&address_handler_lock, flags);
-
-	if (handler == NULL)
-		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
-	else
+	if (handler)
 		handler->address_callback(card, request,
 					  tcode, destination, source,
 					  p->generation, offset,
 					  request->data, request->length,
 					  handler->callback_data);
+	spin_unlock_irqrestore(&address_handler_lock, flags);
+
+	if (!handler)
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
 }
 
 static void handle_fcp_region_request(struct fw_card *card,

-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
