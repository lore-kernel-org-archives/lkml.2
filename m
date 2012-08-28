Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2H1WLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:11:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56282 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2H1WLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:11:18 -0400
Date: Wed, 29 Aug 2012 00:11:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: use new exception_enter()/exception_exit() API
 in do_device_not_available()
Message-ID: <20120828221111.GC9297@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20120828210047.GA22279@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120828210047.GA22279@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 12:00:47AM +0300, Sergey Senozhatsky wrote:
>  x86: use new exception_enter()/exception_exit() API in do_device_not_available()
> 
>  RCU can be in extended quiescent state when do_device_not_available() called.
> 
> [  676.400274] RCU used illegally from idle CPU!
> [  676.400274] rcu_scheduler_active = 1, debug_locks = 0
> [  676.400278] RCU used illegally from extended quiescent state!
> [  676.400282] 2 locks held by sed/9468:
> [  676.400285]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff814c67cf>] __schedule+0x1c0/0x992
> [  676.400304]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8106a880>] cpuacct_charge+0x27/0x1e0
> [  676.400321] 
> [  676.400329] Call Trace:
> [  676.400340]  [<ffffffff8108933a>] lockdep_rcu_suspicious+0x109/0x112
> [  676.400347]  [<ffffffff8106a8f7>] cpuacct_charge+0x9e/0x1e0
> [  676.400353]  [<ffffffff8106a880>] ? cpuacct_charge+0x27/0x1e0
> [  676.400359]  [<ffffffff814c67cf>] ? __schedule+0x1c0/0x992
> [  676.400366]  [<ffffffff8106d525>] update_curr+0x159/0x200
> [  676.400375]  [<ffffffff8100a04f>] ? init_fpu+0x4e/0x8f
> [  676.400382]  [<ffffffff8106e0da>] put_prev_task_fair+0x2a/0xac
> [  676.400388]  [<ffffffff814c69a7>] __schedule+0x398/0x992
> [  676.400397]  [<ffffffff810b4f0a>] ? rcu_irq_exit+0x83/0x99
> [  676.400404]  [<ffffffff814c8bf0>] ? retint_restore_args+0x13/0x13
> [  676.400411]  [<ffffffff810889e9>] ? lock_is_held+0x2d/0xa5
> [  676.400414]  [<ffffffff8100a04f>] ? init_fpu+0x4e/0x8f
> [  676.400417]  [<ffffffff81065d0a>] __cond_resched+0x28/0x34
> [  676.400420]  [<ffffffff814c701a>] _cond_resched+0x2e/0x35
> [  676.400425]  [<ffffffff8111cad4>] kmem_cache_alloc+0x4c/0x1c5
> [  676.400430]  [<ffffffff810021ff>] ? math_state_restore+0x1f/0xdc
> [  676.400433]  [<ffffffff8100a04f>] init_fpu+0x4e/0x8f
> [  676.400437]  [<ffffffff8100220e>] math_state_restore+0x2e/0xdc
> [  676.400440]  [<ffffffff814c982e>] do_device_not_available+0xe/0x10
> [  676.400445]  [<ffffffff814d161b>] device_not_available+0x1b/0x20
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  arch/x86/kernel/traps.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index ab82cbd..dff3e72 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -654,7 +654,9 @@ do_device_not_available(struct pt_regs *regs, long error_code)
>  		return;
>  	}
>  #endif
> +	exception_enter(regs);
>  	math_state_restore(); /* interrupts still off */
> +	exception_enter(regs);

Shouldn't that be exception_exit actually?

-- 
Regards/Gruss,
    Boris.
