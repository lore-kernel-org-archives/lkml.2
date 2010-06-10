Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab0FJP5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:57:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53975 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0FJP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:57:01 -0400
Subject: Re: [ANNOUNCE] 2.6.33.5-rt23
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.LFD.2.00.1006100800330.2933@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
	 <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
	 <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
	 <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
	 <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
	 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
	 <1276119074.15867.311.camel@lexx>
	 <alpine.LFD.2.00.1006100800330.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 10 Jun 2010 10:56:46 -0500
Message-ID: <1276185406.15867.390.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 08:07 +0200, Thomas Gleixner wrote:
> On Wed, 9 Jun 2010, Will Schmidt wrote:
> 
> > On Wed, 2010-06-09 at 18:44 +0200, Thomas Gleixner wrote:
> > I'm still on 2.6.33.5-rt22 on powerpc, and have run into a couple
> > "sleeping function called from invalid context..." BUGs.   The first was
> > during system boot, second during a 'make'.
> > 
> > relevant code paths don't seem to have changed between -rt22 and -rt23,
> > so I think still valid.. :-)  
> > 
> > This is on a POWER7 system, which may have opened up some timing
> > windows, wrt previous runs on POWER6 systems.
> > 
> > 
> > BUG: sleeping function called from invalid context at
> > kernel/rtmutex.c:684
> 
> > [c000000078cf2cf0] [c000000000131a04] .irq_to_desc_alloc_node+0xdc/0x2b8
> 
> Grr. I thought I had the SPARSE_IRQ stuff disabled on -rt, but seems
> it came back somehow. Can you disable that, or does you machine depend
> on it ?

I'm not sure whether it is required by the architecture.  I do see that
SPARSE_IRQ is disabled in arch/x86/Kconfig with a !PREEMPT_RT, but I
don't see an equivalent 'disable' in arch/powerpc/Kconfig.  


> > BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
> > pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 4760, name: make
> > Call Trace:
> > [c0000000792978b0] [c000000000015550] .show_stack+0xd8/0x218 (unreliable)
> > [c000000079297990] [c0000000006a99c8] .dump_stack+0x28/0x3c
> > [c000000079297a10] [c00000000006cea8] .__might_sleep+0x134/0x15c
> > [c000000079297ab0] [c0000000006a2f78] .rt_spin_lock+0x4c/0x9c
> > [c000000079297b40] [c0000000000a1ff0] .get_signal_to_deliver+0xcc/0x4ec
> > [c000000079297c50] [c000000000018604] .do_signal_pending.clone.0+0x6c/0x2e0
> > [c000000079297d90] [c0000000000188b0] .do_signal+0x38/0x74
> > [c000000079297e30] [c000000000008b40] user_work+0x24/0x28
> 
> Does the patch below fix it ?

Probably.. :-)   I'm running with the patch now, and no repeats of that
BUG yet.   

Thanks, 
-Will


> 
> Thanks,
> 
> 	tglx
> -----
> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> index 00b5078..fa580f9 100644
> --- a/arch/powerpc/kernel/signal.c
> +++ b/arch/powerpc/kernel/signal.c
> @@ -120,6 +120,14 @@ static int do_signal_pending(sigset_t *oldset, struct pt_regs *regs)
>  	int ret;
>  	int is32 = is_32bit_task();
> 
> +#ifdef CONFIG_PREEMPT_RT
> +	/*
> +	 * Fully-preemptible kernel does not need interrupts disabled:
> +	 */
> +	local_irq_enable();
> +	preempt_check_resched();
> +#endif
> +
>  	if (current_thread_info()->local_flags & _TLF_RESTORE_SIGMASK)
>  		oldset = &current->saved_sigmask;
>  	else if (!oldset)


