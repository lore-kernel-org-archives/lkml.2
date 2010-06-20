Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0FTUxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:53:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51913 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab0FTUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:53:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:52:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/8] firewire: cdev: count references of cards during inbound
 transactions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.fa0ba0710bd74fed@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a request comes in to an address range managed by a userspace driver
i.e. <linux/firewire-cdev.h> client, the card instance of request and
response may differ from the card instance of the client device.
Therefore we need to take a reference of the card until the response was
sent.

I thought about putting the reference counting into core-transaction.c,
but the various high-level drivers besides cdev clients (firewire-net,
firewire-sbp2, firedtv) use the card pointer in their fw_address_handler
address_callback method only to look up devices of which they already
hold the necessary references.  So this seems to be a specific
firewire-cdev issue which is better addressed locally.

We do not need the reference
  - in case of FCP_REQUEST or FCP_RESPONSE requests because then the
    firewire-core will send the split transaction response for us
    already in the context of the request handler,
  - if it is the same card as the client device's because we hold a
    card reference indirectly via teh client->device reference.
To keep things simple, we take the reference nevertheless.

Jay Fenlason wrote:
> there's no way for the core to tell cdev "this card is gone,
> kill any inbound transactions on it", while cdev holds the transaction
> open until userspace issues a SEND_RESPONSE ioctl, which may be a very,
> very long time.  But when it does, it calls fw_send_response(), which
> will dereference the card...
> 
> So how unhappy are we about userspace potentially holding a fw_card
> open forever?

While termination of inbound transcations at card removal could be
implemented, it is IMO not worth the effort.  Currently, the effect of
holding a reference of a card that has been removed is to block the
process that called the pci_remove of the card.  This is
  - either a user process ran by root.  Root can find and kill processes
    that have /dev/fw* open, if desired.
  - a kernel thread (which one?) in case of hot removal of a PCCard or
    ExpressCard.
The latter case could be a problem indeed.  firewire-core's card
shutdown and card release should probably be improved not to block in
shutdown, just to defer freeing of memory until release.

This is not a new problem though; the same already always happens with
the client->device->card without the need of inbound transactions or
other special conditions involved, other than the client not closing the
file.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -628,6 +628,8 @@ static void release_request(struct clien
 		kfree(r->data);
 	else
 		fw_send_response(r->card, r->request, RCODE_CONFLICT_ERROR);
+
+	fw_card_put(r->card);
 	kfree(r);
 }
 
@@ -642,6 +644,9 @@ static void handle_request(struct fw_car
 	void *fcp_frame = NULL;
 	int ret;
 
+	/* card may be different from handler->client->device->card */
+	fw_card_get(card);
+
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
 	if (r == NULL || e == NULL)
@@ -687,6 +692,8 @@ static void handle_request(struct fw_car
 
 	if (!is_fcp_request(request))
 		fw_send_response(card, request, RCODE_CONFLICT_ERROR);
+
+	fw_card_put(card);
 }
 
 static void release_address_handler(struct client *client,
@@ -769,6 +776,7 @@ static int ioctl_send_response(struct cl
 	}
 	fw_send_response(r->card, r->request, a->rcode);
  out:
+	fw_card_put(r->card);
 	kfree(r);
 
 	return ret;

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

