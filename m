Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3AGVJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:09:31 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:4608 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab3AGVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:09:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,425,1355094000"; 
   d="scan'208";a="188806441"
Date: Mon, 7 Jan 2013 22:09:27 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/platform/soc_camera/pxa_camera.c:
 reposition free_irq to avoid access to invalid data
In-Reply-To: <874nisbvsh.fsf@free.fr>
Message-ID: <alpine.DEB.2.02.1301072209090.1989@localhost6.localdomain6>
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr> <1357552816-6046-2-git-send-email-Julia.Lawall@lip6.fr> <Pine.LNX.4.64.1301071111420.23972@axis700.grange> <874nisbvsh.fsf@free.fr>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > (adding Robert to CC)
> > I don't think any data is freed by pxa_free_dma(), it only disables DMA on 
> > a certain channel. Theoretically there could be a different problem: 
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
> Agreed that pxa_free_dma() doesn't free anything, that one is easy :)
> 
> And agreed too for the second part, with a slighly different explanation :
>  - pxa_camera_remove_device() has been called as you said
>  - inside this function, check comment
>    "/* disable capture, disable interrupts */"
>    => this ensures no interrupt can be generated anymore
> 
> So after pxa_camera_remove_device() has been called, no interrupts can be
> generated.
> 
> Yet as you said, it leaves the "almost impossible" scenario :
>  - a user begins a capture
>  - the user closes the capture device and unloads pxa-camera.ko:
>      soc_camera_close()
>        pxa_camera_remove_device()
>          the IRQ line is asserted but doesn't trigger yet the interrupt handler
>          (yes I know, improbable)
>          meanwhile, IRQs are disabled, DMA channels are stopped
>      switch_to(rmmod)
>        => yes I know, impossible, the interrupt handler must be run before, but
>        let's continue for love of discussion ...
>      rmmod pxa-camera
>        pxa_camera_remove()
>          pxa_free_dma() * 3
>          ----> here the IRQ handler kicks in !!!
>                => pxa_camera_irq()
>                     pxa_dma_start_channels()
>          ----> it hurts !
> 
> My call is that this is impossible because the switch_to() should run the IRQ
> handler before pxa_camera_remove() is called.
> 
> So all this to say that I think we're safe, unless a heavy ion or a cosmic ray
> strikes the PXA :)

Thanks for the explanation.

julia
