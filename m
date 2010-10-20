Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0JTR0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:26:18 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47695 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0JTR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:26:17 -0400
Date: Wed, 20 Oct 2010 18:26:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
cc: Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
In-Reply-To: <4CBEA2D6.6050507@niisi.msk.ru>
Message-ID: <alpine.LFD.2.00.1010201750060.15889@eddie.linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost> <17d8d27a2356640a4359f1a7dcbb3b42@localhost> <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com> <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
 <20101019123441.GJ27377@linux-mips.org> <alpine.LFD.2.00.1010192039550.15889@eddie.linux-mips.org> <4CBEA2D6.6050507@niisi.msk.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010, Gleb O. Raiko wrote:

> >   That said, R4k DECstations seem to perform aggressive write buffering in
> > the chipset and to make sure a write has propagated to an MMIO register a
> > SYNC and an uncached read operation are necessary.
> 
> Just uncached read may be enough. R4k shall pull data from its store buffer on
> uncached read.

 I'm not sure what you mean: whether the processor will snoop the value to 
read in the store buffer or will it stall until the buffer has drained and 
issue the load on the external bus?

 I can't see the behaviour of uncached loads wrt uncached stores clearly 
documented anywhere for the R4400 processor (DEC used the SC variation, 
BTW).  There's no mention of uncached loads to have SYNC properties.  
Therefore in the context of one or more pending uncached stores I can 
assume one of the three for an uncached load:

1. If the addresses match, then the value loaded is snooped in (retrieved 
   from) the store buffer, no external cycle on the bus is seen.  This is 
   what the R2020 WB did.

2. The load bypasses the stores and therefore reaches the external bus 
   before the stores.  This is what the R3220 MB did and I believe the 
   R2020 WB defaulted to in the case of no address match.

3. The load stalls until the outstanding stores have completed and only 
   then appears on the external bus.

There's no hurt from using SYNC here and its semantics make it clear it 
enforces the case #3 above even if not otherwise guaranteed.  Otherwise I 
think the case #2 would be a reasonable default (i.e. one I'd recommend to 
a processor designer) as draining the store buffer on any uncached load 
whether needed or not is a waste of performance.

> >   I haven't investigated DMA dependencies and I think we currently only
> > have one TURBOchannel device/driver only (that is the DEFTA/defxx FDDI
> > thingy) making use of the generic DMA API on DECstations.  It seemed to
> > work correctly the last time I tried; presumably either because the API
> > Does The Right Thing, or by pure luck and right timings.
> 
> dfx_writel issues sync after store. BTW, it seems no uncached read issued here
> (just mb() is used, which seems to do sync only), so either those uncached
> read is not needed (unlikely) or data from dfx_writel wait somewhere in the
> chipset for being pulled by subsequent reads or writes.

 Ah, I could have added it myself ;) -- oddly enough even though the 
driver originated from DEC, they only used/tested it with x86 systems 
apparently, rather than the obvious choice of the Alpha that implemented a 
much, much weaker ordering model that any MIPS chip ever did.

  Maciej
