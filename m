Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1EZFFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:05:16 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51488 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1EZFFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:05:11 -0400
X-AuditID: b753bd60-9a3c8ba0000039ed-b9-4dddded59fcf
X-AuditID: b753bd60-9a3c8ba0000039ed-b9-4dddded59fcf
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 4/7] perf branch trace: print file path of the
 executed elf
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
Date: Thu, 26 May 2011 14:03:22 +0900
Message-ID: <20110526050322.30011.58833.stgit@localhost6.localdomain6>
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

Provide the function to print file path to the executed elf.
Users can enable it with option '-e' or '--elfpath'.
For example,
    'perf branch -ae trace'
This command prints address and file path of elf.
And, output is:

address            elf_filepath
0xffffffff81458f4e /lib/modules/2.6.39-rc3-tip+/build/vmlinux => 0x0000003806200b20 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.39-rc3-tip+/build/vmlinux => 0x0000003806200b20 /lib64/ld-2.12.90.so
0x0000003806200b23 /lib64/ld-2.12.90.so             => 0x0000003806204910 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.39-rc3-tip+/build/vmlinux => 0x0000003806204910 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.39-rc3-tip+/build/vmlinux => 0x0000003806204936 /lib64/ld-2.12.90.so
0xffffffff81458f4e /lib/modules/2.6.39-rc3-tip+/build/vmlinux => 0x000000380620493d /lib64/ld-2.12.90.so
0x0000003806204981 /lib64/ld-2.12.90.so             => 0x00000038062049a3 /lib64/ld-2.12.90.so
0x00000038062049a7 /lib64/ld-2.12.90.so             => 0x0000003806204988 /lib64/ld-2.12.90.so
...

Changes in V4
 - support output tsv mode

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
index f3a4e13..b3e5cf33 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -42,6 +42,9 @@ OPTIONS
 -p::
 --pid::
 	Print pid.
+-e::
+--elfpath::
+	Print file path of executed elf.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 6e37c775..0b96461 100644
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
 
 /*
  * It's used when no print item specified.
@@ -99,6 +101,9 @@ static const struct option branch_options[] = {
 	OPT_CALLBACK_DEFAULT_NOOPT('c', "comm", NULL, NULL,
 				   "print command name", set_print_flags,
 				   (void *)EI_FLAG_PRINT_COMM),
+	OPT_CALLBACK_DEFAULT_NOOPT('e', "elfpath", NULL, NULL,
+				   "print file path to elf", set_print_flags,
+				   (void *)EI_FLAG_PRINT_ELFPATH),
 	OPT_END()
 };
 
@@ -134,6 +139,7 @@ static void fill_exec_info(struct exec_info *ei,
 		struct perf_session *session, union perf_event *event, u64 addr)
 {
 	struct thread *thread;
+	struct addr_location al;
 
 	ei->addr = addr;
 	ei->pid = event->ip.pid;
@@ -142,12 +148,26 @@ static void fill_exec_info(struct exec_info *ei,
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
 
 static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
 {
 	char pid[16];
 	const char *comm;
+	const char *elfpath;
 
 	if (ei_print_flags & EI_FLAG_PRINT_PID) {
 		if (ei->pid == EI_PID_UNSET)
@@ -162,6 +182,10 @@ static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
 	}
 	if (ei_print_flags & EI_FLAG_PRINT_ADDR)
 		output_item_addr(ei->addr);
+	if (ei_print_flags & EI_FLAG_PRINT_ELFPATH) {
+		elfpath = ei->elfpath ? : EI_UNKNOWN_TEXT;
+		output_item_str("%-32s ", elfpath);
+	}
 }
 
 static void print_exec_info(struct exec_info *ei_from, struct exec_info *ei_to)
@@ -181,6 +205,8 @@ static void print_exec_info_header(void)
 		output_item_str("%-12s ", "command");
 	if (print_flags & EI_FLAG_PRINT_ADDR)
 		output_item_str("%-" FMT_ADDR_WIDTH "s ", "address");
+	if (print_flags & EI_FLAG_PRINT_ELFPATH)
+		output_item_str("%-32s ", "elf_filepath");
 	printf("\n");
 }
 
@@ -208,6 +234,7 @@ static int process_sample_event(union perf_event *event __unused,
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
 	.comm			= perf_event__process_comm,
+	.mmap			= perf_event__process_mmap,
 	.ordered_samples	= false,
 };
 
@@ -225,6 +252,11 @@ static int __cmd_trace(void)
 	if (is_flags_unset(print_flags & EI_FLAG_REQUIRED))
 		print_flags |= EI_FLAG_PRINT_DEFAULT;
 
+	/* setup kernel maps to resolve vmlinux file path */
+	perf_session__create_kernel_maps(session);
+	if (symbol__init() < 0)
+		fprintf(stderr, "failed to initialize symbol.\n");
+
 	setup_pager();
 	print_exec_info_header();
 	perf_session__process_events(session, &event_ops);

