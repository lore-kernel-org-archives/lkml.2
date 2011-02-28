Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1B1JsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:48:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:36876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1B1JsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:48:17 -0500
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <4D6B16A8.4050405@cn.fujitsu.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <4D6765B6.1030401@cn.fujitsu.com>
	 <20110225203219.GD2269@linux.vnet.ibm.com>
	 <4D6B16A8.4050405@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 10:47:17 +0100
Message-ID: <1298886437.2428.10174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 11:29 +0800, Lai Jiangshan wrote:
> >>> +static int rcu_cpu_kthread_should_stop(int cpu)
> >>> +{
> >>> +   while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
> >>> +           if (kthread_should_stop())
> >>> +                   return 1;
> >>> +           local_bh_enable();
> >>> +           schedule_timeout_uninterruptible(1);
> >>> +           if (smp_processor_id() != cpu)
> >>> +                   set_cpus_allowed_ptr(current, cpumask_of(cpu));
> >>
> >> The current task is PF_THREAD_BOUND,
> >> Why do "set_cpus_allowed_ptr(current, cpumask_of(cpu));" ?
> > 
> > Because I have seen CPU hotplug operations unbind PF_THREAD_BOUND threads.

Correct, but that's on unplug, the rest of the story seems about plug,
so just detatch the thread on down/offline and let it die when its done.

> > In addition, I end up having to spawn the kthread at CPU_UP_PREPARE time,

Sure, that's a common time to create such treads :-), you can
kthread_ceate()+kthread_bind() in UP_PREPARE, just don't wake them yet.

> > at which point the thread must run unbound because its CPU isn't online
> > yet.  I cannot invoke kthread_create() within the stop-machine handler
> > (right?).

No you can not ;-)

>   I cannot wait until CPU_ONLINE time because that results in
> > hangs when other CPU notifiers wait for grace periods.
> > 
> > Yes, I did find out about the hangs the hard way.  Why do you ask?  ;-)

Right, so I assume that whoever needs the thread will:

 1) wake the thread,
 2) only do so after the cpu is actually online, how else could it be
executing code? :-)


