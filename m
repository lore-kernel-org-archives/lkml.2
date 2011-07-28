Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1G1Wk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:40:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51451 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1G1Wkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:40:55 -0400
Date: Thu, 28 Jul 2011 23:40:38 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110728224038.GD829@flint.arm.linux.org.uk>
References: <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com> <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com> <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com> <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com> <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com> <20110727203710.GB5028@flint.arm.linux.org.uk> <CAJe_ZhcggEW1wfF8EVy-qgfa194B+-qifongLOvPwVg5O9AcBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJe_ZhcggEW1wfF8EVy-qgfa194B+-qifongLOvPwVg5O9AcBg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:24:12PM +0530, Jaswinder Singh wrote:
> On 28 July 2011 02:07, Russell King <rmk@arm.linux.org.uk> wrote:
> >
> >> On a serious note, my proposal, and the reply, shows the possibility
> >> of having :-
> >> a) Client drivers that are truly platform agnostic -- no platform_data
> >> poking for
> >>       channel selection
> >
> > I really doubt that's even possible.  Take this setup:
> 
> I don't want to suggest anything wrong just because I didn't understand
> your h/w.
> I hope you will be kind enough to help me better understand your setup,
> so that I have a fair chance to present my proposal.
> 
> A simple 'yes' or a 'no'(with clarification) is all I ask.
> 
> >
> > MMCI ---> DMAC
> >
> > where the DMAC has 32 request signals, and 8 channels.
> The DMAC is similar to PL330.

That coincidence is merely that.

> Only max 8 request-signals can be active at any time.
> Is my understanding right ?

Correct.

> > The MMCI is connected to two of them.
> I don't know anything about MMCI.
> So I assume it is just another third party MMC controller.
> It simply needs 2 dma channels(for RX, TX each) - be it from a DMAC
> that has a programmable RequestSignal->Peripheral map or a fixed map.
> Is my understanding right ?

Correct.

> > The DMAC can supply any of its physical channels for MMCI.
> The RequestSignal->Peripheral map is decided during board design
> and can not be changed later.
> Is my understanding right ?

No.  See the board#3 case..

> > Board 1 has the MMCI connected to request signals #1 and #3.
> > Board 2 has the MMCI connected to request signals #8 and #22.
> Say,
>  Board1
>      MMCI_RX  -> #1
>      MMCI_TX  -> #3
> 
>  Board2
>      MMCI_RX  -> #8
>      MMCI_TX  -> #22
> 
> > Board 3 has the MMCI connected through an external FPGA mux, which can route the
> > MMCI requests to DMA request signals #1, #2 or #3.
> Say
>  Board3
>      MMCI_RX  -> #{1,2,3}
>      MMCI_TX  -> #{1,2,3}
> And you can't change the route(mapping) after the dmac driver has
> been loaded.

No.  You have to change it dynamically at run time according to the
DMA activity, because DMA request signals #1, #2 and #3 are shared
between 6 devices.  To make matters worse, it's not six on any of
RQ#1 RQ#2 RQ#3, but some on a couple, some on another couple, and
some on all three.

BTW, we do support this with Linus W's code (which he's posted to
this thread.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
