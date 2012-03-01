Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2CAHjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:39:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab2CAHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:39:17 -0500
Date: Thu, 1 Mar 2012 08:38:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120301073845.GA5350@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228084359.GJ21106@elte.hu>
 <20120228132719.f375071a.akpm@linux-foundation.org>
 <4F4DBB26.2060907@linux.vnet.ibm.com>
 <20120229091732.GA11505@elte.hu>
 <4F4E083A.2080304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E083A.2080304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> On 02/29/2012 02:47 PM, Ingo Molnar wrote:
> 
> > 
> > * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > 
> >> Hi Andrew,
> >>
> >> On 02/29/2012 02:57 AM, Andrew Morton wrote:
> >>
> >>> On Tue, 28 Feb 2012 09:43:59 +0100
> >>> Ingo Molnar <mingo@elte.hu> wrote:
> >>>
> >>>> This patch should also probably go upstream through the 
> >>>> locking/lockdep tree? Mind sending it us once you think it's 
> >>>> ready?
> >>>
> >>> Oh goody, that means you own
> >>> http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
> >>>
> >>
> >>
> >> That bug got fixed sometime around Dec 2011. See commit e30e2fdf
> >> (VFS: Fix race between CPU hotplug and lglocks)
> > 
> > The lglocks code is still CPU-hotplug racy AFAICS, despite the 
> > ->cpu_lock complication:
> > 
> > Consider a taken global lock on a CPU:
> > 
> > 	CPU#1
> > 	...
> > 	br_write_lock(vfsmount_lock);
> > 
> > this takes the lock of all online CPUs: say CPU#1 and CPU#2. Now 
> > CPU#3 comes online and takes the read lock:
> 
> 
> CPU#3 cannot come online! :-)
> 
> No new CPU can come online until that corresponding br_write_unlock()
> is completed. That is because  br_write_lock acquires &name##_cpu_lock
> and only br_write_unlock will release it.

Indeed, you are right.

Note that ->cpu_lock is an entirely superfluous complication in 
br_write_lock(): the whole CPU hotplug race can be addressed by 
doing a br_write_lock()/unlock() barrier in the hotplug callback 
...

> > Another detail I noticed, this bit:
> > 
> >         register_hotcpu_notifier(&name##_lg_cpu_notifier);              \
> >         get_online_cpus();                                              \
> >         for_each_online_cpu(i)                                          \
> >                 cpu_set(i, name##_cpus);                                \
> >         put_online_cpus();                                              \
> > 
> > could be something simpler and loop-less, like:
> > 
> >         get_online_cpus();
> > 	cpumask_copy(name##_cpus, cpu_online_mask);
> > 	register_hotcpu_notifier(&name##_lg_cpu_notifier);
> > 	put_online_cpus();
> > 
> 
> 
> While the cpumask_copy is definitely better, we can't put the 
> register_hotcpu_notifier() within get/put_online_cpus() 
> because it will lead to ABBA deadlock with a newly initiated 
> CPU Hotplug operation, the 2 locks involved being the 
> cpu_add_remove_lock and the cpu_hotplug lock.
>
> IOW, at the moment there is no "absolutely race-free way" way 
> to do CPU Hotplug callback registration. Some time ago, while 
> going through the asynchronous booting patch by Arjan [1] I 
> had written up a patch to fix that race because that race got 
> transformed from "purely theoretical" to "very real" with the 
> async boot patch, as shown by the powerpc boot failures [2].
> 
> But then I stopped short of posting that patch to the lists 
> because I started wondering how important that race would 
> actually turn out to be, in case the async booting design 
> takes a totally different approach altogether.. [And the 
> reason why I didn't post it is also because it would require 
> lots of changes in many parts where CPU Hotplug registration 
> is done, and that wouldn't probably be justified (I don't 
> know..) if the race remained only theoretical, as it is now.]

A fairly simple solution would be to eliminate the _cpus mask as 
well, and do a for_each_possible_cpu() loop in the super-slow 
loop - like dozens and dozens of other places do it in the 
kernel.

At a first quick glance that way the code gets a lot simpler and 
the only CPU hotplug related change needed are the CPU_* 
callbacks to do the lock barrier.

Thanks,

	Ingo
