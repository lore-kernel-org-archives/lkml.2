Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1CVNRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:17:50 -0400
Received: from bar.sig21.net ([80.81.252.164]:55705 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1CVNRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:17:48 -0400
X-Greylist: delayed 2654 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Mar 2011 09:17:47 EDT
Date: Tue, 22 Mar 2011 13:33:11 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Florian Mickler <florian@mickler.org>,
        Andy Walls <awalls@md.metrocast.net>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Joerg Roedel <joerg.roedel@amd.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
Message-ID: <20110322123311.GA24812@linuxtv.org>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
 <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
 <20110321220315.7545a61a@schatten.dmk.lab>
 <alpine.LRH.2.00.1103221157510.8710@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1103221157510.8710@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.2 (---)
X-Spam-21-Report: No, score=-3.2 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=1.202,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:59:32AM +0100, Jiri Kosina wrote:
> On Mon, 21 Mar 2011, Florian Mickler wrote:
> 
> > To be blunt, I'm not shure I fully understand the requirements myself. 
> > But as far as I grasped it, the main problem is that we need memory 
> > which the processor can see as soon as the device has scribbled upon it. 
> > (think caches and the like)
> > 
> > Somewhere down the line, the buffer to usb_control_msg get's to be a 
> > parameter to dma_map_single which is described as part of the DMA API in 
> > Documentation/DMA-API.txt
> > 
> > The main point I filter out from that is that the memory has to begin
> > exactly at a cache line boundary... 
> > 
> > I guess (not verified), that the dma api takes sufficient precautions to 
> > abort the dma transfer if a timeout happens.  So freeing _should_ not be 
> > an issue. (At least, I would expect big fat warnings everywhere if that 
> > were the case)
> > 
> > I cc'd some people that hopefully will correct me if I'm wrong...
> 
> It all boils down to making sure that you don't free the memory which is 
> used as target of DMA transfer.
> 
> This is very likely to hit you when DMA memory region is on stack, but 
> blindly just converting this to kmalloc()/kfree() isn't any better if you 
> don't make sure that all the DMA transfers have been finished and device 
> will not be making any more to that particular memory region.

I think it is important that one cache line is not shared between
a DMA buffer and other objects, especially on architectures where
cache coherency is managed in software (ARM, MIPS etc.).  If you
use kmalloc() for the DMA buffer that is guaranteed.
(E.g. DMA API will do writeback/invalidate before the DMA starts, but
if the CPU accesses a variable which is next to the buffer
while DMA is still pending then the whole cacheline is read back into
the cache.  If the CPU is then trying to read the DMA buffer after
the DMA finished it will see stale data from the cache.  You lose.)

It depends on the device doing DMA if it needs special alignment.
If you meet its alignment requirements, and wait for the end of the DMA before
returning, and make sure the buffer does not share cache lines with
neighbouring objects on the stack, then you can use DMA buffers on
stack.  In practice it's simpler and much less error prone to use kmalloc().

Regarding usb_control_msg(), since it is a synchronous API which
waits for the end of the transfer I'm relatively sure there is no
DMA pending when it returns, even if it aborts with timeout or any
other error code.


Johannes
