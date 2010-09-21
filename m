Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0IUOF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:05:57 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:43647 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0IUOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:05:56 -0400
Date: Tue, 21 Sep 2010 10:05:01 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
Message-ID: <20100921140501.GA21572@elliptictech.com>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <20100920174443.GA5515@elliptictech.com>
 <1285006844.2323.17.camel@edumazet-laptop>
 <20100920195256.GA14330@elliptictech.com>
 <1285013853.2323.148.camel@edumazet-laptop>
 <1285018272.2323.243.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285018272.2323.243.camel@edumazet-laptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 23:31 +0200, Eric Dumazet wrote:
> Could you try following patch ?
>
> [PATCH] ip : fix truesize mismatch in ip fragmentation
[...]
> @@ -658,13 +657,15 @@ static int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
>  				goto slow_path;
>  
>  			BUG_ON(frag->sk);
> -			if (skb->sk) {
> +		}
> +		if (skb->sk) {
> +			skb_walk_frags(skb, frag) {
>  				frag->sk = skb->sk;
>  				frag->destructor = sock_wfree;
> -				truesizes += frag->truesize;
> +				skb->truesize -= frag->truesize;
>  			}
>  		}
> -
> +				

This hunk introduces some whitespace damage.

Anyway, I tried this with ESP on both IPv4 and IPv6 and it appears to
correct the issue.  Thanks!

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
