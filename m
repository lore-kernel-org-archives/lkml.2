Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2BFPGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:06:01 -0500
Received: from mxout1.idt.com ([157.165.5.25]:53000 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab2BFPGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:06:00 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Date: Mon, 6 Feb 2012 07:04:32 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1328529182.26182.92.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Thread-Index: AczkxbAig2wYYjItRm+TZsa+GHCwPQAF8q2w
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>, Russell King <rmk@arm.linux.org.uk>
CC: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q16F69KK020049

On Mon, Feb 06, 2012 at 6:53 AM, Vinod Koul wrote:
> On Fri, 2012-02-03 at 07:31 -0800, Bounine, Alexandre wrote:
> > On Thu, Feb 02, 2012 at 4:44 PM, Russell King wrote:
> > >
> > > On Thu, Feb 02, 2012 at 04:32:11PM -0500, Alexandre Bounine wrote:
> > > > Add context parameter to device_prep_slave_sg() and
> > device_prep_dma_cyclic()
> > > > interfaces to allow passing client/target specific information
> > associated
> > > > with the data transfer.
> > >
> > > I'm slightly concerned about having this as a vague 'void *'
> pointer.
> > > What that means is that the data being passed through it is
> entirely
> > > unspecified, and quite specific to the DMA engine.
> > >
> > > That's rather worrying when we (on ARM) are moving towards a model
> > > where the same peripheral IP can be backed by multiple different
> DMA
> > > engines.  We already have peripheral drivers (clients of DMA
> engine)
> > > which can be attached to completely different DMA engine drivers.
> Russell,
> Agreed but the problem with new models like RIO, MSM is that they seem
> to have some different parameters they depend on, apart from the usual
> ones we have. And these are per transfer dependent rather than channel
> dependent as we have. So we need some way to pass arch specfic
> parameters... so a agenric mechanism this was proposed...
> Agreed, this has its own shortcoming. If you have a better way, please
> let us know :)
> 
> > >
> > > If DMA engines continue to operate conventionally with this
> parameter
> > > NULL then that's fine for current stuff.  I would suggest that it's
> > > made to be something a little better defined though, as the 'void
> *'
> > > approach encourages each driver writer to invent their own way to
> > > specify, eg, an interleaved transfer.  We'll then end up with N
> > > different ways to specify the same thing.
> > >
> > > Not only that, but peripheral drivers won't know what kind of data
> to
> > > pass there (they would have to have additional knowledge of the DMA
> > > engine which they're attached to.)
> > >
> > > Basically, allowing a DMA engine specific blob of data to be passed
> > > destroys the idea of having a consistent API for peripheral drivers
> > > to use, because they can then no longer be independent of their DMA
> > > engine.
> > >
> > I agree with your concern about "void *" being quite wide-open
> > definition.
> > But it may be practically impossible to come up with better
> definition
> > that may be equally suitable for different systems or HW combinations
> > (e.g. definition that is good for ARM peripherals may not fit into
> the
> > RapidIO model).
> >
> > Some level of protection should be expected from filter callbacks
> > invoked
> > by dma_request_channel(). This way, for example, RapidIO client will
> not
> > acquire DMA channel which does not support RapidIO data transfers.
> >
> > After saying all above to defend the changes, I have to admit that
> your
> > comment made me to look harder for an alternative way to pass
> > per-transfer
> > parameter. As a result, I am considering a new idea when per-transfer
> > configuration data will be passed as the first element of the scatter
> > list.
> > Something like a packet header data but it will be used to setup
> > buffer descriptors instead of being part of data stream.
> Alexandre,
> dmac gets physical address, so you would need to remap that again to be
> able to parse these buffers... Sorry I dont like this idea at all.

I was thinking about keeping the original scatterlist for dmac unchanged,
but allocating another scatterlist in rio_dma_prep_slave_sg() and chaining
two lists together. After it passed to device specific function, it parses
first section of the chain for additional transfer parameters and use
following scatterlist as intended for dmac.

But Russell's idea (See https://lkml.org/lkml/2012/2/3/269 ) seems to be
a better way without added complexity and I am ready to take that path and
make new patches if you and Dan agree with it.   

... skip ...

Alex.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
