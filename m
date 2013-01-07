Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3AGLeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:34:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3AGLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:34:06 -0500
Date: Mon, 7 Jan 2013 12:33:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Julia Lawall <julia.lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/2] drivers/media/platform/soc_camera/pxa_camera.c:
 reposition free_irq to avoid access to invalid data
In-Reply-To: <alpine.DEB.2.02.1301071214150.1908@hadrien>
Message-ID: <Pine.LNX.4.64.1301071229070.23972@axis700.grange>
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
 <1357552816-6046-2-git-send-email-Julia.Lawall@lip6.fr>
 <Pine.LNX.4.64.1301071111420.23972@axis700.grange> <alpine.DEB.2.02.1301071214150.1908@hadrien>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:yu+p0jaUXXp5Mx8F3Diz0MTNzQ4lvyWVmyeUsGVGqbg
 834jk8sgtjF+KlhwuMUHdOGUgMaOS5ipzwby1zqTa556OiHnYR
 D1rrSe02FJ2fddlfblac+fUTR98DDgNI3IPZCRhH8XEDIgN+xC
 YX6gyMcj1Du6J7I8O8BL76HUxrsjaaS2G0CxzQlU92HLlai4zA
 bsIdwMPl68bvsrYVi8CObNmwJv2M1d1wbWHV8HwvhfB/z3bp1H
 vYmFzPCaqRSbLE9I863yOHbUwrhyitse3qWl3n2pTFEzJG6F66
 C+7JIsuzc8elBQklCB1l/np2C02Vzx+TZfyBoBU1dq+WOsQp6S
 UwU4Yy5q3C1MG1V4xNs4WLagO/3kbruPuBMEJ+ias+3cf9C2Ln
 bnIA3G4yULpgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Julia Lawall wrote:

> On Mon, 7 Jan 2013, Guennadi Liakhovetski wrote:
> 
> > (adding Robert to CC)
> >
> > Hi Julia
> >
> > Thanks for the patch.
> >
> > On Mon, 7 Jan 2013, Julia Lawall wrote:
> >
> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > The data referenced by an interrupt handler should not be freed before the
> > > interrupt is ended.  The handler is pxa_camera_irq.  This handler may call
> > > pxa_dma_start_channels, which references the channels that are freed on the
> > > lines before the call to free_irq.
> >
> > I don't think any data is freed by pxa_free_dma(), it only disables DMA on
> > a certain channel.
> 
> OK, I seem to have been thrown off by the clearing fo the name field, but
> that doesn't seem to be very important.

Exactly.

> > Theoretically there could be a different problem:
> > pxa_free_dma() deactivates DMA, whereas pxa_dma_start_channels() activates
> > it. But I think we're also protected against that: by the time
> > pxa_camera_remove() is called, and operation on the interface has been
> > stopped, client devices have been detached, pxa_camera_remove_device() has
> > been called, which has also stopped the interface clock. And with clock
> > stopped no interrupts can be generated. And the case of interrupt having
> > been generated before clk_disabled() and only delivered to the driver so
> > much later, that we're already unloading the module, seems really
> > impossible to me. Robert, you agree?
> 
> OK, thanks for the explanation.
> 
> > OTOH, it would be nice to convert also this driver to managed allocations,
> > which also would include devm_request(_threaded)_irq(), but that would
> > mean, that free_irq() would be called even later than now, also after
> > pxa_free_dma().
> 
> OK, if it is safe to call free_irq much later, then I can propose a patch
> for that.

I think it should be safe. In any case we cannot rely on the fact, that 
free_irq() in the current code happens "soon" after pxa_free_dma(), so, 
putting it even later will either emphasise our certainty, that we're safe 
there, or help up catch the bug, since statistically the window will 
become larger;-) Of course, all of clk_get(), request_mem_region() + 
ioremap(), kzalloc(), request_irq() would have to be replaced.

Thanks
Guennadi

> > Speaking about managed allocations, those can be dangerous too: if you
> > request an IRQ before, say, remapping memory, or if you only use managed
> > IRQ requesting and ioremap() memory in your driver manually, that would be
> > wrong. But from a quick grep looks like most (all?) drivers get ir right -
> > first ioremap(), then request IRQ, but to be certain maybe coccinelle
> > could run a test for that too;-)
> 
> Sure.  Thanks for the suggestion!
> 
> julia
> 
> > Thanks
> > Guennadi
> >
> > > The semantic match that finds this problem is as follows:
> > > (http://coccinelle.lip6.fr/)
> > >
> > > // <smpl>
> > > @fn exists@
> > > expression list es;
> > > expression a,b;
> > > identifier f;
> > > @@
> > >
> > > if (...) {
> > >   ... when any
> > >   free_irq(a,b);
> > >   ... when any
> > >   f(es);
> > >   ... when any
> > >   return ...;
> > > }
> > >
> > > @@
> > > expression list fn.es;
> > > expression fn.a,fn.b;
> > > identifier fn.f;
> > > @@
> > >
> > > *f(es);
> > > ... when any
> > > *free_irq(a,b);
> > > // </smpl>
> > >
> > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > ---
> > > Not compiled.  I have not observed the problem in practice; the code just
> > > looks suspicious.
> > >
> > >  drivers/media/platform/soc_camera/pxa_camera.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> > > index f91f7bf..2a19aba 100644
> > > --- a/drivers/media/platform/soc_camera/pxa_camera.c
> > > +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> > > @@ -1810,10 +1810,10 @@ static int pxa_camera_remove(struct platform_device *pdev)
> > >
> > >  	clk_put(pcdev->clk);
> > >
> > > +	free_irq(pcdev->irq, pcdev);
> > >  	pxa_free_dma(pcdev->dma_chans[0]);
> > >  	pxa_free_dma(pcdev->dma_chans[1]);
> > >  	pxa_free_dma(pcdev->dma_chans[2]);
> > > -	free_irq(pcdev->irq, pcdev);
> > >
> > >  	soc_camera_host_unregister(soc_host);
> > >
> > >
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
