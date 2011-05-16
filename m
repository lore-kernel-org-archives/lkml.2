Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1EPUWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:22:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:5573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1EPUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:22:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,221,1304319600"; 
   d="scan'208";a="437061092"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
References: <cover.1305560561.git.luto@mit.edu>
	<20110516160943.GC25898@one.firstfloor.org>
	<alpine.LFD.2.02.1105161817120.3078@ionos>
	<20110516164939.GD25898@one.firstfloor.org>
	<BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
Date: Mon, 16 May 2011 13:22:04 -0700
In-Reply-To: <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> (Andrew
	Lutomirski's message of "Mon, 16 May 2011 13:05:12 -0400")
Message-ID: <m2fwoeo0pf.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski <luto@mit.edu> writes:

> On Mon, May 16, 2011 at 12:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> And unless you or someone else changes the primitive state of the
>>> kernel, framepointers are going to stay simply because removing them
>>> breaks profiling backtraces when the hit is inside vread().
>>
>> This doesn't work anyways because the glibc stub code calling vgettimeofday
>> normally doesn't set up a frame pointer frame.
>>
>> The only way to unwind there is dwarf2.
>
> For code in the vsyscall page, I think using CFI data is a lost cause.
>  How is any user code supposed to find the CFI data?

It only works for the vDSO. vsyscall is legacy.

> For the vDSO, we could be nice to userspace and install the debugging
> symbols somewhere sensible.  Currently we generate a buildid but we
> don't install the symbols anywhere by default.

Actually we include the dwarf2 tables and signal unwinding works
(for the vDSO)

> Longer term, it would be nice to mark the vsyscall page NX.  That
> involves a few things:

Why NX? What would make sense is to call the VDSO from it.
The problem is that the vDSO is randomized and there's no good memory
location to store the pointer to it.

The real reason for all this dance is to have some less non randomized
code around. What I implemented back then was instead code to patch out
the SYSCALL in there if not needed to lower the attack surface (not sure
if that still works though, but that was the idea). For most cases
(TSC/HPET read) it's not needed.

Checking: someone removed the code meanwhile.

> And we won't have a
> syscall instruction sitting at a predictable address.

The easy way to fix this is to just re-add the patching.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
