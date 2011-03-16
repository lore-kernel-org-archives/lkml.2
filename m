Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1CPNwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:52:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:32873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab1CPNwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:52:45 -0400
Date: Wed, 16 Mar 2011 13:52:15 GMT
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
Subject: [tip:perf/urgent] perf top: Remove redundant syme->origin field
Message-ID: <tip-8b8ba4a9a5b04916858f79cee71873f973931649@git.kernel.org>
Git-Commit-ID: 8b8ba4a9a5b04916858f79cee71873f973931649
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b8ba4a9a5b04916858f79cee71873f973931649
Gitweb:     http://git.kernel.org/tip/8b8ba4a9a5b04916858f79cee71873f973931649
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Mar 2011 12:38:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Mar 2011 13:28:45 -0300

perf top: Remove redundant syme->origin field

We can get it from syme->map->dso->kernel (that should be renamed to
origin, but leave this for another patch).

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
 tools/perf/builtin-top.c |    1 -
 tools/perf/util/top.c    |    4 ++--
 tools/perf/util/top.h    |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4bf6e02..4976400 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -782,7 +782,6 @@ static void perf_event__process_sample(const union perf_event *event,
 	if (!syme->skip) {
 		struct perf_evsel *evsel;
 
-		syme->origin = origin;
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 		syme->count[evsel->idx]++;
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index fcfb777..a11f607 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -184,9 +184,9 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 		if (syme->snap_count != 0) {
 
 			if ((top->hide_user_symbols &&
-			     syme->origin == PERF_RECORD_MISC_USER) ||
+			     syme->map->dso->kernel == DSO_TYPE_USER) ||
 			    (top->hide_kernel_symbols &&
-			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
+			     syme->map->dso->kernel == DSO_TYPE_KERNEL)) {
 				perf_top__remove_active_sym(top, syme);
 				continue;
 			}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 96a7831..ba111b2 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -17,7 +17,6 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
-	u8			origin;
 	struct map		*map;
 	unsigned long		count[0];
 };
