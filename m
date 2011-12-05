Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1LEMso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:48:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1LEMsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:48:43 -0500
Date: Mon, 5 Dec 2011 04:47:46 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-zdsksd4aphu0nltg2lpwsw3x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Introduce {prepare,start}_workload refactored from 'perf record'
Git-Commit-ID: 35b9d88ecd8c5fb720ba0dd325262f356d0b03e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:47:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35b9d88ecd8c5fb720ba0dd325262f356d0b03e7
Gitweb:     http://git.kernel.org/tip/35b9d88ecd8c5fb720ba0dd325262f356d0b03e7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 9 Nov 2011 08:47:15 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:26:14 -0200

perf evlist: Introduce {prepare,start}_workload refactored from 'perf record'

So that we can easily start a workload in other tools.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zdsksd4aphu0nltg2lpwsw3x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   81 ++++++------------------------------
 tools/perf/perf.h           |    1 +
 tools/perf/util/evlist.c    |   96 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h    |   10 ++++
 4 files changed, 120 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c3ac541..4799195 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -47,11 +47,9 @@ static struct perf_record_opts record_opts = {
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= UINT_MAX;
 static int			output;
-static int			pipe_output			=      0;
 static const char		*output_name			= NULL;
 static bool			group				=  false;
 static int			realtime_prio			=      0;
-static pid_t			child_pid			=     -1;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
@@ -144,9 +142,9 @@ static void sig_atexit(void)
 {
 	int status;
 
-	if (child_pid > 0) {
+	if (evsel_list->workload.pid > 0) {
 		if (!child_finished)
-			kill(child_pid, SIGTERM);
+			kill(evsel_list->workload.pid, SIGTERM);
 
 		wait(&status);
 		if (WIFSIGNALED(status))
@@ -304,7 +302,7 @@ static int process_buildids(void)
 
 static void atexit_header(void)
 {
-	if (!pipe_output) {
+	if (!record_opts.pipe_output) {
 		session->header.data_size += bytes_written;
 
 		if (!no_buildid)
@@ -377,9 +375,7 @@ static int __cmd_record(int argc, const char **argv)
 	int flags;
 	int err;
 	unsigned long waking = 0;
-	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = argc > 0;
-	char buf;
 	struct machine *machine;
 
 	progname = argv[0];
@@ -391,20 +387,15 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 
-	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
-		perror("failed to create pipes");
-		exit(-1);
-	}
-
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			pipe_output = true;
+			record_opts.pipe_output = true;
 		else
 			output_name = "perf.data";
 	}
 	if (output_name) {
 		if (!strcmp(output_name, "-"))
-			pipe_output = true;
+			record_opts.pipe_output = true;
 		else if (!stat(output_name, &st) && st.st_size) {
 			if (write_mode == WRITE_FORCE) {
 				char oldname[PATH_MAX];
@@ -424,7 +415,7 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		flags |= O_TRUNC;
 
-	if (pipe_output)
+	if (record_opts.pipe_output)
 		output = STDOUT_FILENO;
 	else
 		output = open(output_name, flags, S_IRUSR | S_IWUSR);
@@ -470,57 +461,11 @@ static int __cmd_record(int argc, const char **argv)
 		mmap_pages = (512 * 1024) / page_size;
 
 	if (forks) {
-		child_pid = fork();
-		if (child_pid < 0) {
-			perror("failed to fork");
-			exit(-1);
-		}
-
-		if (!child_pid) {
-			if (pipe_output)
-				dup2(2, 1);
-			close(child_ready_pipe[0]);
-			close(go_pipe[1]);
-			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
-
-			/*
-			 * Do a dummy execvp to get the PLT entry resolved,
-			 * so we avoid the resolver overhead on the real
-			 * execvp call.
-			 */
-			execvp("", (char **)argv);
-
-			/*
-			 * Tell the parent we're ready to go
-			 */
-			close(child_ready_pipe[1]);
-
-			/*
-			 * Wait until the parent tells us to go.
-			 */
-			if (read(go_pipe[0], &buf, 1) == -1)
-				perror("unable to read pipe");
-
-			execvp(argv[0], (char **)argv);
-
-			perror(argv[0]);
-			kill(getppid(), SIGUSR1);
-			exit(-1);
-		}
-
-		if (!record_opts.system_wide && record_opts.target_tid == -1 && record_opts.target_pid == -1)
-			evsel_list->threads->map[0] = child_pid;
-
-		close(child_ready_pipe[1]);
-		close(go_pipe[0]);
-		/*
-		 * wait for child to settle
-		 */
-		if (read(child_ready_pipe[0], &buf, 1) == -1) {
-			perror("unable to read pipe");
-			exit(-1);
+		err = perf_evlist__prepare_workload(evsel_list, &record_opts, argv);
+		if (err < 0) {
+			pr_err("Couldn't run the workload!\n");
+			goto out_delete_session;
 		}
-		close(child_ready_pipe[0]);
 	}
 
 	open_counters(evsel_list);
@@ -530,7 +475,7 @@ static int __cmd_record(int argc, const char **argv)
 	 */
 	atexit(atexit_header);
 
-	if (pipe_output) {
+	if (record_opts.pipe_output) {
 		err = perf_header__write_pipe(output);
 		if (err < 0)
 			return err;
@@ -543,7 +488,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
-	if (pipe_output) {
+	if (record_opts.pipe_output) {
 		err = perf_session__synthesize_attrs(session,
 						     process_synthesized_event);
 		if (err < 0) {
@@ -629,7 +574,7 @@ static int __cmd_record(int argc, const char **argv)
 	 * Let the child rip
 	 */
 	if (forks)
-		close(go_pipe[1]);
+		perf_evlist__start_workload(evsel_list);
 
 	for (;;) {
 		int hits = samples;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index eb6a138..32ee6ca 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -193,6 +193,7 @@ struct perf_record_opts {
 	bool	     no_delay;
 	bool	     no_inherit;
 	bool	     no_samples;
+	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_time;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b774341..a472247 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -13,6 +13,7 @@
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
+#include <unistd.h>
 
 #include "parse-events.h"
 
@@ -33,6 +34,7 @@ void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		INIT_HLIST_HEAD(&evlist->heads[i]);
 	INIT_LIST_HEAD(&evlist->entries);
 	perf_evlist__set_maps(evlist, cpus, threads);
+	evlist->workload.pid = -1;
 }
 
 struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
@@ -674,3 +676,97 @@ out_err:
 
 	return err;
 }
+
+int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_record_opts *opts,
+				  const char *argv[])
+{
+	int child_ready_pipe[2], go_pipe[2];
+	char bf;
+
+	if (pipe(child_ready_pipe) < 0) {
+		perror("failed to create 'ready' pipe");
+		return -1;
+	}
+
+	if (pipe(go_pipe) < 0) {
+		perror("failed to create 'go' pipe");
+		goto out_close_ready_pipe;
+	}
+
+	evlist->workload.pid = fork();
+	if (evlist->workload.pid < 0) {
+		perror("failed to fork");
+		goto out_close_pipes;
+	}
+
+	if (!evlist->workload.pid) {
+		if (opts->pipe_output)
+			dup2(2, 1);
+
+		close(child_ready_pipe[0]);
+		close(go_pipe[1]);
+		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+		/*
+		 * Do a dummy execvp to get the PLT entry resolved,
+		 * so we avoid the resolver overhead on the real
+		 * execvp call.
+		 */
+		execvp("", (char **)argv);
+
+		/*
+		 * Tell the parent we're ready to go
+		 */
+		close(child_ready_pipe[1]);
+
+		/*
+		 * Wait until the parent tells us to go.
+		 */
+		if (read(go_pipe[0], &bf, 1) == -1)
+			perror("unable to read pipe");
+
+		execvp(argv[0], (char **)argv);
+
+		perror(argv[0]);
+		kill(getppid(), SIGUSR1);
+		exit(-1);
+	}
+
+	if (!opts->system_wide && opts->target_tid == -1 && opts->target_pid == -1)
+		evlist->threads->map[0] = evlist->workload.pid;
+
+	close(child_ready_pipe[1]);
+	close(go_pipe[0]);
+	/*
+	 * wait for child to settle
+	 */
+	if (read(child_ready_pipe[0], &bf, 1) == -1) {
+		perror("unable to read pipe");
+		goto out_close_pipes;
+	}
+
+	evlist->workload.cork_fd = go_pipe[1];
+	close(child_ready_pipe[0]);
+	return 0;
+
+out_close_pipes:
+	close(go_pipe[0]);
+	close(go_pipe[1]);
+out_close_ready_pipe:
+	close(child_ready_pipe[0]);
+	close(child_ready_pipe[1]);
+	return -1;
+}
+
+int perf_evlist__start_workload(struct perf_evlist *evlist)
+{
+	if (evlist->workload.cork_fd > 0) {
+		/*
+		 * Remove the cork, let it rip!
+		 */
+		return close(evlist->workload.cork_fd);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 231c06f..07d56b3 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -6,6 +6,7 @@
 #include "../perf.h"
 #include "event.h"
 #include "util.h"
+#include <unistd.h>
 
 struct pollfd;
 struct thread_map;
@@ -22,6 +23,10 @@ struct perf_evlist {
 	int		 nr_fds;
 	int		 nr_mmaps;
 	int		 mmap_len;
+	struct {
+		int	cork_fd;
+		pid_t	pid;
+	} workload;
 	bool		 overwrite;
 	union perf_event event_copy;
 	struct perf_mmap *mmap;
@@ -68,6 +73,11 @@ int perf_evlist__open(struct perf_evlist *evlist, bool group);
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts);
 
+int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_record_opts *opts,
+				  const char *argv[]);
+int perf_evlist__start_workload(struct perf_evlist *evlist);
+
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
