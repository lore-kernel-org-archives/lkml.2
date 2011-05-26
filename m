Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1EZFGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:06:33 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51708 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1EZFGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:06:32 -0400
X-AuditID: b753bd60-a28c6ba000003bac-f4-4ddddee86633
X-AuditID: b753bd60-a28c6ba000003bac-f4-4ddddee86633
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 7/7] perf branch trace: add kernel filter
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
Date: Thu, 26 May 2011 14:03:40 +0900
Message-ID: <20110526050340.30011.15617.stgit@localhost6.localdomain6>
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

This patch introduces filter to eliminate kernel functions from
'perf branch trace' output. 'perf branch record' records
'kernel to user' logs, but it doesn't record 'user to kernel' logs.
So users may be surprised at kernel functions which are appeared suddenly.

If you want to see all recorded BTS logs, you can disable this filter
with the option '--no-kernel-filter'.
Usage:
 # perf branch --no-kernel-filter trace

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |    5 +++++
 tools/perf/builtin-branch.c              |   12 +++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index a034f12..9635f22 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -51,6 +51,11 @@ OPTIONS
 -A::
 --all::
 	Print all information.
+--no-kernel-filter::
+	Disable kernel filter and print all recorded branch-trace-store logs.
+	The logs recorded by 'perf branch record' include 'kernel to user'
+	logs because of processors' specification. In the default behavior,
+	'perf branch trace' doesn't show it. This option disables this filter.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index 51cdcd4..8b49c30 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -25,6 +25,7 @@ struct exec_info {
 	const char	*elfpath;	/* file path to elf */
 	const char	*function;	/* function name */
 	u64		offset;		/* offset from top of the function */
+	enum dso_kernel_type kernel;	/* to distingish kernel or user*/
 };
 
 #define EI_PID_UNSET	-1
@@ -60,6 +61,9 @@ static unsigned long print_flags;
 
 #define is_flags_unset(flags)		((flags) == 0)
 
+/* kernel filter is disabled or not */
+static bool no_kernel_filter;
+
 /* print it when we cannnot analyze and get the information */
 #define EI_UNKNOWN_TEXT			"(unknown)"
 #define EI_UNKNOWN_TEXT_LEN		(sizeof(EI_UNKNOWN_TEXT))
@@ -120,6 +124,8 @@ static const struct option branch_options[] = {
 	OPT_CALLBACK_DEFAULT_NOOPT('A', "all", NULL, NULL,
 				   "print all items", set_print_flags,
 				   (void *)EI_FLAG_PRINT_ALL),
+	OPT_BOOLEAN('\0', "no-kernel-filter", &no_kernel_filter,
+		    "disable kernel filter"),
 	OPT_END()
 };
 
@@ -148,6 +154,7 @@ static void init_exec_info(struct exec_info *ei)
 {
 	memset(ei, 0, sizeof(*ei));
 	ei->pid = EI_PID_UNSET;
+	ei->kernel = DSO_TYPE_USER;
 }
 
 /* collect printable items to struct exec_info */
@@ -177,6 +184,7 @@ static void fill_exec_info(struct exec_info *ei,
 	/* resolve vmlinux path */
 	map__load(al.map, NULL);
 	ei->elfpath = al.map->dso->long_name;
+	ei->kernel = al.map->dso->kernel;
 
 	al.addr = al.map->map_ip(al.map, addr);
 	al.sym = map__find_symbol(al.map, al.addr, NULL);
@@ -269,7 +277,9 @@ static int process_sample_event(union perf_event *event __unused,
 	fill_exec_info(&ei_from, session, event, sample->ip);
 	fill_exec_info(&ei_to, session, event, sample->addr);
 
-	print_exec_info(&ei_from, &ei_to);
+	if (no_kernel_filter || (ei_from.kernel == DSO_TYPE_USER &&
+					ei_to.kernel == DSO_TYPE_USER))
+		print_exec_info(&ei_from, &ei_to);
 
 	return 0;
 }

