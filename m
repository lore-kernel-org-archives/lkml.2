Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab1D0Vz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:55:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59901 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1D0Vzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:55:53 -0400
Date: Wed, 27 Apr 2011 14:55:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110427215549.GN2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110425191607.GL2468@linux.vnet.ibm.com>
 <20110425231016.34b4293e@neptune.home>
 <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
 <20110425214933.GO2468@linux.vnet.ibm.com>
 <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com>
 <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home>
 <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1104262314110.3323@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 12:28:37AM +0200, Thomas Gleixner wrote:
> On Tue, 26 Apr 2011, Linus Torvalds wrote:
> 
> > On Tue, Apr 26, 2011 at 10:09 AM, Bruno Prémont
> > <bonbons@linux-vserver.org> wrote:
> > >
> > > Just in case, /proc/$(pidof rcu_kthread)/status shows ~20k voluntary
> > > context switches and exactly one non-voluntary one.
> > >
> > > In addition when rcu_kthread has stopped doing its work
> > > `swapoff $(swapdevice)` seems to block forever (at least normal shutdown
> > > blocks on disabling swap device).
> > > If I get to do it when I get back home I will manually try to swapoff
> > > and take process traces with sysrq-t.
> > 
> > That "exactly one non-voluntary one" sounds like the smoking gun.
> > 
> > Normally SCHED_FIFO runs until it voluntarily gives up the CPU. That's
> > kind of the point of SCHED_FIFO. Involuntary context switches happen
> > when some higher-priority SCHED_FIFO process becomes runnable (irq
> > handlers? You _do_ have CONFIG_IRQ_FORCED_THREADING=y in your config
> > too), and maybe there is a bug in the runqueue handling for that case.
> 
> The forced irq threading is only effective when you add the command
> line parameter "threadirqs". I don't see any irq threads in the ps
> outputs, so that's not the problem.
> 
> Though the whole ps output is weird. There is only one thread/process
> which accumulated CPU time
> 
> collectd  1605  0.6  0.7  49924  3748 ?        SNLsl 22:14   0:14

I believe that the above is the script that prints out the RCU debugfs
information periodically.  Unless there is something else that begins
with "collectd" instead of just collectdebugfs.sh.

							Thanx, Paul

> All others show 0:00 CPU time - not only kthread_rcu.
> 
> Bruno, are you running on real hardware or in a virtual machine?
> 
> Can you please enable CONFIG_SCHED_DEBUG and provide the output of
> /proc/sched_stat when the problem surfaces and a minute after the
> first snapshot?
> 
> Also please apply the patch below and check, whether the printk shows
> up in your dmesg.
> 
> Thanks,
> 
> 	tglx
> 
> ---
>  kernel/sched_rt.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6-tip/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sched_rt.c
> +++ linux-2.6-tip/kernel/sched_rt.c
> @@ -609,6 +609,7 @@ static int sched_rt_runtime_exceeded(str
> 
>  	if (rt_rq->rt_time > runtime) {
>  		rt_rq->rt_throttled = 1;
> +		printk_once(KERN_WARNING "sched: RT throttling activated\n");
>  		if (rt_rq_throttled(rt_rq)) {
>  			sched_rt_rq_dequeue(rt_rq);
>  			return 1;

