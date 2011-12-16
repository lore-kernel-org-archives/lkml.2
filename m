Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab1LPIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:46:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1LPIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:46:17 -0500
Date: Fri, 16 Dec 2011 00:48:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-Id: <20111216004843.dbd0405b.akpm@linux-foundation.org>
In-Reply-To: <20111216081915.GA28288@elte.hu>
References: <20111216081915.GA28288@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 09:19:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> This patch turns on -momit-leaf-frame-pointer on x86 builds and 
> thus shrinks .text noticeably. On a defconfig-ish kernel:
> 
>    text	   data	    bss	    dec	    hex	filename
>    9843902	1935808	3649536	15429246	 eb6e7e	vmlinux.before
>    9813764	1935792	3649536	15399092	 eaf8b4	vmlinux.after
> 
> That's 0.3% off text size.
> 
> The actual win is larger than this percentage suggests: many 
> small, hot helper functions such as find_next_bit(), 
> do_raw_spin_lock() or most of the list_*() functions are leaf 
> functions and are now shorter by 2 instructions.
> 
> Probably a good chunk of the framepointers related runtime 
> overhead on common workloads is eliminated via this patch, as 
> small leaf functions execute more often than larger parent 
> functions.
> 
> The call-chains are still intact for quality backtraces and for 
> call-chain profiling (perf record -g), as the backtrace walker 
> can deduct the full backtrace from the RIP of a leaf function 
> and the parent chain.

The only problem I can think of (apart from tickling gcc bugs) is that
it might break __builtin_return_address(n) for n>0 with frame pointers
enabled?  The only code I can find which does this is
drivers/isdn/hardware/mISDN/ and ftrace.
