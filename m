Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2EHLWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:22:55 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54178 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2EHLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:22:54 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>
Date: Tue, 08 May 2012 16:41:26 +0530
Message-Id: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v20] tracing: Fix kconfig warning due to a typo
x-cbid: 12050811-3864-0000-0000-000002AB18B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Commit f3f096cfe ("tracing: Provide trace events interface for
uprobes") throws a warning about unmet dependencies.

The exact warning message is:
	warning: (UPROBE_EVENT) selects UPROBES which has unmet
direct dependencies (UPROBE_EVENTS && PERF_EVENTS)

This is due to a typo in arch/Kconfig file. Fix similar typos in
uprobetracer documentation.

Also add sample format of a uprobe event in the uprobetracer
documentation as suggested by Masami Hiramatsu.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 Documentation/trace/uprobetracer.txt |   22 ++++++++++++++++++++--
 arch/Kconfig                         |    2 +-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index eae40a0..24ce682 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -5,7 +5,7 @@
 Overview
 --------
 Uprobe based trace events are similar to kprobe based trace events.
-To enable this feature, build your kernel with CONFIG_UPROBE_EVENTS=y.
+To enable this feature, build your kernel with CONFIG_UPROBE_EVENT=y.
 
 Similar to the kprobe-event tracer, this doesn't need to be activated via
 current_tracer. Instead of that, add probe points via
@@ -68,7 +68,25 @@ in the object. We can see the events that are registered by looking at the
 uprobe_events file.
 
     # cat uprobe_events
-    p:uprobes/p_zsh_0x46420 /bin/zsh:0x0000000000046420
+    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+
+The format of events can be seen by viewing the file events/uprobes/p_zsh_0x46420/format
+
+    # cat events/uprobes/p_zsh_0x46420/format
+    name: p_zsh_0x46420
+    ID: 922
+    format:
+	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
+	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
+	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
+	field:int common_pid;	offset:4;	size:4;	signed:1;
+	field:int common_padding;	offset:8;	size:4;	signed:1;
+
+	field:unsigned long __probe_ip;	offset:12;	size:4;	signed:0;
+	field:u32 arg1;	offset:16;	size:4;	signed:0;
+	field:u32 arg2;	offset:20;	size:4;	signed:0;
+
+    print fmt: "(%lx) arg1=%lx arg2=%lx", REC->__probe_ip, REC->arg1, REC->arg2
 
 Right after definition, each event is disabled by default. For tracing these
 events, you need to enable it by:
diff --git a/arch/Kconfig b/arch/Kconfig
index 9e2fbb5..c160d92 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -78,7 +78,7 @@ config OPTPROBES
 
 config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on UPROBE_EVENTS && PERF_EVENTS
+	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
 	help
 	  Uprobes is the user-space counterpart to kprobes: they


