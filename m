Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0KBBzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:55:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab0KBBzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H5wzRoDewgexd60SY3UPeVlVwYBrOb2ABpAKqbN5T8uC/AtLMlWgRFmb0YyzovLnv6
         R2Yc5E2TV6p4buKdm4HQ==
MIME-Version: 1.0
In-Reply-To: <1288620663.2712.84.camel@localhost>
References: <1288620663.2712.84.camel@localhost>
Date: Tue, 2 Nov 2010 02:55:46 +0100
Message-ID: <AANLkTimdp1teeaZkn2h32TQjaWxqegp27TNq+rvQcxAF@mail.gmail.com>
Subject: Re: [PATCH] wrong PERF_COUNT_HW_CACHE_REFERENCES and
 PERF_COUNT_HW_CACHE_MISSES for AMD
From: Stephane Eranian <eranian@google.com>
To: =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On Mon, Nov 1, 2010 at 3:11 PM, Robert Schöne
<robert.schoene@tu-dresden.de> wrote:
>
> The current arch/x86/kernel/cpu/perf_event_amd.c file lists
> L1-Instruction-Cache Misses and Accesses as PERF_COUNT_HW_CACHE_MISSES
> resp. PERF_COUNT_HW_CACHE_REFERENCES.
>
I always thought PERF_COUNT_HW_CACHE_* was about data cache misses.
But given that there is no clear definitions for those events, it
creates confusion.

If you change the meaning of HW_CACHE_MISSES, then seems to me, you need
to change the mapping in the perf tool, because now it includes both data+code.


> This fix uses L2C-Misses and Accesses instead. (Real LLC-events would be
> better, but there are some restrictions for Northbridge Events on AMD).
>
And those constraints are handled correctly by the kernel.

The constraint is such that you cannot have more than 4 instances of
Northbridge events active at the same time per core. If you do, then one
of them will starve (if issued from different cores).


> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -100,8 +100,8 @@ static const u64 amd_perfmon_event_map[] =
>  {
>   [PERF_COUNT_HW_CPU_CYCLES]           = 0x0076,
>   [PERF_COUNT_HW_INSTRUCTIONS]         = 0x00c0,
> -  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x0080,
> -  [PERF_COUNT_HW_CACHE_MISSES]         = 0x0081,
> +  [PERF_COUNT_HW_CACHE_REFERENCES]     = 0x037D,
> +  [PERF_COUNT_HW_CACHE_MISSES]         = 0x037E,
>   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]  = 0x00c2,
>   [PERF_COUNT_HW_BRANCH_MISSES]                = 0x00c3,
>  };
>
