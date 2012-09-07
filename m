Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2IGGCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:02:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2IGGCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:02:05 -0400
Date: Thu, 6 Sep 2012 23:01:46 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-8d3eca20b9f31cf10088e283d704f6a71b9a4ee2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-8-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-8-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Remove use of die/exit
Git-Commit-ID: 8d3eca20b9f31cf10088e283d704f6a71b9a4ee2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:01:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d3eca20b9f31cf10088e283d704f6a71b9a4ee2
Gitweb:     http://git.kernel.org/tip/8d3eca20b9f31cf10088e283d704f6a71b9a4ee2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:47 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:22:41 -0300

perf record: Remove use of die/exit

Allows perf to clean up properly on exit. If perf-record is exiting due
to failure, the on_exit should not run as the session has been deleted.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-8-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  158 +++++++++++++++++++++++++++++-------------
 1 files changed, 109 insertions(+), 49 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 479ff2a..7b8b891 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -71,19 +71,23 @@ static void advance_output(struct perf_record *rec, size_t size)
 	rec->bytes_written += size;
 }
 
-static void write_output(struct perf_record *rec, void *buf, size_t size)
+static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	while (size) {
 		int ret = write(rec->output, buf, size);
 
-		if (ret < 0)
-			die("failed to write");
+		if (ret < 0) {
+			pr_err("failed to write\n");
+			return -1;
+		}
 
 		size -= ret;
 		buf += ret;
 
 		rec->bytes_written += ret;
 	}
+
+	return 0;
 }
 
 static int process_synthesized_event(struct perf_tool *tool,
@@ -92,11 +96,13 @@ static int process_synthesized_event(struct perf_tool *tool,
 				     struct machine *machine __used)
 {
 	struct perf_record *rec = container_of(tool, struct perf_record, tool);
-	write_output(rec, event, event->header.size);
+	if (write_output(rec, event, event->header.size) < 0)
+		return -1;
+
 	return 0;
 }
 
-static void perf_record__mmap_read(struct perf_record *rec,
+static int perf_record__mmap_read(struct perf_record *rec,
 				   struct perf_mmap *md)
 {
 	unsigned int head = perf_mmap__read_head(md);
@@ -104,9 +110,10 @@ static void perf_record__mmap_read(struct perf_record *rec,
 	unsigned char *data = md->base + rec->page_size;
 	unsigned long size;
 	void *buf;
+	int rc = 0;
 
 	if (old == head)
-		return;
+		return 0;
 
 	rec->samples++;
 
@@ -117,17 +124,26 @@ static void perf_record__mmap_read(struct perf_record *rec,
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		write_output(rec, buf, size);
+		if (write_output(rec, buf, size) < 0) {
+			rc = -1;
+			goto out;
+		}
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	write_output(rec, buf, size);
+	if (write_output(rec, buf, size) < 0) {
+		rc = -1;
+		goto out;
+	}
 
 	md->prev = old;
 	perf_mmap__write_tail(md, old);
+
+out:
+	return rc;
 }
 
 static volatile int done = 0;
@@ -183,12 +199,13 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 	return true;
 }
 
-static void perf_record__open(struct perf_record *rec)
+static int perf_record__open(struct perf_record *rec)
 {
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
 	struct perf_record_opts *opts = &rec->opts;
+	int rc = 0;
 
 	perf_evlist__config_attrs(evlist, opts);
 
@@ -222,10 +239,13 @@ try_again:
 
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
-				exit(EXIT_FAILURE);
+				rc = -err;
+				goto out;
 			} else if (err ==  ENODEV && opts->target.cpu_list) {
-				die("No such device - did you specify"
-					" an out-of-range profile CPU?\n");
+				pr_err("No such device - did you specify"
+				       " an out-of-range profile CPU?\n");
+				rc = -err;
+				goto out;
 			} else if (err == EINVAL) {
 				if (!opts->exclude_guest_missing &&
 				    (attr->exclude_guest || attr->exclude_host)) {
@@ -272,7 +292,8 @@ try_again:
 			if (err == ENOENT) {
 				ui__error("The %s event is not supported.\n",
 					  perf_evsel__name(pos));
-				exit(EXIT_FAILURE);
+				rc = -err;
+				goto out;
 			}
 
 			printf("\n");
@@ -280,34 +301,46 @@ try_again:
 			      err, strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
-			if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
-				die("No hardware sampling interrupt available."
-				    " No APIC? If so then you can boot the kernel"
-				    " with the \"lapic\" boot parameter to"
-				    " force-enable it.\n");
+			if (attr->type == PERF_TYPE_HARDWARE &&
+			    err == EOPNOTSUPP) {
+				pr_err("No hardware sampling interrupt available."
+				       " No APIC? If so then you can boot the kernel"
+				       " with the \"lapic\" boot parameter to"
+				       " force-enable it.\n");
+				rc = -err;
+				goto out;
+			}
 #endif
 
-			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			rc = -err;
+			goto out;
 		}
 	}
 
 	if (perf_evlist__set_filters(evlist)) {
 		error("failed to set filter with %d (%s)\n", errno,
 			strerror(errno));
-		exit(-1);
+		rc = -1;
+		goto out;
 	}
 
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
-		if (errno == EPERM)
-			die("Permission error mapping pages.\n"
-			    "Consider increasing "
-			    "/proc/sys/kernel/perf_event_mlock_kb,\n"
-			    "or try again with a smaller value of -m/--mmap_pages.\n"
-			    "(current value: %d)\n", opts->mmap_pages);
-		else if (!is_power_of_2(opts->mmap_pages))
-			die("--mmap_pages/-m value must be a power of two.");
-
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+		if (errno == EPERM) {
+			pr_err("Permission error mapping pages.\n"
+			       "Consider increasing "
+			       "/proc/sys/kernel/perf_event_mlock_kb,\n"
+			       "or try again with a smaller value of -m/--mmap_pages.\n"
+			       "(current value: %d)\n", opts->mmap_pages);
+			rc = -errno;
+		} else if (!is_power_of_2(opts->mmap_pages)) {
+			pr_err("--mmap_pages/-m value must be a power of two.");
+			rc = -EINVAL;
+		} else {
+			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			rc = -errno;
+		}
+		goto out;
 	}
 
 	if (rec->file_new)
@@ -315,11 +348,14 @@ try_again:
 	else {
 		if (!perf_evlist__equal(session->evlist, evlist)) {
 			fprintf(stderr, "incompatible append\n");
-			exit(-1);
+			rc = -1;
+			goto out;
 		}
  	}
 
 	perf_session__set_id_hdr_size(session);
+out:
+	return rc;
 }
 
 static int process_buildids(struct perf_record *rec)
@@ -335,10 +371,13 @@ static int process_buildids(struct perf_record *rec)
 					      size, &build_id__mark_dso_hit_ops);
 }
 
-static void perf_record__exit(int status __used, void *arg)
+static void perf_record__exit(int status, void *arg)
 {
 	struct perf_record *rec = arg;
 
+	if (status != 0)
+		return;
+
 	if (!rec->opts.pipe_output) {
 		rec->session->header.data_size += rec->bytes_written;
 
@@ -393,17 +432,26 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void perf_record__mmap_read_all(struct perf_record *rec)
+static int perf_record__mmap_read_all(struct perf_record *rec)
 {
 	int i;
+	int rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
-		if (rec->evlist->mmap[i].base)
-			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
+		if (rec->evlist->mmap[i].base) {
+			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
+				rc = -1;
+				goto out;
+			}
+		}
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		write_output(rec, &finished_round_event, sizeof(finished_round_event));
+		rc = write_output(rec, &finished_round_event,
+				  sizeof(finished_round_event));
+
+out:
+	return rc;
 }
 
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
@@ -463,7 +511,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		output = open(output_name, flags, S_IRUSR | S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
-		exit(-1);
+		return -1;
 	}
 
 	rec->output = output;
@@ -503,7 +551,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
-	perf_record__open(rec);
+	if (perf_record__open(rec) != 0) {
+		err = -1;
+		goto out_delete_session;
+	}
 
 	/*
 	 * perf_session__delete(session) will be called at perf_record__exit()
@@ -513,19 +564,20 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (opts->pipe_output) {
 		err = perf_header__write_pipe(output);
 		if (err < 0)
-			return err;
+			goto out_delete_session;
 	} else if (rec->file_new) {
 		err = perf_session__write_header(session, evsel_list,
 						 output, false);
 		if (err < 0)
-			return err;
+			goto out_delete_session;
 	}
 
 	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
 		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
-		return -1;
+		err = -1;
+		goto out_delete_session;
 	}
 
 	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
@@ -533,7 +585,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	machine = perf_session__find_host_machine(session);
 	if (!machine) {
 		pr_err("Couldn't find native kernel information.\n");
-		return -1;
+		err = -1;
+		goto out_delete_session;
 	}
 
 	if (opts->pipe_output) {
@@ -541,14 +594,14 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
-			return err;
+			goto out_delete_session;
 		}
 
 		err = perf_event__synthesize_event_types(tool, process_synthesized_event,
 							 machine);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
-			return err;
+			goto out_delete_session;
 		}
 
 		if (have_tracepoints(&evsel_list->entries)) {
@@ -564,7 +617,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
-				return err;
+				goto out_delete_session;
 			}
 			advance_output(rec, err);
 		}
@@ -592,20 +645,24 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					       perf_event__synthesize_guest_os);
 
 	if (!opts->target.system_wide)
-		perf_event__synthesize_thread_map(tool, evsel_list->threads,
+		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
 	else
-		perf_event__synthesize_threads(tool, process_synthesized_event,
+		err = perf_event__synthesize_threads(tool, process_synthesized_event,
 					       machine);
 
+	if (err != 0)
+		goto out_delete_session;
+
 	if (rec->realtime_prio) {
 		struct sched_param param;
 
 		param.sched_priority = rec->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			pr_err("Could not set realtime priority.\n");
-			exit(-1);
+			err = -1;
+			goto out_delete_session;
 		}
 	}
 
@@ -620,7 +677,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	for (;;) {
 		int hits = rec->samples;
 
-		perf_record__mmap_read_all(rec);
+		if (perf_record__mmap_read_all(rec) < 0) {
+			err = -1;
+			goto out_delete_session;
+		}
 
 		if (hits == rec->samples) {
 			if (done)
