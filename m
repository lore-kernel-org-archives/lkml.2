Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1LEMvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:51:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1LEMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:51:50 -0500
Date: Mon, 5 Dec 2011 04:50:49 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8x0yr77r6lrd2t699s499m8n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Move 'group' to perf_event_ops
Git-Commit-ID: ed80f5813fd6ecc6d74250681910a4214f699d4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:50:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed80f5813fd6ecc6d74250681910a4214f699d4e
Gitweb:     http://git.kernel.org/tip/ed80f5813fd6ecc6d74250681910a4214f699d4e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Nov 2011 15:12:56 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:36:27 -0200

perf record: Move 'group' to perf_event_ops

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
