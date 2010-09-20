Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0ITS6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:58:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65237 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0ITS6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:58:41 -0400
Date: Mon, 20 Sep 2010 21:00:35 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] usb: gadget: rndis: don't use dev_get_stats()
In-reply-to: <1285008527.2323.52.camel@edumazet-laptop>
To: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-id: <op.vjchq9lx7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
 <20100920.112727.214208208.davem@davemloft.net>
 <1285008527.2323.52.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
>>> This commit removes the call to dev_get_stats() from the
>>> gen_ndis_query_resp() function.  Since spin_lock_bh() was
>>> added to dev_txq_stats_fold() the call started causing
>>> warnings.  This is because gen_ndis_query_resp() can be
>>> (indirectly) called from rndis_command_complete() which is
>>> called with interrupts disabled.

> Le lundi 20 septembre 2010 à 11:27 -0700, David Miller a écrit :
>> The way this works is dev_get_stats() takes that "temp" object the
>> caller provides, it writes the correct statistics into it (with any
>> necessary translations), and then passes back a pointer to it.
[...]
>> Like I originally suggested, you need to rearrange the code in this
>> driver such that the gen_ndis_query_resp() work happens in a tasklet,
>> workqueue, or some other non-hardware-irq context.

On Mon, 20 Sep 2010 20:48:47 +0200, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Hmm, maybe its a bit difficult to fix this problem for stable kernel.
>
> What we could do is assume rndis wont use a device driver that actually
> needs txq tx stats folding, and just use following interim patch ?
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b9b22a3..31d5424 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5288,6 +5288,14 @@ void dev_txq_stats_fold(const struct net_device *dev,
>  	unsigned int i;
>  	struct netdev_queue *txq;
>+	/* temporary hack : rndis calls us under hard irq */
> +	if (WARN_ON_ONCE(in_irq())) {
> +		stats->tx_bytes   = dev->stats.tx_bytes;
> +		stats->tx_packets = dev->stats.tx_packets;
> +		stats->tx_dropped = dev->stats.tx_dropped;
> +		return;
> +	}
> +
>  	for (i = 0; i < dev->num_tx_queues; i++) {
>  		txq = netdev_get_tx_queue(dev, i);
>  		spin_lock_bh(&txq->_xmit_lock);

I think it's better to put such temporary fix inside RNDIS code.  It
seems there is no need to clutter the whole subsystem with temporary
fix.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
