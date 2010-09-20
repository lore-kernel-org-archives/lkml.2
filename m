Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0ITSzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:55:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab0ITSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j21O4NZLkI59+ignWuJvVL09omug3TyEMw2KtIOSipswGuXRIt+F4bdbt/+WfoErpT
         Szx8C22Wz3cYib9pdo33Ptx7S8XwEqRM0h40IkeUmSCSU8RT+It4S+NZU09WxTwKXLoo
         /ufytR5EJHBter3isLMUffNEx/Vu8BEI/pUmI=
Subject: Re: [PATCH] usb: gadget: rndis: don't use dev_get_stats()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: m.nazarewicz@samsung.com, dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20100920.112727.214208208.davem@davemloft.net>
References: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
	 <20100920.112727.214208208.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 20:48:47 +0200
Message-ID: <1285008527.2323.52.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 20 septembre 2010 à 11:27 -0700, David Miller a écrit :
> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Date: Mon, 20 Sep 2010 20:23:04 +0200
> 
> > This commit removes the call to dev_get_stats() from the
> > gen_ndis_query_resp() function.  Since spin_lock_bh() was
> > added to dev_txq_stats_fold() the call started causing
> > warnings.  This is because gen_ndis_query_resp() can be
> > (indirectly) called from rndis_command_complete() which is
> > called with interrupts disabled.
> > 
> > While at it, this commit also changes the
> > gen_ndis_query_resp() function so that "net" local variable is
> > used instead of "rndis_per_dev_params[configNr].dev" in all
> > places this is referenced.
> > 
> > Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> 
> The way this works is dev_get_stats() takes that "temp" object the
> caller provides, it writes the correct statistics into it (with any
> necessary translations), and then passes back a pointer to it.
> 
> See net/core/dev.c:dev_get_stats()
> 
> You must use dev_get_stats() or else the statistics won't be properly
> converted.
> 
> Like I originally suggested, you need to rearrange the code in this
> driver such that the gen_ndis_query_resp() work happens in a tasklet,
> workqueue, or some other non-hardware-irq context.

Hmm, maybe its a bit difficult to fix this problem for stable kernel.

What we could do is assume rndis wont use a device driver that actually
needs txq tx stats folding, and just use following interim patch ?

diff --git a/net/core/dev.c b/net/core/dev.c
index b9b22a3..31d5424 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5288,6 +5288,14 @@ void dev_txq_stats_fold(const struct net_device *dev,
 	unsigned int i;
 	struct netdev_queue *txq;
 
+	/* temporary hack : rndis calls us under hard irq */
+	if (WARN_ON_ONCE(in_irq())) {
+		stats->tx_bytes   = dev->stats.tx_bytes;
+		stats->tx_packets = dev->stats.tx_packets;
+		stats->tx_dropped = dev->stats.tx_dropped;
+		return;
+	}
+
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		txq = netdev_get_tx_queue(dev, i);
 		spin_lock_bh(&txq->_xmit_lock);


