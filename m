Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab0EBAVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 20:21:16 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40112 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0EBAVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 20:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B9dozsBRM2sm1I412t22+ssh4S81VYBmUwggf9DAhY61M0jtme7+0n69cx+SreZNWe
         DTcnzowqv5jOppWJn/dCa0rvN/fDMeG1WaVq+ZsNvAQfpS+My6XEDlmJNUkkdWjsIt7Y
         EZS2CzgtNyZ+TgQF7JvG+5TuJg96B9mBhuv20=
MIME-Version: 1.0
In-Reply-To: <20100501232823.GB17693@n2100.arm.linux.org.uk>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
	 <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
	 <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
	 <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com>
	 <20100422110025.GC20008@n2100.arm.linux.org.uk>
	 <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com>
	 <20100501224429.GA17693@n2100.arm.linux.org.uk>
	 <x2u63386a3d1005011604kaee33364l880e90a4e2453e0f@mail.gmail.com>
	 <20100501232823.GB17693@n2100.arm.linux.org.uk>
Date: Sun, 2 May 2010 02:21:13 +0200
Message-ID: <r2u63386a3d1005011721v66d04172nc0e5163115006267@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/2 Russell King - ARM Linux <linux@arm.linux.org.uk>:

>> But the implementation of the DMA engine would be better of
>> handling the muxing dynamically I believe, so when the PL011
>> driver (say) requests a DMA channel, it doesn't mean it requests the
>> *physical* channel and holds it (unless the driver is very naďvely
>> implemented) it nominally means it reserves a placeholder in the
>> DMA engine.
>
> So what happens if we try to use DMA with the PL011 but the physical
> channels are already in use?  From what I can see, it assumes that it
> always has access to the transmit channel, and there's no recovery if
> it doesn't.
>
> Plus if we can't get DMA for the RX path, it _permanently_ disables
> all DMA for the device.

OK now I get it.. the point of crux is that you need the drivers to be
coded to switch seamlessly back to interrupt mode and retry with
DMA on next transaction nevertheless if possible.

That is definately possible with the current API, so it's nothing blocking
the stuff pending in Dan's tree.

However when it comes to the PL011/PL180 drivers you got me there,
it surely does assume you either have the channel and can use it
or else there is some permanent error on it.

I'll twist these patches around a bit, it shouldn't be too hard to come up
with some convincing code.

> Three physical channels shared between: AACI Tx, AACI Rx, MMCI 0, MMCI 1,
> UART3 Tx, UART3 Rx.
> (...)
> All you need is to load both the AACI
> and MMCI drivers, and if they want to use the DMA channels, you're
> already wanting 4 channels with only 3 available.

Yep, that's where it kicks in. (What's the name of this DMA controller
BTW? Is that PL080?)

(I read it as MMCI is bidirectional also on the Versatile, as it is
on the U300.)

However: this way of using the DMA dynamically instead of statically
leads to the situation where a UART or two MMCs are using up the
DMA channels and AACI cannot use it, and need to fall back to
interrupts. Since the Audio traffic is likely to be more important, this
is perhaps not so optimal, so a static assignment of DMA channels
may be desired after all in a practical scenario.

But I'll surely make a try to make all DMA allocation from the
PrimeCells dynamic!

Yours,
Linus Walleij
