Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1LEMut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:50:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1LEMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:50:48 -0500
Date: Mon, 5 Dec 2011 04:49:17 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-zydc1yhxfm0z35fuy95bsn1l@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Move mmap_pages to perf_record_opts
Git-Commit-ID: 01c2d99bcf6fc7f6ce3fe3d0fb38b124e1f127fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:49:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01c2d99bcf6fc7f6ce3fe3d0fb38b124e1f127fc
Gitweb:     http://git.kernel.org/tip/01c2d99bcf6fc7f6ce3fe3d0fb38b124e1f127fc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 9 Nov 2011 09:16:26 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:34:50 -0200

perf record: Move mmap_pages to perf_record_opts

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
