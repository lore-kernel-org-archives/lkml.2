Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1LENIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:08:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab1LENIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:08:11 -0500
Date: Mon, 5 Dec 2011 05:07:42 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-iokhcvkzzijr3keioubx8hlq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Always do automatic allocation of pollfd and mmap structures
Git-Commit-ID: 806fb63007447622dd61d9767b4403919737e120
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:07:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  806fb63007447622dd61d9767b4403919737e120
Gitweb:     http://git.kernel.org/tip/806fb63007447622dd61d9767b4403919737e120
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 Nov 2011 08:05:52 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Nov 2011 08:05:52 -0200

perf evlist: Always do automatic allocation of pollfd and mmap structures

At first tools were required to do that, but while writing the python
bindings to simplify the API I made them auto-allocate when needed.

This just makes record, stat and top use that auto allocation,
simplifying them a bit.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-iokhcvkzzijr3keioubx8hlq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    6 ------
 tools/perf/builtin-stat.c   |    3 +--
 tools/perf/builtin-top.c    |   19 ++++---------------
 tools/perf/util/evlist.c    |    4 ++--
 tools/perf/util/evlist.h    |    2 --
 5 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7d4fdaa..766fa0a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -778,16 +778,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_fd(pos, evsel_list->cpus->nr,
-					 evsel_list->threads->nr) < 0)
-			goto out_free_fd;
 		if (perf_header__push_event(pos->attr.config, event_name(pos)))
 			goto out_free_fd;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list) < 0)
-		goto out_free_fd;
-
 	if (rec->opts.user_interval != ULLONG_MAX)
 		rec->opts.default_interval = rec->opts.user_interval;
 	if (rec->opts.user_freq != UINT_MAX)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 227befb..4356144 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1240,8 +1240,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
 		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, evsel_list->cpus->nr) < 0 ||
-		    perf_evsel__alloc_fd(pos, evsel_list->cpus->nr, evsel_list->threads->nr) < 0)
+		    perf_evsel__alloc_counts(pos, evsel_list->cpus->nr) < 0)
 			goto out_free_fd;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 50ff362..c3836b9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1034,9 +1034,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		symbol_conf.use_callchain = false;
 
 		return 0;
-	}
-
-	else
+	} else
 		return -1;
 
 	/* get the min percentage */
@@ -1225,22 +1223,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	}
 
 	list_for_each_entry(pos, &top.evlist->entries, node) {
-		if (perf_evsel__alloc_fd(pos, top.evlist->cpus->nr,
-					 top.evlist->threads->nr) < 0)
-			goto out_free_fd;
 		/*
 		 * Fill in the ones not specifically initialized via -c:
 		 */
-		if (pos->attr.sample_period)
-			continue;
-
-		pos->attr.sample_period = top.default_interval;
+		if (!pos->attr.sample_period)
+			pos->attr.sample_period = top.default_interval;
 	}
 
-	if (perf_evlist__alloc_pollfd(top.evlist) < 0 ||
-	    perf_evlist__alloc_mmap(top.evlist) < 0)
-		goto out_free_fd;
-
 	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
 	symbol_conf.priv_size = sizeof(struct annotation);
@@ -1270,7 +1259,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	}
 
 	status = __cmd_top(&top);
-out_free_fd:
+
 	perf_evlist__delete(top.evlist);
 
 	return status;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b36f26f..8b19e7a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -275,7 +275,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	}
 }
 
-int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
+static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
@@ -431,7 +431,7 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 	evlist->mmap = NULL;
 }
 
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
+static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = evlist->cpus->nr;
 	if (evlist->cpus->map[0] == -1)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f94ed7e..8922aee 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -72,7 +72,6 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
-int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
@@ -89,7 +88,6 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  const char *argv[]);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
-int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
