Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1AZHOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:14:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:32933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZHOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:14:15 -0500
Date: Wed, 26 Jan 2011 07:13:45 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110121203643.046218322@efficios.com>
References: <20110121203643.046218322@efficios.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoints: Use __u64_aligned/U64_ALIGN()
Message-ID: <tip-15e3540ce2159705f18fad6147ffedf04445ad64@git.kernel.org>
Git-Commit-ID: 15e3540ce2159705f18fad6147ffedf04445ad64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:13:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15e3540ce2159705f18fad6147ffedf04445ad64
Gitweb:     http://git.kernel.org/tip/15e3540ce2159705f18fad6147ffedf04445ad64
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Fri, 21 Jan 2011 15:36:33 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 21 Jan 2011 22:12:13 -0500

tracepoints: Use __u64_aligned/U64_ALIGN()

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
