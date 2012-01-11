Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2AKQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:58:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:45928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2AKQ6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:58:38 -0500
Message-ID: <1326301102.2442.171.camel@twins>
Subject: Re: [BUG] kernel freezes with latest tree
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 11 Jan 2012 17:58:22 +0100
In-Reply-To: <CA+55aFyyBpDR_oYu9EizwPf63q3Q=44Yw_jXd0Ozk0Ei1TtZJQ@mail.gmail.com>
References: <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
	 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
	 <1326234230.2614.15.camel@edumazet-laptop>
	 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
	 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
	 <1326284711.2442.138.camel@twins> <20120111155658.GB26659@elte.hu>
	 <1326297936.2442.157.camel@twins>
	 <CA+55aFyyBpDR_oYu9EizwPf63q3Q=44Yw_jXd0Ozk0Ei1TtZJQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 08:31 -0800, Linus Torvalds wrote:
> On Wed, Jan 11, 2012 at 8:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Ah, right! Silly me. One possibility is to rotate that list, except that
> > won't work for the cgroup case where we have another iteration.
> 
> I just wonder whether you *really* need that loop at all?
> 
> If something went wrong with the attempted task move - you raced with
> another cpu, or whatever - is there any real reason to even bother to
> try again?
> 
> It's just a heuristic, after all, and we'll come back to balancing later.
> 
> The minimal patch looks good, but I did want to ask whether people
> have considered just removing the looping entirely?

Yeah, I did consider it, and given the current code it doesn't really
make a difference either way. But ideally we'll go fix the code to
provide better progress over repeated attempts.

Esp for people who put the migration count rather low (-rt crackpots)
multiple rounds (provided progress) make more sense.

Something like the below snippet improves the progress for !cgroup
kernels, but it also defeats the regular termination condition since any
list with two or more elements will endlessly rotate until we hit the
break limit.

We could fix this by adding an iteration count and limit that to
nr_running I guess, but since world and dog compiles kernels with cgroup
muck these days we need something slightly more clever to deal with the
for_each_leaf_cfs_rq() loop in load_balance_fair().

Will ponder more.. 

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3244,8 +3246,10 @@ balance_tasks(struct rq *this_rq, int th
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
-				      lb_flags))
+				      lb_flags)) {
+			list_move_tail(&p->se.group_node, &busiest_cfs_rq->tasks);
 			continue;
+		}
 
 		pull_task(busiest, p, this_rq, this_cpu);
 		pulled++;

