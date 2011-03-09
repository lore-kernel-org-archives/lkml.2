Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1CICBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:01:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab1CICBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:01:20 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=VOOo5lHdzEUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=pT0EQOadSOjnDE2_OloA:9 a=T48Kkk0wYn-kEv9_4rUA:7 a=FQi0pZl2CSjis89chJBH37AL2bwA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
From: Steven Rostedt <rostedt@goodmis.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        David Sharp <dhsharp@google.com>
In-Reply-To: <1299627003.20306.94.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-5-git-send-email-dhsharp@google.com>
	 <1299627003.20306.94.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 20:09:07 -0500
Message-ID: <1299632947.20306.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 18:30 -0500, Steven Rostedt wrote:
> David (Miller),
> 
> I'm going back through this patch set and looking to incorporate it into
> 2.6.39. But I know how touchy sparc is with "packed" data structures. Do
> you see this patch as hurting sparc?
> 
> I wonder if we should change this to something like:
> 
> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> # define do_event_packed __attirbute__((packed))
> #else
> # define do_event_packed
> #endif
> 
> and use "do_event_packed" instead?
> 

Here's the modified patch, if you think the current one is not OK:

-- Steve

commit c49fd97767b112a9a7a50c184caf5059f798d5a0
Author: David Sharp <dhsharp@google.com>
Date:   Fri Dec 3 16:13:18 2010 -0800

    tracing: Pack event structures.
    
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
    
    Cc: David S. Miller <davem@davemloft.net>
    Signed-off-by: David Sharp <dhsharp@google.com>
    LKML-Reference: <1291421609-14665-5-git-send-email-dhsharp@google.com>
    
    [
      Replaced "__attibute__((packed))" with "ftrace_do_packed" which
      is a macro that is defined as the packed attribute only if the
      arch has efficient unaligned access.
    ]
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47e3997..c920ab5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -282,4 +282,16 @@ perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
 }
 #endif
 
+/*
+ * On systems that can access unaligned data efficiently we
+ * pack the data structures. This actually gives a boost
+ * in tracing speed. But leave the structs alone for archs
+ * that do not do as well with packed data structures.
+ */
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+# define ftrace_do_packed __attribute__((packed))
+#else
+# define ftrace_do_packed
+#endif
+
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3e68366..6b8f366 100644
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
+	} ftrace_do_packed;						\
 									\
 	static struct ftrace_event_class event_class_##name;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9cd025a..ce185fe 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -60,7 +60,7 @@ enum trace_type {
 	struct struct_name {					\
 		struct trace_entry	ent;			\
 		tstruct						\
-	}
+	} ftrace_do_packed
 
 #undef TP_ARGS
 #define TP_ARGS(args...)	args


