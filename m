Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2ICCpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 22:45:23 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54952 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2ICCpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 22:45:21 -0400
X-Originating-IP: 217.70.178.152
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 19:45:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] trace: Stop compiling in trace_clock unconditionally
Message-ID: <20120903024513.GA19583@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 56449f437add737a1e5e1cb7e00f63ac8ead1938, in April 2009, made
trace_clock available unconditionally, since CONFIG_X86_DS used it too.
Commit faa4602e47690fb11221e00f9b9697c8dc0d4b19, in March 2010, removed
CONFIG_X86_DS, and now only CONFIG_RING_BUFFER (split out from
CONFIG_TRACING for general use) has a dependency on trace_clock.  So,
only compile in trace_clock with CONFIG_RING_BUFFER or CONFIG_TRACING
enabled.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/Makefile       |    2 +-
 kernel/trace/Kconfig  |    5 +++++
 kernel/trace/Makefile |    6 +-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..29d993b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
-obj-$(CONFIG_X86_DS) += trace/
+obj-$(CONFIG_TRACE_CLOCK) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8c4c070..e8b7c26 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -57,8 +57,12 @@ config HAVE_C_RECORDMCOUNT
 config TRACER_MAX_TRACE
 	bool
 
+config TRACE_CLOCK
+	bool
+
 config RING_BUFFER
 	bool
+	select TRACE_CLOCK
 
 config FTRACE_NMI_ENTER
        bool
@@ -109,6 +113,7 @@ config TRACING
 	select NOP_TRACER
 	select BINARY_PRINTF
 	select EVENT_TRACING
+	select TRACE_CLOCK
 
 config GENERIC_TRACER
 	bool
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index b831087..1b8e4c7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -17,11 +17,7 @@ endif
 
 CFLAGS_trace_events_filter.o := -I$(src)
 
-#
-# Make the trace clocks available generally: it's infrastructure
-# relied on by ptrace for example:
-#
-obj-y += trace_clock.o
+obj-$(CONFIG_TRACE_CLOCK) += trace_clock.o
 
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
-- 
1.7.10.4

