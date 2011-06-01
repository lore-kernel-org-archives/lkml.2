Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab1FAUE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:04:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56112 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab1FAUEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:04:42 -0400
Date: Wed, 1 Jun 2011 22:04:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/10] drivers/net/can/flexcan.c: add missing clk_put
In-Reply-To: <4DE67CBF.5080006@bfs.de>
Message-ID: <Pine.LNX.4.64.1106012201220.5871@ask.diku.dk>
References: <1306948213-20767-4-git-send-email-julia@diku.dk> <4DE67CBF.5080006@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, walter harms wrote:

> 
> 
> Am 01.06.2011 19:10, schrieb Julia Lawall:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The failed_get label is used after the call to clk_get has succeeded, so it
> > should be moved up above the call to clk_put.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @r exists@
> > expression e1,e2;
> > statement S;
> > @@
> > 
> > e1 = clk_get@p1(...);
> > ... when != e1 = e2
> >     when != clk_put(e1)
> >     when any
> > if (...) { ... when != clk_put(e1)
> >                when != if (...) { ... clk_put(e1) ... }
> > * return@p3 ...;
> >  } else S
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/net/can/flexcan.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> > index d499056..121739c 100644
> > --- a/drivers/net/can/flexcan.c
> > +++ b/drivers/net/can/flexcan.c
> > @@ -978,8 +978,8 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
> >   failed_map:
> >  	release_mem_region(mem->start, mem_size);
> >   failed_req:
> > -	clk_put(clk);
> >   failed_get:
> > +	clk_put(clk);
> >   failed_clock:
> >  	return err;
> >  }
> > 
> 
> So failed_req == failed_get, is that intended ?

I have the impression that it is.  failed_req comes after successful 
calls to platform_get_resource and platform_get_irq, which don't allocate 
anything.

julia
