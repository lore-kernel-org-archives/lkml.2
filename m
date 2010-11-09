Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0KIN2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:28:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:39541 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0KIN2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:28:44 -0500
Message-ID: <4CD94C0D.3030007@kernel.org>
Date: Tue, 09 Nov 2010 14:26:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in synchronize_sched_expedited()
References: <20101107020507.GA4974@linux.vnet.ibm.com> <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Nov 2010 13:26:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On 11/07/2010 03:05 AM, Paul E. McKenney wrote:
> The new (early 2010) implementation of synchronize_sched_expedited() uses
> try_stop_cpu() to force a context switch on every CPU.  It also permits
> concurrent calls to synchronize_sched_expedited() to share a single call
> to try_stop_cpu() through use of an atomically incremented
> synchronize_sched_expedited_count variable.  Unfortunately, this is
> subject to failure as follows:
> 
> o	Task A invokes synchronize_sched_expedited(), try_stop_cpus()
> 	succeeds, but Task A is preempted before getting to the atomic
> 	increment of synchronize_sched_expedited_count.
> 
> o	Task B also invokes synchronize_sched_expedited(), with exactly
> 	the same outcome as Task A.
> 
> o	Task C also invokes synchronize_sched_expedited(), again with
> 	exactly the same outcome as Tasks A and B.
> 
> o	Task D also invokes synchronize_sched_expedited(), but only
> 	gets as far as acquiring the mutex within try_stop_cpus()
> 	before being preempted, interrupted, or otherwise delayed.
> 
> o	Task E also invokes synchronize_sched_expedited(), but only
> 	gets to the snapshotting of synchronize_sched_expedited_count.
> 
> o	Tasks A, B, and C all increment synchronize_sched_expedited_count.
> 
> o	Task E fails to get the mutex, so checks the new value
> 	of synchronize_sched_expedited_count.  It finds that the
> 	value has increased, so (wrongly) assumes that its work
> 	has been done, returning despite there having been no
> 	expedited grace period since it began.
> 
> The solution is to have the lowest-numbered CPU atomically increment
> the synchronize_sched_expedited_count variable within the
> synchronize_sched_expedited_cpu_stop() function, which is under
> the protection of the mutex acquired by try_stop_cpus().  However, this
> also requires that piggybacking tasks wait for three rather than two
> instances of try_stop_cpu(), because we cannot control the order in
> which the per-CPU callback function occur.

How about something like the following?  It's slightly bigger but I
think it's a bit easier to understand.  Thanks.

diff --git a/kernel/sched.c b/kernel/sched.c
index aa14a56..0069be5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9342,7 +9342,8 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);

 #else /* #ifndef CONFIG_SMP */

-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_token = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);

 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
@@ -9373,11 +9374,18 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  */
 void synchronize_sched_expedited(void)
 {
-	int snap, trycount = 0;
+	int my_tok, tok, t, trycount = 0;
+
+	smp_mb();  /* ensure prior mod happens before getting token. */
+
+	/*
+	 * Get a token.  This is used to coordinate with other
+	 * concurrent syncers and consolidate multiple syncs.
+	 */
+	my_tok = tok = atomic_inc_return(&sync_sched_expedited_token);

-	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
 	get_online_cpus();
+
 	while (try_stop_cpus(cpu_online_mask,
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
@@ -9388,13 +9396,34 @@ void synchronize_sched_expedited(void)
 			synchronize_sched();
 			return;
 		}
-		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
+
+		/*
+		 * If the done count reached @my_tok, we know at least
+		 * one synchronization happened since we entered this
+		 * function.
+		 */
+		if (atomic_read(&sync_sched_expedited_done) - my_tok >= 0) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
 		}
+
 		get_online_cpus();
+
+		/* about to retry, get the latest token value */
+		tok = atomic_read(&sync_sched_expedited_token);
 	}
-	atomic_inc(&synchronize_sched_expedited_count);
+
+	/*
+	 * We now know that everything upto @tok is synchronized.
+	 * Update done counter which should always monotonically
+	 * increase (with wrapping considered).
+	 */
+	do {
+		t = atomic_read(&sync_sched_expedited_done);
+		if (t - tok >= 0)
+			break;
+	} while (atomic_cmpxchg(&sync_sched_expedited_done, t, tok) != t);
+
 	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
 }
