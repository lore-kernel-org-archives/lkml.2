Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1K1XTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:19:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1K1XOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/25] perf record: Move mmap_pages to perf_record_opts
Date: Mon, 28 Nov 2011 21:14:09 -0200
Message-Id: <1322522066-21879-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Tools being developed will need this to allow the user to override this
value.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zydc1yhxfm0z35fuy95bsn1l@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 +++++----
 tools/perf/perf.h           |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 749862d..ffb627d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,9 +35,10 @@ enum write_mode_t {
 	WRITE_APPEND
 };
 
-static struct perf_record_opts record_opts = {
+struct perf_record_opts record_opts = {
 	.target_pid	     = -1,
 	.target_tid	     = -1,
+	.mmap_pages	     = UINT_MAX,
 	.user_freq	     = UINT_MAX,
 	.user_interval	     = ULLONG_MAX,
 	.freq		     = 1000,
@@ -45,7 +46,6 @@ static struct perf_record_opts record_opts = {
 };
 
 static unsigned int		page_size;
-static unsigned int		mmap_pages			= UINT_MAX;
 static int			output;
 static const char		*output_name			= NULL;
 static bool			group				=  false;
@@ -272,7 +272,7 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, record_opts.mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
 	if (file_new)
@@ -647,7 +647,8 @@ const struct option record_options[] = {
 	OPT_BOOLEAN('i', "no-inherit", &record_opts.no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &record_opts.user_freq, "profile at this frequency"),
-	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
+	OPT_UINTEGER('m', "mmap-pages", &record_opts.mmap_pages,
+		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &group,
 		    "put the counters into a counter group"),
 	OPT_BOOLEAN('g', "call-graph", &record_opts.call_graph,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32ee6ca..13c42f3 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -200,6 +200,7 @@ struct perf_record_opts {
 	bool	     sample_id_all_avail;
 	bool	     system_wide;
 	unsigned int freq;
+	unsigned int mmap_pages;
 	unsigned int user_freq;
 	u64	     default_interval;
 	u64	     user_interval;
-- 
1.7.8.rc0.35.gee6df

