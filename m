Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2BCSrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab2BCSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:47:18 -0500
Date: Fri, 3 Feb 2012 19:40:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>, stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 2/2 v4] preempt-rt/x86: Delay calling signals in int3
Message-ID: <20120203184016.GA10413@redhat.com>
References: <20120203182853.547078531@goodmis.org> <20120203183041.427463295@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203183041.427463295@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, I guess I need to actually read the patch before asking the
questions... I'll try later, but

On 02/03, Steven Rostedt wrote:
>
> --- linux-rt.git.orig/arch/x86/kernel/entry_64.S
> +++ linux-rt.git/arch/x86/kernel/entry_64.S
> @@ -1391,6 +1391,14 @@ paranoid_userspace:
>  paranoid_schedule:
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_ANY)
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +	GET_THREAD_INFO(%rcx)
> +	movl TI_flags(%rcx),%ebx
> +	testl $_TIF_FORCE_SIG_TRAP,%ebx
> +	jz paranoid_do_schedule
> +	call do_force_sig_trap
> +paranoid_do_schedule:
> +#endif

Stupid question. Do we really need to send the signal from here?

Why force_sig(rt => T) can't set TIF_NOTIFY_RESUME instead? Then
we can change do_notify_resume() to check TIF_FORCE_SIG_TRAP. And
perhaps we can even avoid the new TIF_FORCE_SIG_TRAP, we could
check task->stored_info_set.

In fact I feel this can be simplified even more, but I am not sure.

Oleg.

