Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2AKMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:25:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:42281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2AKMZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:25:25 -0500
Message-ID: <1326284711.2442.138.camel@twins>
Subject: Re: [BUG] kernel freezes with latest tree
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 11 Jan 2012 13:25:11 +0100
In-Reply-To: <1326272685.2442.120.camel@twins>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
	 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
	 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
	 <1326234230.2614.15.camel@edumazet-laptop>
	 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
	 <4F0D2D9B.8030501@gmail.com> <1326272685.2442.120.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 10:04 +0100, Peter Zijlstra wrote:
> Maybe adding a few more NEED_BREAK bits
> and making it a counter and overflowing it into ABORT might be good.
> 
> 
I could reproduce and confirm something like the below makes the hang
go-away. I haven't managed to fully understand why we're stuck though
because we do release the runqueue locks and re-enable IRQs on this
lock-break.

My stuck machine had several CPUs stuck in a load-balance pass, so it
could be they're bouncing tasks back and forth without actually making
any progress what so ever.

I reproduced with hackbench 500, which results in 20000 tasks, spread
over 24 cpus that gives some 833 tasks per runqueue on average, easily
overflowing that lock-break scanning limit.

---
Subject: sched: Limit load-balance retries on lock-break
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jan 11 13:11:12 CET 2012

Eric and David reported dead machines and traced it to commit a195f004 ("sched:
Fix load-balance lock-breaking"), it turns out there's still a
scenario where we can end up re-trying forever.

Limit the number of retries and simply abort.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -4509,6 +4511,9 @@ static int load_balance(int this_cpu, st
 
 		if (lb_flags & LBF_NEED_BREAK) {
 			lb_flags &= ~LBF_NEED_BREAK;
+			lb_flags += LBF_HAD_BREAK;
+			if (lb_flags & LBF_ABORT)
+				goto out_balanced;
 			goto redo;
 		}
 

