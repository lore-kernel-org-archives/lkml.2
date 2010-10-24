Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab0JXFMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 01:12:42 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46713 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0JXFMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 01:12:41 -0400
Date: Sun, 24 Oct 2010 06:12:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
cc: Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
In-Reply-To: <4CBFFF3F.2050700@niisi.msk.ru>
Message-ID: <alpine.LFD.2.00.1010240529380.15889@eddie.linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost> <17d8d27a2356640a4359f1a7dcbb3b42@localhost> <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com> <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
 <20101019123441.GJ27377@linux-mips.org> <alpine.LFD.2.00.1010192039550.15889@eddie.linux-mips.org> <4CBEA2D6.6050507@niisi.msk.ru> <alpine.LFD.2.00.1010201750060.15889@eddie.linux-mips.org> <4CBFFF3F.2050700@niisi.msk.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Gleb O. Raiko wrote:

> >   I'm not sure what you mean: whether the processor will snoop the value to
> > read in the store buffer or will it stall until the buffer has drained and
> > issue the load on the external bus?
> I meant the latter.

 OK, I hoped so, but just double-checked to be sure. :)

> > Therefore in the context of one or more pending uncached stores I can
> > assume one of the three for an uncached load:
> > 
> > 1. If the addresses match, then the value loaded is snooped in (retrieved
> >     from) the store buffer, no external cycle on the bus is seen.  This is
> >     what the R2020 WB did.
> > 
> > 2. The load bypasses the stores and therefore reaches the external bus
> >     before the stores.  This is what the R3220 MB did and I believe the
> >     R2020 WB defaulted to in the case of no address match.
> > 
> > 3. The load stalls until the outstanding stores have completed and only
> >     then appears on the external bus.
> > 
> > There's no hurt from using SYNC here and its semantics make it clear it
> > enforces the case #3 above even if not otherwise guaranteed.  Otherwise I
> > think the case #2 would be a reasonable default (i.e. one I'd recommend to
> > a processor designer) as draining the store buffer on any uncached load
> > whether needed or not is a waste of performance.
> There is no such thing like performance in case of uncached loads.
> The case #2 requires:
> 1. sync
> 2. additional operations (usually just a read) to pull data behind input
> buffers on an IO bus.

 When talking to MMIO you often don't need to force the outstanding writes 
to complete before you exit some driver's code.  They will eventually 
reach the device and to their things in due course.

 A notable exception are some kinds of side effects that need to be 
synchronised to prevent races.  For example to avoid wasting processing 
time for handling spurious interrupts you do want to make sure a write 
that acknowledges a pending interrupt has been recorded by the handler 
reaches the respective device's register before the interrupt has been 
cleared in the interrupt controller.

 On the other hand you do not need to issue a writeback of a request for 
the device to look for more data in the outgoing DMA descriptor ring.

> While it's ok to put that in MMIO reads/writes as you've done, it's almost
> impossible to program X server in that way, for example. This beast considers
> a frame buffer as an memory array with strong ordering. That's why I'd vote
> for the case #3. Not because it outperforms #2 in the real life (who cares for
> 0.0001% gain), but because IO devices requires strong ordering.

 Ah, framebuffers.  The DEC Alpha people somehow managed to get them 
right. :)  What you say is of course true for a dumb framebuffer -- but 
who cares about dumb framebuffers these days?

 A half-decent graphics controller will provide a set of typical masked 
raster operations: STORE, AND, OR, XOR, etc. so that you don't have to 
issue RMW cycles to framebuffer's memory -- all you need are bulk writes, 
where the order does not really matter and which can be pipelined (the 
graphics controller may be able to replicate writes too, such as across 
the whole scanline -- good for the bandwidth!).

 You may still have to issue some barriers around accesses to 
framebuffer's control registers, but that's about it.  And the TGA X11 
driver undobtedly gets these things right or otherwise nobody could have 
used it and the adapters it supports with an Alpha (as a side note: that 
graphics chip/software applies to MIPS-based DECstation systems too).  
This is all early 1990s' technology, no rocket science anymore. :)

 There's a technical report on the techniques used somewhere on the web -- 
look for "Smart Frame Buffer" (and don't forget to check its date ;) ).

 In general: don't break the CPU because you've got a broken piece of 
software -- fix the piece instead!

 I stand by my choice -- inefficiency from unnecessary (implicit) ordering 
barriers accumulates.  These operations are so slow (with latencies 
possibly counted in hundreds of CPU cycles) it really matters whether you 
need ten or just one, especially with the speeds of contemporary 
processors.

  Maciej
