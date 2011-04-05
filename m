Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1DEIOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:14:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:44326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1DEIOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:14:38 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
References: <20110402103125.GA18746@elte.hu>
	 <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 10:14:25 +0200
Message-ID: <1301991265.2225.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 08:45 -0700, Linus Torvalds wrote:
> So I pulled this, but I think this:
> 
> On Sat, Apr 2, 2011 at 3:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > -               if (interval > HZ*NR_CPUS/10)
> > -                       interval = HZ*NR_CPUS/10;
> > +               if (interval > HZ*num_online_cpus()/10)
> > +                       interval = HZ*num_online_cpus()/10;
> 
> is a horrible patch.
> 
> Think about what that expands to. It's going to potentially be two
> function calls. And the code is just ugly.
> 
> So please, when doing search-and-replace changes like this, just clean
> up the code at the same time. Back when it was about pure constants,
> there was only a typing/ugly overhead from duplicating the constant,
> but the compiler would see a single constant.
> 
> Now it's _possible_ that the compiler could do the analysis and fold
> it all back to a single thing. But it's unlikely to happen except for
> configurations that end up making it all trivial.
> 
> So just add something like a
> 
>    int max_interval = HZ*num_online_cpus()/10;
> 
> possibly even with a comment about _why_ that is the max interval allowed.  Ok?

How about something like the below?

---
Subject: sched: Clean up load-balance interval calculation

Instead of the possible multiple-evaluation of num_online_cpus() avoid
it all together in the normal case since its implemented with a hamming
weight function over a cpu bitmask which can be darn expensive for those
with big iron.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   16 ++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a884551..17b4d22 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6331,6 +6331,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 #endif
 	}
+
+	update_max_interval();
+
 	return NOTIFY_OK;
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c7ec5c8..a14a04e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3820,6 +3820,17 @@ void select_nohz_load_balancer(int stop_tick)
 
 static DEFINE_SPINLOCK(balancing);
 
+static unsigned long max_load_balance_interval = HZ/10;
+
+/*
+ * Scale the max load_balance interval with the number of CPUs in the system.
+ * This trades load-balance latency on larger machines for less cross talk.
+ */
+static void update_max_interval(void)
+{
+	max_load_balance_interval = HZ*num_online_cpus()/10;
+}
+
 /*
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
@@ -3849,10 +3860,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 		/* scale ms to jiffies */
 		interval = msecs_to_jiffies(interval);
-		if (unlikely(!interval))
-			interval = 1;
-		if (interval > HZ*num_online_cpus()/10)
-			interval = HZ*num_online_cpus()/10;
+		interval = clamp(interval, 1UL, max_load_balance_interval);
 
 		need_serialize = sd->flags & SD_SERIALIZE;
 

