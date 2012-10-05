Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2JENF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:05:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2JENF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:05:58 -0400
Date: Fri, 5 Oct 2012 06:05:38 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-so7wi2zf3jjzrwcutm2mkz0j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf_cgroup_switch for sw-events
Git-Commit-ID: 95cf59ea72331d0093010543b8951bb43f262cac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 06:05:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95cf59ea72331d0093010543b8951bb43f262cac
Gitweb:     http://git.kernel.org/tip/95cf59ea72331d0093010543b8951bb43f262cac
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Oct 2012 15:41:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 13:59:07 +0200

perf: Fix perf_cgroup_switch for sw-events

Jiri reported that he could trigger the WARN_ON_ONCE() in
perf_cgroup_switch() using sw-events. This is because sw-events share
a cpuctx with multiple PMUs.

Use the ->unique_pmu pointer to limit the pmu iteration to unique
cpuctx instances.

Reported-and-Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-so7wi2zf3jjzrwcutm2mkz0j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 81939e8..fd15593 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -372,6 +372,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			continue; /* ensure we process each cpuctx once */
 
 		/*
 		 * perf_cgroup_events says at least one
@@ -395,9 +397,10 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 
 			if (mode & PERF_CGROUP_SWIN) {
 				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
+				/*
+				 * set cgrp before ctxsw in to allow
+				 * event_filter_match() to not have to pass
+				 * task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
