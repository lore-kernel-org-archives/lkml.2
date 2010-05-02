Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0EBIT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 04:19:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0EBIT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 04:19:26 -0400
Date: Sun, 2 May 2010 09:18:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Message-ID: <20100502081844.GA7061@n2100.arm.linux.org.uk>
References: <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local> <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com> <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com> <20100422110025.GC20008@n2100.arm.linux.org.uk> <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com> <20100501224429.GA17693@n2100.arm.linux.org.uk> <x2u63386a3d1005011604kaee33364l880e90a4e2453e0f@mail.gmail.com> <20100501232823.GB17693@n2100.arm.linux.org.uk> <r2u63386a3d1005011721v66d04172nc0e5163115006267@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2u63386a3d1005011721v66d04172nc0e5163115006267@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 02:21:13AM +0200, Linus Walleij wrote:
> Yep, that's where it kicks in. (What's the name of this DMA controller
> BTW? Is that PL080?)

It's one of the standard ARM primecells, with a FPGA controlling the
routing of the first three channels.

> (I read it as MMCI is bidirectional also on the Versatile, as it is
> on the U300.)

There are two MMCIs on Versatile.

> However: this way of using the DMA dynamically instead of statically
> leads to the situation where a UART or two MMCs are using up the
> DMA channels and AACI cannot use it, and need to fall back to
> interrupts. Since the Audio traffic is likely to be more important, this
> is perhaps not so optimal, so a static assignment of DMA channels
> may be desired after all in a practical scenario.

Such a scenario leads to two of the three channels assigned to AACI
(one for playback and the other for record - remember, it's full duplex),
leaving one to be shared between the UART Tx and Rx, and two MMCIs.

I'd disagree with you and say that MMCI would be more important than
AACI.  The data rate for MMCI is far higher than AACI - and remember
ARM MMCIs overflow if you don't read the data fast enough.  The MMCI
fmax parameter only exists to put a cap on the rate of the transfer
so that the CPU can read the data fast enough in PIO mode.

However, you only need DMA for MMCI if there's a card inserted in the
slot.  If there's no card in the slot, there's no point starving AACI
of a DMA channel if that's what is being used.
