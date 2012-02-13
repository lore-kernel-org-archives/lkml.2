Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2BMF1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:27:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2BMF1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:27:49 -0500
Date: Mon, 13 Feb 2012 13:27:29 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
Message-ID: <20120213052729.GA24636@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
 <20120208065115.GA19691@zhy>
 <CABeCy1bAB6PSAUabk8zO8oh_sLVo3sOPVrr_kSovLdmOOtkfTg@mail.gmail.com>
 <20120209021855.GA26152@zhy>
 <CABeCy1YcELDiFB0rdSCKGgPm7RE5MkQL9v-9xOHfwn5SP3iVeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABeCy1YcELDiFB0rdSCKGgPm7RE5MkQL9v-9xOHfwn5SP3iVeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 06:17:06PM -0800, Venki Pallipadi wrote:
> 
> This should likely work. But, if you do want to use similar logic in
> smp_call_function() or idle load balance kick etc, you need additional
> bit other than need_resched() as there we only need irq+softirq and
> not necessarily a resched.

Yeah, putting resched_idle_cpu() into smp_call_function_*() is a bit ugly
though resched could work in the scenario because you have
generic_smp_call_function_single_interrupt() called in cpu_idle();

> At this time I am not sure how poll wakeup logic works in MIPS. But,

A typical example is busy loop:
void __noreturn cpu_idle(void)
{
	...

        while (1) {
                tick_nohz_idle_enter();
                rcu_idle_enter();
                while (!need_resched() && cpu_online(cpu)) {
                	;
		}   
                rcu_idle_exit();
                tick_nohz_idle_exit();
                preempt_enable_no_resched();
                schedule();
		preempt_disable();
	}

	...
}


> if it is something that is similar to x86 mwait and we can wakeup with
> a bit other than TIF_NEED_RESCHED, we can generalize most of the
> changes in my RFC and share it across archs.

Yeah, there are many things we could share IMHO, especially the hook
in cpu_idle().

Thanks,
Yong
