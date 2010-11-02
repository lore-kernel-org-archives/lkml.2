Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0KBLIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 07:08:23 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:42799 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab0KBLIS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 07:08:18 -0400
Subject: Re: [PATCH] wrong PERF_COUNT_HW_CACHE_REFERENCES and
 PERF_COUNT_HW_CACHE_MISSES for AMD
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimdp1teeaZkn2h32TQjaWxqegp27TNq+rvQcxAF@mail.gmail.com>
References: <1288620663.2712.84.camel@localhost>
	 <AANLkTimdp1teeaZkn2h32TQjaWxqegp27TNq+rvQcxAF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 12:08:05 +0100
Message-ID: <1288696085.2720.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Am Dienstag, den 02.11.2010, 02:55 +0100 schrieb Stephane Eranian:
> Hi,
> 
> 
> 
> On Mon, Nov 1, 2010 at 3:11 PM, Robert Schöne
> <robert.schoene@tu-dresden.de> wrote:
> >
> > The current arch/x86/kernel/cpu/perf_event_amd.c file lists
> > L1-Instruction-Cache Misses and Accesses as PERF_COUNT_HW_CACHE_MISSES
> > resp. PERF_COUNT_HW_CACHE_REFERENCES.
> >
> I always thought PERF_COUNT_HW_CACHE_* was about data cache misses.
> But given that there is no clear definitions for those events, it
> creates confusion.
>
That's what I thought too before reading the AMD BKDG for Family 10.
It always seemed to me that the "hardware" event type was kind of a
mapping to the Intel "architectural events". And in their definition its
it reads as LLC.
> 
> If you change the meaning of HW_CACHE_MISSES, then seems to me, you need
> to change the mapping in the perf tool, because now it includes both data+code.
>
So does the Intel implementation. It's just LLC misses with no
definition on what was accessed.
> 
> > This fix uses L2C-Misses and Accesses instead. (Real LLC-events would be
> > better, but there are some restrictions for Northbridge Events on AMD).
> >
> And those constraints are handled correctly by the kernel.
> 
> The constraint is such that you cannot have more than 4 instances of
> Northbridge events active at the same time per core. If you do, then one
> of them will starve (if issued from different cores).
>
Yes, we could use event 4E1 (L3 Cache Misses), but we would need
different event IDs for the different AMD Families. Not all of them have
an L3-Cache and even some implementations of Family 10h don't have L3
either.
As this event ID is a definition, we would have to introduce a
"placeholder" definition, which is - whenever a Cache Misses/Accesses
event is initiated - replaced by the "Last Level Cache" event ID for the
processor, which is currently in the system.
>
> 
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -100,8 +100,8 @@ static const u64 amd_perfmon_event_map[] =
> >  {
> >   [PERF_COUNT_HW_CPU_CYCLES]           = 0x0076,
> >   [PERF_COUNT_HW_INSTRUCTIONS]         = 0x00c0,
> > -  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x0080,
> > -  [PERF_COUNT_HW_CACHE_MISSES]         = 0x0081,
> > +  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x037D,
> > +  [PERF_COUNT_HW_CACHE_MISSES]         = 0x037E,
> >   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]  = 0x00c2,
> >   [PERF_COUNT_HW_BRANCH_MISSES]                = 0x00c3,
> >  };
> >


