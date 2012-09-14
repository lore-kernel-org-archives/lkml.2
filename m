Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2INLmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:42:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab2INLmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:42:03 -0400
Date: Fri, 14 Sep 2012 04:41:36 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-ea632e9f12033346cc68247faa3b924d54936b8b@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, fweisbec@gmail.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, fweisbec@gmail.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <20120903024513.GA19583@leaf>
References: <20120903024513.GA19583@leaf>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace:
  Stop compiling in trace_clock unconditionally
Git-Commit-ID: ea632e9f12033346cc68247faa3b924d54936b8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:41:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea632e9f12033346cc68247faa3b924d54936b8b
Gitweb:     http://git.kernel.org/tip/ea632e9f12033346cc68247faa3b924d54936b8b
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 2 Sep 2012 19:45:14 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:08 -0400

trace: Stop compiling in trace_clock unconditionally

Commit 56449f437 "tracing: make the trace clocks available generally",
in April 2009, made trace_clock available unconditionally, since
CONFIG_X86_DS used it too.

Commit faa4602e47 "x86, perf, bts, mm: Delete the never used BTS-ptrace code",
in March 2010, removed CONFIG_X86_DS, and now only CONFIG_RING_BUFFER (split
out from CONFIG_TRACING for general use) has a dependency on trace_clock. So,
only compile in trace_clock with CONFIG_RING_BUFFER or CONFIG_TRACING
enabled.

Link: http://lkml.kernel.org/r/20120903024513.GA19583@leaf

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 9301a0e..4cea4f4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -62,8 +62,12 @@ config HAVE_C_RECORDMCOUNT
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
@@ -114,6 +118,7 @@ config TRACING
 	select NOP_TRACER
 	select BINARY_PRINTF
 	select EVENT_TRACING
+	select TRACE_CLOCK
 
 config GENERIC_TRACER
 	bool
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 8370908..d7e2068 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -19,11 +19,7 @@ endif
 
 CFLAGS_trace_events_filter.o := -I$(src)
 
-#
-# Make the trace clocks available generally: it's infrastructure
-# relied on by ptrace for example:
-#
-obj-y += trace_clock.o
+obj-$(CONFIG_TRACE_CLOCK) += trace_clock.o
 
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
