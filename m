Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2FNIRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:17:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2FNIRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:17:34 -0400
Message-ID: <1339661848.2559.7.camel@twins>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jun 2012 10:17:28 +0200
In-Reply-To: <1339661331.2559.5.camel@twins>
References: <20120613102823.373180763@linutronix.de>
	 <20120613105815.206105518@linutronix.de>
	 <20120613183301.GE2427@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206132050270.3086@ionos> <1339661331.2559.5.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 10:08 +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-13 at 20:56 +0200, Thomas Gleixner wrote:
> > If it's just a spurious wakeup then it goes back to sleep right away
> > as nothing cleared the park bit. 
> 
> Your spurious wakeup will have destroyed the binding though. So you need
> to be careful.

We should probably do something like the below..

TJ does this wreck workqueues? Its somewhat 'creative' in that regard
and really wants fixing.

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5018,6 +5018,8 @@ void do_set_cpus_allowed(struct task_str
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
 	p->nr_cpus_allowed = cpumask_weight(new_mask);
+	if (p->nr_cpus_allowed != 1)
+		p->flags &= ~PF_THREAD_BOUND;
 }
 
 /*

