Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1JAQfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 12:35:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45805 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab1JAQfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 12:35:38 -0400
Date: Sat, 1 Oct 2011 09:35:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111001163533.GA2539@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111001122442.GA3391@somewhere>
 <CAFTL4hxEu+Fra1F0xAACj-5sYbiLYNuzrxSzbRzd_S0UJnSoMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFTL4hxEu+Fra1F0xAACj-5sYbiLYNuzrxSzbRzd_S0UJnSoMA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 02:28:10PM +0200, Frederic Weisbecker wrote:
> 2011/10/1 Frederic Weisbecker <fweisbec@gmail.com>:
> > Yeah something like this (untested):
> >
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index d5097c4..ad3ecad 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -273,9 +273,12 @@ void tick_nohz_stop_sched_tick(int inidle)
> >         * updated. Thus, it must not be called in the event we are called from
> >         * irq_exit() with the prior state different than idle.
> >         */
> > -       if (!inidle && !ts->inidle)
> > +       if (inidle)
> > +               rcu_idle_enter();
> > +       else if (!ts->inidle)
> >                goto end;
> >
> > +
> >        /*
> >         * Set ts->inidle unconditionally. Even if the system did not
> >         * switch to NOHZ mode the cpu frequency governers rely on the
> > @@ -409,7 +412,6 @@ void tick_nohz_stop_sched_tick(int inidle)
> >                        ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
> >                        ts->tick_stopped = 1;
> >                        ts->idle_jiffies = last_jiffies;
> > -                       rcu_enter_nohz();
> >                }
> >
> >                ts->idle_sleeps++;
> > @@ -505,6 +507,9 @@ void tick_nohz_restart_sched_tick(void)
> >        ktime_t now;
> >
> >        local_irq_disable();
> > +
> > +       rcu_idle_exit();
> > +
> >        if (ts->idle_active || (ts->inidle && ts->tick_stopped))
> >                now = ktime_get();
> >
> > @@ -519,8 +524,6 @@ void tick_nohz_restart_sched_tick(void)
> >
> >        ts->inidle = 0;
> >
> > -       rcu_exit_nohz();
> > -
> >        /* Update jiffies first */
> >        select_nohz_load_balancer(0);
> >        tick_do_update_jiffies64(now);
> >
> 
> Ah I see you fixed it in the delta. Ok :)

But rcutorture still hates it.  Possibly because of this boneheaded bug:

int rcu_is_cpu_rrupt_from_idle(void)
{
	return (__get_cpu_var(rcu_dynticks).dynticks_nesting & 0x1) <= 1;
}

Do you think that it might work better if I drop off the "& 0x1" that
I copy-pasted from rcu_is_cpu_idle()?  ;-)

Sigh!!!  Giving it a try now.

							Thanx, Paul
