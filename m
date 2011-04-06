Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1DFJN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:13:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab1DFJN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:13:56 -0400
Message-ID: <4D9C2FF6.7090607@cn.fujitsu.com>
Date: Wed, 06 Apr 2011 17:18:46 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on 32bit
 machine
References: <4D9573DB.4010009@cn.fujitsu.com> <1301665762.2160.22.camel@gandalf.stny.rr.com>
In-Reply-To: <1301665762.2160.22.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-06 17:12:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-06 17:12:18,
	Serialize complete at 2011-04-06 17:12:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
__print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
on 32bit box.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |   12 ++++++++++++
 include/trace/events/btrfs.h |    4 ++--
 include/trace/ftrace.h       |   13 +++++++++++++
 kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af..6b2e245 100644
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
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f445cff..4114129 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -28,7 +28,7 @@ struct extent_buffer;
 		{ BTRFS_SHARED_DATA_REF_KEY, 	"SHARED_DATA_REF" })
 
 #define __show_root_type(obj)						\
-	__print_symbolic(obj,						\
+	__print_symbolic_u64(obj,					\
 		{ BTRFS_ROOT_TREE_OBJECTID, 	"ROOT_TREE"	},	\
 		{ BTRFS_EXTENT_TREE_OBJECTID, 	"EXTENT_TREE"	},	\
 		{ BTRFS_CHUNK_TREE_OBJECTID, 	"CHUNK_TREE"	},	\
@@ -125,7 +125,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 );
 
 #define __show_map_type(type)						\
-	__print_symbolic(type,						\
+	__print_symbolic_u64(type,					\
 		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
 		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
 		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
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
index 456be90..47aafa9 100644
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
1.6.5.2
