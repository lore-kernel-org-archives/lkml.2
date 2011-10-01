Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1JAM2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 08:28:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50920 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1JAM2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 08:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <20111001122442.GA3391@somewhere>
References: <20110927180142.GD2335@linux.vnet.ibm.com>
	<20110928123116.GP18553@somewhere>
	<20110928184025.GF2383@linux.vnet.ibm.com>
	<20110928234633.GA3537@somewhere>
	<20110929005545.GT2383@linux.vnet.ibm.com>
	<20110929123040.GB3537@somewhere>
	<20110929171205.GA2362@linux.vnet.ibm.com>
	<20110930131105.GC19053@somewhere>
	<20110930152946.GA2397@linux.vnet.ibm.com>
	<20110930192438.GA7505@linux.vnet.ibm.com>
	<20111001122442.GA3391@somewhere>
Date: Sat, 1 Oct 2011 14:28:10 +0200
Message-ID: <CAFTL4hxEu+Fra1F0xAACj-5sYbiLYNuzrxSzbRzd_S0UJnSoMA@mail.gmail.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/1 Frederic Weisbecker <fweisbec@gmail.com>:
> Yeah something like this (untested):
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d5097c4..ad3ecad 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -273,9 +273,12 @@ void tick_nohz_stop_sched_tick(int inidle)
>         * updated. Thus, it must not be called in the event we are called from
>         * irq_exit() with the prior state different than idle.
>         */
> -       if (!inidle && !ts->inidle)
> +       if (inidle)
> +               rcu_idle_enter();
> +       else if (!ts->inidle)
>                goto end;
>
> +
>        /*
>         * Set ts->inidle unconditionally. Even if the system did not
>         * switch to NOHZ mode the cpu frequency governers rely on the
> @@ -409,7 +412,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>                        ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
>                        ts->tick_stopped = 1;
>                        ts->idle_jiffies = last_jiffies;
> -                       rcu_enter_nohz();
>                }
>
>                ts->idle_sleeps++;
> @@ -505,6 +507,9 @@ void tick_nohz_restart_sched_tick(void)
>        ktime_t now;
>
>        local_irq_disable();
> +
> +       rcu_idle_exit();
> +
>        if (ts->idle_active || (ts->inidle && ts->tick_stopped))
>                now = ktime_get();
>
> @@ -519,8 +524,6 @@ void tick_nohz_restart_sched_tick(void)
>
>        ts->inidle = 0;
>
> -       rcu_exit_nohz();
> -
>        /* Update jiffies first */
>        select_nohz_load_balancer(0);
>        tick_do_update_jiffies64(now);
>

Ah I see you fixed it in the delta. Ok :)
