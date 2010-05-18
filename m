Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0ERDqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:46:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52170 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0ERDqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=tjGoiG9CZ4vXzn7PSnUkeLlX/xqGaU5QnBBoh3lE0hHLk3GY1mCfr2eaftgXlG2XHK
         1rnTmD1F4Iacj3YdVScDT+KBvdohQ4B3fyWIhuF4rEV3yf9ChOGVij1VxZZ9ssusmivI
         q7k3kPUj52FHz0QIrHRFe6JqZ08TOjsDIp0qg=
MIME-Version: 1.0
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Mon, 17 May 2010 20:46:21 -0700
X-Google-Sender-Auth: BncC3enpbCDRvbQQXBAb2vVj_Z0
Message-ID: <AANLkTin0Rpuo2FH2ieaHWWyMTcYF_9igyAyGgkUiOHlG@mail.gmail.com>
Subject: Re: Issue with SCHED_FIFO app (using CFS)
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, Xianghua Xiao <xiaoxianghua@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have been trying to find the reason for the problem I am facing with
CFS and process with SCHED_FIFO.
Here is a small program I wrote.

/* Lets call this V1 */
#include <sys/types.h>
#include <sys/stat.h>
/* There are other includes but for brevity I have not shown */

main ()
{
  /* I have even tried using the IOCTL to put the system
     to sleep, but the results are same */
  system ("echo mem > /sys/power/state");

  exit (0);
}

When I execute this program from the shell, the system sleeps and
wakes up as soon as the RTC interrupt happens (after 4 seconds, as per
our design). There is no visible delay.

When I put the program in a loop (using bash's while), I see the
system going to sleep and coming out (on RTC interrupt) exactly at 4
seconds as it should.

Now when I change the program slightly as below (it's made a RT process)

/* Lets call this V2 */
#include <sys/types.h>
#include <sys/stat.h>
/* There are other includes but for brevity I have not shown */

main ()
{
  struct sched_param p;
  int ret;

  p.sched_priority = 5;
  ret = sched_setscheduler (0, SCHED_FIFO, &p);
  if (ret == -1)
    {
      printf ("sch.c: sched_setscheduler() failed\n");
      exit (1);
    }

  /* I have even tried using the IOCTL to put the system
     to sleep, but the results are same */
  system ("echo mem > /sys/power/state");
  exit (0);
}

Now when I execute the program from the shell, there is an observable
delay once the processor wakes up before the prompt is returned. The
prints (in kernel/power/main.c) in the kernel confirms that the
process is awake but the application does not finish and drop back to
shell atleast for the 2 to 3 seconds. This delay is not observed in V1
but only on V2.

When put in a loop, I clearly observe that the time we sleep is
proportional to the delay.

I can avoid this delay problem using

echo -1 > /proc/sys/kernel/sched_rt_runtime_us

but this creates more problems. Our system has lot of other other
SCHED_FIFO threads (higher in priority and using pthreads) which
suffer and don't run as expected. One of them is a watchdog thread
which also does not run (inspite of being at priority 54) and thus the
system gets reset.

This issue was not observed in 2.6.16 but seen on 2.6.29. CFS has lot
of knobs, but very little documentation. We understand that turning
these knobs will fix the problem, but we don't know which ones.

I am pasting below some of the values of procfs files and debugfs
files. I can send the complete kernel configuration is required.

Please hint us on something so that we can dig deeper and find a
resolution for this.

We are using this kernel on OMAP platform.

Thanks in advance,
Suresh

[ procfs files ]
sched_child_runs_first = 1
sched_compat_yield = 0
sched_features = 24191
sched_latency_ns = 20000000
sched_migration_cost = 500000
sched_min_granularity_ns = 4000000
sched_nr_migrate = 32
sched_rt_period_us = 1000000
sched_rt_runtime_us = 950000
sched_shares_ratelimit = 250000
sched_shares_thresh = 4
sched_wakeup_granularity_ns = 5000000

[ CFS related kernel configuration ]
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set

[ debugfs file ]
#/debug >cat sched_features
NEW_FAIR_SLEEPERS NORMALIZED_SLEEPER WAKEUP_PREEMPT START_DEBIT
AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK NO_DOUBLE_TICK
ASYM
_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD NO_WAKEUP_OVERLAP LAST_BUDDY


On Wed, May 12, 2010 at 8:16 PM, Xianghua Xiao <xiaoxianghua@gmail.com> wrote:
>
> On Wed, May 12, 2010 at 9:49 PM, Con Kolivas <kernel@kolivas.org> wrote:
> > On Wed, 12 May 2010 12:46:20 Xianghua Xiao wrote:
> >> On Sun, May 9, 2010 at 11:42 PM, Suresh Rajashekara
> >>
> >> <suresh.raj+linuxomap@gmail.com> wrote:
> >> > Hi All,
> >> >
> >> > I had a couple of application (with real time priority SCHED_FIFO)
> >> > which were working fine on 2.6.16. They have started behaving
> >> > differently on 2.6.29.
> >> >
> >> > I will explain my problem briefly.
> >> >
> >> > Application A (my main application) is scheduled with SCHED_FIFO and
> >> > priority 5. Application B (watchdog application) is also scheduled with
> >> > SCHED_FIFO but with priority 54.
> >> >
> >> > A keeps putting the OMAP to sleep and wake up every 4 seconds and
> >> > again puts it to sleep.
> >> > B is supposed to be running every 1.25 seconds to kick watchdog, but
> >> > since A keeps OMAP in sleep for 4 seconds, it should run as soon as
> >> > OMAP wakes up.
> >> >
> >> > Since B is of a higher priority, its supposed to run whenever the OMAP
> >> > wakes up and then A should again put it back to sleep. This happens
> >> > perfectly on 2.6.16
> >> >
> >> > On 2.6.29, B fails to run when OMAP wakes up and before A puts it back
> >> > to sleep. B only runs if there is atleast 1.5 seconds of delay between
> >> > the awake-sleep cycle.
> >> >
> >> > On searching the internet, I figured out that CFS (completely fair
> >> > scheduler) was introduced in 2.6.23, which makes some changes to the
> >> > RT bandwidth (and many users started facing issues with they
> >> > applications with SCHED_FIFO). Somewhere on the web I found that
> >> > issuing
> >> >
> >> > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> >> >
> >> > should disable the changes which affects the RT bandwidth. It actually
> >> > did help to an extent in solving some other problem (not described
> >> > above. A's IOCTL call return was getting delayed), but this problem
> >> > still persists.
> >> >
> >> > Any pointers to where I should look for the solution.
> >> >
> >> > Is there a way I can revert back to the scheduler behavior as it was on
> >> > 2.6.16?
> >> >
> >> > I have disabled CONFIG_GROUP_SCHED and also CONFIG_CGROUPS. I am using
> >> > 2.6.29 on an OMAP1 platform.
> >> >
> >> > Thanks in advance,
> >> > Suresh
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> I have seen similar things while upgrading a 2.6.18 RT kernel to
> >> 2.6.33 RT, actually exactly when CFS was introduced we found
> >> performance issues, in that, our main application(a multi-thread
> >> SCHED_FIFO / SCHED_RR mixed) runs with much higher overhead under CFS.
> >> In 2.6.18RT, the cpu usage is close to 0% and on newer kernel with
> >> CFS, the cpu usage is 12% when the application runs idle(i.e. sleeping
> >> and waiting for input, WCHAN shows sched_timeout or futex_wait). When
> >> the main application runs with real load, cpu usage gets much worse
> >> with CFS.
> >>
> >> I tried various methods, including the one you described above, and
> >> made sure no sched_yield is used, etc, still the main application
> >> spends 6% cpu in user space and 6% in kernel space while at idle. I
> >> tried BFS schedule and it's actually better, about 8% in user space
> >> and 0.6% in kernel space while the application runs idle. Again with
> >> 2.6.18 RT it's nearly 0% cpu usage.
> >
> > It's distinctly possible that there is no change in the CPU usage at all and
> > this is purely representing the change in how CPU accounting is done in CFS,
> > and now BFS since the older mainline scheduler. The old mainline scheduler was
> > potentially very inaccurate at representing CPU usage, particularly when tasks
> > were very short lived. In fact it was possible to write a carefully crafted
> > application that would use 99.9% CPU and register as zero CPU usage, by
> > ensuring it slept just before the accounting tick would be hit. CFS changed
> > dramatically how CPU accounting was done, and on BFS I changed it yet again,
> > trying to make it more accurate.
> >
> > The only way to see if there is a real issue with a change in CPU usage is to
> > measure CPU usage through other means, which can be incredibly difficult to
> > do, such as the power consumed by the CPU, the maximum throughput of the
> > applications, and so on.
> >
> > I do not think this is related to the original issue reported with SCHED_FIFO
> > apps on this email thread though.
> >
> > --
> > -ck
> >
>
> The pthread that has most "cpu usage"(2.6%) is a simple SCHED_RR task
> waiting on select(), another two top cpu usage SCHED_RR pthreads are
> our own timers, these three are supposedly idle tasks before a user
> activates inputs.
>
> lmbench was done and the results are close, though 2.6.33rt wins on
> latency but overall 2.6.18rt has better performance(esp on fork, exec,
> context switch performance).
>
> I'm unsure if the newest "top" (or /proc/PID/stat) reports the correct
> cpu usage when CFS/BFS is used, as you mentioned it seems failed to do
> that. I will try to stress the system and see who fails first under
> same workload, maybe that's the only way to compare cpu usage between
> 2.6.18rt vs 2.6.33rt, for now.
>
> Thanks a lot,
> Xianghua
