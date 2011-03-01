Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1CAREJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:04:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab1CAREF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:04:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/6] perf top tui: Wait till the first sample to refresh the screen.
Date: Tue,  1 Mar 2011 14:03:47 -0300
Message-Id: <1298999027-30673-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298999027-30673-1-git-send-email-acme@infradead.org>
References: <1298999027-30673-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   21 +++++++++++++++++++--
 tools/perf/util/top.h    |    1 +
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0b07cc3..417f757 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -72,6 +72,7 @@ static struct perf_top top = {
 	.target_tid		= -1,
 	.active_symbols		= LIST_HEAD_INIT(top.active_symbols),
 	.active_symbols_lock	= PTHREAD_MUTEX_INITIALIZER,
+	.active_symbols_cond	= PTHREAD_COND_INITIALIZER,
 	.freq			= 1000, /* 1 KHz */
 };
 
@@ -577,7 +578,17 @@ static void handle_keypress(struct perf_session *session, int c)
 
 static void *display_thread_tui(void *arg __used)
 {
-	perf_top__tui_browser(&top);
+	int err = 0;
+	pthread_mutex_lock(&top.active_symbols_lock);
+	while (list_empty(&top.active_symbols)) {
+		err = pthread_cond_wait(&top.active_symbols_cond,
+					&top.active_symbols_lock);
+		if (err)
+			break;
+	}
+	pthread_mutex_unlock(&top.active_symbols_lock);
+	if (!err)
+		perf_top__tui_browser(&top);
 	exit_browser(0);
 	exit(0);
 	return NULL;
@@ -776,8 +787,14 @@ static void perf_event__process_sample(const union perf_event *event,
 		syme->count[evsel->idx]++;
 		record_precise_ip(syme, evsel->idx, ip);
 		pthread_mutex_lock(&top.active_symbols_lock);
-		if (list_empty(&syme->node) || !syme->node.next)
+		if (list_empty(&syme->node) || !syme->node.next) {
+			static bool first = true;
 			__list_insert_active_sym(syme);
+			if (first) {
+				pthread_cond_broadcast(&top.active_symbols_cond);
+				first = false;
+			}
+		}
 		pthread_mutex_unlock(&top.active_symbols_lock);
 	}
 }
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index e8d28e2..96d1cb7 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -35,6 +35,7 @@ struct perf_top {
 	 */
 	struct list_head   active_symbols;
 	pthread_mutex_t	   active_symbols_lock;
+	pthread_cond_t	   active_symbols_cond;
 	u64		   samples;
 	u64		   kernel_samples, us_samples;
 	u64		   exact_samples;
-- 
1.6.2.5

