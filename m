Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3AGUJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:09:05 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43238 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3AGUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:09:03 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/platform/soc_camera/pxa_camera.c: reposition free_irq to avoid access to invalid data
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
	<1357552816-6046-2-git-send-email-Julia.Lawall@lip6.fr>
	<Pine.LNX.4.64.1301071111420.23972@axis700.grange>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 07 Jan 2013 21:08:46 +0100
In-Reply-To: <Pine.LNX.4.64.1301071111420.23972@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon, 7 Jan 2013 12:09:36 +0100 (CET)")
Message-ID: <874nisbvsh.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> (adding Robert to CC)
> I don't think any data is freed by pxa_free_dma(), it only disables DMA on 
> a certain channel. Theoretically there could be a different problem: 
> pxa_free_dma() deactivates DMA, whereas pxa_dma_start_channels() activates 
> it. But I think we're also protected against that: by the time 
> pxa_camera_remove() is called, and operation on the interface has been 
> stopped, client devices have been detached, pxa_camera_remove_device() has 
> been called, which has also stopped the interface clock. And with clock 
> stopped no interrupts can be generated. And the case of interrupt having 
> been generated before clk_disabled() and only delivered to the driver so 
> much later, that we're already unloading the module, seems really 
> impossible to me. Robert, you agree?

Agreed that pxa_free_dma() doesn't free anything, that one is easy :)

And agreed too for the second part, with a slighly different explanation :
 - pxa_camera_remove_device() has been called as you said
 - inside this function, check comment
   "/* disable capture, disable interrupts */"
   => this ensures no interrupt can be generated anymore

So after pxa_camera_remove_device() has been called, no interrupts can be
generated.

Yet as you said, it leaves the "almost impossible" scenario :
 - a user begins a capture
 - the user closes the capture device and unloads pxa-camera.ko:
     soc_camera_close()
       pxa_camera_remove_device()
         the IRQ line is asserted but doesn't trigger yet the interrupt handler
         (yes I know, improbable)
         meanwhile, IRQs are disabled, DMA channels are stopped
     switch_to(rmmod)
       => yes I know, impossible, the interrupt handler must be run before, but
       let's continue for love of discussion ...
     rmmod pxa-camera
       pxa_camera_remove()
         pxa_free_dma() * 3
         ----> here the IRQ handler kicks in !!!
               => pxa_camera_irq()
                    pxa_dma_start_channels()
         ----> it hurts !

My call is that this is impossible because the switch_to() should run the IRQ
handler before pxa_camera_remove() is called.

So all this to say that I think we're safe, unless a heavy ion or a cosmic ray
strikes the PXA :)

Cheers.

--
Robert
