Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1BIUKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1BIUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:33 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=3ZO_lGxKx-wA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=2pOhCIMU1Zli-UKOOJUA:9 a=G53jnfjMq-ErjomeCkljEYkzZUAA:4 a=jEp0ucaQiEUA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110209201029.772571775@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Feb 2011 15:02:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [RFC][PATCH 2/4] ftrace: Add -mfentry to Makefile on function tracer
References: <20110209200249.111932716@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Add-mfentry-to-Makefile-on-function-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Thanks to Andi Kleen, gcc 4.6.0 now supports -mfentry for x86
(and hopefully soon for other archs). What this does is to have
the function profiler start at the beginning of the function
instead of after the stack is set up. As plain -pg (mcount) is
called after the stack is set up, and in some cases can have issues
with the function graph tracer. It also requires frame pointers to
be enabled.

The -mfentry now calls __fentry__ at the beginning of the function.
This allows for compiling without frame pointers and even has the
ability to access parameters if needed.

If the architecture and the compiler both support -mfentry then
use that instead.

TODO: Allow for FUNCTION_TRACER to be set without FRAME_POINTERS

Cc: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile             |    6 +++++-
 kernel/trace/Kconfig |    5 +++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index c9c8c8f..915bf47 100644
--- a/Makefile
+++ b/Makefile
@@ -578,7 +578,11 @@ KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
 endif
 
 ifdef CONFIG_FUNCTION_TRACER
-KBUILD_CFLAGS	+= -pg
+ifdef CONFIG_HAVE_FENTRY
+CC_HAS_FENTRY	:= $(call cc-option, -mfentry -DCC_HAS_FENTRY)
+endif
+KBUILD_CFLAGS	+= -pg $(CC_HAS_FENTRY)
+KBUILD_AFLAGS	+= $(CC_HAS_FENTRY)
 ifdef CONFIG_DYNAMIC_FTRACE
 	ifdef CONFIG_HAVE_C_RECORDMCOUNT
 		BUILD_C_RECORDMCOUNT := y
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 14674dc..7ed3f17 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -49,6 +49,11 @@ config HAVE_SYSCALL_TRACEPOINTS
 	help
 	  See Documentation/trace/ftrace-design.txt
 
+config HAVE_FENTRY
+	bool
+	help
+	  Arch supports the gcc options -pg with -mfentry
+
 config HAVE_C_RECORDMCOUNT
 	bool
 	help
-- 
1.7.2.3


