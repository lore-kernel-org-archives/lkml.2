Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0FTUwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:52:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51911 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab0FTUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:52:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:51:46 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/8] firewire: cdev: fix responses to nodes at different card
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.d02278a5592d11e3@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Tue, 18 May 2010 14:02:45 -0400
From: Jay Fenlason <fenlason@redhat.com>

My box has two firewire cards in it: card0 and card1.
My application opens /dev/fw0 (card 0) and allocates an address space.
The core makes the address space available on both cards.
Along comes the remote device, which sends a READ_QUADLET_REQUEST to
card1.  The request gets passed up to my application, which calls
ioctl_send_response().

ioctl_send_response() then calls fw_send_response() with card0,
because that's the card it's bound to.
Card0's driver drops the response, because it isn't part of
a transaction that it has outstanding.

So in core-cdev: handle_request(), we need to stash the
card of the inbound request in the struct inbound_transaction_resource and
use that card to send the response to.

The hard part will be refcounting the card correctly
so it can't get deallocated while we hold a pointer to it.

Here's a trivial patch, which does not do the card refcounting, but at
least demonstrates what the problem is.

Note that we can't depend on the fact that the core-cdev:client
structure holds a card open, because in this case the card it holds
open is not the card the request came in on.

..and there's no way for the core to tell cdev "this card is gone,
kill any inbound transactions on it", while cdev holds the transaction
open until userspace issues a SEND_RESPONSE ioctl, which may be a very,
very long time.  But when it does, it calls fw_send_response(), which
will dereference the card...

So how unhappy are we about userspace potentially holding a fw_card
open forever?

Signed-off-by: Jay Fenlason <fenlason@redhat.com>

Reference counting to be addressed in a separate change.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (whitespace)
---
 drivers/firewire/core-cdev.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -107,6 +107,7 @@ struct outbound_transaction_resource {
 
 struct inbound_transaction_resource {
 	struct client_resource resource;
+	struct fw_card *card;
 	struct fw_request *request;
 	void *data;
 	size_t length;
@@ -626,8 +627,7 @@ static void release_request(struct clien
 	if (is_fcp_request(r->request))
 		kfree(r->data);
 	else
-		fw_send_response(client->device->card, r->request,
-				 RCODE_CONFLICT_ERROR);
+		fw_send_response(r->card, r->request, RCODE_CONFLICT_ERROR);
 	kfree(r);
 }
 
@@ -647,6 +647,7 @@ static void handle_request(struct fw_car
 	if (r == NULL || e == NULL)
 		goto failed;
 
+	r->card    = card;
 	r->request = request;
 	r->data    = payload;
 	r->length  = length;
@@ -766,7 +767,7 @@ static int ioctl_send_response(struct cl
 		kfree(r->request);
 		goto out;
 	}
-	fw_send_response(client->device->card, r->request, a->rcode);
+	fw_send_response(r->card, r->request, a->rcode);
  out:
 	kfree(r);
 

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

