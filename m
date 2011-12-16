Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab1LPOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:06:50 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45546 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab1LPOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:06:43 -0500
Date: Fri, 16 Dec 2011 15:06:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-ID: <20111216140635.GB22873@somewhere.redhat.com>
References: <20111216081915.GA28288@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216081915.GA28288@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:19:16AM +0100, Ingo Molnar wrote:
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

In the case of linked stacks (like frame pointer linking interrupt
to exception stack) we may also miss a leaf function (and not its parent).

Now perhaps we can live with all that, I don't know.

> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Makefile |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux/arch/x86/Makefile
> ===================================================================
> --- linux.orig/arch/x86/Makefile
> +++ linux/arch/x86/Makefile
> @@ -72,6 +72,14 @@ else
>          KBUILD_CFLAGS += -maccumulate-outgoing-args
>  endif
>  
> +#
> +# This shrinks many small functions, we don't actually
> +# need their frame pointer, in backtraces the RIP will
> +# identify the function and the stack frame walker will
> +# find the parent function:
> +#
> +KBUILD_CFLAGS += $(call cc-option,-momit-leaf-frame-pointer)
> +
>  ifdef CONFIG_CC_STACKPROTECTOR
>  	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
>          ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
