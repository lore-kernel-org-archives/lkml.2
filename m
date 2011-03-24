Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1CXLb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:31:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38626 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab1CXLb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:31:56 -0400
X-AuditID: b753bd60-9d955ba000007e19-bf-4d8b2ba9f959
X-AuditID: b753bd60-9d955ba000007e19-bf-4d8b2ba9f959
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 4/6] perf branch trace: print file path of the
 executed elf
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
Date: Thu, 24 Mar 2011 20:32:25 +0900
Message-ID: <20110324113225.20235.35934.stgit@localhost6.localdomain6>
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

Provide the function to print file path to the executed elf.
Users can enable it with option '-e' or '--elfpath'.
For example,
    'perf branch -ae trace'
This command prints address and file path of elf.
And, output is:

address            elf_filepath
0xffffffff81458f4e /lib/modules/2.6.38-rc8-tip+/build/vmlinux => 0x0000003806200b20 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.38-rc8-tip+/build/vmlinux => 0x0000003806200b20 /lib64/ld-2.12.90.so
0x0000003806200b23 /lib64/ld-2.12.90.so             => 0x0000003806204910 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.38-rc8-tip+/build/vmlinux => 0x0000003806204910 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.38-rc8-tip+/build/vmlinux => 0x0000003806204936 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.38-rc8-tip+/build/vmlinux => 0x000000380620493d /lib64/ld-2.12.90.so
0x0000003806204981 /lib64/ld-2.12.90.so             => 0x00000038062049a3 /lib64/ld-2.12.90.so
0x00000038062049a7 /lib64/ld-2.12.90.so             => 0x0000003806204988 /lib64/ld-2.12.90.so
...

Changes in V3:
 - Update to latest -tip tree

Changes in V2:
 - add comment

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |    3 +++
 tools/perf/builtin-branch.c              |   32 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index 6c9c253..f98b32e 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -39,6 +39,9 @@ OPTIONS
 -p::
 --pid::
 	Print pid.
+-e::
+--elfpath::
+	Print file path of executed elf.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 22aa25e..3d8a9c5 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -22,6 +22,7 @@ struct exec_info {
 	u64		addr;		/* recorded address by bts */
 	pid_t		pid;		/* tracee process pid */
 	const char	*comm;		/* command name */
+	const char	*elfpath;	/* file path to elf */
 };
 
 #define EI_PID_UNSET	-1
@@ -30,6 +31,7 @@ struct exec_info {
 #define EI_FLAG_PRINT_ADDR		(1 << 0)
 #define EI_FLAG_PRINT_PID		(1 << 1)
 #define EI_FLAG_PRINT_COMM		(1 << 2)
+#define EI_FLAG_PRINT_ELFPATH		(1 << 3)
 
 /* it's used when no print item specified */
 #define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
@@ -79,6 +81,9 @@ static const struct option branch_options[] = {
 	OPT_CALLBACK_DEFAULT_NOOPT('c', "comm", NULL, NULL,
 				   "print command name", set_print_flags,
 				   (void *)EI_FLAG_PRINT_COMM),
+	OPT_CALLBACK_DEFAULT_NOOPT('e', "elfpath", NULL, NULL,
+				   "print file path to elf", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ELFPATH),
 	OPT_END()
 };
 
@@ -114,6 +119,7 @@ static void fill_exec_info(struct exec_info *ei,
 		struct perf_session *session, union perf_event *event, u64 addr)
 {
 	struct thread *thread;
+	struct addr_location al;
 
 	ei->addr = addr;
 	ei->pid = event->ip.pid;
@@ -122,12 +128,26 @@ static void fill_exec_info(struct exec_info *ei,
 	if (!thread)
 		return;
 	ei->comm = thread->comm;
+
+	/* get file path to elf */
+	memset(&al, 0, sizeof(al));
+	thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
+			      MAP__FUNCTION, event->ip.pid, addr, &al);
+	if (!al.map)
+		thread__find_addr_map(thread, session, PERF_RECORD_MISC_KERNEL,
+				      MAP__FUNCTION, event->ip.pid, addr, &al);
+	if (!al.map)
+		return;
+	/* resolve vmlinux path */
+	map__load(al.map, NULL);
+	ei->elfpath = al.map->dso->long_name;
 }
 
 static void __print_exec_info(struct exec_info *ei)
 {
 	char pid[16];
 	const char *comm;
+	const char *elfpath;
 
 	if (print_flags & EI_FLAG_PRINT_PID) {
 		if (ei->pid == EI_PID_UNSET)
@@ -142,6 +162,10 @@ static void __print_exec_info(struct exec_info *ei)
 	}
 	if (print_flags & EI_FLAG_PRINT_ADDR)
 		printf(FMT_ADDR " ", ei->addr);
+	if (print_flags & EI_FLAG_PRINT_ELFPATH) {
+		elfpath = ei->elfpath ? : EI_UNKNOWN_TEXT;
+		printf("%-32s ", elfpath);
+	}
 }
 
 static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
@@ -160,6 +184,8 @@ static void print_exec_info_header(void)
 		printf("%-12s ", "command");
 	if (print_flags & EI_FLAG_PRINT_ADDR)
 		printf("%-" FMT_ADDR_WIDTH "s ", "address");
+	if (print_flags & EI_FLAG_PRINT_ELFPATH)
+		printf("%-32s ", "elf_filepath");
 	printf("\n");
 }
 
@@ -186,6 +212,7 @@ static int process_sample_event(union perf_event *event __unused,
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
 	.comm			= perf_event__process_comm,
+	.mmap			= perf_event__process_mmap,
 	.ordered_samples	= false,
 };
 
@@ -203,6 +230,11 @@ static int __cmd_trace(void)
 	if (is_flags_unset(print_flags))
 		print_flags = EI_FLAG_PRINT_DEFAULT;
 
+	/* setup kernel maps to resolve vmlinux file path */
+	perf_session__create_kernel_maps(session);
+	if (symbol__init() < 0)
+		fprintf(stderr, "failed to initialize symbol.\n");
+
 	setup_pager();
 	print_exec_info_header();
 	perf_session__process_events(session, &event_ops);

