Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1ENPbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 11:31:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43170 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995Ab1ENPbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 11:31:23 -0400
Date: Sat, 14 May 2011 08:31:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110514153118.GA24311@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DCAF894.7030707@kernel.org>
 <4DCAFFD8.2080605@kernel.org>
 <4DCB157F.20202@kernel.org>
 <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com>
 <20110514142621.GB2258@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110514142621.GB2258@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 07:26:21AM -0700, Paul E. McKenney wrote:
> On Fri, May 13, 2011 at 02:08:21PM -0700, Yinghai Lu wrote:
> > On Thu, May 12, 2011 at 2:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > On 05/12/2011 02:20 AM, Paul E. McKenney wrote:
> > >> On Thu, May 12, 2011 at 12:42:50AM -0700, Yinghai Lu wrote:
> > >>> On 05/12/2011 12:27 AM, Yinghai Lu wrote:
> > >>>> On 05/11/2011 11:03 PM, Ingo Molnar wrote:
> > >>>>>
> > >>>>> * Yinghai Lu <yinghai@kernel.org> wrote:
> > >>>>>
> > >>>>>> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
> > >>>>>> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
> > >>>>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >>>>>> Date:   Tue Sep 7 10:38:22 2010 -0700
> > >>>>>>
> > >>>>>>     rcu: Decrease memory-barrier usage based on semi-formal proof
> > >>>>>
> > >>>>> Find below an (untested!) attempt at reverting it for debugging purposes: could
> > >>>>> you please try it, does your system now boot up fine?
> > >>>>>
> > >>>>> Thanks,
> > >>>>>
> > >>>>>    Ingo
> > >>>>>
> > >>>>
> > >>>> yes, reverted manually that commit fix the problem.
> > >>>
> > >>> on system with 8 sockets westmere-ex
> > >>>
> > >>> it seems other commits after that commit contribute some delay too.
> > >>>
> > >>> [   32.240739] cpu_dev_init done
> > >>> [   73.587288] memory_dev_init done
> > >>
> > >> I am testing a revert of e59fb3120becfb36b22ddb8bd27d065d3cdca499 and
> > >> will chase down the delay.
> > >>
> > >
> > > it seems still need to revert following one in addition  e59fb3120becfb36b22ddb8bd27d065d3cdca499.
> > >
> > > [root@mpk14-2404-239-158 linux-2.6]# git bisect good
> > > a26ac2455ffcf3be5c6ef92bc6df7182700f2114 is the first bad commit
> > > commit a26ac2455ffcf3be5c6ef92bc6df7182700f2114
> > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Date:   Wed Jan 12 14:10:23 2011 -0800
> > >
> > >    rcu: move TREE_RCU from softirq to kthread
> > >
> > >    If RCU priority boosting is to be meaningful, callback invocation must
> > >    be boosted in addition to preempted RCU readers.  Otherwise, in presence
> > >    of CPU real-time threads, the grace period ends, but the callbacks don't
> > >    get invoked.  If the callbacks don't get invoked, the associated memory
> > >    doesn't get freed, so the system is still subject to OOM.
> > >
> > >    But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
> > >    moves the callback invocations to a kthread, which can be boosted easily.
> > >
> > >    Also add comments and properly synchronized all accesses to
> > >    rcu_cpu_kthread_task, as suggested by Lai Jiangshan.
> > >
> > >    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > >    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > >
> > > :040000 040000 e40306ac6405952c1d387325a98588442209abe8 efe9ea2f408c62daaccf49e6d1339dff3a74f049 M      Documentation
> > > :040000 040000 8f9e7a8fa3a728d4ae58e2efb8ada7cf08aed00e 9b44deba45ba905c5d9b3cc314812f0ba3f7e639 M      include
> > > :040000 040000 4b10b719a2d56ed4bc796a9f43775732bb5ff144 4db269277ccf607e1a6a7d7f4c2a7cf8d592d46a M      kernel
> > > :040000 040000 881f102e6831381beed016ed240d690f6a2ccd5e 57d2fc6f84e47394c116bc617a9a0ef9b8b6dbd4 M      tools
> > 
> > so only revert  e59fb3120becfb36b22ddb8bd27d065d3cdca499 is not enough.
> > 
> > [  315.248277] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > [  315.285642] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > [  427.405283] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> > 0} (detected by 50, t=15002 jiffies)
> > [  427.408267] sending NMI to all CPUs:
> > [  427.419298] NMI backtrace for cpu 1
> > [  427.420616] CPU 1
> > 
> > Paul, can you make one clean revert for
> > | a26ac2455ffcf3be5c6ef92bc6df7182700f2114
> > | rcu: move TREE_RCU from softirq to kthread
> 
> I will be continuing to look into a few things over the weekend, but
> if I cannot find the cause, then changing back to softirq might be the
> thing to do.  It won't be so much a revert in the "git revert" sense
> due to later dependencies, but it could be shifted back from kthread
> to softirq.  This would certainly decrease dependence on the scheduler,
> at least in the common case where ksoftirqd does not run.

So, upon reviewing Yinghai's RCU debugfs output after getting a good
night's sleep, I see that the dyntick nesting level is getting messed up.
This is shown by the "dt=7237/73" near the end of the debugfs info of
Yinghai's message from Tue, 10 May 2011 23:42:24 -0700.  This says that
RCU believes that the CPU is not in dyntick-idle mode (7237 is an odd
number) and that that there are 73 levels of not being in dyntick-idle
mode, which means at least 72 interrupt levels.  Unless x86 interrupts
normally nest 72 levels deep...

This situation will cause RCU to think that a given CPU is not in
dyntick-idle mode when it really is.  This results in RCU waiting on
it to respond, and eventually waking it up.  Which would cause needless
grace-period delays.

Before commit e59fb31 (Decrease memory-barrier usage based on semi-formal
proof), rcu_enter_nohz() would have unconditionally caused RCU to believe
that the CPU was in dyntick-idle mode.  After this commit, RCU pays attention
to the (broken) nesting count.  Though the broken nesting level probably
caused some trouble even before this commit.

So I am restoring the old semantics where rcu_enter_nohz() unconditionally
tells RCU that the CPU really is in nohz mode.  I am also adding
some WARN_ON_ONCE() statements that will hopefully help find where the
misnesting is occurring.  I will also see if I can find the mis-nesting,
but I am not as familiar with the interrupt entry/exit code as I should
be.  So I will create and sanity-test the patch and post it first,
and do the inspection afterwards.

							Thanx, Paul
