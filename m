Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0DLPji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:39:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab0DLPjh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:39:37 -0400
Date: Mon, 12 Apr 2010 08:38:42 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Cong Wang <amwang@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
       Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Jeff Moyer <jmoyer@redhat.com>, Andy Gospodarek <gospo@redhat.com>,
       bonding-devel@lists.sourceforge.net
Subject: Re: [Bonding-devel] [v3 Patch 2/3] bridge: make bridge support
 netpoll
Message-ID: <20100412083842.26d71bda@nehalam>
In-Reply-To: <1271068737.16881.18.camel@edumazet-laptop>
References: <20100408062234.4499.17042.sendpatchset@localhost.localdomain>
	<20100408062246.4499.5670.sendpatchset@localhost.localdomain>
	<20100408083710.2b61ee44@nehalam>
	<4BC2F7E2.7020309@redhat.com>
	<1271068737.16881.18.camel@edumazet-laptop>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 12:38:57 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le lundi 12 avril 2010 à 18:37 +0800, Cong Wang a écrit :
> > Stephen Hemminger wrote:
> > > There is no protection on dev->priv_flags for SMP access.
> > > It would better bit value in dev->state if you are using it as control flag.
> > > 
> > > Then you could use 
> > > 			if (unlikely(test_and_clear_bit(__IN_NETPOLL, &skb->dev->state)))
> > > 				netpoll_send_skb(...)
> > > 
> > > 
> > 
> > Hmm, I think we can't use ->state here, it is not for this kind of purpose,
> > according to its comments.
> > 
> > Also, I find other usages of IFF_XXX flags of ->priv_flags are also using
> > &, | to set or clear the flags. So there must be some other things preventing
> > the race...
> 
> Yes, its RTNL that protects priv_flags changes, hopefully...
> 

The patch was not protecting priv_flags with RTNL.
For example..


@@ -308,7 +312,9 @@ static void netpoll_send_skb(struct netp
 		     tries > 0; --tries) {
 			if (__netif_tx_trylock(txq)) {
 				if (!netif_tx_queue_stopped(txq)) {
+					dev->priv_flags |= IFF_IN_NETPOLL;
 					status = ops->ndo_start_xmit(skb, dev);
+					dev->priv_flags &= ~IFF_IN_NETPOLL;
 					if (status == NETDEV_TX_OK)
 						txq_trans_update(txq);
