Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2K2Q2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:28:23 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:45056 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2K2Q2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:28:22 -0500
Date: Thu, 29 Nov 2012 17:28:18 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121129162818.GA6615@shrek.podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
 <1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
 <1354036592.2534.6.camel@shinybook.infradead.org>
 <20121127173906.GA11390@shrek.podlesie.net>
 <1354039349.2534.11.camel@shinybook.infradead.org>
 <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
 <AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
 <1354141115.21562.101.camel@shinybook.infradead.org>
 <20121129150945.GB16478@shrek.podlesie.net>
 <1354204077.21562.172.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354204077.21562.172.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:47:57PM +0000, David Woodhouse wrote:
> On Thu, 2012-11-29 at 16:09 +0100, Krzysztof Mazur wrote:
> > 
> > I don't like two thinks about this patch:
> > 
> >         - if allos_skb(sizeof(*header), GFP_ATOMIC) at beginning of
> >           pclose() fails we will crash
> > 
> >         - if card wakes up after this timeout we will probably crash too
> > 
> > That's why proposed different approach, but it has other problems.
> 
> How about this variant on what you suggested. Yes, we can definitely
> remove everything that's in the queue... as long as we use
> skb_queue_walk_safe() instead of skb_queue_walk().
> 
> We can use GFP_KERNEL instead of GFP_ATOMIC, which at least reduces the
> likelihood of failing to close the vcc.
> 
> We end up waiting *only* if there is a packet which is *currently* being
> DMA'd to the card. And if the card doesn't take that within 5 seconds,
> it almost certainly never will. So I can live with that.
> 

Yeah, that shouldn't happen.

> +				if (!test_bit(ATM_VF_READY, &vcc->flags))
> +					wake_up(&card->param_wq);
> +			} else

according to CodingStyle:

+ } else {
>  				dev_kfree_skb_irq(oldskb);
> -			}
+ }

Krzysiek
