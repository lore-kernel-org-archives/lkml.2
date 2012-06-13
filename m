Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2FMUre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:47:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59333 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FMUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:47:32 -0400
Date: Wed, 13 Jun 2012 13:47:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120613204725.GA9858@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613191745.GG2427@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061320-3270-0000-0000-000007265DC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:17:45PM -0700, Paul E. McKenney wrote:
> On Wed, Jun 13, 2012 at 09:02:55PM +0200, Thomas Gleixner wrote:
> > On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> > > On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> > > >  	/* Now call notifier in preparation. */
> > > >  	cpu_notify(CPU_ONLINE | mod, hcpu);
> > > > +	smpboot_unpark_threads(cpu);
> > > 
> > > OK, RCU must use the lower-level interfaces, given that one of
> > > then CPU_ONLINE notifiers might invoke synchronize_rcu().
> > 
> > We can start the threads before the notifiers. There is no
> > restriction.
> 
> Sounds very good in both cases!

Just for reference, here is what I am using.


Anticipatory changes in advance of Thomas's next patchset

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ab5d82..510ba5e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -372,10 +372,10 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
+	smpboot_unpark_threads(cpu);
 
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);
-	smpboot_unpark_threads(cpu);
 
 out_notify:
 	if (ret != 0)
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d7a3659..7d54e7c 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -201,7 +201,7 @@ void smpboot_park_threads(unsigned int cpu)
 	struct smp_hotplug_thread *cur;
 
 	mutex_lock(&smpboot_threads_lock);
-	list_for_each_entry(cur, &hotplug_threads, list)
+	list_for_each_entry_reverse(cur, &hotplug_threads, list)
 		smpboot_park_thread(cur, cpu);
 	mutex_unlock(&smpboot_threads_lock);
 }

