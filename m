Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1AGQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:57:24 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40955 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1AGQ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:57:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 7 Jan 2011 17:56:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [git pull] FireWire updates post 2.6.37
Message-ID: <20110107175656.09f01272@stein>
In-Reply-To: <20110107175539.2b882d3d@stein>
References: <20110107175539.2b882d3d@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 07 Stefan Richter wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates for the IEEE 1394 (FireWire) subsystem.

commit 410cf2bd3dc6ec1ed9e1b36b25b9d7aa927ed14e
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Dec 13 14:56:02 2010 +0100

    firewire: use split transaction timeout only for split transactions
    
    Instead of starting the split transaction timeout timer when any request
    is submitted, start it only when the destination's ACK_PENDING has been
    received.  This prevents us from using a timeout that is too short, and,
    if the controller's AT queue is emptying very slowly, from cancelling
    a packet that has not yet been sent.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |   45 ++++++++++++++++++++++++----------
 include/linux/firewire.h            |    2 +-
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 9e81cc5..d00f8ce 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -72,6 +72,15 @@
 #define PHY_CONFIG_ROOT_ID(node_id)	((((node_id) & 0x3f) << 24) | (1 << 23))
 #define PHY_IDENTIFIER(id)		((id) << 30)
 
+/* returns 0 if the split timeout handler is already running */
+static int try_cancel_split_timeout(struct fw_transaction *t)
+{
+	if (t->is_split_transaction)
+		return del_timer(&t->split_timeout_timer);
+	else
+		return 1;
+}
+
 static int close_transaction(struct fw_transaction *transaction,
 			     struct fw_card *card, int rcode)
 {
@@ -81,7 +90,7 @@ static int close_transaction(struct fw_transaction *transaction,
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t == transaction) {
-			if (!del_timer(&t->split_timeout_timer)) {
+			if (!try_cancel_split_timeout(t)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
@@ -141,16 +150,28 @@ static void split_transaction_timeout_callback(unsigned long data)
 	card->tlabel_mask &= ~(1ULL << t->tlabel);
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	card->driver->cancel_packet(card, &t->packet);
-
-	/*
-	 * At this point cancel_packet will never call the transaction
-	 * callback, since we just took the transaction out of the list.
-	 * So do it here.
-	 */
 	t->callback(card, RCODE_CANCELLED, NULL, 0, t->callback_data);
 }
 
+static void start_split_transaction_timeout(struct fw_transaction *t,
+					    struct fw_card *card)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	if (list_empty(&t->link) || WARN_ON(t->is_split_transaction)) {
+		spin_unlock_irqrestore(&card->lock, flags);
+		return;
+	}
+
+	t->is_split_transaction = true;
+	mod_timer(&t->split_timeout_timer,
+		  jiffies + card->split_timeout_jiffies);
+
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
 static void transmit_complete_callback(struct fw_packet *packet,
 				       struct fw_card *card, int status)
 {
@@ -162,7 +183,7 @@ static void transmit_complete_callback(struct fw_packet *packet,
 		close_transaction(t, card, RCODE_COMPLETE);
 		break;
 	case ACK_PENDING:
-		t->timestamp = packet->timestamp;
+		start_split_transaction_timeout(t, card);
 		break;
 	case ACK_BUSY_X:
 	case ACK_BUSY_A:
@@ -349,11 +370,9 @@ void fw_send_request(struct fw_card *card, struct fw_transaction *t, int tcode,
 	t->node_id = destination_id;
 	t->tlabel = tlabel;
 	t->card = card;
+	t->is_split_transaction = false;
 	setup_timer(&t->split_timeout_timer,
 		    split_transaction_timeout_callback, (unsigned long)t);
-	/* FIXME: start this timer later, relative to t->timestamp */
-	mod_timer(&t->split_timeout_timer,
-		  jiffies + card->split_timeout_jiffies);
 	t->callback = callback;
 	t->callback_data = callback_data;
 
@@ -926,7 +945,7 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(t, &card->transaction_list, link) {
 		if (t->node_id == source && t->tlabel == tlabel) {
-			if (!del_timer(&t->split_timeout_timer)) {
+			if (!try_cancel_split_timeout(t)) {
 				spin_unlock_irqrestore(&card->lock, flags);
 				goto timed_out;
 			}
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 1cd637e..9a3f5f9 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -302,9 +302,9 @@ struct fw_packet {
 struct fw_transaction {
 	int node_id; /* The generation is implied; it is always the current. */
 	int tlabel;
-	int timestamp;
 	struct list_head link;
 	struct fw_card *card;
+	bool is_split_transaction;
 	struct timer_list split_timeout_timer;
 
 	struct fw_packet packet;

commit 693a50b511818e07a131efc944cba1a504b63d3d
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jan 1 15:17:05 2011 +0100

    firewire: ohci: consolidate context status flags
    
    "firewire: ohci: restart iso DMA contexts on resume from low power mode"
    added the flag struct context.active and "firewire: ohci: cache the
    context run bit" added struct context.running.
    
    These flags contain the same information; combine them.
    Also, normalize whitespace in pci_resume().
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 3ae84e2..d77d120 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -156,7 +156,6 @@ struct context {
 	descriptor_callback_t callback;
 
 	struct tasklet_struct tasklet;
-	bool active;
 };
 
 #define IT_HEADER_SY(v)          ((v) <<  0)
@@ -1169,7 +1168,6 @@ static struct descriptor *context_get_descriptors(struct context *ctx,
 static void context_run(struct context *ctx, u32 extra)
 {
 	struct fw_ohci *ohci = ctx->ohci;
-	ctx->active = true;
 
 	reg_write(ohci, COMMAND_PTR(ctx->regs),
 		  le32_to_cpu(ctx->last->branch_address));
@@ -1202,7 +1200,6 @@ static void context_stop(struct context *ctx)
 	u32 reg;
 	int i;
 
-	ctx->active = false;
 	reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
 	ctx->running = false;
 	flush_writes(ctx->ohci);
@@ -2797,13 +2794,13 @@ static void ohci_resume_iso_dma(struct fw_ohci *ohci)
 
 	for (i = 0 ; i < ohci->n_ir ; i++) {
 		ctx = &ohci->ir_context_list[i];
-		if (ctx->context.active)
+		if (ctx->context.running)
 			ohci_start_iso(&ctx->base, 0, ctx->sync, ctx->tags);
 	}
 
 	for (i = 0 ; i < ohci->n_it ; i++) {
 		ctx = &ohci->it_context_list[i];
-		if (ctx->context.active)
+		if (ctx->context.running)
 			ohci_start_iso(&ctx->base, 0, ctx->sync, ctx->tags);
 	}
 }
@@ -3363,11 +3360,11 @@ static int pci_resume(struct pci_dev *dev)
 	}
 
 	err = ohci_enable(&ohci->card, NULL, 0);
-
 	if (err)
 		return err;
 
 	ohci_resume_iso_dma(ohci);
+
 	return 0;
 }
 #endif

commit 386a4153a2c1455e424f280d636efa3c91864466
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Fri Dec 24 14:42:46 2010 +0100

    firewire: ohci: cache the context run bit
    
    The DMA context run control bit is entirely controlled by software, so
    it is safe to cache it.  This allows the driver to avoid doing an
    additional MMIO read when queueing an AT packet.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index cfe5afe..3ae84e2 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -125,6 +125,7 @@ struct context {
 	struct fw_ohci *ohci;
 	u32 regs;
 	int total_allocation;
+	bool running;
 	bool flushing;
 
 	/*
@@ -1174,6 +1175,7 @@ static void context_run(struct context *ctx, u32 extra)
 		  le32_to_cpu(ctx->last->branch_address));
 	reg_write(ohci, CONTROL_CLEAR(ctx->regs), ~0);
 	reg_write(ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN | extra);
+	ctx->running = true;
 	flush_writes(ohci);
 }
 
@@ -1202,6 +1204,7 @@ static void context_stop(struct context *ctx)
 
 	ctx->active = false;
 	reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
+	ctx->running = false;
 	flush_writes(ctx->ohci);
 
 	for (i = 0; i < 10; i++) {
@@ -1232,7 +1235,6 @@ static int at_context_queue_packet(struct context *ctx,
 	struct descriptor *d, *last;
 	__le32 *header;
 	int z, tcode;
-	u32 reg;
 
 	d = context_get_descriptors(ctx, 4, &d_bus);
 	if (d == NULL) {
@@ -1351,9 +1353,7 @@ static int at_context_queue_packet(struct context *ctx,
 
 	context_append(ctx, d, z, 4 - z);
 
-	/* If the context isn't already running, start it up. */
-	reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
-	if ((reg & CONTEXT_RUN) == 0)
+	if (!ctx->running)
 		context_run(ctx, 0);
 
 	return 0;

commit 78dec56d6a56322e1b728d51f3a7def416d36b34
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jan 1 15:15:40 2011 +0100

    firewire: ohci: flush AT contexts after bus reset - addendum
    
    Add comments
      - on why bus_reset_tasklet flushes AT queues,
      - that commit 76f73ca1b291 can possibly be reverted now.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Acked-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/firewire/ohci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 3372cd1..cfe5afe 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1336,6 +1336,8 @@ static int at_context_queue_packet(struct context *ctx,
 	 * some controllers (like a JMicron JMB381 PCI-e) misbehave and wind
 	 * up stalling out.  So we just bail out in software and try again
 	 * later, and everyone is happy.
+	 * FIXME: Test of IntEvent.busReset may no longer be necessary since we
+	 *        flush AT queues in bus_reset_tasklet.
 	 * FIXME: Document how the locking works.
 	 */
 	if (ohci->generation != packet->generation ||
@@ -1750,6 +1752,11 @@ static void bus_reset_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
+	/*
+	 * Per OHCI 1.2 draft, clause 7.2.3.3, hardware may leave unsent
+	 * packets in the AT queues and software needs to drain them.
+	 * Some OHCI 1.1 controllers (JMicron) apparently require this too.
+	 */
 	at_context_flush(&ohci->at_request_ctx);
 	at_context_flush(&ohci->at_response_ctx);
 

commit 82b662dc41027527675740de15344d1b4e34958e
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Fri Dec 24 14:40:15 2010 +0100

    firewire: ohci: flush AT contexts after bus reset for OHCI 1.2
    
    The OHCI 1.2 (draft) specification, clause 7.2.3.3, allows and
    recommends that, after a bus reset, the controller does not flush all
    the packets in the AT queues.  Therefore, the driver has to do this
    itself.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   46 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5e5d5d3..3372cd1 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -125,6 +125,7 @@ struct context {
 	struct fw_ohci *ohci;
 	u32 regs;
 	int total_allocation;
+	bool flushing;
 
 	/*
 	 * List of page-sized buffers for storing DMA descriptors.
@@ -1356,6 +1357,17 @@ static int at_context_queue_packet(struct context *ctx,
 	return 0;
 }
 
+static void at_context_flush(struct context *ctx)
+{
+	tasklet_disable(&ctx->tasklet);
+
+	ctx->flushing = true;
+	context_tasklet((unsigned long)ctx);
+	ctx->flushing = false;
+
+	tasklet_enable(&ctx->tasklet);
+}
+
 static int handle_at_packet(struct context *context,
 			    struct descriptor *d,
 			    struct descriptor *last)
@@ -1365,7 +1377,7 @@ static int handle_at_packet(struct context *context,
 	struct fw_ohci *ohci = context->ohci;
 	int evt;
 
-	if (last->transfer_status == 0)
+	if (last->transfer_status == 0 && !context->flushing)
 		/* This descriptor isn't done yet, stop iteration. */
 		return 0;
 
@@ -1399,11 +1411,15 @@ static int handle_at_packet(struct context *context,
 		break;
 
 	case OHCI1394_evt_missing_ack:
-		/*
-		 * Using a valid (current) generation count, but the
-		 * node is not on the bus or not sending acks.
-		 */
-		packet->ack = RCODE_NO_ACK;
+		if (context->flushing)
+			packet->ack = RCODE_GENERATION;
+		else {
+			/*
+			 * Using a valid (current) generation count, but the
+			 * node is not on the bus or not sending acks.
+			 */
+			packet->ack = RCODE_NO_ACK;
+		}
 		break;
 
 	case ACK_COMPLETE + 0x10:
@@ -1416,6 +1432,13 @@ static int handle_at_packet(struct context *context,
 		packet->ack = evt - 0x10;
 		break;
 
+	case OHCI1394_evt_no_status:
+		if (context->flushing) {
+			packet->ack = RCODE_GENERATION;
+			break;
+		}
+		/* fall through */
+
 	default:
 		packet->ack = RCODE_SEND_ERROR;
 		break;
@@ -1721,9 +1744,18 @@ static void bus_reset_tasklet(unsigned long data)
 	/* FIXME: Document how the locking works. */
 	spin_lock_irqsave(&ohci->lock, flags);
 
-	ohci->generation = generation;
+	ohci->generation = -1; /* prevent AT packet queueing */
 	context_stop(&ohci->at_request_ctx);
 	context_stop(&ohci->at_response_ctx);
+
+	spin_unlock_irqrestore(&ohci->lock, flags);
+
+	at_context_flush(&ohci->at_request_ctx);
+	at_context_flush(&ohci->at_response_ctx);
+
+	spin_lock_irqsave(&ohci->lock, flags);
+
+	ohci->generation = generation;
 	reg_write(ohci, OHCI1394_IntEventClear, OHCI1394_busReset);
 
 	if (ohci->quirks & QUIRK_RESET_PACKET)

commit c16714704bb35165e5b85d927873dcc643772648
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Dec 17 22:22:33 2010 +0100

    firewire: net: set carrier state at ifup
    
    At ifup, carrier status would be shown on even if it actually was off.
    Also add an include for ethtool_ops rather than to rely on the one from
    netdevice.h.
    
    Note, we can alas not use fwnet_device_mutex to serialize access to
    dev->peer_count (as I originally wanted).  This would cause a lock
    inversion:
      - fwnet_probe | takes fwnet_device_mutex
          + register_netdev | takes rtnl_mutex
      - devinet_ioctl | takes rtnl_mutex
          + fwnet_open | ...must not take fwnet_device_mutex
    
    Hence use the dev->lock spinlock for serialization.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 7fd51c9..c2e194c 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -9,6 +9,7 @@
 #include <linux/bug.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/firewire.h>
 #include <linux/firewire-constants.h>
 #include <linux/highmem.h>
@@ -178,8 +179,8 @@ struct fwnet_device {
 
 	/* Number of tx datagrams that have been queued but not yet acked */
 	int queued_datagrams;
-	int peer_count;
 
+	int peer_count;
 	struct list_head peer_list;
 	struct fw_card *card;
 	struct net_device *netdev;
@@ -1222,6 +1223,14 @@ static int fwnet_broadcast_start(struct fwnet_device *dev)
 	return retval;
 }
 
+static void set_carrier_state(struct fwnet_device *dev)
+{
+	if (dev->peer_count > 1)
+		netif_carrier_on(dev->netdev);
+	else
+		netif_carrier_off(dev->netdev);
+}
+
 /* ifup */
 static int fwnet_open(struct net_device *net)
 {
@@ -1235,6 +1244,10 @@ static int fwnet_open(struct net_device *net)
 	}
 	netif_start_queue(net);
 
+	spin_lock_irq(&dev->lock);
+	set_carrier_state(dev);
+	spin_unlock_irq(&dev->lock);
+
 	return 0;
 }
 
@@ -1429,7 +1442,6 @@ static void fwnet_init_dev(struct net_device *net)
 	net->type		= ARPHRD_IEEE1394;
 	net->tx_queue_len	= FWNET_TX_QUEUE_LEN;
 	net->ethtool_ops	= &fwnet_ethtool_ops;
-
 }
 
 /* caller must hold fwnet_device_mutex */
@@ -1471,6 +1483,7 @@ static int fwnet_add_peer(struct fwnet_device *dev,
 	spin_lock_irq(&dev->lock);
 	list_add_tail(&peer->peer_link, &dev->peer_list);
 	dev->peer_count++;
+	set_carrier_state(dev);
 	spin_unlock_irq(&dev->lock);
 
 	return 0;
@@ -1542,9 +1555,6 @@ static int fwnet_probe(struct device *_dev)
 		unregister_netdev(net);
 		list_del(&dev->dev_link);
 	}
-
-	if (dev->peer_count > 1)
-		netif_carrier_on(net);
  out:
 	if (ret && allocated_netdev)
 		free_netdev(net);
@@ -1554,14 +1564,15 @@ static int fwnet_probe(struct device *_dev)
 	return ret;
 }
 
-static void fwnet_remove_peer(struct fwnet_peer *peer)
+static void fwnet_remove_peer(struct fwnet_peer *peer, struct fwnet_device *dev)
 {
 	struct fwnet_partial_datagram *pd, *pd_next;
 
-	spin_lock_irq(&peer->dev->lock);
+	spin_lock_irq(&dev->lock);
 	list_del(&peer->peer_link);
-	peer->dev->peer_count--;
-	spin_unlock_irq(&peer->dev->lock);
+	dev->peer_count--;
+	set_carrier_state(dev);
+	spin_unlock_irq(&dev->lock);
 
 	list_for_each_entry_safe(pd, pd_next, &peer->pd_list, pd_link)
 		fwnet_pd_delete(pd);
@@ -1578,12 +1589,7 @@ static int fwnet_remove(struct device *_dev)
 
 	mutex_lock(&fwnet_device_mutex);
 
-	fwnet_remove_peer(peer);
-
-	/* If we serve just one node, that means we lost link
-		with outer world */
-	if (dev->peer_count == 1)
-		netif_carrier_off(dev->netdev);
+	fwnet_remove_peer(peer, dev);
 
 	if (list_empty(&dev->peer_list)) {
 		net = dev->netdev;

commit 18bb36f9fab5980efeff063755c037a622f0231c
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Wed Dec 8 04:22:57 2010 +0200

    firewire: net: add carrier detection
    
    To make userland, e.g. NetworkManager work with firewire, we need to
    detect whether cable is plugged or not.  Simple and correct way of doing
    that is just counting number of peers.  No peers - no link and vice
    versa.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index ea31e30..7fd51c9 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -178,6 +178,7 @@ struct fwnet_device {
 
 	/* Number of tx datagrams that have been queued but not yet acked */
 	int queued_datagrams;
+	int peer_count;
 
 	struct list_head peer_list;
 	struct fw_card *card;
@@ -1405,6 +1406,10 @@ static int fwnet_change_mtu(struct net_device *net, int new_mtu)
 	return 0;
 }
 
+static const struct ethtool_ops fwnet_ethtool_ops = {
+	.get_link	= ethtool_op_get_link,
+};
+
 static const struct net_device_ops fwnet_netdev_ops = {
 	.ndo_open       = fwnet_open,
 	.ndo_stop	= fwnet_stop,
@@ -1423,6 +1428,8 @@ static void fwnet_init_dev(struct net_device *net)
 	net->hard_header_len	= FWNET_HLEN;
 	net->type		= ARPHRD_IEEE1394;
 	net->tx_queue_len	= FWNET_TX_QUEUE_LEN;
+	net->ethtool_ops	= &fwnet_ethtool_ops;
+
 }
 
 /* caller must hold fwnet_device_mutex */
@@ -1463,6 +1470,7 @@ static int fwnet_add_peer(struct fwnet_device *dev,
 
 	spin_lock_irq(&dev->lock);
 	list_add_tail(&peer->peer_link, &dev->peer_list);
+	dev->peer_count++;
 	spin_unlock_irq(&dev->lock);
 
 	return 0;
@@ -1534,6 +1542,9 @@ static int fwnet_probe(struct device *_dev)
 		unregister_netdev(net);
 		list_del(&dev->dev_link);
 	}
+
+	if (dev->peer_count > 1)
+		netif_carrier_on(net);
  out:
 	if (ret && allocated_netdev)
 		free_netdev(net);
@@ -1549,6 +1560,7 @@ static void fwnet_remove_peer(struct fwnet_peer *peer)
 
 	spin_lock_irq(&peer->dev->lock);
 	list_del(&peer->peer_link);
+	peer->dev->peer_count--;
 	spin_unlock_irq(&peer->dev->lock);
 
 	list_for_each_entry_safe(pd, pd_next, &peer->pd_list, pd_link)
@@ -1568,6 +1580,11 @@ static int fwnet_remove(struct device *_dev)
 
 	fwnet_remove_peer(peer);
 
+	/* If we serve just one node, that means we lost link
+		with outer world */
+	if (dev->peer_count == 1)
+		netif_carrier_off(dev->netdev);
+
 	if (list_empty(&dev->peer_list)) {
 		net = dev->netdev;
 		unregister_netdev(net);

commit c4d6fd40df38eb4c187565d48807f5f902481ba8
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Mon Nov 29 04:09:53 2010 +0200

    firewire: net: ratelimit error messages
    
    Unfortunately its easy to trigger such error messages by removing the
    cable while sending streams of data over the link.
    
    Such errors are normal, and therefore this patch stops firewire-net from
    flooding the kernel log with these errors, by combining series of same
    errors together.
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    
    (Stefan R:)  Eventually we should remove this logging when firewire-net
    and related firewire-ohci facilities have been stabilized.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 1a467a9..ea31e30 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -996,15 +996,23 @@ static void fwnet_transmit_packet_failed(struct fwnet_packet_task *ptask)
 static void fwnet_write_complete(struct fw_card *card, int rcode,
 				 void *payload, size_t length, void *data)
 {
-	struct fwnet_packet_task *ptask;
-
-	ptask = data;
+	struct fwnet_packet_task *ptask = data;
+	static unsigned long j;
+	static int last_rcode, errors_skipped;
 
 	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
 	} else {
-		fw_error("fwnet_write_complete: failed: %x\n", rcode);
 		fwnet_transmit_packet_failed(ptask);
+
+		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
+			fw_error("fwnet_write_complete: "
+				"failed: %x (skipped %d)\n", rcode, errors_skipped);
+
+			errors_skipped = 0;
+			last_rcode = rcode;
+		} else
+			errors_skipped++;
 	}
 }
 

commit dd23736e092035b71df1117482b71fdfb5634239
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Mon Nov 29 04:09:50 2010 +0200

    firewire: ohci: restart iso DMA contexts on resume from low power mode
    
    Restore iso channels DMA so that iso channels could continue to work
    after resume from RAM/disk.
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   54 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 3a90803..5e5d5d3 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
@@ -153,6 +154,7 @@ struct context {
 	descriptor_callback_t callback;
 
 	struct tasklet_struct tasklet;
+	bool active;
 };
 
 #define IT_HEADER_SY(v)          ((v) <<  0)
@@ -168,6 +170,9 @@ struct iso_context {
 	int excess_bytes;
 	void *header;
 	size_t header_length;
+
+	u8 sync;
+	u8 tags;
 };
 
 #define CONFIG_ROM_SIZE 1024
@@ -184,7 +189,8 @@ struct fw_ohci {
 	u32 bus_time;
 	bool is_root;
 	bool csr_state_setclear_abdicate;
-
+	int n_ir;
+	int n_it;
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
 	 * this driver with this lock held.
@@ -1161,6 +1167,7 @@ static struct descriptor *context_get_descriptors(struct context *ctx,
 static void context_run(struct context *ctx, u32 extra)
 {
 	struct fw_ohci *ohci = ctx->ohci;
+	ctx->active = true;
 
 	reg_write(ohci, COMMAND_PTR(ctx->regs),
 		  le32_to_cpu(ctx->last->branch_address));
@@ -1192,6 +1199,7 @@ static void context_stop(struct context *ctx)
 	u32 reg;
 	int i;
 
+	ctx->active = false;
 	reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
 	flush_writes(ctx->ohci);
 
@@ -2641,6 +2649,10 @@ static int ohci_start_iso(struct fw_iso_context *base,
 		reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, 1 << index);
 		reg_write(ohci, CONTEXT_MATCH(ctx->context.regs), match);
 		context_run(&ctx->context, control);
+
+		ctx->sync = sync;
+		ctx->tags = tags;
+
 		break;
 	}
 
@@ -2738,6 +2750,26 @@ static int ohci_set_iso_channels(struct fw_iso_context *base, u64 *channels)
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static void ohci_resume_iso_dma(struct fw_ohci *ohci)
+{
+	int i;
+	struct iso_context *ctx;
+
+	for (i = 0 ; i < ohci->n_ir ; i++) {
+		ctx = &ohci->ir_context_list[i];
+		if (ctx->context.active)
+			ohci_start_iso(&ctx->base, 0, ctx->sync, ctx->tags);
+	}
+
+	for (i = 0 ; i < ohci->n_it ; i++) {
+		ctx = &ohci->it_context_list[i];
+		if (ctx->context.active)
+			ohci_start_iso(&ctx->base, 0, ctx->sync, ctx->tags);
+	}
+}
+#endif
+
 static int queue_iso_transmit(struct iso_context *ctx,
 			      struct fw_iso_packet *packet,
 			      struct fw_iso_buffer *buffer,
@@ -3047,7 +3079,7 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	struct fw_ohci *ohci;
 	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
-	int i, err, n_ir, n_it;
+	int i, err;
 	size_t size;
 
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
@@ -3141,15 +3173,15 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	ohci->ir_context_channels = ~0ULL;
 	ohci->ir_context_mask = reg_read(ohci, OHCI1394_IsoRecvIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskClear, ~0);
-	n_ir = hweight32(ohci->ir_context_mask);
-	size = sizeof(struct iso_context) * n_ir;
+	ohci->n_ir = hweight32(ohci->ir_context_mask);
+	size = sizeof(struct iso_context) * ohci->n_ir;
 	ohci->ir_context_list = kzalloc(size, GFP_KERNEL);
 
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, ~0);
 	ohci->it_context_mask = reg_read(ohci, OHCI1394_IsoXmitIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskClear, ~0);
-	n_it = hweight32(ohci->it_context_mask);
-	size = sizeof(struct iso_context) * n_it;
+	ohci->n_it = hweight32(ohci->it_context_mask);
+	size = sizeof(struct iso_context) * ohci->n_it;
 	ohci->it_context_list = kzalloc(size, GFP_KERNEL);
 
 	if (ohci->it_context_list == NULL || ohci->ir_context_list == NULL) {
@@ -3174,7 +3206,7 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	fw_notify("Added fw-ohci device %s, OHCI v%x.%x, "
 		  "%d IR + %d IT contexts, quirks 0x%x\n",
 		  dev_name(&dev->dev), version >> 16, version & 0xff,
-		  n_ir, n_it, ohci->quirks);
+		  ohci->n_ir, ohci->n_it, ohci->quirks);
 
 	return 0;
 
@@ -3291,7 +3323,13 @@ static int pci_resume(struct pci_dev *dev)
 		reg_write(ohci, OHCI1394_GUIDHi, (u32)(ohci->card.guid >> 32));
 	}
 
-	return ohci_enable(&ohci->card, NULL, 0);
+	err = ohci_enable(&ohci->card, NULL, 0);
+
+	if (err)
+		return err;
+
+	ohci_resume_iso_dma(ohci);
+	return 0;
 }
 #endif
 

commit 8662b6b029636c35e5876e184d90daf6b0072667
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Mon Nov 29 04:09:49 2010 +0200

    firewire: ohci: restore GUID on resume.
    
    Some lousy BIOSes, e.g. my Aspire 5720 BIOS forget to restore the GUID
    register on resume from RAM.
    
    Fix that by setting it to the last value that was read from it.
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index eb7b591..3a90803 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3284,6 +3284,13 @@ static int pci_resume(struct pci_dev *dev)
 		return err;
 	}
 
+	/* Some systems don't setup GUID register on resume from ram  */
+	if (!reg_read(ohci, OHCI1394_GUIDLo) &&
+					!reg_read(ohci, OHCI1394_GUIDHi)) {
+		reg_write(ohci, OHCI1394_GUIDLo, (u32)ohci->card.guid);
+		reg_write(ohci, OHCI1394_GUIDHi, (u32)(ohci->card.guid >> 32));
+	}
+
 	return ohci_enable(&ohci->card, NULL, 0);
 }
 #endif

commit ec766a7970126f99665992c0b0b10bd60a4d6208
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:25:17 2010 +0100

    firewire: ohci: use common buffer for self IDs and AR descriptors
    
    The buffers used for the selfIDs packets and the AR request and response
    descriptors end up using three pages because dma_alloc_coherent()
    allocates at least one page per call.  However, these data structures
    would all fit into 4 KB, so we can save space by using a common buffer
    for them.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   66 ++++++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 01b3bc9..eb7b591 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -193,6 +193,9 @@ struct fw_ohci {
 
 	struct mutex phy_reg_mutex;
 
+	void *misc_buffer;
+	dma_addr_t misc_buffer_bus;
+
 	struct ar_context ar_request_ctx;
 	struct ar_context ar_response_ctx;
 	struct context at_request_ctx;
@@ -623,11 +626,6 @@ static void ar_context_release(struct ar_context *ctx)
 {
 	unsigned int i;
 
-	if (ctx->descriptors)
-		dma_free_coherent(ctx->ohci->card.device,
-				  AR_BUFFERS * sizeof(struct descriptor),
-				  ctx->descriptors, ctx->descriptors_bus);
-
 	if (ctx->buffer)
 		vm_unmap_ram(ctx->buffer, AR_BUFFERS + AR_WRAPAROUND_PAGES);
 
@@ -925,8 +923,8 @@ error:
 	ctx->pointer = NULL;
 }
 
-static int ar_context_init(struct ar_context *ctx,
-			   struct fw_ohci *ohci, u32 regs)
+static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
+			   unsigned int descriptors_offset, u32 regs)
 {
 	unsigned int i;
 	dma_addr_t dma_addr;
@@ -960,13 +958,8 @@ static int ar_context_init(struct ar_context *ctx,
 	if (!ctx->buffer)
 		goto out_of_memory;
 
-	ctx->descriptors =
-		dma_alloc_coherent(ohci->card.device,
-				   AR_BUFFERS * sizeof(struct descriptor),
-				   &ctx->descriptors_bus,
-				   GFP_KERNEL);
-	if (!ctx->descriptors)
-		goto out_of_memory;
+	ctx->descriptors     = ohci->misc_buffer     + descriptors_offset;
+	ctx->descriptors_bus = ohci->misc_buffer_bus + descriptors_offset;
 
 	for (i = 0; i < AR_BUFFERS; i++) {
 		d = &ctx->descriptors[i];
@@ -3108,12 +3101,28 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	if (param_quirks)
 		ohci->quirks = param_quirks;
 
-	err = ar_context_init(&ohci->ar_request_ctx, ohci,
+	/*
+	 * Because dma_alloc_coherent() allocates at least one page,
+	 * we save space by using a common buffer for the AR request/
+	 * response descriptors and the self IDs buffer.
+	 */
+	BUILD_BUG_ON(AR_BUFFERS * sizeof(struct descriptor) > PAGE_SIZE/4);
+	BUILD_BUG_ON(SELF_ID_BUF_SIZE > PAGE_SIZE/2);
+	ohci->misc_buffer = dma_alloc_coherent(ohci->card.device,
+					       PAGE_SIZE,
+					       &ohci->misc_buffer_bus,
+					       GFP_KERNEL);
+	if (!ohci->misc_buffer) {
+		err = -ENOMEM;
+		goto fail_iounmap;
+	}
+
+	err = ar_context_init(&ohci->ar_request_ctx, ohci, 0,
 			      OHCI1394_AsReqRcvContextControlSet);
 	if (err < 0)
-		goto fail_iounmap;
+		goto fail_misc_buf;
 
-	err = ar_context_init(&ohci->ar_response_ctx, ohci,
+	err = ar_context_init(&ohci->ar_response_ctx, ohci, PAGE_SIZE/4,
 			      OHCI1394_AsRspRcvContextControlSet);
 	if (err < 0)
 		goto fail_arreq_ctx;
@@ -3148,15 +3157,8 @@ static int __devinit pci_probe(struct pci_dev *dev,
 		goto fail_contexts;
 	}
 
-	/* self-id dma buffer allocation */
-	ohci->self_id_cpu = dma_alloc_coherent(ohci->card.device,
-					       SELF_ID_BUF_SIZE,
-					       &ohci->self_id_bus,
-					       GFP_KERNEL);
-	if (ohci->self_id_cpu == NULL) {
-		err = -ENOMEM;
-		goto fail_contexts;
-	}
+	ohci->self_id_cpu = ohci->misc_buffer     + PAGE_SIZE/2;
+	ohci->self_id_bus = ohci->misc_buffer_bus + PAGE_SIZE/2;
 
 	bus_options = reg_read(ohci, OHCI1394_BusOptions);
 	max_receive = (bus_options >> 12) & 0xf;
@@ -3166,7 +3168,7 @@ static int __devinit pci_probe(struct pci_dev *dev,
 
 	err = fw_card_add(&ohci->card, max_receive, link_speed, guid);
 	if (err)
-		goto fail_self_id;
+		goto fail_contexts;
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	fw_notify("Added fw-ohci device %s, OHCI v%x.%x, "
@@ -3176,9 +3178,6 @@ static int __devinit pci_probe(struct pci_dev *dev,
 
 	return 0;
 
- fail_self_id:
-	dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
-			  ohci->self_id_cpu, ohci->self_id_bus);
  fail_contexts:
 	kfree(ohci->ir_context_list);
 	kfree(ohci->it_context_list);
@@ -3189,6 +3188,9 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	ar_context_release(&ohci->ar_response_ctx);
  fail_arreq_ctx:
 	ar_context_release(&ohci->ar_request_ctx);
+ fail_misc_buf:
+	dma_free_coherent(ohci->card.device, PAGE_SIZE,
+			  ohci->misc_buffer, ohci->misc_buffer_bus);
  fail_iounmap:
 	pci_iounmap(dev, ohci->registers);
  fail_iomem:
@@ -3228,10 +3230,10 @@ static void pci_remove(struct pci_dev *dev)
 	if (ohci->config_rom)
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  ohci->config_rom, ohci->config_rom_bus);
-	dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
-			  ohci->self_id_cpu, ohci->self_id_bus);
 	ar_context_release(&ohci->ar_request_ctx);
 	ar_context_release(&ohci->ar_response_ctx);
+	dma_free_coherent(ohci->card.device, PAGE_SIZE,
+			  ohci->misc_buffer, ohci->misc_buffer_bus);
 	context_release(&ohci->at_request_ctx);
 	context_release(&ohci->at_response_ctx);
 	kfree(ohci->it_context_list);

commit 2dd5bed59356e03610bebe1a37c397788df50b9b
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:25:05 2010 +0100

    firewire: ohci: optimize iso context checks in the interrupt handler
    
    When the isochRx/isochTx bit is clear, we do not need to read the
    corresponding iso interrupt event register.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 29259f3..01b3bc9 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1813,22 +1813,28 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (event & OHCI1394_respTxComplete)
 		tasklet_schedule(&ohci->at_response_ctx.tasklet);
 
-	iso_event = reg_read(ohci, OHCI1394_IsoRecvIntEventClear);
-	reg_write(ohci, OHCI1394_IsoRecvIntEventClear, iso_event);
-
-	while (iso_event) {
-		i = ffs(iso_event) - 1;
-		tasklet_schedule(&ohci->ir_context_list[i].context.tasklet);
-		iso_event &= ~(1 << i);
+	if (event & OHCI1394_isochRx) {
+		iso_event = reg_read(ohci, OHCI1394_IsoRecvIntEventClear);
+		reg_write(ohci, OHCI1394_IsoRecvIntEventClear, iso_event);
+
+		while (iso_event) {
+			i = ffs(iso_event) - 1;
+			tasklet_schedule(
+				&ohci->ir_context_list[i].context.tasklet);
+			iso_event &= ~(1 << i);
+		}
 	}
 
-	iso_event = reg_read(ohci, OHCI1394_IsoXmitIntEventClear);
-	reg_write(ohci, OHCI1394_IsoXmitIntEventClear, iso_event);
+	if (event & OHCI1394_isochTx) {
+		iso_event = reg_read(ohci, OHCI1394_IsoXmitIntEventClear);
+		reg_write(ohci, OHCI1394_IsoXmitIntEventClear, iso_event);
 
-	while (iso_event) {
-		i = ffs(iso_event) - 1;
-		tasklet_schedule(&ohci->it_context_list[i].context.tasklet);
-		iso_event &= ~(1 << i);
+		while (iso_event) {
+			i = ffs(iso_event) - 1;
+			tasklet_schedule(
+				&ohci->it_context_list[i].context.tasklet);
+			iso_event &= ~(1 << i);
+		}
 	}
 
 	if (unlikely(event & OHCI1394_regAccessFail))

commit 5b06db166c4d38638980283505259fa165d4f369
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:24:47 2010 +0100

    firewire: make PHY packet header format consistent
    
    Change the header of PHY packets to be sent to include a pseudo
    transaction code.  This makes the header consistent with that of
    received PHY packets, and allows at_context_queue_packet() and
    log_ar_at_event() to see the packet type directly instead of having
    to deduce it from the header length or even from the header contents.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c        |    7 +++--
 drivers/firewire/core-transaction.c |    7 +++--
 drivers/firewire/core.h             |    4 ++-
 drivers/firewire/ohci.c             |   44 +++++++++++++++++-----------------
 4 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 14bb7b7..48ae712 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1501,9 +1501,10 @@ static int ioctl_send_phy_packet(struct client *client, union ioctl_arg *arg)
 	e->client		= client;
 	e->p.speed		= SCODE_100;
 	e->p.generation		= a->generation;
-	e->p.header[0]		= a->data[0];
-	e->p.header[1]		= a->data[1];
-	e->p.header_length	= 8;
+	e->p.header[0]		= TCODE_LINK_INTERNAL << 4;
+	e->p.header[1]		= a->data[0];
+	e->p.header[2]		= a->data[1];
+	e->p.header_length	= 12;
 	e->p.callback		= outbound_phy_packet_callback;
 	e->phy_packet.closure	= a->closure;
 	e->phy_packet.type	= FW_CDEV_EVENT_PHY_PACKET_SENT;
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index ad864d8..9e81cc5 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -423,7 +423,8 @@ static void transmit_phy_packet_callback(struct fw_packet *packet,
 }
 
 static struct fw_packet phy_config_packet = {
-	.header_length	= 8,
+	.header_length	= 12,
+	.header[0]	= TCODE_LINK_INTERNAL << 4,
 	.payload_length	= 0,
 	.speed		= SCODE_100,
 	.callback	= transmit_phy_packet_callback,
@@ -451,8 +452,8 @@ void fw_send_phy_config(struct fw_card *card,
 
 	mutex_lock(&phy_config_mutex);
 
-	phy_config_packet.header[0] = data;
-	phy_config_packet.header[1] = ~data;
+	phy_config_packet.header[1] = data;
+	phy_config_packet.header[2] = ~data;
 	phy_config_packet.generation = generation;
 	INIT_COMPLETION(phy_config_done);
 
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index e6239f9..f8dfcf1 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -215,9 +215,11 @@ static inline bool is_next_generation(int new_generation, int old_generation)
 
 /* -transaction */
 
+#define TCODE_LINK_INTERNAL		0xe
+
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
 #define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
-#define TCODE_IS_LINK_INTERNAL(tcode)	((tcode) == 0xe)
+#define TCODE_IS_LINK_INTERNAL(tcode)	((tcode) == TCODE_LINK_INTERNAL)
 #define TCODE_IS_REQUEST(tcode)		(((tcode) &  2) == 0)
 #define TCODE_IS_RESPONSE(tcode)	(((tcode) &  2) != 0)
 #define TCODE_HAS_REQUEST_DATA(tcode)	(((tcode) & 12) != 4)
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 0031ec6..29259f3 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -418,10 +418,6 @@ static const char *tcodes[] = {
 	[0xc] = "-reserved-",		[0xd] = "-reserved-",
 	[0xe] = "link internal",	[0xf] = "-reserved-",
 };
-static const char *phys[] = {
-	[0x0] = "phy config packet",	[0x1] = "link-on packet",
-	[0x2] = "self-id packet",	[0x3] = "-reserved-",
-};
 
 static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
 {
@@ -440,12 +436,6 @@ static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
 		return;
 	}
 
-	if (header[0] == ~header[1]) {
-		fw_notify("A%c %s, %s, %08x\n",
-		    dir, evts[evt], phys[header[0] >> 30 & 0x3], header[0]);
-		return;
-	}
-
 	switch (tcode) {
 	case 0x0: case 0x6: case 0x8:
 		snprintf(specific, sizeof(specific), " = %08x",
@@ -460,9 +450,13 @@ static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
 	}
 
 	switch (tcode) {
-	case 0xe: case 0xa:
+	case 0xa:
 		fw_notify("A%c %s, %s\n", dir, evts[evt], tcodes[tcode]);
 		break;
+	case 0xe:
+		fw_notify("A%c %s, PHY %08x %08x\n",
+			  dir, evts[evt], header[1], header[2]);
+		break;
 	case 0x0: case 0x1: case 0x4: case 0x5: case 0x9:
 		fw_notify("A%c spd %x tl %02x, "
 		    "%04x -> %04x, %s, "
@@ -1250,21 +1244,27 @@ static int at_context_queue_packet(struct context *ctx,
 	/*
 	 * The DMA format for asyncronous link packets is different
 	 * from the IEEE1394 layout, so shift the fields around
-	 * accordingly.  If header_length is 8, it's a PHY packet, to
-	 * which we need to prepend an extra quadlet.
+	 * accordingly.
 	 */
 
+	tcode = (packet->header[0] >> 4) & 0x0f;
 	header = (__le32 *) &d[1];
-	switch (packet->header_length) {
-	case 16:
-	case 12:
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+	case TCODE_WRITE_RESPONSE:
+	case TCODE_READ_QUADLET_REQUEST:
+	case TCODE_READ_BLOCK_REQUEST:
+	case TCODE_READ_QUADLET_RESPONSE:
+	case TCODE_READ_BLOCK_RESPONSE:
+	case TCODE_LOCK_REQUEST:
+	case TCODE_LOCK_RESPONSE:
 		header[0] = cpu_to_le32((packet->header[0] & 0xffff) |
 					(packet->speed << 16));
 		header[1] = cpu_to_le32((packet->header[1] & 0xffff) |
 					(packet->header[0] & 0xffff0000));
 		header[2] = cpu_to_le32(packet->header[2]);
 
-		tcode = (packet->header[0] >> 4) & 0x0f;
 		if (TCODE_IS_BLOCK_PACKET(tcode))
 			header[3] = cpu_to_le32(packet->header[3]);
 		else
@@ -1273,18 +1273,18 @@ static int at_context_queue_packet(struct context *ctx,
 		d[0].req_count = cpu_to_le16(packet->header_length);
 		break;
 
-	case 8:
+	case TCODE_LINK_INTERNAL:
 		header[0] = cpu_to_le32((OHCI1394_phy_tcode << 4) |
 					(packet->speed << 16));
-		header[1] = cpu_to_le32(packet->header[0]);
-		header[2] = cpu_to_le32(packet->header[1]);
+		header[1] = cpu_to_le32(packet->header[1]);
+		header[2] = cpu_to_le32(packet->header[2]);
 		d[0].req_count = cpu_to_le16(12);
 
-		if (is_ping_packet(packet->header))
+		if (is_ping_packet(&packet->header[1]))
 			d[0].control |= cpu_to_le16(DESCRIPTOR_PING);
 		break;
 
-	case 4:
+	case TCODE_STREAM_DATA:
 		header[0] = cpu_to_le32((packet->header[0] & 0xffff) |
 					(packet->speed << 16));
 		header[1] = cpu_to_le32(packet->header[0] & 0xffff0000);

commit 8327b37b18addfc6f8cf41a2f1a4490b656377b9
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:24:32 2010 +0100

    firewire: ohci: properly clear posted write errors
    
    To remove the error information from the controller's queue and to allow
    more posted writes, the driver has to read the failed posted write
    address before clearing the postedWriteErr interrupt bit.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    
    (Stefan R:) The spec is somewhat fuzzy about the actual requirements.
    To err on the safe side, let's do these two read accesses.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 276324d..0031ec6 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1790,8 +1790,12 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (!event || !~event)
 		return IRQ_NONE;
 
-	/* busReset must not be cleared yet, see OHCI 1.1 clause 7.2.3.2 */
-	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
+	/*
+	 * busReset and postedWriteErr must not be cleared yet
+	 * (OHCI 1.1 clauses 7.2.3.2 and 13.2.8.1)
+	 */
+	reg_write(ohci, OHCI1394_IntEventClear,
+		  event & ~(OHCI1394_busReset | OHCI1394_postedWriteErr));
 	log_irqs(event);
 
 	if (event & OHCI1394_selfIDComplete)
@@ -1831,8 +1835,13 @@ static irqreturn_t irq_handler(int irq, void *data)
 		fw_error("Register access failure - "
 			 "please notify linux1394-devel@lists.sf.net\n");
 
-	if (unlikely(event & OHCI1394_postedWriteErr))
+	if (unlikely(event & OHCI1394_postedWriteErr)) {
+		reg_read(ohci, OHCI1394_PostedWriteAddressHi);
+		reg_read(ohci, OHCI1394_PostedWriteAddressLo);
+		reg_write(ohci, OHCI1394_IntEventClear,
+			  OHCI1394_postedWriteErr);
 		fw_error("PCI posted write error\n");
+	}
 
 	if (unlikely(event & OHCI1394_cycleTooLong)) {
 		if (printk_ratelimit())

commit e597e9898abe45beff4696159c7fe5c96f53e581
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:24:19 2010 +0100

    firewire: ohci: flush MMIO writes in the interrupt handler
    
    Make sure that interrupt event clear bit writes are executed before the
    interrupt handler returns.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 3775364..276324d 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1856,7 +1856,8 @@ static irqreturn_t irq_handler(int irq, void *data)
 		spin_lock(&ohci->lock);
 		update_bus_time(ohci);
 		spin_unlock(&ohci->lock);
-	}
+	} else
+		flush_writes(ohci);
 
 	return IRQ_HANDLED;
 }

commit c088ab30ebf184afae01d919c77cebcfdce39df3
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Tue Nov 30 08:24:01 2010 +0100

    firewire: ohci: fix AT context initialization error handling
    
    Add proper error handling for the context_init() calls.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index be0a01d..3775364 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3102,11 +3102,15 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	if (err < 0)
 		goto fail_arreq_ctx;
 
-	context_init(&ohci->at_request_ctx, ohci,
-		     OHCI1394_AsReqTrContextControlSet, handle_at_packet);
+	err = context_init(&ohci->at_request_ctx, ohci,
+			   OHCI1394_AsReqTrContextControlSet, handle_at_packet);
+	if (err < 0)
+		goto fail_arrsp_ctx;
 
-	context_init(&ohci->at_response_ctx, ohci,
-		     OHCI1394_AsRspTrContextControlSet, handle_at_packet);
+	err = context_init(&ohci->at_response_ctx, ohci,
+			   OHCI1394_AsRspTrContextControlSet, handle_at_packet);
+	if (err < 0)
+		goto fail_atreq_ctx;
 
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, ~0);
 	ohci->ir_context_channels = ~0ULL;
@@ -3163,7 +3167,9 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	kfree(ohci->ir_context_list);
 	kfree(ohci->it_context_list);
 	context_release(&ohci->at_response_ctx);
+ fail_atreq_ctx:
 	context_release(&ohci->at_request_ctx);
+ fail_arrsp_ctx:
 	ar_context_release(&ohci->ar_response_ctx);
  fail_arreq_ctx:
 	ar_context_release(&ohci->ar_request_ctx);

commit 7a39d8b82165462729d09066bddb395a19025acd
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Fri Nov 26 08:57:31 2010 +0100

    firewire: ohci: Asynchronous Reception rewrite
    
    Move the AR DMA descriptors out of the buffer pages, and map the buffer
    pages linearly into the kernel's address space.  This allows the driver
    to ignore any page boundaries in the DMA data and thus to avoid any
    copying around of packet payloads.
    
    This fixes the bug where S800 packets that are so big (> 4080 bytes)
    that they can be split over three pages were not handled correctly.
    
    Due to the changed algorithm, we can now use arbitrarily many buffer
    pages, which improves performance because the controller can more easily
    unload its DMA FIFO.
    
    Furthermore, using streaming DMA mappings should improve perfomance on
    architectures where coherent DMA mappings are not cacheable.  Even on
    other architectures, the caching behaviour should be improved slightly
    because the CPU no longer writes to the buffer pages.
    
    v2: Detect the last filled buffer page by searching the descriptor's
        residual count value fields in order (like in the old code), instead
        of going backwards through the transfer status fields; it looks as
        if some controllers do not set the latter correctly.
    
    v3: Fix an old resume bug that would now make the handler run into
        a BUG_ON, and replace that check with more useful error handling.
        Increase the buffer size for better performance with non-TI chips.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    
    Maxim Levitsky writes:
        Works almost perfectly.  I can still see RCODE_BUSY errors
        sometimes, not very often though.  64K here eliminates these errors
        completely.  This is most likely due to nouveau drivers and lowest
        perf level I use to lower card temperature.  That increases
        latencies too much I think.  Besides that the IO is just perfect.
    
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |    2 +-
 drivers/firewire/ohci.c  |  411 +++++++++++++++++++++++++++++++---------------
 2 files changed, 278 insertions(+), 135 deletions(-)

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 40a222e..68f942c 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -19,7 +19,7 @@ config FIREWIRE
 
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
-	depends on PCI && FIREWIRE
+	depends on PCI && FIREWIRE && MMU
 	help
 	  Enable this driver if you have a FireWire controller based
 	  on the OHCI specification.  For all practical purposes, this
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index e3c8b60..be0a01d 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -40,6 +40,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/time.h>
+#include <linux/vmalloc.h>
 
 #include <asm/byteorder.h>
 #include <asm/page.h>
@@ -80,17 +81,23 @@ struct descriptor {
 #define COMMAND_PTR(regs)	((regs) + 12)
 #define CONTEXT_MATCH(regs)	((regs) + 16)
 
-struct ar_buffer {
-	struct descriptor descriptor;
-	struct ar_buffer *next;
-	__le32 data[0];
-};
+#define AR_BUFFER_SIZE	(32*1024)
+#define AR_BUFFERS_MIN	DIV_ROUND_UP(AR_BUFFER_SIZE, PAGE_SIZE)
+/* we need at least two pages for proper list management */
+#define AR_BUFFERS	(AR_BUFFERS_MIN >= 2 ? AR_BUFFERS_MIN : 2)
+
+#define MAX_ASYNC_PAYLOAD	4096
+#define MAX_AR_PACKET_SIZE	(16 + MAX_ASYNC_PAYLOAD + 4)
+#define AR_WRAPAROUND_PAGES	DIV_ROUND_UP(MAX_AR_PACKET_SIZE, PAGE_SIZE)
 
 struct ar_context {
 	struct fw_ohci *ohci;
-	struct ar_buffer *current_buffer;
-	struct ar_buffer *last_buffer;
+	struct page *pages[AR_BUFFERS];
+	void *buffer;
+	struct descriptor *descriptors;
+	dma_addr_t descriptors_bus;
 	void *pointer;
+	unsigned int last_buffer_index;
 	u32 regs;
 	struct tasklet_struct tasklet;
 };
@@ -594,59 +601,155 @@ static int ohci_update_phy_reg(struct fw_card *card, int addr,
 	return ret;
 }
 
-static void ar_context_link_page(struct ar_context *ctx,
-				 struct ar_buffer *ab, dma_addr_t ab_bus)
+static inline dma_addr_t ar_buffer_bus(struct ar_context *ctx, unsigned int i)
+{
+	return page_private(ctx->pages[i]);
+}
+
+static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 {
-	size_t offset;
+	struct descriptor *d;
 
-	ab->next = NULL;
-	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
-	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
-						    DESCRIPTOR_STATUS |
-						    DESCRIPTOR_BRANCH_ALWAYS);
-	offset = offsetof(struct ar_buffer, data);
-	ab->descriptor.req_count      = cpu_to_le16(PAGE_SIZE - offset);
-	ab->descriptor.data_address   = cpu_to_le32(ab_bus + offset);
-	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
-	ab->descriptor.branch_address = 0;
+	d = &ctx->descriptors[index];
+	d->branch_address  &= cpu_to_le32(~0xf);
+	d->res_count       =  cpu_to_le16(PAGE_SIZE);
+	d->transfer_status =  0;
 
 	wmb(); /* finish init of new descriptors before branch_address update */
-	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
-	ctx->last_buffer->next = ab;
-	ctx->last_buffer = ab;
+	d = &ctx->descriptors[ctx->last_buffer_index];
+	d->branch_address  |= cpu_to_le32(1);
+
+	ctx->last_buffer_index = index;
 
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_WAKE);
 	flush_writes(ctx->ohci);
 }
 
-static int ar_context_add_page(struct ar_context *ctx)
+static void ar_context_release(struct ar_context *ctx)
 {
-	struct device *dev = ctx->ohci->card.device;
-	struct ar_buffer *ab;
-	dma_addr_t uninitialized_var(ab_bus);
+	unsigned int i;
 
-	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
-	if (ab == NULL)
-		return -ENOMEM;
+	if (ctx->descriptors)
+		dma_free_coherent(ctx->ohci->card.device,
+				  AR_BUFFERS * sizeof(struct descriptor),
+				  ctx->descriptors, ctx->descriptors_bus);
 
-	ar_context_link_page(ctx, ab, ab_bus);
+	if (ctx->buffer)
+		vm_unmap_ram(ctx->buffer, AR_BUFFERS + AR_WRAPAROUND_PAGES);
 
-	return 0;
+	for (i = 0; i < AR_BUFFERS; i++)
+		if (ctx->pages[i]) {
+			dma_unmap_page(ctx->ohci->card.device,
+				       ar_buffer_bus(ctx, i),
+				       PAGE_SIZE, DMA_FROM_DEVICE);
+			__free_page(ctx->pages[i]);
+		}
 }
 
-static void ar_context_release(struct ar_context *ctx)
+static void ar_context_abort(struct ar_context *ctx, const char *error_msg)
 {
-	struct ar_buffer *ab, *ab_next;
-	size_t offset;
-	dma_addr_t ab_bus;
+	if (reg_read(ctx->ohci, CONTROL_CLEAR(ctx->regs)) & CONTEXT_RUN) {
+		reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
+		flush_writes(ctx->ohci);
 
-	for (ab = ctx->current_buffer; ab; ab = ab_next) {
-		ab_next = ab->next;
-		offset = offsetof(struct ar_buffer, data);
-		ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
-		dma_free_coherent(ctx->ohci->card.device, PAGE_SIZE,
-				  ab, ab_bus);
+		fw_error("AR error: %s; DMA stopped\n", error_msg);
 	}
+	/* FIXME: restart? */
+}
+
+static inline unsigned int ar_next_buffer_index(unsigned int index)
+{
+	return (index + 1) % AR_BUFFERS;
+}
+
+static inline unsigned int ar_prev_buffer_index(unsigned int index)
+{
+	return (index - 1 + AR_BUFFERS) % AR_BUFFERS;
+}
+
+static inline unsigned int ar_first_buffer_index(struct ar_context *ctx)
+{
+	return ar_next_buffer_index(ctx->last_buffer_index);
+}
+
+/*
+ * We search for the buffer that contains the last AR packet DMA data written
+ * by the controller.
+ */
+static unsigned int ar_search_last_active_buffer(struct ar_context *ctx,
+						 unsigned int *buffer_offset)
+{
+	unsigned int i, next_i, last = ctx->last_buffer_index;
+	__le16 res_count, next_res_count;
+
+	i = ar_first_buffer_index(ctx);
+	res_count = ACCESS_ONCE(ctx->descriptors[i].res_count);
+
+	/* A buffer that is not yet completely filled must be the last one. */
+	while (i != last && res_count == 0) {
+
+		/* Peek at the next descriptor. */
+		next_i = ar_next_buffer_index(i);
+		rmb(); /* read descriptors in order */
+		next_res_count = ACCESS_ONCE(
+				ctx->descriptors[next_i].res_count);
+		/*
+		 * If the next descriptor is still empty, we must stop at this
+		 * descriptor.
+		 */
+		if (next_res_count == cpu_to_le16(PAGE_SIZE)) {
+			/*
+			 * The exception is when the DMA data for one packet is
+			 * split over three buffers; in this case, the middle
+			 * buffer's descriptor might be never updated by the
+			 * controller and look still empty, and we have to peek
+			 * at the third one.
+			 */
+			if (MAX_AR_PACKET_SIZE > PAGE_SIZE && i != last) {
+				next_i = ar_next_buffer_index(next_i);
+				rmb();
+				next_res_count = ACCESS_ONCE(
+					ctx->descriptors[next_i].res_count);
+				if (next_res_count != cpu_to_le16(PAGE_SIZE))
+					goto next_buffer_is_active;
+			}
+
+			break;
+		}
+
+next_buffer_is_active:
+		i = next_i;
+		res_count = next_res_count;
+	}
+
+	rmb(); /* read res_count before the DMA data */
+
+	*buffer_offset = PAGE_SIZE - le16_to_cpu(res_count);
+	if (*buffer_offset > PAGE_SIZE) {
+		*buffer_offset = 0;
+		ar_context_abort(ctx, "corrupted descriptor");
+	}
+
+	return i;
+}
+
+static void ar_sync_buffers_for_cpu(struct ar_context *ctx,
+				    unsigned int end_buffer_index,
+				    unsigned int end_buffer_offset)
+{
+	unsigned int i;
+
+	i = ar_first_buffer_index(ctx);
+	while (i != end_buffer_index) {
+		dma_sync_single_for_cpu(ctx->ohci->card.device,
+					ar_buffer_bus(ctx, i),
+					PAGE_SIZE, DMA_FROM_DEVICE);
+		i = ar_next_buffer_index(i);
+	}
+	if (end_buffer_offset > 0)
+		dma_sync_single_for_cpu(ctx->ohci->card.device,
+					ar_buffer_bus(ctx, i),
+					end_buffer_offset, DMA_FROM_DEVICE);
 }
 
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
@@ -689,6 +792,10 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = p.header[3] >> 16;
+		if (p.payload_length > MAX_ASYNC_PAYLOAD) {
+			ar_context_abort(ctx, "invalid packet length");
+			return NULL;
+		}
 		break;
 
 	case TCODE_WRITE_RESPONSE:
@@ -699,9 +806,8 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 		break;
 
 	default:
-		/* FIXME: Stop context, discard everything, and restart? */
-		p.header_length = 0;
-		p.payload_length = 0;
+		ar_context_abort(ctx, "invalid tcode");
+		return NULL;
 	}
 
 	p.payload = (void *) buffer + p.header_length;
@@ -751,121 +857,152 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 	return buffer + length + 1;
 }
 
+static void *handle_ar_packets(struct ar_context *ctx, void *p, void *end)
+{
+	void *next;
+
+	while (p < end) {
+		next = handle_ar_packet(ctx, p);
+		if (!next)
+			return p;
+		p = next;
+	}
+
+	return p;
+}
+
+static void ar_recycle_buffers(struct ar_context *ctx, unsigned int end_buffer)
+{
+	unsigned int i;
+
+	i = ar_first_buffer_index(ctx);
+	while (i != end_buffer) {
+		dma_sync_single_for_device(ctx->ohci->card.device,
+					   ar_buffer_bus(ctx, i),
+					   PAGE_SIZE, DMA_FROM_DEVICE);
+		ar_context_link_page(ctx, i);
+		i = ar_next_buffer_index(i);
+	}
+}
+
 static void ar_context_tasklet(unsigned long data)
 {
 	struct ar_context *ctx = (struct ar_context *)data;
-	struct ar_buffer *ab;
-	struct descriptor *d;
-	void *buffer, *end;
-	__le16 res_count;
+	unsigned int end_buffer_index, end_buffer_offset;
+	void *p, *end;
 
-	ab = ctx->current_buffer;
-	d = &ab->descriptor;
+	p = ctx->pointer;
+	if (!p)
+		return;
 
-	res_count = ACCESS_ONCE(d->res_count);
-	if (res_count == 0) {
-		size_t size, size2, rest, pktsize, size3, offset;
-		dma_addr_t start_bus;
-		void *start;
+	end_buffer_index = ar_search_last_active_buffer(ctx,
+							&end_buffer_offset);
+	ar_sync_buffers_for_cpu(ctx, end_buffer_index, end_buffer_offset);
+	end = ctx->buffer + end_buffer_index * PAGE_SIZE + end_buffer_offset;
 
+	if (end_buffer_index < ar_first_buffer_index(ctx)) {
 		/*
-		 * This descriptor is finished and we may have a
-		 * packet split across this and the next buffer. We
-		 * reuse the page for reassembling the split packet.
+		 * The filled part of the overall buffer wraps around; handle
+		 * all packets up to the buffer end here.  If the last packet
+		 * wraps around, its tail will be visible after the buffer end
+		 * because the buffer start pages are mapped there again.
 		 */
+		void *buffer_end = ctx->buffer + AR_BUFFERS * PAGE_SIZE;
+		p = handle_ar_packets(ctx, p, buffer_end);
+		if (p < buffer_end)
+			goto error;
+		/* adjust p to point back into the actual buffer */
+		p -= AR_BUFFERS * PAGE_SIZE;
+	}
 
-		offset = offsetof(struct ar_buffer, data);
-		start = ab;
-		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
-		buffer = ab->data;
-
-		ab = ab->next;
-		d = &ab->descriptor;
-		size = start + PAGE_SIZE - ctx->pointer;
-		/* valid buffer data in the next page */
-		rest = le16_to_cpu(d->req_count) - le16_to_cpu(d->res_count);
-		/* what actually fits in this page */
-		size2 = min(rest, (size_t)PAGE_SIZE - offset - size);
-		memmove(buffer, ctx->pointer, size);
-		memcpy(buffer + size, ab->data, size2);
-
-		while (size > 0) {
-			void *next = handle_ar_packet(ctx, buffer);
-			pktsize = next - buffer;
-			if (pktsize >= size) {
-				/*
-				 * We have handled all the data that was
-				 * originally in this page, so we can now
-				 * continue in the next page.
-				 */
-				buffer = next;
-				break;
-			}
-			/* move the next packet to the start of the buffer */
-			memmove(buffer, next, size + size2 - pktsize);
-			size -= pktsize;
-			/* fill up this page again */
-			size3 = min(rest - size2,
-				    (size_t)PAGE_SIZE - offset - size - size2);
-			memcpy(buffer + size + size2,
-			       (void *) ab->data + size2, size3);
-			size2 += size3;
-		}
-
-		if (rest > 0) {
-			/* handle the packets that are fully in the next page */
-			buffer = (void *) ab->data +
-					(buffer - (start + offset + size));
-			end = (void *) ab->data + rest;
+	p = handle_ar_packets(ctx, p, end);
+	if (p != end) {
+		if (p > end)
+			ar_context_abort(ctx, "inconsistent descriptor");
+		goto error;
+	}
 
-			while (buffer < end)
-				buffer = handle_ar_packet(ctx, buffer);
+	ctx->pointer = p;
+	ar_recycle_buffers(ctx, end_buffer_index);
 
-			ctx->current_buffer = ab;
-			ctx->pointer = end;
+	return;
 
-			ar_context_link_page(ctx, start, start_bus);
-		} else {
-			ctx->pointer = start + PAGE_SIZE;
-		}
-	} else {
-		buffer = ctx->pointer;
-		ctx->pointer = end =
-			(void *) ab + PAGE_SIZE - le16_to_cpu(res_count);
-
-		while (buffer < end)
-			buffer = handle_ar_packet(ctx, buffer);
-	}
+error:
+	ctx->pointer = NULL;
 }
 
 static int ar_context_init(struct ar_context *ctx,
 			   struct fw_ohci *ohci, u32 regs)
 {
-	struct ar_buffer ab;
+	unsigned int i;
+	dma_addr_t dma_addr;
+	struct page *pages[AR_BUFFERS + AR_WRAPAROUND_PAGES];
+	struct descriptor *d;
 
 	ctx->regs        = regs;
 	ctx->ohci        = ohci;
-	ctx->last_buffer = &ab;
 	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
 
-	ar_context_add_page(ctx);
-	ar_context_add_page(ctx);
-	ctx->current_buffer = ab.next;
-	ctx->pointer = ctx->current_buffer->data;
+	for (i = 0; i < AR_BUFFERS; i++) {
+		ctx->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32);
+		if (!ctx->pages[i])
+			goto out_of_memory;
+		dma_addr = dma_map_page(ohci->card.device, ctx->pages[i],
+					0, PAGE_SIZE, DMA_FROM_DEVICE);
+		if (dma_mapping_error(ohci->card.device, dma_addr)) {
+			__free_page(ctx->pages[i]);
+			ctx->pages[i] = NULL;
+			goto out_of_memory;
+		}
+		set_page_private(ctx->pages[i], dma_addr);
+	}
+
+	for (i = 0; i < AR_BUFFERS; i++)
+		pages[i]              = ctx->pages[i];
+	for (i = 0; i < AR_WRAPAROUND_PAGES; i++)
+		pages[AR_BUFFERS + i] = ctx->pages[i];
+	ctx->buffer = vm_map_ram(pages, AR_BUFFERS + AR_WRAPAROUND_PAGES,
+				 -1, PAGE_KERNEL_RO);
+	if (!ctx->buffer)
+		goto out_of_memory;
+
+	ctx->descriptors =
+		dma_alloc_coherent(ohci->card.device,
+				   AR_BUFFERS * sizeof(struct descriptor),
+				   &ctx->descriptors_bus,
+				   GFP_KERNEL);
+	if (!ctx->descriptors)
+		goto out_of_memory;
+
+	for (i = 0; i < AR_BUFFERS; i++) {
+		d = &ctx->descriptors[i];
+		d->req_count      = cpu_to_le16(PAGE_SIZE);
+		d->control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
+						DESCRIPTOR_STATUS |
+						DESCRIPTOR_BRANCH_ALWAYS);
+		d->data_address   = cpu_to_le32(ar_buffer_bus(ctx, i));
+		d->branch_address = cpu_to_le32(ctx->descriptors_bus +
+			ar_next_buffer_index(i) * sizeof(struct descriptor));
+	}
 
 	return 0;
+
+out_of_memory:
+	ar_context_release(ctx);
+
+	return -ENOMEM;
 }
 
 static void ar_context_run(struct ar_context *ctx)
 {
-	struct ar_buffer *ab = ctx->current_buffer;
-	dma_addr_t ab_bus;
-	size_t offset;
+	unsigned int i;
+
+	for (i = 0; i < AR_BUFFERS; i++)
+		ar_context_link_page(ctx, i);
 
-	offset = offsetof(struct ar_buffer, data);
-	ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+	ctx->pointer = ctx->buffer;
 
-	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs), ab_bus | 1);
+	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs), ctx->descriptors_bus | 1);
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN);
 	flush_writes(ctx->ohci);
 }
@@ -2955,11 +3092,15 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	if (param_quirks)
 		ohci->quirks = param_quirks;
 
-	ar_context_init(&ohci->ar_request_ctx, ohci,
-			OHCI1394_AsReqRcvContextControlSet);
+	err = ar_context_init(&ohci->ar_request_ctx, ohci,
+			      OHCI1394_AsReqRcvContextControlSet);
+	if (err < 0)
+		goto fail_iounmap;
 
-	ar_context_init(&ohci->ar_response_ctx, ohci,
-			OHCI1394_AsRspRcvContextControlSet);
+	err = ar_context_init(&ohci->ar_response_ctx, ohci,
+			      OHCI1394_AsRspRcvContextControlSet);
+	if (err < 0)
+		goto fail_arreq_ctx;
 
 	context_init(&ohci->at_request_ctx, ohci,
 		     OHCI1394_AsReqTrContextControlSet, handle_at_packet);
@@ -3024,7 +3165,9 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	context_release(&ohci->at_response_ctx);
 	context_release(&ohci->at_request_ctx);
 	ar_context_release(&ohci->ar_response_ctx);
+ fail_arreq_ctx:
 	ar_context_release(&ohci->ar_request_ctx);
+ fail_iounmap:
 	pci_iounmap(dev, ohci->registers);
  fail_iomem:
 	pci_release_region(dev, 0);

commit 5878730be4e3d0c9527d6f2f688874e38acacc98
Author: Joe Perches <joe@perches.com>
Date:   Sat Oct 30 14:08:27 2010 -0700

    firewire: core: Update WARN uses
    
    Add missing newlines.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index b42a0bd..ad864d8 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -250,7 +250,7 @@ static void fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 		break;
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 	}
  common:
 	packet->speed = speed;
@@ -638,7 +638,7 @@ int fw_get_response_length(struct fw_request *r)
 		}
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 		return 0;
 	}
 }
@@ -694,7 +694,7 @@ void fw_fill_response(struct fw_packet *response, u32 *request_header,
 		break;
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 	}
 
 	response->payload_mapped = false;

commit 60a74a6ff86b4e90b9558956589390efdeb4e924
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Oct 23 13:18:56 2010 +0200

    firewire: nosy: char device is not seekable
    
    Amend .open handler accordingly and remove the .llseek handler.
    .llseek = NULL means no_llseek (return error) since commit 776c163b1b93.
    
    The only client that uses this interface is nosy-dump in linux/tools/firewire
    and it knows not to seek in this char dev.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/nosy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index bf184fb..0618145 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -302,7 +302,7 @@ nosy_open(struct inode *inode, struct file *file)
 
 	file->private_data = client;
 
-	return 0;
+	return nonseekable_open(inode, file);
 fail:
 	kfree(client);
 	lynx_put(lynx);
@@ -405,7 +405,6 @@ static const struct file_operations nosy_ops = {
 	.poll =			nosy_poll,
 	.open =			nosy_open,
 	.release =		nosy_release,
-	.llseek =		noop_llseek,
 };
 
 #define PHY_PACKET_SIZE 12 /* 1 payload, 1 inverse, 1 ack = 3 quadlets */



-- 
Stefan Richter
-=====-==-== ---= --===
http://arcgraph.de/sr/
