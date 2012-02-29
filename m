Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2B2JRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:17:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab2B2JRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:17:50 -0500
Date: Wed, 29 Feb 2012 10:17:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120229091732.GA11505@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228084359.GJ21106@elte.hu>
 <20120228132719.f375071a.akpm@linux-foundation.org>
 <4F4DBB26.2060907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4DBB26.2060907@linux.vnet.ibm.com>
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

> Hi Andrew,
> 
> On 02/29/2012 02:57 AM, Andrew Morton wrote:
> 
> > On Tue, 28 Feb 2012 09:43:59 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> This patch should also probably go upstream through the 
> >> locking/lockdep tree? Mind sending it us once you think it's 
> >> ready?
> > 
> > Oh goody, that means you own
> > http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
> >
> 
> 
> That bug got fixed sometime around Dec 2011. See commit e30e2fdf
> (VFS: Fix race between CPU hotplug and lglocks)

The lglocks code is still CPU-hotplug racy AFAICS, despite the 
->cpu_lock complication:

Consider a taken global lock on a CPU:

	CPU#1
	...
	br_write_lock(vfsmount_lock);

this takes the lock of all online CPUs: say CPU#1 and CPU#2. Now 
CPU#3 comes online and takes the read lock:

			CPU#3
			br_read_lock(vfsmount_lock);

This will succeed while the br_write_lock() is still active, 
because CPU#1 has only taken the locks of CPU#1 and CPU#2. 

Crash!

The proper fix would be for CPU-online to serialize with all 
known lglocks, via the notifier callback, i.e. to do something 
like this:

        case CPU_UP_PREPARE:                                            
		for_each_online_cpu(cpu) {
	                spin_lock(&name##_cpu_lock);                            
	                spin_unlock(&name##_cpu_lock);
		}
	...

I.e. in essence do:

        case CPU_UP_PREPARE:                                            
		name##_global_lock_online();
		name##_global_unlock_online();

Another detail I noticed, this bit:

        register_hotcpu_notifier(&name##_lg_cpu_notifier);              \
        get_online_cpus();                                              \
        for_each_online_cpu(i)                                          \
                cpu_set(i, name##_cpus);                                \
        put_online_cpus();                                              \

could be something simpler and loop-less, like:

        get_online_cpus();
	cpumask_copy(name##_cpus, cpu_online_mask);
	register_hotcpu_notifier(&name##_lg_cpu_notifier);
	put_online_cpus();

Thanks,

	Ingo
