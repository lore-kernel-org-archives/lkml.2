Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2HUPRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:17:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2HUPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:16:35 -0400
Date: Tue, 21 Aug 2012 08:16:13 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-3c18c10bde65b6dcaffab7a4d040285e4defa49b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <1343663105.3847.7.camel@fedora>
References: <1343663105.3847.7.camel@fedora>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Fix wakeup_rt self test on virtual machines
Git-Commit-ID: 3c18c10bde65b6dcaffab7a4d040285e4defa49b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:16:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c18c10bde65b6dcaffab7a4d040285e4defa49b
Gitweb:     http://git.kernel.org/tip/3c18c10bde65b6dcaffab7a4d040285e4defa49b
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 31 Jul 2012 10:23:37 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 7 Aug 2012 09:40:51 -0400

tracing: Fix wakeup_rt self test on virtual machines

The warkeup_rt self test used msleep() calls to wait for real time
tasks to wake up and run. On bare-metal hardware, this was enough as
the scheduler should let the RT task run way before the non-RT task
wakes up from the msleep(). If it did not, then that would mean the
scheduler was broken.

But when dealing with virtual machines, this is a different story.
If the RT task wakes up on a VCPU, it's up to the host to decide when
that task gets to schedule, which can be far behind the time that the
non-RT task wakes up. In this case, the test would fail incorrectly.

As we are not testing the scheduler, but instead the wake up tracing,
we can use completions to wait and not depend on scheduler timings
to see if events happen on time.

Link: http://lkml.kernel.org/r/1343663105.3847.7.camel@fedora

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 1003a4d..2c00a69 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1041,6 +1041,8 @@ static int trace_wakeup_test_thread(void *data)
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule();
 
+	complete(x);
+
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
 		/*
@@ -1084,24 +1086,21 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* reset the max latency */
 	tracing_max_latency = 0;
 
-	/* sleep to let the RT thread sleep too */
-	msleep(100);
+	while (p->on_rq) {
+		/*
+		 * Sleep to make sure the RT thread is asleep too.
+		 * On virtual machines we can't rely on timings,
+		 * but we want to make sure this test still works.
+		 */
+		msleep(100);
+	}
 
-	/*
-	 * Yes this is slightly racy. It is possible that for some
-	 * strange reason that the RT thread we created, did not
-	 * call schedule for 100ms after doing the completion,
-	 * and we do a wakeup on a task that already is awake.
-	 * But that is extremely unlikely, and the worst thing that
-	 * happens in such a case, is that we disable tracing.
-	 * Honestly, if this race does happen something is horrible
-	 * wrong with the system.
-	 */
+	init_completion(&isrt);
 
 	wake_up_process(p);
 
-	/* give a little time to let the thread wake up */
-	msleep(100);
+	/* Wait for the task to wake up */
+	wait_for_completion(&isrt);
 
 	/* stop the tracing. */
 	tracing_stop();
