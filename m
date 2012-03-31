Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2CaJnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:43:24 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59607 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755921Ab2CaJnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:43:21 -0400
Date: Sat, 31 Mar 2012 11:40:14 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Sinkovsky <msink@permonline.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] Ethernet driver for the WIZnet W5100 chip
Message-ID: <20120331094014.GA7746@electric-eye.fr.zoreil.com>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333090806-27988-2-git-send-email-msink@permonline.ru> <1333099431.19659.15.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333099431.19659.15.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> :
> Le vendredi 30 mars 2012 ?? 13:00 +0600, Mike Sinkovsky a ??crit :
> > Tested and used in production with Blackfin BF531 embedded processor.
[...]
> > +static int w5100_start_tx(struct sk_buff *skb, struct net_device *ndev)
> > +{
> > +	struct w5100_priv *priv = netdev_priv(ndev);
> > +	u16 offset;
> > +
> > +	if (w5100_read16(priv, W5100_S0_TX_FSR) < skb->len) {
> 
> There is a race here.
> 
> Interrupt came come right here before you set the stop_queue()
> 
> 
> > +		netif_stop_queue(ndev);
> 
> So Here I suggest adding a test again
> 	
> 	if (w5100_read16(priv, W5100_S0_TX_FSR) >= skb->len)
> 		netif_wake_queue(ndev);
> 	else
> 		return NETDEV_TX_BUSY;

The start_tx logic seems broken anyway: it claims it always can take
packets until it is given one it can't process. The driver should rather
do the opposite and stop queueing as soon as there is no guarantee for
the next packet.

-- 
Ueimor
