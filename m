Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2K1KEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:04:15 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:49237 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2K1KEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:04:13 -0500
Date: Wed, 28 Nov 2012 11:04:12 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121128100412.GA6269@shrek.podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
 <1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
 <1354036592.2534.6.camel@shinybook.infradead.org>
 <20121127173906.GA11390@shrek.podlesie.net>
 <1354039349.2534.11.camel@shinybook.infradead.org>
 <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
 <AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 09:21:37AM -0000, David Laight wrote:
> > On Tue, 27 Nov 2012 18:02:29 +0000
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > In solos-pci at least, the ops->close() function doesn't flush all
> > > pending skbs for this vcc before returning. So can be a tasklet
> > > somewhere which has loaded the address of the vcc->pop function from one
> > > of them, and is going to call it in some unspecified amount of time.
> > >
> > > Should we make the device's ->close function wait for all TX and RX skbs
> > > for this vcc to complete?
> > 
> > the driver's close routine should wait for any of the pending tx and rx
> > to complete.  take a look at the he.c in driver/atm
> 
> I'm not sure that sleeping for long periods in close() is always a
> good idea. If the process is event driven it will be unable to
> handle events on other fd until the close completes.
> This may be known not to be true in this case, but is more generally
> a problem.
> In this case the close should probably (IMHO at least) only sleep
> while pending tx and rx are aborted/discarded.
> 
> Even when it might make sense to sleep in close until tx drains
> there needs to be a finite timeout before it become abortive.
> 

The ->close() routine can just abort any pending rx/tx and just wait
for completion of currently running rx/tx code. That shouldn't take
long.

Krzysiek
