Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1EZFEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:37 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51317 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1EZFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:35 -0400
X-AuditID: b753bd60-a1eacba0000019f4-ec-4ddddedbd363
X-AuditID: b753bd60-a1eacba0000019f4-ec-4ddddedbd363
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 5/7] perf branch trace: print function+offset
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
Date: Thu, 26 May 2011 14:03:28 +0900
Message-ID: <20110526050328.30011.28344.stgit@localhost6.localdomain6>
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

Provide the function to print function+offset.
And, set it as the default behavior of 'perf branch trace'.
To use this function, users can also specify the option '-s' or '--symbol'.

Example: 'perf branch -as trace'
This command prints address and function+offset.

Output sample:
address            function+offset
0xffffffff8146fe0e irq_return+0x0         => 0x00007fd4038e3b20 _start+0x0
...
0x000000380661ee79 __libc_start_main+0xf9 => 0x00000000004035c3 main+0x0
0xffffffff8146ef4e irq_return+0x0         => 0x00000000004035c3 main+0x0
0x00000000004035e8 main+0x25              => 0x000000000040bca0 set_program_name+0x0
0xffffffff8146ef4e irq_return+0x0         => 0x000000000040bca0 set_program_name+0x0
0x000000000040bcae set_program_name+0xe   => 0x00000000004023d0 strrchr@plt+0x0
0x00000000004023d0 strrchr@plt+0x0        => 0x00000000004023d6 strrchr@plt+0x6
...
0x0000000000403e0c main+0x849             => 0x00000000004021f0 exit@plt+0x0
0x00000000004021f0 exit@plt+0x0           => 0x00000000004021f6 exit@plt+0x6
0x00000000004021fb exit@plt+0xb           => 0x00000000004020d0 _init+0x18
0x00000000004020d6 _init+0x1e             => 0x00000038062149d0 _dl_runtime_resolve+0x0
...

Changes in V4:
 - support output tsv mode

Changes in V3:
 - rename to 'perf branch'
 - fix getting elf_path bug

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |    5 +++
 tools/perf/builtin-branch.c              |   45 +++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index b3e5cf33..9b7b1e1 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -35,7 +35,7 @@ OPTIONS
 	Output TSV format.
 -a::
 --addr::
-	Print address. (default)
+	Print address.
 -c::
 --comm::
 	Print command name.
@@ -45,6 +45,9 @@ OPTIONS
 -e::
 --elfpath::
 	Print file path of executed elf.
+-s::
+--symbol::
+	Print function name and offset. (default)
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 0b96461..708b056 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -23,6 +23,8 @@ struct exec_info {
 	pid_t		pid;		/* tracee process pid */
 	const char	*comm;		/* command name */
 	const char	*elfpath;	/* file path to elf */
+	const char	*function;	/* function name */
+	u64		offset;		/* offset from top of the function */
 };
 
 #define EI_PID_UNSET	-1
@@ -32,15 +34,16 @@ struct exec_info {
 #define EI_FLAG_PRINT_PID		(1 << 1)
 #define EI_FLAG_PRINT_COMM		(1 << 2)
 #define EI_FLAG_PRINT_ELFPATH		(1 << 3)
+#define EI_FLAG_PRINT_SYMBOL		(1 << 4)
 
 /*
  * It's used when no print item specified.
  * It must be selected from EI_FLAG_REQUIRED.
  */
-#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_ADDR
+#define EI_FLAG_PRINT_DEFAULT		EI_FLAG_PRINT_SYMBOL
 
 /* the flags must be printed at least. */
-#define EI_FLAG_REQUIRED		EI_FLAG_PRINT_ADDR
+#define EI_FLAG_REQUIRED	(EI_FLAG_PRINT_ADDR | EI_FLAG_PRINT_SYMBOL)
 
 /*
  * The items which are not printed in branch_to field.
@@ -58,6 +61,9 @@ static unsigned long print_flags;
 #define EI_UNKNOWN_TEXT			"(unknown)"
 #define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
 
+/* 'function+offset' lengh = function + '+' + %#18lx + '\0' */
+#define symbol_buf_size(func_name)	(strlen(func_name) + 1 + 18 + 1)
+
 /* default input file name to analyze */
 static const char *input_name		= "perf.data";
 
@@ -93,7 +99,7 @@ static const struct option branch_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_BOOLEAN('t', "tsv", &output_tsv, "output tsv format"),
 	OPT_CALLBACK_DEFAULT_NOOPT('a', "addr", NULL, NULL,
-				   "print address (default)", set_print_flags,
+				   "print address", set_print_flags,
 				   (void *)EI_FLAG_PRINT_ADDR),
 	OPT_CALLBACK_DEFAULT_NOOPT('p', "pid", NULL, NULL,
 				   "print pid", set_print_flags,
@@ -104,6 +110,10 @@ static const struct option branch_options[] = {
 	OPT_CALLBACK_DEFAULT_NOOPT('e', "elfpath", NULL, NULL,
 				   "print file path to elf", set_print_flags,
 				   (void *)EI_FLAG_PRINT_ELFPATH),
+	OPT_CALLBACK_DEFAULT_NOOPT('s', "symbol", NULL, NULL,
+				   "print function+offset (default)",
+				   set_print_flags,
+				   (void *)EI_FLAG_PRINT_SYMBOL),
 	OPT_END()
 };
 
@@ -149,7 +159,7 @@ static void fill_exec_info(struct exec_info *ei,
 		return;
 	ei->comm = thread->comm;
 
-	/* get file path to elf */
+	/* get file path to elf, and symbol information */
 	memset(&al, 0, sizeof(al));
 	thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
 			      MAP__FUNCTION, event->ip.pid, addr, &al);
@@ -161,6 +171,13 @@ static void fill_exec_info(struct exec_info *ei,
 	/* resolve vmlinux path */
 	map__load(al.map, NULL);
 	ei->elfpath = al.map->dso->long_name;
+
+	al.addr = al.map->map_ip(al.map, addr);
+	al.sym = map__find_symbol(al.map, al.addr, NULL);
+	if (!al.sym)
+		return;
+	ei->function = al.sym->name;
+	ei->offset = al.addr - al.sym->start;
 }
 
 static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
@@ -168,6 +185,8 @@ static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
 	char pid[16];
 	const char *comm;
 	const char *elfpath;
+	char *symbol;
+	int symbol_len;
 
 	if (ei_print_flags & EI_FLAG_PRINT_PID) {
 		if (ei->pid == EI_PID_UNSET)
@@ -182,6 +201,22 @@ static void __print_exec_info(struct exec_info *ei, int ei_print_flags)
 	}
 	if (ei_print_flags & EI_FLAG_PRINT_ADDR)
 		output_item_addr(ei->addr);
+	if (ei_print_flags & EI_FLAG_PRINT_SYMBOL) {
+		if (!ei->function) {
+			/* when function is unknown, offset must be unknown */
+			printf("%-32s ", EI_UNKNOWN_TEXT);
+			goto print_elfpath;
+		}
+
+		symbol_len = symbol_buf_size(ei->function);
+		symbol = malloc(symbol_len);
+		snprintf(symbol, symbol_len, "%s+0x%lx",
+			 ei->function, ei->offset);
+		output_item_str("%-32s ", symbol);
+		free(symbol);
+	}
+
+print_elfpath:
 	if (ei_print_flags & EI_FLAG_PRINT_ELFPATH) {
 		elfpath = ei->elfpath ? : EI_UNKNOWN_TEXT;
 		output_item_str("%-32s ", elfpath);
@@ -205,6 +240,8 @@ static void print_exec_info_header(void)
 		output_item_str("%-12s ", "command");
 	if (print_flags & EI_FLAG_PRINT_ADDR)
 		output_item_str("%-" FMT_ADDR_WIDTH "s ", "address");
+	if (print_flags & EI_FLAG_PRINT_SYMBOL)
+		output_item_str("%-32s ", "function+offset");
 	if (print_flags & EI_FLAG_PRINT_ELFPATH)
 		output_item_str("%-32s ", "elf_filepath");
 	printf("\n");

