Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0GXRBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 13:01:54 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58956 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0GXRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 13:01:52 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jul 2010 13:01:52 EDT
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH RFC] perf lock: Add new event "lock_acquired_waittime" for contention analysis
Date: Sun, 25 Jul 2010 01:55:29 +0900
Message-Id: <1279990529-8798-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recording every lock events produces too large overhead
both in CPU time and memory space.
This overhead is a big problem which should be solved,
but locks are important factor today.

So I'd like to add a new lock event "lock_acquired_waittime"
for contention analysis. lock_acquired() calculates time consumed
for waiting the locks with held_lock->waittime_stamp set by lock_contended().
If this value is 0, no contention occured. If this value is not 0,
there is occurence of contention.
So I inserted the branch based on this value into lock_acquired().
New lock_acquired() calls trace_lock_acquired() when waittime is 0,
and calls trace_lock_acquired_waittime(), function for the new event,
when waittime is not 0.

The traditional event, lock_acquired, is too high frequency event.
But the event lock_acquired_waittime is not so high frequency,
so overhead produced by tracing this event is not so large.

This is an example:
| mitake@X201i:~/linux/.../tools/perf% ./perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 1.712 [sec]
| mitake@X201i:~/linux/.../tools/perf% sudo ./perf record -R -f -m 1024 -c 1 -e lock:lock_acquired_waittime:r ./perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 1.754 [sec]
| [ perf record: Woken up 1 times to write data ]
| [ perf record: Captured and wrote 0.958 MB perf.data (~41837 samples) ]

"perf bench sched messaging" is a kernel bound program, but this result
shows that overhead is, at least on my Core i3 laptop, small enough for discarding
especially from CPU time perspective.

This new event is not enough for analyzing complete lock behaviour.
But measuring quantity of time consumed for lock contention will be possible.

So I think this patch is useful for real world lock analysis.
I'd like to write in new analyzer which use this event in Python.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

---
 include/trace/events/lock.h |   23 +++++++++++++++++++++++
 kernel/lockdep.c            |    5 ++++-
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 2821b86..40164f2 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -77,6 +77,29 @@ DEFINE_EVENT(lock, lock_acquired,
 	TP_ARGS(lock, ip)
 );
 
+TRACE_EVENT(lock_acquired_waittime,
+
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip,
+		u64 waittime),
+
+	TP_ARGS(lock, ip, waittime),
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+		__field(void *, lockdep_addr)
+		__field(u64, waittime)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
+		__entry->waittime = waittime;
+	),
+
+	TP_printk("%p %s %llu [ns]", __entry->lockdep_addr,
+		__get_str(name), __entry->waittime)
+);
+
 #endif
 #endif
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5428679..2a002e9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3390,7 +3390,10 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	trace_lock_acquired(lock, ip);
+	if (waittime)
+		trace_lock_acquired_waittime(lock, ip, waittime);
+	else
+		trace_lock_acquired(lock, ip);
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
-- 
1.7.1.1

