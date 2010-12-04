Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0LDANz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58485 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0LDANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=bnSt6T5oIiFpaA/Ph+tpYNPmMKPVoIj1jWShC5iyVRujJ1inoODBx1uSYU1IIPGjG
	LspbX8zrhuz7sXB4CB2vg==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 04/15] ftrace: pack event structures.
Date: Fri,  3 Dec 2010 16:13:18 -0800
Message-Id: <1291421609-14665-5-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace event structures have a 12-byte struct trace_entry at the beginning.
If the structure is aligned, this means that if the first field is 64-bits,
there will be 4 bytes of padding. Ironically, due to the 4-byte ringbuffer
header, this will make 64-bit writes unaligned, if the ring buffer position
is currently 64-bit aligned:
4(rb)+12(ftrace)+4(pad) = 20;  20%8 = 4

Adding __attribute__((packed)) to the event structures removes the extra
space from the trace events, and actually improves alignment of trace
events with a first field that is 64-bits.

About 65 tracepoints have a 4-byte pad at offset 12:
 # find events -name format | xargs -n1 awk '
   $1=="name:" {name=$2}
   $1=="format:"{FS="\t"}
   $3=="offset:12;" && $4=="size:4;"{okay=1}
   $3=="offset:16;" && !okay {print name}' | wc -l
65

With all 'syscalls' and 'timer' events enabled, this results in a 5%
improvement in a simple 512MB read benchmark with warm caches.

Tested:

setup:
 # echo 1 >events/syscalls/enable
 # echo 1 >events/timer/enable
 # echo 0 > tracing_enabled
off:
 # for n in $(seq 10) ; do \
   time dd if=/dev/hda3 of=/dev/null bs=1K count=512K ; \
   done
on:
 # for n in $(seq 10) ; do \
   echo 1 >tracing_enabled; \
   time dd if=/dev/hda3 of=/dev/null bs=1K count=512K ; \
   echo 0 >tracing_enabled; \
   echo > trace; \
   done

real time      mean/median/stdev
w/o patch off: 1.1679/1.164/0.0169
w/o patch on : 1.9432/1.936/0.0274
w/  patch off: 1.1715/1.159/0.0431
w/  patch on : 1.8425/1.836/0.0138
"on" delta: -0.1007 --> -5.2%

Google-Bug-Id: 2895627

Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/trace/ftrace.h |    5 +++--
 kernel/trace/trace.h   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a9377c0..51d1f52 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -48,7 +48,8 @@
 #define __array(type, item, len)	type	item[len];
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len) u32 __data_loc_##item;
+#define __dynamic_array(type, item, len) \
+    u32 __data_loc_##item __attribute__((aligned(4)));
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -62,7 +63,7 @@
 		struct trace_entry	ent;				\
 		tstruct							\
 		char			__data[0];			\
-	};								\
+	} __attribute__((packed));					\
 									\
 	static struct ftrace_event_class event_class_##name;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9021f8c..2e80433 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -60,7 +60,7 @@ enum trace_type {
 	struct struct_name {					\
 		struct trace_entry	ent;			\
 		tstruct						\
-	}
+	} __attribute__((packed))
 
 #undef TP_ARGS
 #define TP_ARGS(args...)	args
-- 
1.7.3.1

