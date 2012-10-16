Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2JPNq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:46:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54562 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2JPNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:46:58 -0400
X-Nat-Received: from [202.181.97.72]:54724 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1350395206.26317
To: bpoirier@suse.de, mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3.7-rc1] Fix kconfig failure on old environments.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201210162049.HIC43747.OOtOJHFFFQMVSL@I-love.SAKURA.ne.jp>
In-Reply-To: <201210162049.HIC43747.OOtOJHFFFQMVSL@I-love.SAKURA.ne.jp>
Message-Id: <201210162246.BBE56248.FQSFLtHOVMOOJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Oct 2012 22:46:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16102012 #8125454, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From af0876644f04eca9d59c96320447abb0af526079 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 16 Oct 2012 22:30:38 +0900
Subject: [PATCH 3.7-rc1] Fix kconfig failure on old environments.

Commit 95ac9b3b "menuconfig: Assign jump keys per-page instead of globally"
used macros which are available in "@(#)queue.h 8.5 (Berkeley) 8/20/94" but are
not available in "@(#)queue.h 8.3 (Berkeley) 12/13/93", making it impossible to
run one of kconfig targets on old environments.

This patch defines missing macros as needed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/expr.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index bd2e098..1ec59f3 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -13,6 +13,49 @@ extern "C" {
 #include <assert.h>
 #include <stdio.h>
 #include <sys/queue.h>
+#ifndef CIRCLEQ_HEAD_INITIALIZER
+#define	CIRCLEQ_HEAD_INITIALIZER(head)					\
+	{ (void *)&head, (void *)&head }
+#endif
+#ifndef CIRCLEQ_FOREACH
+#define	CIRCLEQ_FOREACH(var, head, field)				\
+	for ((var) = ((head)->cqh_first);				\
+		(var) != (const void *)(head);				\
+		(var) = ((var)->field.cqe_next))
+#endif
+#ifndef CIRCLEQ_FOREACH_REVERSE
+#define	CIRCLEQ_FOREACH_REVERSE(var, head, field)			\
+	for ((var) = ((head)->cqh_last);				\
+		(var) != (const void *)(head);				\
+		(var) = ((var)->field.cqe_prev))
+#endif
+#ifndef CIRCLEQ_EMPTY
+#define	CIRCLEQ_EMPTY(head)		((head)->cqh_first == (void *)(head))
+#endif
+#ifndef CIRCLEQ_FIRST
+#define	CIRCLEQ_FIRST(head)		((head)->cqh_first)
+#endif
+#ifndef CIRCLEQ_LAST
+#define	CIRCLEQ_LAST(head)		((head)->cqh_last)
+#endif
+#ifndef CIRCLEQ_NEXT
+#define	CIRCLEQ_NEXT(elm, field)	((elm)->field.cqe_next)
+#endif
+#ifndef CIRCLEQ_PREV
+#define	CIRCLEQ_PREV(elm, field)	((elm)->field.cqe_prev)
+#endif
+#ifndef CIRCLEQ_LOOP_NEXT
+#define CIRCLEQ_LOOP_NEXT(head, elm, field)				\
+	(((elm)->field.cqe_next == (void *)(head))			\
+	    ? ((head)->cqh_first)					\
+	    : (elm->field.cqe_next))
+#endif
+#ifndef CIRCLEQ_LOOP_PREV
+#define CIRCLEQ_LOOP_PREV(head, elm, field)				\
+	(((elm)->field.cqe_prev == (void *)(head))			\
+	    ? ((head)->cqh_last)					\
+	    : (elm->field.cqe_prev))
+#endif
 #ifndef __cplusplus
 #include <stdbool.h>
 #endif
-- 
1.7.9.5
