Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1G1Koj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:44:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62012 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1G1Kof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110727202859.GA5028@flint.arm.linux.org.uk>
References: <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	<CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
	<CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
	<20110727202859.GA5028@flint.arm.linux.org.uk>
Date: Thu, 28 Jul 2011 16:14:34 +0530
Message-ID: <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2011 01:58, Russell King <rmk@arm.linux.org.uk> wrote:
> On Wed, Jul 27, 2011 at 10:44:53PM +0530, Jaswinder Singh wrote:
>> 1) What I propose
>>        http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059212.html
>>
>> 2) Why RMK thinks I am the biggest idiot on earth
>>        http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059217.html
>>
>> 3) How I ask for better proof of that
>>       http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059223.html

> How do you deal with a peripheral being linked to a _specific_ DMA
> engine on a _specific_ DMA request signal?  What if your system has
> two DMA engines, each with 32 request signals?  Are you going to have
> something like a 128-bit capability mask?

I am afraid, you don't get the idea.

Let's consider even more 'complicated' and general case:-

The SoC/platform has 5 DMACs with 64request-signals(channels) each.
Say, only 16 of these 64request signals can be active at a time,
i.e, dmac has 16 internal work-horse threads(doesn't really matter to the API)
The platform is very flexible and it is possible for an implementation
(the board) to route _any_ request signal on _any_ dmac to _any_ peripheral.

Say, the board 'PITA', decides to use
   DMAC0_Chan8  and DMAC1_Chan31   for  MMC2_RX
   DMAC4_Chan57 and DMAC3__Chan8   for  MMC2_TX

That is, each of MMC2 RX and TX are connected to 2 request-signals.
Duplex channels don't make much difference to the scheme.

Obviously, a platform with such a flexible dmac need the board to
provide the channel map. And the dmac driver ought to be written
accordingly i.e, platform-independent, well always.

So the board, arch/arm/mach-abc/board-pita.c, will provide the
RequestSignal-Peripheral map to the platform arch/arm/mach-abc/dma.c
in platform specific format.
Or via DT when we have it.

The platform must then pass on the RequestSignal-Peripheral map to the
dmac driver via platform_data in the format the platform-independent
dmac driver expects.

At this point the dmac has been 'stripped-off' of its channel-mapping
flexibility.
The dmac driver now has fixed(board specific) RequestSignal-Peripheral
map via platfrom_data.

{
So far, I haven't assumed the capability of a DMAC to switch, say,
the RequestSignal_7 from MMC to UART at _runtime_
If you think such dmacs and platforms exist, please let me know.
I will update the proposal.
}

In the probe, the DMAC driver will populate the tag/capability-list
of the dma_chan corresponding to each RequestSignal. Remember
the dmac driver already got it from platform.

{
Tag / Capability-List
***********************
So far the practical capabilities(rather limitations) that I assumed, could
be expressed in 32 bits. If need be we can either increase the size or use
some common data structure, say struct dma_chan_cap, to express capabilities.
This 'tag' could be a pointer to a data-structure or simply a u32 or whatever.
 *** That is implementation detail ***
Please get over the impression that I insist on using chan_id for the purpose.
I do not.
}

For ex, for 'PITA' board, the dmac driver (via info directly gotten
from platform) will announce
  cap_rs8  := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC0
  cap_rs31 := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC1
  cap_rs8  := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC3
  cap_rs57 := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC4

Btw, I have also defined an 'identity/priority' 7bits field - which will
be a part of channel's 'capability' and used by DMAENGINE API to tell
  {DMAC0_Chan8 from DMAC1_Chan31} and {DMAC4_Chan57 from DMAC3__Chan8}

Ideally, in cases like 'PITA', the capabilities(including priority) of a
channel should come from the board --> platform --> dmac driver.
Otherwise, just platform --> dmac driver


CLIENTS
***********
Any client driver already knows the Device(MMC, USB, SPI etc) and
its instance(via platform_id) it is working for.
It also knows what type(burst size/len, simplex, duplex etc) of
transfers is it gonna need.
The client conveys these(and other) requirements to the DMAENGINE API
using a global platform-independent format(say struct dma_chan_capreq).


DMAENGINE API
**********************
All the complexity should lie here.
The client would have already specified enough requirements that
in most cases only one of all free channels would meet them.
And if there are 'n' more channels that could do the job -- the
one with least value in 'identity/priority' field(gotten from platform),
will be assigned and marked busy.


For easy reference, I copy-paste again the capabilities/limitatons
that I have taken care of :-
Assuming
************
a) There are no more than 256 types of DMA'able devices
   (MMC, USB, SPI etc) --  [8bits]

b) A type of device never has more than 16 instances in a platform
   (MMC-0, MMC-1, MMC-2 etc) --  [4bits]

c) Mem->Mem, Mem->Dev, Dev->Mem, Dev->Dev capability in [4bits]

d) Max_Burst_Len for any channel is less than 64KB, in power of two [4bits]
   Support programmable Max_Burst_Len(tunable in geometric steps of 2)  [1bit]

e) Max_RW_width/fifo_width is less than 128, in power of two -- [3bits]
   Support programmable Max_RW_Width(tunable in geometric steps of 2)  [1bit]

f) Finally, No platform has more than 128 channels with identicial
   capabilities - identity/priority [7bits]

Thanks

PS: I am not replying to other comments, because I think this detailed
explanation
would either change your opinion or help you deliver the fatal blow to
my proposal.
I just want to contain the discussion. If you think I must solve the
equation for a
particular set of parameters you have, I'll be happy to.
