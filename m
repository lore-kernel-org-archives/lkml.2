Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2BFQpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:45:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50961 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2BFQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:45:11 -0500
Date: Mon, 06 Feb 2012 11:45:05 -0500 (EST)
Message-Id: <20120206.114505.1068389709235471266.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 08:45:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Sun,  5 Feb 2012 18:19:09 +0530

> From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
> 
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

Applied, but I had to fix several things up:

> -			if (pkt_len < rx_copybreak && (skb = dev_alloc_skb(pkt_len + 2)) != NULL) {
> +			if (pkt_len < rx_copybreak &&
> +					(skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {

This is not the correct way to format a multi-line conditional.

All subsequent lines must start at the first column after the initial line's
openning parenthesis:

	if (format_it &&
	    like_this)

	if (not &&
		like_this)

To be honest I have no idea what posses people to tab things out in such
an incredibly ugly fashion in the first place.

> -		if (!(lp->rx_skbuff[i] = dev_alloc_skb(lp->rx_buff_len))) {
> +		lp->rx_skbuff[i] = netdev_alloc_skb(dev, lp->rx_buff_len);
> +		if (!lp->rx_skbuff[i]) {

You properly leave this test alone and keep it as "!foo" yet:

> -			if(!(new_skb = dev_alloc_skb(lp->rx_buff_len))){
> +			new_skb = netdev_alloc_skb(dev, lp->rx_buff_len);
> +			if (new_skb == NULL) {

You change this one to the undesirable "== NULL" test, don't do that.
"!foo" is the canonical and most efficient NULL pointer test.

> -      skb = dev_alloc_skb(pkt_len+2);
> +	skb = netdev_alloc_skb(dev, pkt_len + 2);

Do not change the indentation in one place when the entire rest of the source
file uses something else, fixing that would a seperate change from what you're
doing.

> -	    skb = dev_alloc_skb(RX_BUFLEN + 2);
> +		skb = netdev_alloc_skb(RX_BUFLEN + 2);

Same problem.
