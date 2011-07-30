Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1G3NJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 09:09:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1G3NJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 09:09:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110728224038.GD829@flint.arm.linux.org.uk>
References: <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	<CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com>
	<20110727203710.GB5028@flint.arm.linux.org.uk>
	<CAJe_ZhcggEW1wfF8EVy-qgfa194B+-qifongLOvPwVg5O9AcBg@mail.gmail.com>
	<20110728224038.GD829@flint.arm.linux.org.uk>
Date: Sat, 30 Jul 2011 18:39:13 +0530
Message-ID: <CAJe_ZheU2CNsNYqrEZd-9BWw8WFWmEqsGAutJcOXir-PGdyFdQ@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2011 04:10, Russell King <rmk@arm.linux.org.uk> wrote:

>> > Board 3 has the MMCI connected through an external FPGA mux, which can route the
>> > MMCI requests to DMA request signals #1, #2 or #3.
>> Say
>>  Board3
>>      MMCI_RX  -> #{1,2,3}
>>      MMCI_TX  -> #{1,2,3}
>> And you can't change the route(mapping) after the dmac driver has
>> been loaded.
>
> No.  You have to change it dynamically at run time according to the
> DMA activity, because DMA request signals #1, #2 and #3 are shared
> between 6 devices.  To make matters worse, it's not six on any of
> RQ#1 RQ#2 RQ#3, but some on a couple, some on another couple, and
> some on all three.
>
> BTW, we do support this with Linus W's code (which he's posted to
> this thread.)

In case you missed my reply to these runtime switching cases,
please have a look at https://lkml.org/lkml/2011/7/29/211
Assuming you have read that, I write hence ...

A solution to Board-3 would work for Board-1,2 as well.
Rather this is how every dmac driver should be written, imho.

For a dmac driver, allocating a channel should be purely a s/w thing i.e, just
as a way for it to see what features the client needs and inform
immediately if it is impossible. Successful return of channel must not be
taken as a guarantee of any successful transfer by the clients.
Nothing esoteric, but important  to keep in mind nonetheless.

Since Board-3 has fpga-mux routing req-sigs, probably more number
of peripherals could be reached on board-3. Anyways, the dmac driver would
get every reachable h/w channel from board via platform and happily
allot to clients as if every channel is available all the time.

As a design, your dmac driver should lock as less h/w resources as possible
during channel allocation - ideally, zero, and it should be possible when
afterall the dmac-driver can't guarantee success of xfers.

 //Just before starting the xfers.
 if (plat->rs_activate)      // NULL for board-1 and 2
     err = plat->rs_activate(DMACd_RSs)
 else
     err = 0;

......do xfers .....

 //After xfers-done 'irq'
 if (plat->rs_deactivate)       // NULL for board-1 and 2
      plat->rs_deactivate(DMACd_RSs)

Depending upon time taken by rs_activate, you might want to schedule
rs_deactivate after sometime rather than calling it immediately.

This also indicates submitting xfers in batches, a good practice for clients.

All of the above is to prove that -- Runtime switching isn't as big a deal as
is made out to be. It should be done _transparently_ to the Client drivers.
So, shouldn't be a part of the DMAENGINE API.

So basically your setup should work just as fine as any other
statically allocated
req-signals. i.e, from the DMAENGINE API pov.

Thanks
