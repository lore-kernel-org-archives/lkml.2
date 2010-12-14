Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0LNFrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:47:06 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60078 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0LNFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:47:05 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Miao Xie <miaox@cn.fujitsu.com>,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 1/2] perf stat: wait on unix domain socket before calling sys_perf_event_open()
Date: Tue, 14 Dec 2010 14:46:58 +0900
Message-Id: <1292305619-29627-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <4D0659D6.7000803@dcl.info.waseda.ac.jp>
References: <4D0659D6.7000803@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new option "--wait-on" option to perf stat.

Current perf stat can monitor
 1) lifetime of program specified as command line argument, or
 2) lifetime of perf stat. Target process is specified with pid,
    and end of monitoring is triggered with signal.
1) is too coarse grain. And 2) is difficult to distinguish the range to monitor.

This patch makes it possible to wait before sys_perf_event_open().
Monitored process can wake up perf stat via unix domain socket,
and terminate monitoring via signal.

New option --wait-on requires the string as the path of unix domain socket.
perf stat read the pid from the socket for target_pid. Monitored program
should write the pid of itself to it.
perf stat replies the pid of itself to monitored program. The monitored program
should send signal SIGINT to perf stat with this pid. Then monitoring is terminated.

I feel current implementation is really dirty. As Arnaldo and Peter suggested,
more unified way like interception or self monitoring library is ideal.
This is the proof of concept version. I'd like to hear your comments.

Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-stat.c |   63 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7ff746d..4cc10a1 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -51,6 +51,8 @@
 #include <sys/prctl.h>
 #include <math.h>
 #include <locale.h>
+#include <sys/socket.h>
+#include <sys/un.h>
 
 #define DEFAULT_SEPARATOR	" "
 
@@ -90,11 +92,15 @@ static const char		*cpu_list;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
 
+static const char		*wait_path;
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			event_scaled[MAX_COUNTERS];
 
+static int			wait_fd				= -1;
+static struct sockaddr_un	wait_addr;
+
 static struct {
 	u64 val;
 	u64 ena;
@@ -342,7 +348,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	unsigned long long t0, t1;
 	int status = 0;
 	int counter, ncreated = 0;
-	int child_ready_pipe[2], go_pipe[2];
+	int child_ready_pipe[2], go_pipe[2], accepted_fd;
 	bool perm_err = false;
 	const bool forks = (argc > 0);
 	char buf;
@@ -401,6 +407,43 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	if (wait_path) {
+		int sock_err;
+		struct sockaddr accepted_addr;
+		socklen_t accepted_len = sizeof(accepted_addr);
+
+		wait_fd = socket(PF_UNIX, SOCK_STREAM, 0);
+		if (wait_fd < 0)
+			die("unable to create socket for sync\n");
+
+		memset(&wait_addr, 0, sizeof(wait_addr));
+		wait_addr.sun_family = PF_UNIX;
+		strncpy(wait_addr.sun_path, wait_path,
+			sizeof(wait_addr.sun_path));
+
+		sock_err = bind(wait_fd, (struct sockaddr *)&wait_addr,
+				sizeof(wait_addr));
+		if (sock_err < 0)
+			die("bind() failed\n");
+
+		sock_err = listen(wait_fd, 1);
+		if (sock_err < 0)
+			die("listen() failed\n");
+
+		accepted_fd = accept(wait_fd, &accepted_addr, &accepted_len);
+		if (accepted_fd < 0)
+			die("accept() failed\n");
+
+		if (read(accepted_fd, &target_pid, sizeof(target_pid))
+			!= sizeof(target_pid))
+			die("read() pid from socket failed\n");
+
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0)
+			die("couldn't find threads of %d\n", target_pid);
+	}
+
 	for (counter = 0; counter < nr_counters; counter++)
 		ncreated += create_perf_stat_counter(counter, &perm_err);
 
@@ -425,6 +468,14 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(go_pipe[1]);
 		wait(&status);
 	} else {
+		if (wait_path) {
+			pid_t myself = getpid();
+			if (write(accepted_fd, &myself, sizeof(myself))
+				!= sizeof(myself))
+				die("write() my pid failed\n");
+			close(accepted_fd);
+		}
+
 		while(!done) sleep(1);
 	}
 
@@ -670,6 +721,9 @@ static void sig_atexit(void)
 	if (signr == -1)
 		return;
 
+	if (wait_path)
+		unlink(wait_path);
+
 	signal(signr, SIG_DFL);
 	kill(getpid(), signr);
 }
@@ -715,6 +769,8 @@ static const struct option options[] = {
 		    "disable CPU count aggregation"),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
+	OPT_STRING('w', "wait-on", &wait_path, "path",
+		   "path of unix domain socket to wait on"),
 	OPT_END()
 };
 
@@ -746,7 +802,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && target_pid == -1 && target_tid == -1)
+	if (!argc && target_pid == -1 && target_tid == -1 && !wait_path)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
@@ -769,7 +825,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (nr_cpus < 1)
 		usage_with_options(stat_usage, options);
 
-	if (target_pid != -1) {
+	/* if wait_path is specified, we read pid to monitor from it later */
+	if (target_pid != -1 && !wait_path) {
 		target_tid = target_pid;
 		thread_num = find_all_tid(target_pid, &all_tids);
 		if (thread_num <= 0) {
-- 
1.7.3.3

