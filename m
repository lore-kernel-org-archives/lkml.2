Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432Ab1LPI5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:57:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811Ab1LPI4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:56:55 -0500
Date: Fri, 16 Dec 2011 09:54:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-ID: <20111216085459.GD4170@elte.hu>
References: <20111216081915.GA28288@elte.hu>
 <20111216004843.dbd0405b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216004843.dbd0405b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 16 Dec 2011 09:19:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > This patch turns on -momit-leaf-frame-pointer on x86 builds and 
> > thus shrinks .text noticeably. On a defconfig-ish kernel:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >    9843902	1935808	3649536	15429246	 eb6e7e	vmlinux.before
> >    9813764	1935792	3649536	15399092	 eaf8b4	vmlinux.after
> > 
> > That's 0.3% off text size.
> > 
> > The actual win is larger than this percentage suggests: many 
> > small, hot helper functions such as find_next_bit(), 
> > do_raw_spin_lock() or most of the list_*() functions are leaf 
> > functions and are now shorter by 2 instructions.
> > 
> > Probably a good chunk of the framepointers related runtime 
> > overhead on common workloads is eliminated via this patch, as 
> > small leaf functions execute more often than larger parent 
> > functions.
> > 
> > The call-chains are still intact for quality backtraces and for 
> > call-chain profiling (perf record -g), as the backtrace walker 
> > can deduct the full backtrace from the RIP of a leaf function 
> > and the parent chain.
> 
> The only problem I can think of (apart from tickling gcc bugs) is that
> it might break __builtin_return_address(n) for n>0 with frame pointers
> enabled?  The only code I can find which does this is
> drivers/isdn/hardware/mISDN/ and ftrace.

Well, AFAICS it won't really 'break' it but behave as if the 
leaf function got inlined into the parent function. I think we 
can live with that.

Thanks,

	Ingo
