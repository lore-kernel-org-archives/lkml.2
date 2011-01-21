Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1AUPiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:38:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:51721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1AUPiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:38:02 -0500
Date: Fri, 21 Jan 2011 15:37:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Annotate cpuctx->ctx.mutex to avoid a lockdep splat
Message-ID: <tip-547e9fd7d328af261f184bf66effc5033c886498@git.kernel.org>
Git-Commit-ID: 547e9fd7d328af261f184bf66effc5033c886498
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 15:37:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  547e9fd7d328af261f184bf66effc5033c886498
Gitweb:     http://git.kernel.org/tip/547e9fd7d328af261f184bf66effc5033c886498
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 Jan 2011 12:51:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Jan 2011 16:32:42 +0100

perf: Annotate cpuctx->ctx.mutex to avoid a lockdep splat

Lockdep spotted:

	loop_1b_instruc/1899 is trying to acquire lock:
	 (event_mutex){+.+.+.}, at: [<ffffffff810e1908>] perf_trace_init+0x3b/0x2f7

	but task is already holding lock:
	 (&ctx->mutex){+.+.+.}, at: [<ffffffff810eb45b>] perf_event_init_context+0xc0/0x218

	which lock already depends on the new lock.

	the existing dependency chain (in reverse order) is:

	-> #3 (&ctx->mutex){+.+.+.}:
	-> #2 (cpu_hotplug.lock){+.+.+.}:
	-> #1 (module_mutex){+.+...}:
	-> #0 (event_mutex){+.+.+.}:

But because the deadlock would be cpuhotplug (cpu-event) vs fork
(task-event) it cannot, in fact, happen. We can annotate this by giving the
perf_event_context used for the cpuctx a different lock class from those
used by tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 244ca3a..c5fa717 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5380,6 +5380,8 @@ free_dev:
 	goto out;
 }
 
+static struct lock_class_key cpuctx_mutex;
+
 int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
 	int cpu, ret;
@@ -5428,6 +5430,7 @@ skip_type:
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
+		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
