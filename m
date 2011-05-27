Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1E0MsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:48:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1E0MsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:48:16 -0400
Date: Fri, 27 May 2011 12:48:04 GMT
From: tip-bot for liubo <liubo2009@cn.fujitsu.com>
Message-ID: <tip-2fc1b6f0d0a719e1e2a30bf076a3a799feaf6af2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        liubo2009@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liubo2009@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4DACE6E0.7000507@cn.fujitsu.com>
References: <4DACE6E0.7000507@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Add __print_symbolic_u64 to avoid warnings on 32bit machine
Git-Commit-ID: 2fc1b6f0d0a719e1e2a30bf076a3a799feaf6af2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:48:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fc1b6f0d0a719e1e2a30bf076a3a799feaf6af2
Gitweb:     http://git.kernel.org/tip/2fc1b6f0d0a719e1e2a30bf076a3a799feaf6af2
Author:     liubo <liubo2009@cn.fujitsu.com>
AuthorDate: Tue, 19 Apr 2011 09:35:28 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 22:13:44 -0400

tracing: Add __print_symbolic_u64 to avoid warnings on 32bit machine

Filesystem, like Btrfs, has some "ULL" macros, and when these macros are passed
to tracepoints'__print_symbolic(), there will be 64->32 truncate WARNINGS during
compiling on 32bit box.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/4DACE6E0.7000507@cn.fujitsu.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |   12 ++++++++++++
 include/trace/ftrace.h       |   13 +++++++++++++
 kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b5a550a..59d3ef1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -16,6 +16,11 @@ struct trace_print_flags {
 	const char		*name;
 };
 
+struct trace_print_flags_u64 {
+	unsigned long long	mask;
+	const char		*name;
+};
+
 const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 				   unsigned long flags,
 				   const struct trace_print_flags *flag_array);
@@ -23,6 +28,13 @@ const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 				     const struct trace_print_flags *symbol_array);
 
+#if BITS_PER_LONG == 32
+const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
+					 unsigned long long val,
+					 const struct trace_print_flags_u64
+								 *symbol_array);
+#endif
+
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3e68366..533c49f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -205,6 +205,19 @@
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
+#undef __print_symbolic_u64
+#if BITS_PER_LONG == 32
+#define __print_symbolic_u64(value, symbol_array...)			\
+	({								\
+		static const struct trace_print_flags_u64 symbols[] =	\
+			{ symbol_array, { -1, NULL } };			\
+		ftrace_print_symbols_seq_u64(p, value, symbols);	\
+	})
+#else
+#define __print_symbolic_u64(value, symbol_array...)			\
+			__print_symbolic(value, symbol_array)
+#endif
+
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cf535cc..e37de49 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -353,6 +353,33 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 }
 EXPORT_SYMBOL(ftrace_print_symbols_seq);
 
+#if BITS_PER_LONG == 32
+const char *
+ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
+			 const struct trace_print_flags_u64 *symbol_array)
+{
+	int i;
+	const char *ret = p->buffer + p->len;
+
+	for (i = 0;  symbol_array[i].name; i++) {
+
+		if (val != symbol_array[i].mask)
+			continue;
+
+		trace_seq_puts(p, symbol_array[i].name);
+		break;
+	}
+
+	if (!p->len)
+		trace_seq_printf(p, "0x%llx", val);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
+#endif
+
 const char *
 ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 {
