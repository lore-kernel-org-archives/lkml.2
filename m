Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab1CDLw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:52:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:41935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519Ab1CDLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:52:56 -0500
Date: Fri, 4 Mar 2011 11:52:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix cgroup vs jump_label problem
Message-ID: <tip-08309379b7083a9ceec0f9bb96a629058fb623c4@git.kernel.org>
Git-Commit-ID: 08309379b7083a9ceec0f9bb96a629058fb623c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:52:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08309379b7083a9ceec0f9bb96a629058fb623c4
Gitweb:     http://git.kernel.org/tip/08309379b7083a9ceec0f9bb96a629058fb623c4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Mar 2011 11:31:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:52 +0100

perf: Fix cgroup vs jump_label problem

Li Zefan reported that the jump label code sleeps and we're calling it
under a spinlock, *fail* ;-)

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 193b190..ed253aa 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -820,16 +820,8 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		list_add_tail(&event->group_entry, list);
 	}
 
-	if (is_cgroup_event(event)) {
+	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
-		/*
-		 * one more event:
-		 * - that has cgroup constraint on event->cpu
-		 * - that may need work on context switch
-		 */
-		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
-	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
@@ -957,11 +949,8 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	if (is_cgroup_event(event)) {
+	if (is_cgroup_event(event))
 		ctx->nr_cgroups--;
-		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_dec(&perf_sched_events);
-	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
@@ -2903,6 +2892,10 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_task_events);
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
 			put_callchain_buffers();
+		if (is_cgroup_event(event)) {
+			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
+			jump_label_dec(&perf_sched_events);
+		}
 	}
 
 	if (event->buffer) {
@@ -6478,6 +6471,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err)
 			goto err_alloc;
+		/*
+		 * one more event:
+		 * - that has cgroup constraint on event->cpu
+		 * - that may need work on context switch
+		 */
+		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+		jump_label_inc(&perf_sched_events);
 	}
 
 	/*
