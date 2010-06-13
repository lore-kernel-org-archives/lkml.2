Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0FMUuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:50:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49919 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0FMUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ty4+jXBwUuH/WcMpbeQbGAGpZs9lPIDAoLZnevMwUeuMtv8JFofBgVYkBWaC9CuzA8
         IjDT1jopd5gzUHPLdPSPiLTrQ5yQ1m5QSvQRF1EqjTGdUNQrJN4h7R3Mznpq5LUokJfU
         Q+pJ3W5WjTtICG1nuMpsILrvNUaaooPOupbTY=
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: David Miller <davem@davemloft.net>,
       "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, alex.shi@intel.com, tim.c.chen@intel.com
In-Reply-To: <4C15414E.5090201@intel.com>
References: <20100612102802.GA1782@arch.tripp.de>
	 <20100612.145835.123986343.davem@davemloft.net>
	 <4C149147.3080808@intel.com>  <4C15414E.5090201@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 22:50:46 +0200
Message-ID: <1276462246.2448.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 juin 2010 à 13:36 -0700, John Fastabend a écrit :
> John Fastabend wrote:
> > David Miller wrote:
> >> From: Markus Trippelsdorf <markus@trippelsdorf.de>
> >> Date: Sat, 12 Jun 2010 12:28:02 +0200
> >>
> >>> Commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837:
> >>> »net: deliver skbs on inactive slaves to exact matches«
> >>>
> >>> causes large timeouts when mpd clients try to connect to a locally
> >>> running mpd (music player demon) on my machine. This makes it 
> >>> impossible to control mpd.
> >>>
> >>> I bisected this down to the commit mentioned above.
> >>> Reverting the commit from 2.6.35-rc3 also solves the problem.
> >> John, find an easy and fast way to fix this or else I am
> >> going to revert.
> >>
> >> Thanks.
> > 
> > Looks like skbs are hitting loopback_xmit() with deliver_no_wcard set.  Then in 
> > the receive path these skbs are only delivered to exact matches.  Not sure why 
> > this bit is set here, I'll track this down first thing tomorrow.
> > 
> > Thanks,
> > John.
> > --
> 
> Needed to set the wcard bit in copy_skb_header otherwise it will not be cleared 
> when called from skb_clone.  Which then hits the loopback device gets pushed 
> into the rx path and is eventually dropped. The following patch fixes this. 
> Hopefully, this is easy and fast enough for you Dave.
> 
> 
> [PATCH] net: fix deliver_no_wcard regression on loopback device
> 
> deliver_no_wcard is not being set in skb_copy_header.
> In the skb_cloned case it is not being cleared and
> may cause the skb to be dropped when the loopback device
> pushes it back up the stack.
> 
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
> ---
> 
>   net/core/skbuff.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 9f07e74..bcf2fa3 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new, const 
> struct sk_buff *old)
>   	new->ip_summed		= old->ip_summed;
>   	skb_copy_queue_mapping(new, old);
>   	new->priority		= old->priority;
> +	new->deliver_no_wcard	= old->deliver_no_wcard;
>   #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
>   	new->ipvs_property	= old->ipvs_property;
>   #endif
> --

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

BTW, David, it seems there is a double rxhash copy...

[PATCH] net: rxhash already set in __copy_skb_header

No need to copy rxhash again in __skb_clone()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9f07e74..a58e63b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -569,7 +569,6 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	C(len);
 	C(data_len);
 	C(mac_len);
-	C(rxhash);
 	n->hdr_len = skb->nohdr ? skb_headroom(skb) : skb->hdr_len;
 	n->cloned = 1;
 	n->nohdr = 0;


