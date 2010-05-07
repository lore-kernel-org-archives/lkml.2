Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0EGSmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:42:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0EGSmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:42:17 -0400
Date: Fri, 7 May 2010 18:41:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Annotate perf_event_read_group() vs perf_event_release_kernel()
Message-ID: <tip-a0507c84bf47dfd204299774f45fd16da33f0619@git.kernel.org>
Git-Commit-ID: a0507c84bf47dfd204299774f45fd16da33f0619
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:41:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0507c84bf47dfd204299774f45fd16da33f0619
Gitweb:     http://git.kernel.org/tip/a0507c84bf47dfd204299774f45fd16da33f0619
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 6 May 2010 15:42:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:30:59 +0200

perf: Annotate perf_event_read_group() vs perf_event_release_kernel()

Stephane reported a lockdep warning while using PERF_FORMAT_GROUP.

The issue is that perf_event_read_group() takes faults while holding
the ctx->mutex, while perf_event_release_kernel() can be called from
munmap(). Which makes for an AB-BA deadlock.

Except we can never establish the deadlock because we'll only ever
call perf_event_release_kernel() after all file descriptors are dead
so there is no concurrency possible.

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 49d8be5..34659d4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1867,7 +1867,19 @@ int perf_event_release_kernel(struct perf_event *event)
 	event->state = PERF_EVENT_STATE_FREE;
 
 	WARN_ON_ONCE(ctx->parent_ctx);
-	mutex_lock(&ctx->mutex);
+	/*
+	 * There are two ways this annotation is useful:
+	 *
+	 *  1) there is a lock recursion from perf_event_exit_task
+	 *     see the comment there.
+	 *
+	 *  2) there is a lock-inversion with mmap_sem through
+	 *     perf_event_read_group(), which takes faults while
+	 *     holding ctx->mutex, however this is called after
+	 *     the last filedesc died, so there is no possibility
+	 *     to trigger the AB-BA case.
+	 */
+	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	perf_event_remove_from_context(event);
 	mutex_unlock(&ctx->mutex);
 
@@ -5305,7 +5317,7 @@ void perf_event_exit_task(struct task_struct *child)
 	 *
 	 * But since its the parent context it won't be the same instance.
 	 */
-	mutex_lock_nested(&child_ctx->mutex, SINGLE_DEPTH_NESTING);
+	mutex_lock(&child_ctx->mutex);
 
 again:
 	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
