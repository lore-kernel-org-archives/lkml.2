Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab2J3PjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:39:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab2J3PjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:39:15 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=60KdgoBU-20A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Gcm4EvZRSmsA:10 a=pcLIrrrKAAAA:8 a=rFMEq44me7uM0rZAdykA:9 a=QEXdDO2ut3YA:10 a=J0D9jONdvmQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351611552.8467.96.camel@gandalf.local.home>
Subject: Re: [PATCH 01/32] nohz: Move nohz load balancer selection into idle
 logic
From: Steven Rostedt <rostedt@goodmis.org>
To: muming.wq@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@intel.com>
Date: Tue, 30 Oct 2012 11:39:12 -0400
In-Reply-To: <508F90A0.1030503@gmail.com>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203846.797007049@goodmis.org> <508F90A0.1030503@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2012-10-30 at 16:32 +0800, Charles Wang wrote:
> calc_load_exit_idle depends on updated jiffies, so you shouldn't move 
> this before tick_do_update_jiffies64.

OK, so it should be moved to the end of the if block. Note, that was a
change I made, as that function was added since Frederic did his code. I
looked into the code and it seemed that it should be moved for just idle
as well. But I agree with you that it should be after the jiffies
update.


> And why should we do nohz_balance_enter_idle in tick_nohz_idle_exit? 
> It's nohz_balance_exit_idle here.

OK, that's my fault as well. As Frederic's original patch just moved
select_nohz_load_balance(0). But the commit c1cc017c59 "sched/nohz:
Clean up select_nohz_load_balancer()" replaced it with
nohz_balance_enter_idle(cpu), and removed it on exit, there was nothing
to replace for the current code.

Knowing this patch was considered "buggy" instead of just not moving it
(and forgetting about it), I did the change to remind myself to talk
about it :-)

My question is now, is there any reason to keep that call there? Or can
we just remove it as well.

-- Steve


> 
> Regards,
> Charles
> 
> On 10/30/2012 04:27 AM, Steven Rostedt wrote:
> ［snipped］
>  > @@ -573,7 +573,6 @@ static void tick_nohz_restart_sched_tick(struct 
> tick_sched *ts, ktime_t now)
>  >  	tick_do_update_jiffies64(now);
>  >  	update_cpu_load_nohz();
>  >
>  > -	calc_load_exit_idle();
>  >  	touch_softlockup_watchdog();
>  >  	/*
>  >  	 * Cancel the scheduled timer and restore the tick
>  > @@ -628,6 +627,8 @@ void tick_nohz_idle_exit(void)
>  >  		tick_nohz_stop_idle(cpu, now);
>  >
>  >  	if (ts->tick_stopped) {
>  > +		nohz_balance_enter_idle(cpu);
>  > +		calc_load_exit_idle();
>  >  		tick_nohz_restart_sched_tick(ts, now);
>  >  		tick_nohz_account_idle_ticks(ts);
>  >  	}


