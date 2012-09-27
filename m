Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2I0Toz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:44:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49743 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2I0Toy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:44:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 27 Sep 2012 21:44:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Message-ID: <20120927214436.1da8b8ef@stein>
In-Reply-To: <20120820030450.7f5bfa37@stein>
References: <1345359002.6089.3.camel@thor>
	<20120819122759.30f9981f@stein>
	<1345403610.7706.72.camel@thor>
	<20120820030450.7f5bfa37@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Sun, 19 Aug 2012 02:50:02 -0400
From: Peter Hurley <peter@hurleysoftware.com>

Upper-layer handlers for inbound requests were called with a spinlock
held by firewire-core.  Calling into upper layers with a lower layer
lock held is generally a bad idea.

What's more, since commit ea102d0ec475 "firewire: core: convert AR-req
handler lock from _irqsave to _bh", a caller of fw_send_request() i.e.
initiator of outbound request could no longer do that while having
interrupts disabled, if the local node was addressed by that request.

In order to make all this more flexible, convert the management of
address ranges and handlers from a global lock around readers and
writers to RCU (and a remaining global lock for writers).  As a minor
side effect, handling of inbound requests at different cards are now no
longer serialized.  (There is still per-card serialization since
firewire-ohci uses a single DMA tasklet for inbound request events.)

In other words, address handlers are now called in an RCU read-side
critical section instead of from within a spin_lock_bh serialized
section.

(Changelog rewritten by Stefan R.)

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Peter, are you OK with the new changelog?

 drivers/firewire/core-transaction.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -489,7 +489,7 @@ static struct fw_address_handler *lookup
 {
 	struct fw_address_handler *handler;
 
-	list_for_each_entry(handler, list, link) {
+	list_for_each_entry_rcu(handler, list, link) {
 		if (handler->offset < offset + length &&
 		    offset < handler->offset + handler->length)
 			return handler;
@@ -510,7 +510,7 @@ static struct fw_address_handler *lookup
 {
 	struct fw_address_handler *handler;
 
-	list_for_each_entry(handler, list, link) {
+	list_for_each_entry_rcu(handler, list, link) {
 		if (is_enclosing_handler(handler, offset, length))
 			return handler;
 	}
@@ -588,7 +588,7 @@ int fw_core_add_address_handler(struct f
 		if (other != NULL) {
 			handler->offset += other->length;
 		} else {
-			list_add_tail(&handler->link, &address_handler_list);
+			list_add_tail_rcu(&handler->link, &address_handler_list);
 			ret = 0;
 			break;
 		}
@@ -609,8 +609,9 @@ EXPORT_SYMBOL(fw_core_add_address_handle
 void fw_core_remove_address_handler(struct fw_address_handler *handler)
 {
 	spin_lock_bh(&address_handler_lock);
-	list_del(&handler->link);
+	list_del_rcu(&handler->link);
 	spin_unlock_bh(&address_handler_lock);
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(fw_core_remove_address_handler);
 
@@ -844,7 +845,7 @@ static void handle_exclusive_region_requ
 	if (tcode == TCODE_LOCK_REQUEST)
 		tcode = 0x10 + HEADER_GET_EXTENDED_TCODE(p->header[3]);
 
-	spin_lock_bh(&address_handler_lock);
+	rcu_read_lock();
 	handler = lookup_enclosing_address_handler(&address_handler_list,
 						   offset, request->length);
 	if (handler)
@@ -853,7 +854,7 @@ static void handle_exclusive_region_requ
 					  p->generation, offset,
 					  request->data, request->length,
 					  handler->callback_data);
-	spin_unlock_bh(&address_handler_lock);
+	rcu_read_unlock();
 
 	if (!handler)
 		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
@@ -886,8 +887,8 @@ static void handle_fcp_region_request(st
 		return;
 	}
 
-	spin_lock_bh(&address_handler_lock);
-	list_for_each_entry(handler, &address_handler_list, link) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(handler, &address_handler_list, link) {
 		if (is_enclosing_handler(handler, offset, request->length))
 			handler->address_callback(card, NULL, tcode,
 						  destination, source,
@@ -896,7 +897,7 @@ static void handle_fcp_region_request(st
 						  request->length,
 						  handler->callback_data);
 	}
-	spin_unlock_bh(&address_handler_lock);
+	rcu_read_unlock();
 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }


-- 
Stefan Richter
-=====-===-- =--= ==-==
http://arcgraph.de/sr/
