Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0IVIhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:37:16 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:47182 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IVIhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:37:14 -0400
Date: Wed, 22 Sep 2010 10:37:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
Message-ID: <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
 <4C98D0EB.30002@kernel.org>
 <1285083618.2275.884.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285083618.2275.884.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 05:40:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-09-21 at 17:36 +0200, Tejun Heo wrote:
> > I think this is the second time we're seeing deadlock during cpu down
> > due to RT throttling and timer problem.  The rather delicate
> > dependency there makes me somewhat nervous.  If possible, I think it
> > would be better if we can simply turn the RT throttling off when
> > cpu_stop kicks in.  It's intended to be a mechanism to monopolize all
> > CPU cycles to begin with.  Would that be difficult?
> 
> I've wanted to pull the whole migration thread out from SCHED_FIFO for a
> while. Doing that is probably the easiest thing.

Something like this?

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 4372ccb..854fd57 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -291,7 +291,6 @@ repeat:
 static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 					   unsigned long action, void *hcpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 	struct task_struct *p;
@@ -304,7 +303,6 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
 		stopper->thread = p;
 		break;

...gets stuck nearly immediatly on cpu hotplug stress if the machine is
doing anything but idling around.
I was too lazy to figure out why it got stuck. I'm afraid that with such
a change a new class of bugs will appear.
