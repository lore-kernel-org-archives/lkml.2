Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0FAIOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:14:40 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:43864 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0FAIOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:14:38 -0400
Date: Tue, 1 Jun 2010 10:14:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/isdn/hardware/mISDN: Use GFP_ATOMIC when a
 lock is held
In-Reply-To: <20100601080535.GA19288@gw.linux-pingi.de>
Message-ID: <Pine.LNX.4.64.1006011014100.12546@ask.diku.dk>
References: <Pine.LNX.4.64.1005301549230.15938@ask.diku.dk>
 <20100601080535.GA19288@gw.linux-pingi.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Karsten Keil wrote:

> Hello Julia,
> 
> thanks for that report, the issue is valid, but I think the fix in that case
> should be to move the allocation to an other place, to avoid wasting of
> GFP_ATOMIC allocation. I will come up with an other fix.

OK, thanks.  It's not so easy to see what to do in the interprocedural 
case.

julia

> Karsten
> 
> 
> On Sun, May 30, 2010 at 03:49:40PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The function inittiger is only called from nj_init_card, where a lock is held.
> > 
> > The semantic patch that makes this change is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @gfp exists@
> > identifier fn;
> > position p;
> > @@
> > 
> > fn(...) {
> >  ... when != spin_unlock_irqrestore
> >      when any
> >  GFP_KERNEL@p
> >  ... when any
> > }
> > 
> > @locked@
> > identifier gfp.fn;
> > @@
> > 
> > spin_lock_irqsave(...)
> > ...  when != spin_unlock_irqrestore
> > fn(...)
> > 
> > @depends on locked@
> > position gfp.p;
> > @@
> > 
> > - GFP_KERNEL@p
> > + GFP_ATOMIC
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/isdn/hardware/mISDN/netjet.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff -u -p a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
> > --- a/drivers/isdn/hardware/mISDN/netjet.c
> > +++ b/drivers/isdn/hardware/mISDN/netjet.c
> > @@ -320,12 +320,12 @@ inittiger(struct tiger_hw *card)
> >  		return -ENOMEM;
> >  	}
> >  	for (i = 0; i < 2; i++) {
> > -		card->bc[i].hsbuf = kmalloc(NJ_DMA_TXSIZE, GFP_KERNEL);
> > +		card->bc[i].hsbuf = kmalloc(NJ_DMA_TXSIZE, GFP_ATOMIC);
> >  		if (!card->bc[i].hsbuf) {
> >  			pr_info("%s: no B%d send buffer\n", card->name, i + 1);
> >  			return -ENOMEM;
> >  		}
> > -		card->bc[i].hrbuf = kmalloc(NJ_DMA_RXSIZE, GFP_KERNEL);
> > +		card->bc[i].hrbuf = kmalloc(NJ_DMA_RXSIZE, GFP_ATOMIC);
> >  		if (!card->bc[i].hrbuf) {
> >  			pr_info("%s: no B%d recv buffer\n", card->name, i + 1);
> >  			return -ENOMEM;
> > --
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
