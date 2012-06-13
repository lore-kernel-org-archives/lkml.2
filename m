Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2FMS41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:56:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:50762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2FMS40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:56:26 -0400
Date: Wed, 13 Jun 2012 20:56:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <20120613183301.GE2427@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206132050270.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.206105518@linutronix.de> <20120613183301.GE2427@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
>
> So I am currently trying to apply this to RCU's per-CPU kthread.
> I don't believe that I need to mess with RCU's per-rcu_node kthread
> because it can just have its affinity adjusted when the first CPU
> onlines and the last CPU offlines for the corresponding rcu_node.
> 
> One question below about the order of parking.
> 
> Also, I have not yet figured out how this avoids a parked thread waking
> up while the CPU is offline, but I am probably still missing something.

If it's just a spurious wakeup then it goes back to sleep right away
as nothing cleared the park bit.

If something calls unpark(), then it's toast. I should put a warning
into the code somewhere to catch that case.

> > +void smpboot_park_threads(unsigned int cpu)
> > +{
> > +	struct smp_hotplug_thread *cur;
> > +
> > +	mutex_lock(&smpboot_threads_lock);
> > +	list_for_each_entry(cur, &hotplug_threads, list)
> 
> Shouldn't this be list_for_each_entry_reverse()?  Yes, the notifiers
> still run in the same order for both online and offline, but all uses
> of smpboot_park_threads() would be new, so should be OK with the
> proper ordering, right?

Duh, yes

Thanks,

	tglx
