Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2FORj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:39:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2FORj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:39:58 -0400
Message-ID: <1339781988.15222.6.camel@twins>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Charles Wang <muming.wq@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Tao Ma <tm@tao.ma>,
        =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>
Date: Fri, 15 Jun 2012 19:39:48 +0200
In-Reply-To: <4FDB4642.5070509@gmail.com>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
	  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday I ended up with something like the below.. but I haven't
gotten round to trying Doug's latest testing method, nor did I really
read the email I'm now replying to.

I think it does something like what Wang described... every time I try
and write comments related to why it does this I get stuck though. 

I ran out of time again for this week, I'll try and prod at it a little
more next week (and try and catch up with the thread).

In the meantime I thought I might as well post this.. who knows somebody
might be bored over the weekend, it might actually work, or not :-)

---
 kernel/sched/core.c |   77 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca07ee0..4101a0e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2198,26 +2198,49 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
  *
  * When making the ILB scale, we should try to pull this in as well.
  */
-static atomic_long_t calc_load_tasks_idle;
+static atomic_long_t calc_load_idle[2];
+static int calc_load_idx;
+
+static inline int calc_load_write_idx(void)
+{
+	int idx = calc_load_idx;
+
+	/*
+	 * See calc_global_nohz(), if we observe the new index, we also
+	 * need to observe the new update time.
+	 */
+	smp_rmb();
+
+	if (!time_before(jiffies, calc_load_update))
+		idx++;
+
+	return idx & 1;
+}
+
+static inline int calc_load_read_idx(void)
+{
+	return calc_load_idx & 1;
+}
 
 void calc_load_account_idle(struct rq *this_rq)
 {
 	long delta;
+	int idx;
 
 	delta = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks_idle);
+	if (delta) {
+		idx = calc_load_write_idx();
+		atomic_long_add(delta, &calc_load_idle[idx]);
+	}
 }
 
 static long calc_load_fold_idle(void)
 {
+	int idx = calc_load_read_idx();
 	long delta = 0;
 
-	/*
-	 * Its got a race, we don't care...
-	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
-		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+	if (atomic_long_read(&calc_load_idle[idx]))
+		delta = atomic_long_xchg(&calc_load_idle[idx], 0);
 
 	return delta;
 }
@@ -2313,26 +2336,32 @@ static void calc_global_nohz(void)
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
-	/*
-	 * It could be the one fold was all it took, we done!
-	 */
-	if (time_before(jiffies, calc_load_update + 10))
-		return;
+	if (!time_before(jiffies, calc_load_update + 10)) {
+		/*
+		 * Catch-up, fold however many we are behind still
+		 */
+		delta = jiffies - calc_load_update - 10;
+		n = 1 + (delta / LOAD_FREQ);
 
-	/*
-	 * Catch-up, fold however many we are behind still
-	 */
-	delta = jiffies - calc_load_update - 10;
-	n = 1 + (delta / LOAD_FREQ);
+		active = atomic_long_read(&calc_load_tasks);
+		active = active > 0 ? active * FIXED_1 : 0;
 
-	active = atomic_long_read(&calc_load_tasks);
-	active = active > 0 ? active * FIXED_1 : 0;
+		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
-	avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
-	avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
-	avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+		calc_load_update += n * LOAD_FREQ;
+	}
 
-	calc_load_update += n * LOAD_FREQ;
+	/*
+	 * Flip the idle index...
+	 *
+	 * Make sure we first write the new time then flip the index, so that
+	 * calc_load_write_idx() will see the new time when it reads the new
+	 * index, this avoids a double flip messing things up.
+	 */
+	smp_wmb();
+	calc_load_idx++;
 }
 #else
 void calc_load_account_idle(struct rq *this_rq)

