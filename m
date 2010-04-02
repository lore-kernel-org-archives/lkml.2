Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0DBTIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:08:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:47824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0DBTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:08:18 -0400
Date: Fri, 2 Apr 2010 19:07:46 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1269598293.6174.8.camel@marge.simson.net>
References: <1269598293.6174.8.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix 'perf sched record' deadlock
Message-ID: <tip-8bb39f9aa068262732fe44b965d7a6eb5a5a7d67@git.kernel.org>
Git-Commit-ID: 8bb39f9aa068262732fe44b965d7a6eb5a5a7d67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:07:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bb39f9aa068262732fe44b965d7a6eb5a5a7d67
Gitweb:     http://git.kernel.org/tip/8bb39f9aa068262732fe44b965d7a6eb5a5a7d67
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 26 Mar 2010 11:11:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:30:05 +0200

perf: Fix 'perf sched record' deadlock

perf sched record can deadlock a box should the holder of
handle->data->lock take an interrupt, and then attempt to
acquire an rq lock held by a CPU trying to acquire the
same lock. Disable interrupts.

   CPU0                            CPU1
   sched event with rq->lock held
                                   grab handle->data->lock
   spin on handle->data->lock
                                   interrupt
                                   try to grab rq->lock

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1269598293.6174.8.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b0feb47..96aae13 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3376,15 +3376,23 @@ static void perf_event_task_output(struct perf_event *event,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size;
 	struct task_struct *task = task_event->task;
-	int ret;
+	unsigned long flags;
+	int size, ret;
+
+	/*
+	 * If this CPU attempts to acquire an rq lock held by a CPU spinning
+	 * in perf_output_lock() from interrupt context, it's game over.
+	 */
+	local_irq_save(flags);
 
 	size  = task_event->event_id.header.size;
 	ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret)
+	if (ret) {
+		local_irq_restore(flags);
 		return;
+	}
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3395,6 +3403,7 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
+	local_irq_restore(flags);
 }
 
 static int perf_event_task_match(struct perf_event *event)
