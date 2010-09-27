Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0I0Kk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:40:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57910 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab0I0KkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YGQipWvR7znWnA24+2/nQKy4EfJcCrylR96VMWQVVPWvXJ0Z75Q8Rk2JoLyzFgnC4r
         t7BiurQ0NyNRmZ9dR+UOTIvMJJlXY1BIRJbKN9/gWu5hPC5sZwQQlkG4cY7g7qSK4ts4
         23P8dmsxsRdRohHEqNryS7Msav4mZjxjO8yf4=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] perf: Wrap perf_lock_task_context using __cond_lock()
Date: Mon, 27 Sep 2010 19:39:53 +0900
Message-Id: <1285583997-1262-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_lock_task_context() conditionally grabs ctx->lock in case of
returning non-NULL. Rename and wrap it using __cond_lock to make
sparse happy.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/perf_event.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index db5b560..c058a42 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -151,7 +151,7 @@ static u64 primary_event_id(struct perf_event *event)
  * the context could get moved to another task.
  */
 static struct perf_event_context *
-perf_lock_task_context(struct task_struct *task, unsigned long *flags)
+__perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 {
 	struct perf_event_context *ctx;
 
@@ -184,6 +184,14 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 	return ctx;
 }
 
+static inline struct perf_event_context *
+perf_lock_task_context(struct task_struct *task, unsigned long *flags)
+{
+	struct perf_event_context *ctx;
+	__cond_lock(&ctx->lock, ctx = __perf_lock_task_context(task, flags));
+	return ctx;
+}
+
 /*
  * Get the context for a task and increment its pin_count so it
  * can't get swapped to another task.  This also increments its
-- 
1.7.2.2

