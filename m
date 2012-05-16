Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab2EPRY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:24:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2EPRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:24:27 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=IXDOenSsrcIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wYfDrUjZNtrk5NmWzDoA:9 a=cdZg3o63KdCmHFXO4dcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=0Wy_TWe8l2NOzAJH:21 a=P5LyYogyyaPfNIJS:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337189065.6724.55.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH v2] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 13:24:25 -0400
In-Reply-To: <1337175871.6724.46.camel@gandalf.stny.rr.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 09:44 -0400, Steven Rostedt wrote:
> Now that PowerTop v2 is out, which uses the parse-event library, it no
> longer is broken by the removal of the lock-depth field from every
> event. Currently we add 4 bytes of empty space to every event. If we
> have 1 million events, 4 million bytes are wasted in the ring buffers
> (for both ftrace and perf).
> 
> But this change will break PowerTop v1. Thus my question is, how long do
> we need to keep this wasted space in the ring buffers to satisfy an out
> of date tool?
> 

Would help if I compiled it :-)

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5f3f3be..f96dfef 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -49,7 +49,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			padding;
 };
 
 #define FTRACE_MAX_EVENT						\

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08a08ba..0960aa7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1145,7 +1145,6 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->padding			= 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 079a93a..5845731 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -116,7 +116,6 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
-	__common_field(int, padding);
 
 	return ret;
 }


