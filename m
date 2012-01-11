Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2AKQFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:05:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:45095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab2AKQFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:05:49 -0500
Message-ID: <1326297936.2442.157.camel@twins>
Subject: Re: [BUG] kernel freezes with latest tree
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 11 Jan 2012 17:05:36 +0100
In-Reply-To: <20120111155658.GB26659@elte.hu>
References: <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
	 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
	 <1326234230.2614.15.camel@edumazet-laptop>
	 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
	 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
	 <1326284711.2442.138.camel@twins> <20120111155658.GB26659@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 16:56 +0100, Ingo Molnar wrote:

> Well, what happens if every CPU runs load_balance() and we keep 
> triggering:
> 
>                 if (loops++ > sysctl_sched_nr_migrate) {
>                         *lb_flags |= LBF_NEED_BREAK;
>                         break;
>                 }
> 
> in this case load_balance() will do the retry:
> 
>                 if (lb_flags & LBF_NEED_BREAK) {
>                         lb_flags &= ~LBF_NEED_BREAK;
>                         goto redo;
>                 }
> 
> but the retry starts the loop again:
> 
>         list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
> 
> so nobody is able to make progress: livelock/lockup.

Ah, right! Silly me. One possibility is to rotate that list, except that
won't work for the cgroup case where we have another iteration.

OK, here's an updated patch.. 

---
Subject: sched: Limit load-balance retries on lock-break
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jan 11 13:11:12 CET 2012

Eric and David reported dead machines and traced it to commit a195f004 ("sched:
Fix load-balance lock-breaking"), it turns out there's still a
scenario where we can end up re-trying forever.

Since there is no strict forward progress guarantee in the
load-balance iteration we can get stuck re-retrying the same task-set
over and over.

Creating a forward progress guarantee with the existing structure is
somewhat non-trivial, for now simply terminate the retry loop after a
few tries.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[eric: logic cleanup]
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Link: http://lkml.kernel.org/n/tip-ya9m8grb9wfc26uqnviq2wjq@git.kernel.org
---
 kernel/sched/fair.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3130,8 +3130,10 @@ task_hot(struct task_struct *p, u64 now,
 }
 
 #define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02
-#define LBF_ABORT	0x04
+#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
+#define LBF_HAD_BREAK	0x04
+#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
+#define LBF_ABORT	0x10
 
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
@@ -4508,7 +4510,9 @@ static int load_balance(int this_cpu, st
 			goto out_balanced;
 
 		if (lb_flags & LBF_NEED_BREAK) {
-			lb_flags &= ~LBF_NEED_BREAK;
+			lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
+			if (lb_flags & LBF_ABORT)
+				goto out_balanced;
 			goto redo;
 		}
 

