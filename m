Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581Ab2CFNDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:03:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2CFNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:03:44 -0500
Date: Tue, 6 Mar 2012 14:03:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331035739.24656.201.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203061339330.9300@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange> 
 <Pine.LNX.4.64.1203021341590.913@axis700.grange>  <1331022623.24656.191.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203060935460.9300@axis700.grange> <1331035739.24656.201.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ndEzA8H3NqAhKYv9PdpArJM47YBGuftIV7Rg76CIFsL
 rW8mQtacyBkOkXGkNXx2bYq/1e48Wr/eJiP9gTr2Dy1csJUGyw
 YxmyiGoZGQuFBaU43QP6zOkJnNYrMVSx9zpcEf4JQIDhJYeoky
 narjaXCMjXcKjy4cONrRfrkCYZrtZqojBtEqKiWPDG+lGpvQqk
 hcqEx7Hy+9CAOE5GNwPT8GeuelJAOt+PQlt8n8yHsxVJlR8Igr
 aZAQJ16oVAzDqzwjrKsCyU12B7OpVHcIqZLmb55LzP6CQW8qJZ
 CI+osUTlPwUQpdk6EImjnU/cKR0BRl+VO6C9i/7HiMv0ShKRGh
 oJfi3PdcKPxTJnwIMK726e7hs1SQF4X2OdNEPVJu2aEODdwcVm
 7nOy+uQX270Lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Vinod Koul wrote:

> On Tue, 2012-03-06 at 09:53 +0100, Guennadi Liakhovetski wrote:
> > Hi Vinod
> > 
> > Thanks for your review.
> > 
> > On Tue, 6 Mar 2012, Vinod Koul wrote:
> > 
> > > On Fri, 2012-03-02 at 14:21 +0100, Guennadi Liakhovetski wrote:
> > > > Hi Vinod
> > > > 
> > > > On Wed, 1 Feb 2012, Guennadi Liakhovetski wrote:
> > > sorry I thought I had replied, but looks like it got missed!
> > > > 
> > > > > When performing slame DMA some dmaengine drivers need additional data from
> > > typo		  ^^^^^^^^^
> > > > > client drivers to find out, whether they can support that specific client
> > > > > and to configure the DMA channel for it. This additional data has to be
> > > > > supplied by client drivers during channel allocation, i.e., with the
> > > > > __dma_request_channel() function. This patch adds a new
> > > > > struct dma_slave_desc with some basic data in it, further this struct can
> > > > > be embedded in hardware-specific types to supply any auxiliary
> > > > > configuration.
> > > counter arguing shouldn't the client drivers find out of the channel
> > > requested is capable or not, that can be alternate approach as well.
> > > That way people implement this in the filer functions and find if this
> > > is the channel we need rather than dmac finding out if it can service
> > > the client or not.
> > 
> > How shall clients find this out? This is system- and DMAC-specific, this 
> > has nothing to do with the client functionality. The proposed approach is:
> > 
> > * a client driver (MMC, USB, anything else) is capable to use DMA uses the 
> > standard dmaengine API to transfer the data
> > 
> > * if the platform, where it's running, is supplying any auxiliary data, 
> > that it has to pass to the DMAC driver, it can do so, without getting 
> > involved in the details, just passing a pointer
> > 
> > * the most natural location to do this is IMHO when requesting a DMA 
> > channel
> and in that case why do you need the new parameters to be passed back in
> filter function. What is the role of filter in this case ?

Sorry, who said I needed them? No changes are required to the filter 
function. As for its role - don't know, I didn't design it:-) In my case 
the filter will essentially become a "return true" dummy, respectively, it 
can simply be omitted. In general, I can hardly imagine a situation, 
where, say, an MMC driver would have internal knowledge about DMA channels 
on the system, allowing it to select a suitable one... So, I'm really not 
sure what it is for. Good, that it is at least optional. Maybe it can be 
deprecated with time.

> > Now, on sh-mobile platforms you can realistically have around 5 DMAC 
> > instances with 2 or 6 channels each, of which, say, 3 controllers are 
> > suitable for MMC and 2 are not. How shall the filter function find this 
> > out? Call some ugly platform callback? Traverse some platform-specific 
> > lists? Or use a fixed channel, thus significantly reducing flexibility? 
> > Sorry, none of these options seems very attractive to me.
> well you can counter argue that dmac does not have this information
> either.

But the DMAC is certainly a better match for making channel-selection 
decisions.

> Bigger question is who knows about this mapping and how do we
> incorporate this mapping into channel allocation

The platform does. And this knowledge has to be passed to the relevant 
driver. But I think it's the DMAC driver, that is relevant, not the client 
driver. The platform would supply information like

DMAC #1
	channel #1
		(can be used for) device #1
		device #2
		...
	channel #2
	...
...

And I don't think, it would be reasonable to let every slave driver use 
this information. These lists can also be optimised for specific 
platforms. E.g., on some sh-mobile SoCs you have two DMAC types. One of 
them can serve devices from list A on any channel, the other one - from 
list B. So, all you have to do, is to reference either A or B from your 
DMAC platform data. Whereas doing a reverse mapping: for each (potential) 
DMA user reference a list of channels, that it can use - would be really 
clumsy.

> > > Frankly I prefer former model, as that way dmacs will present channel
> > > capabilities, and clients can use as they deem fit.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
