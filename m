Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1CVNfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:35:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33762 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756100Ab1CVNfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:35:12 -0400
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Florian Mickler <florian@mickler.org>
Cc: Andy Walls <awalls@md.metrocast.net>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        js@linuxtv.org, tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <20110321220315.7545a61a@schatten.dmk.lab>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
	 <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
	 <20110321220315.7545a61a@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 08:35:04 -0500
Message-ID: <1300800904.3290.7.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 22:03 +0100, Florian Mickler wrote:
> On Mon, 21 Mar 2011 15:26:43 -0400
> Andy Walls <awalls@md.metrocast.net> wrote:
> 
> > Florian Mickler <florian@mickler.org> wrote:
> > 
> > >Hi all!
> > >
> > >These patches get rid of on-stack dma buffers for some of the dvb-usb
> > >drivers. 
> > >I do not own the hardware, so these are only compile tested. I would 
> > >appreciate testing and review.
> > >They were previously sent to the list, but some error on my side
> > >prevented (some of?) them from beeing delivered to all parties (the
> > >lists).
> > >
> > >These changes are motivated by 
> > >https://bugzilla.kernel.org/show_bug.cgi?id=15977 .
> > >
> > >The patches which got tested already were submitted to Mauro (and
> > >lkml/linux-media) yesterday seperately. Those fix this same issue for
> > >ec168,
> > >ce6230, au6610 and lmedm04. 
> > >
> > >A fix for vp702x has been submitted seperately for review on the list.
> > >I have
> > >similiar fixes like the vp702x-fix for dib0700 (overlooked some
> > >on-stack
> > >buffers in there in my original submission as well) and gp8psk, but I
> > >am
> > >holding them back 'till I got time to recheck those and getting some
> > >feedback
> > >on vp702x.
> > >
> > >Please review and test.
> > >
> > >Regards,
> > >Flo
> > >
> > >Florian Mickler (6):
> > >  [media] a800: get rid of on-stack dma buffers
> > >  [media v2] vp7045: get rid of on-stack dma buffers
> > >  [media] friio: get rid of on-stack dma buffers
> > >  [media] dw2102: get rid of on-stack dma buffer
> > >  [media] m920x: get rid of on-stack dma buffers
> > >  [media] opera1: get rid of on-stack dma buffer
> > >
> > > drivers/media/dvb/dvb-usb/a800.c   |   17 ++++++++++---
> > > drivers/media/dvb/dvb-usb/dw2102.c |   10 ++++++-
> > > drivers/media/dvb/dvb-usb/friio.c  |   23 ++++++++++++++---
> > > drivers/media/dvb/dvb-usb/m920x.c  |   33 ++++++++++++++++--------
> > > drivers/media/dvb/dvb-usb/opera1.c |   31 +++++++++++++++--------
> > >drivers/media/dvb/dvb-usb/vp7045.c |   47
> > >++++++++++++++++++++++++++----------
> > > 6 files changed, 116 insertions(+), 45 deletions(-)
> > >
> > >-- 
> > >1.7.4.1
> > >
> > >--
> > >To unsubscribe from this list: send the line "unsubscribe linux-media"
> > >in
> > >the body of a message to majordomo@vger.kernel.org
> > >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> > Florian,
> > 
> > For all of these, what happens when the USB call times out and you kfree() the buffer?  Can the USB DMA actually complete after this kfree(), possibly corrupting space that has been reallocated off the heap, since the kfree()?
> > 
> > This is the scenario for which I assume allocating off the stack is bad.  
> > 
> > Do these changes simply make corruption less noticable since heap gets corrupted vs stack?
> > 
> > Regards,
> > Andy
> 
> To be blunt, I'm not shure I fully understand the requirements myself.
> But as far as I grasped it, the main problem is that we need memory
> which the processor can see as soon as the device has scribbled upon
> it. (think caches and the like)
> 
> Somewhere down the line, the buffer to usb_control_msg get's to be
> a parameter to dma_map_single which is described as part of
> the DMA API in Documentation/DMA-API.txt 
> 
> The main point I filter out from that is that the memory has to begin
> exactly at a cache line boundary... 

The API will round up so that the correct region covers the API.
However, if you have other structures packed into the space (as very
often happens on stack), you get cache line interference in the CPU if
they get accessed:  The act of accessing an adjacent object pulls in
cache above your object and destroys DMA coherence.  This is the
principle reason why DMA to stack is a bad idea.

> I guess (not verified), that the dma api takes sufficient precautions
> to abort the dma transfer if a timeout happens.  So freeing _should_
> not be an issue. (At least, I would expect big fat warnings everywhere
> if that were the case)

No, it doesn't take any precautions like this.  the DMA API is just
mapping (possibly via an IOMMU).  If the transfer times out, that's done
in the DMA engine of the card, and must be cleaned up by the driver and
unmapped.

The general rule though is never DMA to stack.  On some processors, the
way stack is allocated can actually make this not work.

James


