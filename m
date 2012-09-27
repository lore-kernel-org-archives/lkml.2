Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2I0HKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:10:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64169 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2I0HKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:10:17 -0400
Date: Thu, 27 Sep 2012 09:10:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927071011.GA8980@gmail.com>
References: <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
 <20120927054742.GA4370@gmail.com>
 <1348727665.7059.160.camel@marge.simpson.net>
 <20120927064142.GB5996@gmail.com>
 <1348728852.7059.171.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348728852.7059.171.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Do you have an easy-to-apply hack patch by chance that has 
> > the effect of turning off all such preemption, which people 
> > could try?
> 
> They don't need any hacks, all they have to do is start 
> postgreqsl SCHED_BATCH, then run pgbench the same way.
> 
> I use schedctl, but in chrt speak, chrt -b 0 
> /etc/init.d/postgresql start, and then the same for pgbench 
> itself.

Just in case someone prefers patches to user-space approaches (I 
certainly do!), here's one that turns off wakeup driven 
preemption by default.

It can be turned back on via:

  echo WAKEUP_PREEMPTION > /debug/sched_features

and off again via:

  echo NO_WAKEUP_PREEMPTION > /debug/sched_features 

(the patch is completely untested and such.)

The theory would be that this patch fixes psql performance, with 
CPU selection being a measurable but second order of magnitude 
effect. How well does practice match theory in this case?

Thanks,

	Ingo

---------
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..f936552 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2907,7 +2907,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
 	 * is driven by the tick):
 	 */
-	if (unlikely(p->policy != SCHED_NORMAL))
+	if (unlikely(p->policy != SCHED_NORMAL) || !sched_feat(WAKEUP_PREEMPTION))
 		return;
 
 	find_matching_se(&se, &pse);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..e68e69a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -32,6 +32,11 @@ SCHED_FEAT(LAST_BUDDY, true)
 SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
+ * Allow wakeup-time preemption of the current task:
+ */
+SCHED_FEAT(WAKEUP_PREEMPTION, false)
+
+/*
  * Use arch dependent cpu power functions
  */
 SCHED_FEAT(ARCH_POWER, true)
