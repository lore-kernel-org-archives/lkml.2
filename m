Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0LUJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:05:27 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55148 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab0LUJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:05:08 -0500
X-AuditID: b753bd60-a7da7ba000003e7d-24-4d106dc1629e
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 3/6] perf bts trace: print pid and command
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
Date: Tue, 21 Dec 2010 18:05:56 +0900
Message-ID: <20101221090556.8552.22624.stgit@localhost6.localdomain6>
In-Reply-To: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the function of printing pid and command name to
'perf bts trace'. Users can select items to print with options.
For example,
    'perf bts -p trace' prints only pid,
    'perf bts -ac trace' prints address and comamnd name.
    'perf bts trace' prints only address (default)

This is output sample (perf bts -ac trace):
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

 tools/perf/Documentation/perf-bts.txt |   18 ++++-
 tools/perf/builtin-bts.c              |  128 +++++++++++++++++++++++++++++++--
 2 files changed, 137 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
index 5920dcc..56ddaa4 100644
--- a/tools/perf/Documentation/perf-bts.txt
+++ b/tools/perf/Documentation/perf-bts.txt
@@ -3,7 +3,7 @@ perf-bts(1)
 
 NAME
 ----
-perf-bts - Record and print branch-trace-store log
+perf-bts - Record and analyze branch-trace-store log
 
 SYNOPSIS
 --------
@@ -12,20 +12,32 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command can record and print branch-trace-store log.
+This command can record and analyze branch-trace-store log.
 Branch-trace-store is a facility of processors. It can record
 address of branch to/from on every branch instruction and interrupt.
 
 'perf bts record <command>' records branch-trace-store log while specified
 command is executing. And, save to the file "perf.data".
 
-'perf bts trace' parses recorded branch-trace-store log and prints it.
+'perf bts trace' analyzes recorded branch-trace-store log and prints it.
+The command can select the item to print. For example,
+  'perf bts -a trace'	: prints only address
+  'perf bts -acp trace'	: prints address, command name and pid
 
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
diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
index 0d546d8..525bcd3 100644
--- a/tools/perf/builtin-bts.c
+++ b/tools/perf/builtin-bts.c
@@ -15,6 +15,32 @@
 /* format string to print address */
 #define FMT_ADDR	"%#0" FMT_ADDR_WIDTH "llx"
 
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
 
@@ -32,22 +58,108 @@ static const char * const record_args[] = {
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
 static const struct option bts_options[] = {
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
 
-static int process_sample_event(event_t *event __unused,
-	struct sample_data *sample, struct perf_session *session __unused)
+static void init_exec_info(struct exec_info *ei)
+{
+	memset(ei, 0, sizeof(*ei));
+	ei->pid = EI_PID_UNSET;
+}
+
+/* collect printable items to struct exec_info */
+static void fill_exec_info(struct exec_info *ei, struct perf_session *session,
+						event_t *event, u64 addr)
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
 {
+	if (print_flags & EI_FLAG_PRINT_PID)
+		printf("%5s ", "pid");
+	if (print_flags & EI_FLAG_PRINT_COMM)
+		printf("%-12s ", "command");
+	if (print_flags & EI_FLAG_PRINT_ADDR)
+		printf("%-" FMT_ADDR_WIDTH "s ", "address");
+	printf("\n");
+}
+
+static int process_sample_event(event_t *event, struct sample_data *sample,
+						struct perf_session *session)
+{
+	struct exec_info ei_from, ei_to;
+
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
+	.comm			= event__process_comm,
 	.ordered_samples	= false,
 };
 
@@ -61,6 +173,12 @@ static int __cmd_trace(void)
 		return -ENOMEM;
 	}
 
+	/* if print flags are unset, we use default flags */
+	if (is_flags_unset(print_flags))
+		print_flags = EI_FLAG_PRINT_DEFAULT;
+
+	setup_pager();
+	print_exec_info_header();
 	perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 
@@ -101,10 +219,8 @@ int cmd_bts(int argc, const char **argv, const char *prefix __used)
 
 	if (!strncmp(argv[0], "record", 6))
 		return __cmd_record(argc, argv);
-	else if (!strncmp(argv[0], "trace", 5)) {
-		setup_pager();
+	else if (!strncmp(argv[0], "trace", 5))
 		return __cmd_trace();
-	}
 	else
 		usage_with_options(bts_usage, bts_options);
 

