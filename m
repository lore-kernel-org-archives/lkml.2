Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1JYP6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab1JYP6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:58:38 -0400
Date: Tue, 25 Oct 2011 17:52:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH x86 2/2] Cleanup do_int3
Message-ID: <20111025155259.GB17067@redhat.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com> <20111025142159.GB21225@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025142159.GB21225@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Srikar Dronamraju wrote:
>
> Since there is a possibility of !KPROBES int3 listeners and since
> DIE_TRAP is currently not being used by anybody, notify all listeners
> with DIE_INT3.

Obviously I can't ack this change, but it looks like the bugfix to me.

The current code uses DIE_INT3 or DIE_TRAP depending on CONFIG_KPROBES,
this can't be right.

> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/traps.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 6913369..c9a4be5 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -461,15 +461,10 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  			== NOTIFY_STOP)
>  		return;
>  #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
> -#ifdef CONFIG_KPROBES
> +
>  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
>  			== NOTIFY_STOP)
>  		return;
> -#else
> -	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
> -			== NOTIFY_STOP)
> -		return;
> -#endif
>  
>  	preempt_conditional_sti(regs);
>  	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> 

