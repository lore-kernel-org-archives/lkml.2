Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2BTAxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:53:39 -0500
Received: from ozlabs.org ([203.10.76.45]:40939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2BTAxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:53:38 -0500
From: Michael Neuling <mikey@neuling.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, anton@samba.org
Subject: Re: [PATCH 0/2] More i387 state save/restore work
In-reply-to: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Sun, 19 Feb 2012 14:23:05 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Mon, 20 Feb 2012 11:53:36 +1100
Message-ID: <12996.1329699216@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

> Ok, this is a series of two patches that continue my i387 state 
> save/restore series, but aren't necessarily worth it for Linux-3.3.

We have similar lazy save/restore code on powerpc here:

  http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-December/087422.html
  
With your test, it looks like you're getting about a 10% performance
boost.  For VSX registers on powerpc we got about 8% with a similar
micro-benchmark.  We were a little disappointed it took such a
tailored/synthetic micro-benchmark to get such modest performance
improvements.

> That said, the first one is a bug-fix - but it's an old bug, and I'm not 
> sure it can actually be triggered. The failure path for the FP state 
> preload is bogus - and always was. But I'm not sure it really *can* fail.
> 
> The first one has another small bugfix in it too, and I think that one may 
> be new to the rewritten FP state preloading - it doesn't update the 
> fpu_counter, so once it starts preloading, it never stops.
> 
> I wrote a silly FPU task switch testing program, which basically starts 
> two processes pinned to the same CPU, and then uses sched_yield() in both 
> to switch back-and-forth between them. *One* of the processes uses the FPU 
> between every yield, the other does not. It runs for two seconds, and 
> counts how many loops it gets through.

> With that test, I get:
> 
>  - Plain 3.3-rc4:
> 
>    [torvalds@i5 ~]$ uname -r
>    3.3.0-rc4
>    [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
>    2216090 loops in 2 seconds
>    2216922 loops in 2 seconds
>    2217148 loops in 2 seconds
>    2232191 loops in 2 seconds
>    2186203 loops in 2 seconds
>    2231614 loops in 2 seconds
> 
>  - With the first patch that fixes the FPU preloading to eventually stop:
> 
>    [torvalds@i5 ~]$ uname -r
>    3.3.0-rc4-00001-g704ed737bd3c
>    [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
>    2306667 loops in 2 seconds
>    2295760 loops in 2 seconds
>    2295494 loops in 2 seconds
>    2296282 loops in 2 seconds
>    2282229 loops in 2 seconds
>    2301842 loops in 2 seconds
> 
>  - With the second patch that does the lazy preloading
> 
>    [torvalds@i5 ~]$ uname -r
>    3.3.0-rc4-00002-g022899d937f9
>    [torvalds@i5 ~]$ ./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;./a.out ;
>    2466973 loops in 2 seconds
>    2456168 loops in 2 seconds
>    2449863 loops in 2 seconds
>    2461588 loops in 2 seconds
>    2478256 loops in 2 seconds
>    2476844 loops in 2 seconds

Does "2476844 loops in 2 seconds" imply 2476844 context switches in 2
sec?  With Anton's context_switch [1] benchmark, we don't even hit 100K
context switches per sec.

Do you have this test program anywhere?

Mikey

1. http://ozlabs.org/~anton/junkcode/context_switch.c

> so these things do make some difference. But it is also interesting to see 
> from profiles just how expensive setting CR0.TS is (the write to CR0 is 
> very expensive indeed), so even when you avoid the FP state restore 
> lazily, just setting TS in between task switches is still a big cost of 
> FPU save/restore.
>
> 
> Linus Torvalds (2):
>   i387: use 'restore_fpu_checking()' directly in task switching code
>   i387: support lazy restore of FPU state
> 
>  arch/x86/include/asm/i387.h      |   48 +++++++++++++++++++++++++++---------
-
>  arch/x86/include/asm/processor.h |    3 +-
>  arch/x86/kernel/cpu/common.c     |    2 +
>  arch/x86/kernel/process_32.c     |    2 +-
>  arch/x86/kernel/process_64.c     |    2 +-
>  arch/x86/kernel/traps.c          |   40 ++++++-------------------------
>  6 files changed, 49 insertions(+), 48 deletions(-)
> 
> Comments? I feel confident enough about these that I thin kthey might even 
> work in 3.3, especially the first one. But I want people to look at 
> them.
> 
>                      Linus
> 
> -- 
> 1.7.9.188.g12766.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
