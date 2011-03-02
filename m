Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1CBImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:42:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:45307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1CBIma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:42:30 -0500
Date: Wed, 2 Mar 2011 08:42:02 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top tui: Wait till the first sample to refresh the screen.
Message-ID: <tip-5807806a92450fd57f8063868efae9d4af74db02@git.kernel.org>
Git-Commit-ID: 5807806a92450fd57f8063868efae9d4af74db02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:42:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5807806a92450fd57f8063868efae9d4af74db02
Gitweb:     http://git.kernel.org/tip/5807806a92450fd57f8063868efae9d4af74db02
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Mar 2011 10:43:03 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 Mar 2011 10:43:03 -0300

perf top tui: Wait till the first sample to refresh the screen.

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
