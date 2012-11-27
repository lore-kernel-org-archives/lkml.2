Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2K0S2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:28:48 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:35397 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2K0S2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:28:46 -0500
Date: Tue, 27 Nov 2012 19:28:43 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121127182843.GA11597@shrek.podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
 <1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
 <1354036592.2534.6.camel@shinybook.infradead.org>
 <20121127173906.GA11390@shrek.podlesie.net>
 <1354039349.2534.11.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354039349.2534.11.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 06:02:29PM +0000, David Woodhouse wrote:
> On Tue, 2012-11-27 at 18:39 +0100, Krzysztof Mazur wrote:
> > Yes, I missed that one - it's even worse, I introduced that bug 
> > in "[PATCH 1/7] atm: detach protocol before closing vcc". Before that
> > patch that scenario shouldn't happen because vcc was closed before
> > calling pppoatm_send(vcc, NULL) - the driver should provide appropriate
> > synchronization.
> > 
> > I think that we should just drop that patch. With later changes it's not
> > necessary - the pppoatm_send() can be safely called while closing vcc.
> 
> I'm not running with that patch. This bug exists for br2684 even before
> it, and I think also for pppoatm.
> 
> In solos-pci at least, the ops->close() function doesn't flush all
> pending skbs for this vcc before returning. So can be a tasklet
> somewhere which has loaded the address of the vcc->pop function from one
> of them, and is going to call it in some unspecified amount of time.
> 
> Should we make the device's ->close function wait for all TX and RX skbs
> for this vcc to complete? 

Yes, the ->close() can sleep and after vcc is closed the ->pop() shouldn't be
called.


While reviewing your br2684 patch I also found that some ATM drivers does
not call ->pop() when ->send() fails, they should do:

	if (vcc->pop)
		vcc->pop(vcc, skb);
	else
		dev_kfree_skb(skb);

but some drivers just call dev_kfree_skb(skb).

I think that we should add atm_pop() function that does that and fix all
drivers.

Krzysiek
