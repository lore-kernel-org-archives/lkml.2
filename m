Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1CHTgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:36:53 -0500
Received: from www.tglx.de ([62.245.132.106]:42582 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1CHTgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:36:52 -0500
Date: Tue, 8 Mar 2011 20:36:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Yong Zhang <yong.zhang0@gmail.com>, Venkatesh Pallipadi <venki@google.com>,
        Yong Zhang <yong.zhang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mce.c related WARNING: at kernel/timer.c:983 del_timer_sync
In-Reply-To: <20110308185035.GF2499@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1103082019180.2787@localhost6.localdomain6>
References: <AANLkTikupmQqgVd5Y6Tg0Cj-0TGUvzko8-VPs6_n_pKE@mail.gmail.com> <AANLkTi=7S60UjieW0_ZhX7F5gm39+c28Bdv=dRhPd=tQ@mail.gmail.com> <20110308185035.GF2499@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Tue, 8 Mar 2011, Andi Kleen wrote:
> > >
> > > But, the actual reason is likely some MCE parameter change at boot causing
> > > mce_restart() which in turn calls on_each_cpu mce_cpu_restart() which calls
> > > del_timer_sync().
> > 
> > Seems we found a real bug.
> 
> I don't think it's a real bug actually because the timer cannot run at
> the same time in this state. It's an interrupt which runs with irq disabled 
> Really the only case where it could lead to deadlock is when the timer
> runs with irqs on and the other interrupt with the del_timer_sync
> interrupts it. So most likely your new WARN_ON() is catching
> lots of innocent code.

Nonsense. All timer callbacks run with interrupts enabled. See
timer.c:__run_timers()

	spin_unlock_irq(&base->lock);
	call_timer_fn(timer, fn, data);
        spin_lock_irq(&base->lock);

So it can happen and that's a plain bug, not innocent code.

> That said I don't think we need the del_timer_sync in mce.c either
> for the same reason.  The timer is always on the
> same CPU, so it cannot run in parallel.

But a running timer callback can be interrupted by the smp function
call and if that happens you run into a different problem

     softirq()
	mce_start_timer()
		--> SMP function call interrupt
		    __mcheck_cpu_init_timer()
			del_timer()
			add_timer_on()
                <--
	   add_timer_on()
		--> BUG_ON(timer_pending())

> @@ -2075,7 +2075,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		del_timer_sync(t);
> +		del_timer(t);

Sigh. This is not called on the CPU which is taken down and you really
want to call del_timer_sync() here.

>  		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
>  		break;
>  	case CPU_DOWN_FAILED:

Thanks,

	tglx
