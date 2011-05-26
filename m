Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1EZFEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:25 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51313 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1EZFEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:21 -0400
X-AuditID: b753bd60-a32aeba0000019f4-8f-4dddded01fb4
X-AuditID: b753bd60-a32aeba0000019f4-8f-4dddded01fb4
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 3/7] perf branch trace: print pid and command
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 26 May 2011 14:03:16 +0900
Message-ID: <20110526050316.30011.99813.stgit@localhost6.localdomain6>
In-Reply-To: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
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
ls           0xffffffff8146fe0e => 0x0000003806200b20
ls           0xffffffff8146fe0e => 0x0000003806200b20
ls           0x0000003806200b23 => 0x0000003806204910
ls           0xffffffff8146fe0e => 0x0000003806204910
ls           0xffffffff8146fe0e => 0x0000003806204936
ls           0xffffffff8146fe0e => 0x000000380620493d
ls           0x0000003806204981 => 0x00000038062049a3
ls           0x00000038062049a7 => 0x0000003806204988

Pid and command are never changed between branch_to and branch_from.
So perf branch prints them only branch_from field.

Changes in V4
 - comm and pid are only printed in branch_from field
 - support output tsv mode

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |   18 +++-
 tools/perf/builtin-branch.c              |  138 +++++++++++++++++++++++++++++-
 2 files changed, 148 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index 15ee496..f3a4e13 100644
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
@@ -20,7 +20,10 @@ at every branch instruction and interrupt.
 'perf branch record <command>' records branch-trace-store log while
 the specified command is executing. And, save to the file "perf.data".
 
-'perf branch trace' parses recorded branch-trace-store log and prints it.
+'perf branch trace' analyzes recorded branch-trace-store log and prints it.
+The command can select the item to print. For example,
+  'perf branch -a trace'	: prints only address
+  'perf branch -acp trace'	: prints address, command name and pid
 
 OPTIONS
 -------
@@ -30,6 +33,15 @@ OPTIONS
 -t::
 --tsv::
 	Output TSV format.
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
index 5b0297e..6e37c775 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -17,6 +17,45 @@
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
+/*
+ * It's used when no print item specified.
+ * It must be selected from EI_FLAG_REQUIRED.
+ */
+#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
+
+/* the flags must be printed at least. */
+#define EI_FLAG_REQUIRED		EI_FLAG_PRINT_ADDR
+
+/*
+ * The items which are not printed in branch_to field.
+ * Currently, Pid and command are never changed between branch_to and
+ * branch_from. So, don't print them in branch_to field.
+ */
+#define EI_MASK_BRANCH_TO	(~(EI_FLAG_PRINT_COMM | EI_FLAG_PRINT_PID))
+
+/* print item flags */
+static unsigned long print_flags;
+
+#define is_flags_unset(flags)		((flags) == 0)
+
+/* print it when we cannnot analyze and get the information */
+#define EI_UNKNOWN_TEXT			"(unknown)"
+#define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
+
 /* default input file name to analyze */
 static const char *input_name		= "perf.data";
 
@@ -24,6 +63,7 @@ static const char *input_name		= "perf.data";
 static bool output_tsv;
 #define output_item_addr(addr)		printf(output_tsv ? FMT_ADDR "\t" : \
 							    FMT_ADDR " ", addr)
+#define output_item_str(fmt, str)	printf(output_tsv ? "%s\t" : fmt, str)
 
 static const char * const branch_usage[] = {
 	"perf branch [<options>] {record|trace}",
@@ -39,9 +79,26 @@ static const char * const record_args[] = {
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
 	OPT_BOOLEAN('t', "tsv", &output_tsv, "output tsv format"),
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
 
@@ -66,25 +123,91 @@ static bool is_bts_sample(struct perf_sample *sample,
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
+static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
+{
+	char pid[16];
+	const char *comm;
+
+	if (ei_print_flags & EI_FLAG_PRINT_PID) {
+		if (ei->pid == EI_PID_UNSET)
+			strncpy(pid, EI_UNKNOWN_TEXT, EI_UNKNOWN_TEXT_LEN);
+		else
+			snprintf(pid, 16, "%d", ei->pid);
+		output_item_str("%5s ", pid);
+	}
+	if (ei_print_flags & EI_FLAG_PRINT_COMM) {
+		comm = ei->comm ? : EI_UNKNOWN_TEXT;
+		output_item_str("%-12s ", comm);
+	}
+	if (ei_print_flags & EI_FLAG_PRINT_ADDR)
+		output_item_addr(ei->addr);
+}
+
+static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
+{
+	__print_exec_info(ei_from, print_flags);
+	if (!output_tsv)
+		printf("=> ");
+	__print_exec_info(ei_to, print_flags & EI_MASK_BRANCH_TO);
+	printf("\n");
+}
+
+static void print_exec_info_header(void)
+{
+	if (print_flags & EI_FLAG_PRINT_PID)
+		output_item_str("%5s ", "pid");
+	if (print_flags & EI_FLAG_PRINT_COMM)
+		output_item_str("%-12s ", "command");
+	if (print_flags & EI_FLAG_PRINT_ADDR)
+		output_item_str("%-" FMT_ADDR_WIDTH "s ", "address");
+	printf("\n");
+}
+
 static int process_sample_event(union perf_event *event __unused,
 		struct perf_sample *sample, struct perf_evsel *evsel __unused,
 		struct perf_session *session)
 {
+	struct exec_info ei_from, ei_to;
+
 	if (!is_bts_sample(sample, session))
 		return 0;
 
+	init_exec_info(&ei_from);
+	init_exec_info(&ei_to);
+
 	/* sample->ip is 'from address', sample->addr is 'to address' */
-	output_item_addr(sample->ip);
-	if (!output_tsv)
-		printf("=> ");
-	output_item_addr(sample->addr);
-	printf("\n");
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
 
@@ -98,7 +221,12 @@ static int __cmd_trace(void)
 		return EXIT_FAILURE;
 	}
 
+	/* To avoid meaningless output, we add default printable item. */
+	if (is_flags_unset(print_flags & EI_FLAG_REQUIRED))
+		print_flags |= EI_FLAG_PRINT_DEFAULT;
+
 	setup_pager();
+	print_exec_info_header();
 	perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 

