Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab1EZPaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab1EZPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:30:00 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=JAzV6A35vFUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=cVVy1aDN_lYikmLgV84A:9 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152958.359014807@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 10/12] tracing: Add __print_symbolic_u64 to avoid warnings on 32bit machine
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Add-__print_symbolic_u64-to-avoid-warnings-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liubo <liubo2009@cn.fujitsu.com>

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
-- 
1.7.4.4


