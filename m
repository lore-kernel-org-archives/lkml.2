Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1K1XSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:18:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1K1XOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/25] perf record: Move 'group' to perf_event_ops
Date: Mon, 28 Nov 2011 21:14:11 -0200
Message-Id: <1322522066-21879-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in other tools to share the command line parsing code.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8x0yr77r6lrd2t699s499m8n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 ++++-----
 tools/perf/perf.h           |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ffb627d..ba6777a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -48,7 +48,6 @@ struct perf_record_opts record_opts = {
 static unsigned int		page_size;
 static int			output;
 static const char		*output_name			= NULL;
-static bool			group				=  false;
 static int			realtime_prio			=      0;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
 static bool			no_buildid			=  false;
@@ -202,13 +201,13 @@ static void open_counters(struct perf_evlist *evlist)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
-		if (group && pos != first)
+		if (record_opts.group && pos != first)
 			group_fd = first->fd;
 retry_sample_id:
 		attr->sample_id_all = record_opts.sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
-				     group_fd) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads,
+				     record_opts.group, group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
@@ -649,7 +648,7 @@ const struct option record_options[] = {
 	OPT_UINTEGER('F', "freq", &record_opts.user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &record_opts.mmap_pages,
 		     "number of mmap data pages"),
-	OPT_BOOLEAN(0, "group", &group,
+	OPT_BOOLEAN(0, "group", &record_opts.group,
 		    "put the counters into a counter group"),
 	OPT_BOOLEAN('g', "call-graph", &record_opts.call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 13c42f3..ea804f5 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -189,6 +189,7 @@ struct perf_record_opts {
 	pid_t	     target_pid;
 	pid_t	     target_tid;
 	bool	     call_graph;
+	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
 	bool	     no_inherit;
-- 
1.7.8.rc0.35.gee6df

