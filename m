Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1DAGjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:39:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1DAGjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:39:04 -0400
Message-ID: <4D9573DB.4010009@cn.fujitsu.com>
Date: Fri, 01 Apr 2011 14:42:35 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH] Trace: use unsigned long long in trace print frames
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-01 14:37:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-01 14:37:23,
	Serialize complete at 2011-04-01 14:37:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While adding tracepoint for btrfs, I got a problem:

btrfs uses some macros with "ULL" type, but tracepoint's macros,
__print_[flags,symbols](), only have "unsigned long", so on 32bit box
there will be 64->32 truncate WARNINGs when compiling.

Here I'm inclined to make the replacement to clear those WARNINGs.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    7 ++++---
 kernel/trace/trace_output.c  |   10 +++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af..b52f2c5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -12,15 +12,16 @@ struct tracer;
 struct dentry;
 
 struct trace_print_flags {
-	unsigned long		mask;
+	unsigned long long	mask;
 	const char		*name;
 };
 
 const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
-				   unsigned long flags,
+				   unsigned long long flags,
 				   const struct trace_print_flags *flag_array);
 
-const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+const char *ftrace_print_symbols_seq(struct trace_seq *p,
+				     unsigned long long val,
 				     const struct trace_print_flags *symbol_array);
 
 const char *ftrace_print_hex_seq(struct trace_seq *p,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 456be90..97ba902 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -294,10 +294,10 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 
 const char *
 ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
-		       unsigned long flags,
+		       unsigned long long flags,
 		       const struct trace_print_flags *flag_array)
 {
-	unsigned long mask;
+	unsigned long long mask;
 	const char *str;
 	const char *ret = p->buffer + p->len;
 	int i;
@@ -319,7 +319,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 	if (flags) {
 		if (p->len && delim)
 			trace_seq_puts(p, delim);
-		trace_seq_printf(p, "0x%lx", flags);
+		trace_seq_printf(p, "0x%llx", flags);
 	}
 
 	trace_seq_putc(p, 0);
@@ -329,7 +329,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 EXPORT_SYMBOL(ftrace_print_flags_seq);
 
 const char *
-ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+ftrace_print_symbols_seq(struct trace_seq *p, unsigned long long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
@@ -345,7 +345,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 	}
 
 	if (!p->len)
-		trace_seq_printf(p, "0x%lx", val);
+		trace_seq_printf(p, "0x%llx", val);
 		
 	trace_seq_putc(p, 0);
 
-- 
1.6.5.2

