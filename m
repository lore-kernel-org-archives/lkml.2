Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1E1QjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:39:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:32961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab1E1QjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:39:17 -0400
Date: Sat, 28 May 2011 16:39:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-9137fb28ac74d05eb66d1d8e6778eaa14e6fed43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.719340481@chello.nl>
References: <20110409192141.719340481@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Clean up 'ctx' reference counting
Git-Commit-ID: 9137fb28ac74d05eb66d1d8e6778eaa14e6fed43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:39:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9137fb28ac74d05eb66d1d8e6778eaa14e6fed43
Gitweb:     http://git.kernel.org/tip/9137fb28ac74d05eb66d1d8e6778eaa14e6fed43
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:10 +0200

perf: Clean up 'ctx' reference counting

Small cleanup to how we refcount in find_get_context(), this also
allows us to use put_ctx() to free things instead of using kfree().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.719340481@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4d9a1f01..d665ac4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2835,16 +2835,12 @@ retry:
 		unclone_ctx(ctx);
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
-	if (!ctx) {
+	} else {
 		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
 
-		get_ctx(ctx);
-
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
 		/*
@@ -2856,14 +2852,14 @@ retry:
 		else if (task->perf_event_ctxp[ctxn])
 			err = -EAGAIN;
 		else {
+			get_ctx(ctx);
 			++ctx->pin_count;
 			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
 		}
 		mutex_unlock(&task->perf_event_mutex);
 
 		if (unlikely(err)) {
-			put_task_struct(task);
-			kfree(ctx);
+			put_ctx(ctx);
 
 			if (err == -EAGAIN)
 				goto retry;
