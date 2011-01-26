Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1AZEKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:10:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1AZEKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:10:17 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=t-FhUlll9xQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=J1Y8HTJGAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=pr0X-yGf_Y_1xJW23tYA:9 a=i8XTRPaIkji0tdD7qm4A:7 a=nT_O4JeBaJh4xGAzSXBys_KvQsQA:4 a=D6-X0JM3zdQA:10 a=4N9Db7Z2_RYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110126041014.987944521@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 Jan 2011 23:05:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/3] tracepoints: Use __u64_aligned/U64_ALIGN()
References: <20110126040459.289776311@goodmis.org>
Content-Disposition: inline; filename=0003-tracepoints-Use-__u64_aligned-U64_ALIGN.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
variable attribute to the tracepoint structures to deal with gcc happily
aligning statically defined structures on 32-byte multiples.

Working on issues within Ftrace, we came up with __64_aligned, which deals with
this issue more elegantly by forcing an 8-byte alignment to both the type
declaration and variable definition.

This therefore saves space, bringing down the size of struct tracepoint from 64
bytes to 38 on 64-bit architectures.

Updating:
- The type attribute (for iteration over the struct tracepoint array)
- Added the variable attribute to the extern definition (needed to force gcc to
  consider this alignment for the following definition)
- The definition variable attribute (to force gcc to this specific alignment for
  the static definitions)
- The linker script (8-byte alignment can now replace the previous 32-byte
  alignment for the custom tracepoint section)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110121203643.046218322@efficios.com>
Acked-by: David Miller <davem@davemloft.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/tracepoint.h        |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e4af65c..95abb5f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -176,7 +176,7 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
-	. = ALIGN(32);							\
+	U64_ALIGN();							\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c681461..4bc50ea 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,12 +33,7 @@ struct tracepoint {
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
-} __attribute__((aligned(32)));		/*
-					 * Aligned on 32 bytes because it is
-					 * globally visible and gcc happily
-					 * align these on the structure size.
-					 * Keep in sync with vmlinux.lds.h.
-					 */
+} __u64_aligned;
 
 /*
  * Connect a probe to a tracepoint.
@@ -146,7 +141,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * structure. Force alignment to the same alignment as the section start.
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
-	extern struct tracepoint __tracepoint_##name;			\
+	extern struct tracepoint __u64_aligned __tracepoint_##name;	\
 	static inline void trace_##name(proto)				\
 	{								\
 		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
@@ -178,7 +173,8 @@ do_trace:								\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
-	__attribute__((section("__tracepoints"), aligned(32))) =	\
+	__u64_aligned							\
+	__attribute__((section("__tracepoints"))) =			\
 		{ __tpstrtab_##name, 0, reg, unreg, NULL }
 
 #define DEFINE_TRACE(name)						\
-- 
1.7.2.3


