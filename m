Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0EKHZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:25:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:50758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0EKHZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:25:22 -0400
Date: Tue, 11 May 2010 07:24:46 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       ming.m.lin@intel.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf: Fix exit() vs PERF_FORMAT_GROUP"
Message-ID: <tip-e3174cfd2a1e28fff774681f00a0eef3d31da970@git.kernel.org>
Git-Commit-ID: e3174cfd2a1e28fff774681f00a0eef3d31da970
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 07:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3174cfd2a1e28fff774681f00a0eef3d31da970
Gitweb:     http://git.kernel.org/tip/e3174cfd2a1e28fff774681f00a0eef3d31da970
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 11 May 2010 08:31:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 08:31:49 +0200

Revert "perf: Fix exit() vs PERF_FORMAT_GROUP"

This reverts commit 4fd38e4595e2f6c9d27732c042a0e16b2753049c.

It causes various crashes and hangs when events are activated.

The cause is not fully understood yet but we need to revert it
because the effects are severe.

Reported-by: Stephane Eranian <eranian@google.com>
Reported-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 -
 kernel/perf_event.c        |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4924c96..3fd5c82 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -575,7 +575,6 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
-	PERF_EVENT_STATE_FREE		= -3,
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 180151f..a904746 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -334,9 +334,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
 
-	if (event->state > PERF_EVENT_STATE_FREE)
-		return;
-
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
@@ -1871,8 +1868,6 @@ int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
-	event->state = PERF_EVENT_STATE_FREE;
-
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
