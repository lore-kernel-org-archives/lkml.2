Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab1CXLbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:31:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38608 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab1CXLbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:31:49 -0400
X-AuditID: b753bd60-a274aba0000001d0-68-4d8b2ba32ba2
X-AuditID: b753bd60-a274aba0000001d0-68-4d8b2ba32ba2
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 3/6] perf branch trace: print pid and command
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 24 Mar 2011 20:32:09 +0900
Message-ID: <20110324113209.20235.61900.stgit@localhost6.localdomain6>
In-Reply-To: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the function to print pid and command name to
'perf branch trace'. Users can select items to print with options.
For example,
    'perf branch -p trace' prints only pid,
    'perf branch -ac trace' prints address and comamnd name.
    'perf branch trace' prints only address (default)

This is output sample (perf branch -ac trace):
command      address
ls           0xffffffff8146fe0e => ls           0x0000003806200b20
ls           0xffffffff8146fe0e => ls           0x0000003806200b20
ls           0x0000003806200b23 => ls           0x0000003806204910
ls           0xffffffff8146fe0e => ls           0x0000003806204910
ls           0xffffffff8146fe0e => ls           0x0000003806204936
ls           0xffffffff8146fe0e => ls           0x000000380620493d
ls           0x0000003806204981 => ls           0x00000038062049a3
ls           0x00000038062049a7 => ls           0x0000003806204988

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |   18 ++++-
 tools/perf/builtin-branch.c              |  119 ++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index e223267..6c9c253 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -3,7 +3,7 @@ perf-branch(1)
 
 NAME
 ----
-perf-branch - Record and print branch-trace-store log
+perf-branch - Record and analyze branch-trace-store log
 
 SYNOPSIS
 --------
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command records and prints a branch-trace-store log.
+This command records and analyzes a branch-trace-store log.
 Branch-trace-store is a facility of processors. It can record
 addresses of from/to which the execution of a program branches,
 at every branch instruction and interrupt.
@@ -20,13 +20,25 @@ at every branch instruction and interrupt.
 'perf branch record <command>' records branch-trace-store log while
 the specified command is executing. And, save to the file "perf.data".
 
-'perf branch trace' parses recorded branch-trace-store log and prints it.
+'perf branch trace' analyzes recorded branch-trace-store log and prints it.
+The command can select the item to print. For example,
+  'perf branch -a trace'	: prints only address
+  'perf branch -acp trace'	: prints address, command name and pid
 
 OPTIONS
 -------
 -i::
 --input=::
         Specify input file name to analyze.
+-a::
+--addr::
+	Print address. (default)
+-c::
+--comm::
+	Print command name.
+-p::
+--pid::
+	Print pid.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 7dbabf4..22aa25e 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -17,6 +17,32 @@
 /* format string to print address */
 #define FMT_ADDR	"%#0" FMT_ADDR_WIDTH "lx"
 
+/* printable items */
+struct exec_info {
+	u64		addr;		/* recorded address by bts */
+	pid_t		pid;		/* tracee process pid */
+	const char	*comm;		/* command name */
+};
+
+#define EI_PID_UNSET	-1
+
+/* flags which item print */
+#define EI_FLAG_PRINT_ADDR		(1 << 0)
+#define EI_FLAG_PRINT_PID		(1 << 1)
+#define EI_FLAG_PRINT_COMM		(1 << 2)
+
+/* it's used when no print item specified */
+#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
+
+/* print item flags */
+static unsigned long print_flags;
+
+#define is_flags_unset(flags)		(flags == 0)
+
+/* print it when we cannnot analyze and get the information */
+#define EI_UNKNOWN_TEXT			"(unknown)"
+#define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
+
 /* default input file name to analyze */
 static const char *input_name = "perf.data";
 
@@ -34,8 +60,25 @@ static const char * const record_args[] = {
 	"-d",
 };
 
+/* set print flags call from parse_options() */
+static int set_print_flags(const struct option *opt, const char *str __unused,
+							int unset __unused)
+{
+	print_flags |= (unsigned long)opt->defval;
+	return 0;
+}
+
 static const struct option branch_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_CALLBACK_DEFAULT_NOOPT('a', "addr", NULL, NULL,
+				   "print address (default)", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ADDR),
+	OPT_CALLBACK_DEFAULT_NOOPT('p', "pid", NULL, NULL,
+				   "print pid", set_print_flags,
+				   (void *)EI_FLAG_PRINT_PID),
+	OPT_CALLBACK_DEFAULT_NOOPT('c', "comm", NULL, NULL,
+				   "print command name", set_print_flags,
+				   (void *)EI_FLAG_PRINT_COMM),
 	OPT_END()
 };
 
@@ -60,20 +103,89 @@ static bool is_bts_sample(struct perf_sample *sample,
 	return is_bts_event(evsel);
 }
 
+static void init_exec_info(struct exec_info *ei)
+{
+	memset(ei, 0, sizeof(*ei));
+	ei->pid = EI_PID_UNSET;
+}
+
+/* collect printable items to struct exec_info */
+static void fill_exec_info(struct exec_info *ei,
+		struct perf_session *session, union perf_event *event, u64 addr)
+{
+	struct thread *thread;
+
+	ei->addr = addr;
+	ei->pid = event->ip.pid;
+
+	thread = perf_session__findnew(session, event->ip.pid);
+	if (!thread)
+		return;
+	ei->comm = thread->comm;
+}
+
+static void __print_exec_info(struct exec_info *ei)
+{
+	char pid[16];
+	const char *comm;
+
+	if (print_flags & EI_FLAG_PRINT_PID) {
+		if (ei->pid == EI_PID_UNSET)
+			strncpy(pid, EI_UNKNOWN_TEXT, EI_UNKNOWN_TEXT_LEN);
+		else
+			snprintf(pid, 16, "%d", ei->pid);
+		printf("%5s ", pid);
+	}
+	if (print_flags & EI_FLAG_PRINT_COMM) {
+		comm = ei->comm ? : EI_UNKNOWN_TEXT;
+		printf("%-12s ", comm);
+	}
+	if (print_flags & EI_FLAG_PRINT_ADDR)
+		printf(FMT_ADDR " ", ei->addr);
+}
+
+static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
+{
+	__print_exec_info(ei_from);
+	printf("=> ");
+	__print_exec_info(ei_to);
+	printf("\n");
+}
+
+static void print_exec_info_header(void)
+{
+	if (print_flags & EI_FLAG_PRINT_PID)
+		printf("%5s ", "pid");
+	if (print_flags & EI_FLAG_PRINT_COMM)
+		printf("%-12s ", "command");
+	if (print_flags & EI_FLAG_PRINT_ADDR)
+		printf("%-" FMT_ADDR_WIDTH "s ", "address");
+	printf("\n");
+}
+
 static int process_sample_event(union perf_event *event __unused,
 		struct perf_sample *sample, struct perf_session *session)
 {
+	struct exec_info ei_from, ei_to;
+
 	if (!is_bts_sample(sample, session))
 		return 0;
 
+	init_exec_info(&ei_from);
+	init_exec_info(&ei_to);
+
 	/* sample->ip is 'from address', sample->addr is 'to address' */
-	printf(FMT_ADDR " => " FMT_ADDR "\n", sample->ip, sample->addr);
+	fill_exec_info(&ei_from, session, event, sample->ip);
+	fill_exec_info(&ei_to, session, event, sample->addr);
+
+	print_exec_info(&ei_from, &ei_to);
 
 	return 0;
 }
 
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
+	.comm			= perf_event__process_comm,
 	.ordered_samples	= false,
 };
 
@@ -87,7 +199,12 @@ static int __cmd_trace(void)
 		return EXIT_FAILURE;
 	}
 
+	/* if print flags are unset, we use default flags */
+	if (is_flags_unset(print_flags))
+		print_flags = EI_FLAG_PRINT_DEFAULT;
+
 	setup_pager();
+	print_exec_info_header();
 	perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 

