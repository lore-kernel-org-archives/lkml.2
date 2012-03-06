Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab2CFIxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:53:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab2CFIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:53:22 -0500
Date: Tue, 6 Mar 2012 09:53:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331022623.24656.191.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203060935460.9300@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange> 
 <Pine.LNX.4.64.1203021341590.913@axis700.grange> <1331022623.24656.191.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:mvYuYTFxzRO4uqYJdlUwedGE+TGKZV/NY5Q1aFk8fG/
 KuTyl0zcfDi2a45uVsz3uNa9eoxA1/uql1XTOECX4a2/UUVP3u
 ME4SxbFrdLYgFJxnz20VX5Xq1U0g/ZOFq+Ykfn4GQGGAvUaCsL
 1UL/ksPmJs4InYmai9+DW3uCR274/azXWF6V7dRjJlpIuvGRyf
 GQykHqKkU/1pkmSaLX/tPT1otM9CoTBfTttWQrDNPyj572eJJe
 lmxb+LVW6gVAbwtGhi9GKNFQ7vtlhoX35KFyo+KB1AcwnCeZ6b
 nEDLd1WU8mQkKHrP5lWyTjsV2/QOi2T/uSKIN1+lwa6oAUK+pU
 rJP/Ehh9Q5L5Il29Hg2+ZsaGQMgkj5h350rpVPHkyBPb/IoV9v
 Srn7iA6SkJxSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

Thanks for your review.

On Tue, 6 Mar 2012, Vinod Koul wrote:

> On Fri, 2012-03-02 at 14:21 +0100, Guennadi Liakhovetski wrote:
> > Hi Vinod
> > 
> > On Wed, 1 Feb 2012, Guennadi Liakhovetski wrote:
> sorry I thought I had replied, but looks like it got missed!
> > 
> > > When performing slame DMA some dmaengine drivers need additional data from
> typo		  ^^^^^^^^^
> > > client drivers to find out, whether they can support that specific client
> > > and to configure the DMA channel for it. This additional data has to be
> > > supplied by client drivers during channel allocation, i.e., with the
> > > __dma_request_channel() function. This patch adds a new
> > > struct dma_slave_desc with some basic data in it, further this struct can
> > > be embedded in hardware-specific types to supply any auxiliary
> > > configuration.
> counter arguing shouldn't the client drivers find out of the channel
> requested is capable or not, that can be alternate approach as well.
> That way people implement this in the filer functions and find if this
> is the channel we need rather than dmac finding out if it can service
> the client or not.

How shall clients find this out? This is system- and DMAC-specific, this 
has nothing to do with the client functionality. The proposed approach is:

* a client driver (MMC, USB, anything else) is capable to use DMA uses the 
standard dmaengine API to transfer the data

* if the platform, where it's running, is supplying any auxiliary data, 
that it has to pass to the DMAC driver, it can do so, without getting 
involved in the details, just passing a pointer

* the most natural location to do this is IMHO when requesting a DMA 
channel

Now, on sh-mobile platforms you can realistically have around 5 DMAC 
instances with 2 or 6 channels each, of which, say, 3 controllers are 
suitable for MMC and 2 are not. How shall the filter function find this 
out? Call some ugly platform callback? Traverse some platform-specific 
lists? Or use a fixed channel, thus significantly reducing flexibility? 
Sorry, none of these options seems very attractive to me.

> Frankly I prefer former model, as that way dmacs will present channel
> capabilities, and clients can use as they deem fit.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

[snip]

> > > @@ -948,7 +954,9 @@ int dma_async_device_register(struct dma_device *device);
> > >  void dma_async_device_unregister(struct dma_device *device);
> > >  void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
> > >  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
> > > -#define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> > > +#define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y, NULL)
> > > +#define dma_request_slave_channel(mask, x, y, id) __dma_request_channel(&(mask), \
> > > +									x, y, id)
> > >  
> > >  /* --- Helper iov-locking functions --- */
> > >  
> So what are we supposed to do with the slave argument. Is the
> expectation that dmacs will parse the parameters in dma_slave_desc and
> based on these return the status of .device_alloc_chan_resources?

Exactly. If the channel, handed in to the DMAC driver by the dmaengine 
core for allocation / configuration is suitable for this slave, actions 
will be performed, otherwise an error will be returned.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
