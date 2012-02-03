Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2BCPdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:33:07 -0500
Received: from mxout1.idt.com ([157.165.5.25]:44617 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2BCPdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:33:05 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Date: Fri, 3 Feb 2012 07:31:32 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20120202214350.GB4432@flint.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Thread-Index: Aczh9hpA+j7LOFJBQg+4Lv00oODF6QAitP0Q
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Russell King <rmk@arm.linux.org.uk>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 4:44 PM, Russell King wrote:
> 
> On Thu, Feb 02, 2012 at 04:32:11PM -0500, Alexandre Bounine wrote:
> > Add context parameter to device_prep_slave_sg() and
device_prep_dma_cyclic()
> > interfaces to allow passing client/target specific information
associated
> > with the data transfer.
> 
> I'm slightly concerned about having this as a vague 'void *' pointer.
> What that means is that the data being passed through it is entirely
> unspecified, and quite specific to the DMA engine.
> 
> That's rather worrying when we (on ARM) are moving towards a model
> where the same peripheral IP can be backed by multiple different DMA
> engines.  We already have peripheral drivers (clients of DMA engine)
> which can be attached to completely different DMA engine drivers.
> 
> If DMA engines continue to operate conventionally with this parameter
> NULL then that's fine for current stuff.  I would suggest that it's
> made to be something a little better defined though, as the 'void *'
> approach encourages each driver writer to invent their own way to
> specify, eg, an interleaved transfer.  We'll then end up with N
> different ways to specify the same thing.
> 
> Not only that, but peripheral drivers won't know what kind of data to
> pass there (they would have to have additional knowledge of the DMA
> engine which they're attached to.)
> 
> Basically, allowing a DMA engine specific blob of data to be passed
> destroys the idea of having a consistent API for peripheral drivers
> to use, because they can then no longer be independent of their DMA
> engine.
> 
I agree with your concern about "void *" being quite wide-open
definition.
But it may be practically impossible to come up with better definition
that may be equally suitable for different systems or HW combinations
(e.g. definition that is good for ARM peripherals may not fit into the
RapidIO model).

Some level of protection should be expected from filter callbacks
invoked
by dma_request_channel(). This way, for example, RapidIO client will not
acquire DMA channel which does not support RapidIO data transfers. 
 
After saying all above to defend the changes, I have to admit that your
comment made me to look harder for an alternative way to pass
per-transfer
parameter. As a result, I am considering a new idea when per-transfer
configuration data will be passed as the first element of the scatter
list.
Something like a packet header data but it will be used to setup
buffer descriptors instead of being part of data stream.

This new approach will preserve existing DMA engine interface and be
easier
for backporting of RapidIO drivers. Yes, there is a system dependency in
scatter
list format but it is completely protected by channel filtering
mechanism.   

Because of that it may be a good idea to consider this set of patches
being "on hold" unless there are other parties interested in proposed
interface changes.
 
AB.

