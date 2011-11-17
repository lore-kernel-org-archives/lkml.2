Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1KQP4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:56:24 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53662 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932290Ab1KQP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:56:22 -0500
Date: Thu, 17 Nov 2011 10:56:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] tracepoint/jump_label overhead
Message-ID: <20111117155617.GA12665@Krystal>
References: <1321502104.3274.22.camel@edumazet-laptop> <1321543520.27735.67.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1321543520.27735.67.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:34:56 up 589 days,  1:24,  4 users,  load average: 0.42, 0.26,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2011-11-17 at 04:55 +0100, Eric Dumazet wrote:
> > The general admitted claim of a tracepoint being on x86 a single
> > instruction :
> > 
> > jmp +0
> > 
> > Is not always true.
> > 
> > For example in mm/slub.c, kmem_cache_alloc()
> > 
> > void *ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, _RET_IP_); 
> > trace_kmem_cache_alloc(_RET_IP_, ret, s->objsize, s->size, gfpflags);
> > return ret;
> > 
> > We can check compiler output and see that 4 extra instructions were
> > added because s->objsize & s->size are evaluated.
> > 
> > I noticed this in a perf session, because these 4 extra instructions
> > added some noticeable latency/cost.
> > 
> > c10e26a4:       8b 5d d8                mov    -0x28(%ebp),%ebx
> > c10e26a7:       85 db                   test   %ebx,%ebx
> > c10e26a9:       75 6d                   jne    c10e2718   (doing the memset())
> > c10e26ab:       8b 76 0c                mov    0xc(%esi),%esi   // extra 1
> > c10e26ae:       8b 5d 04                mov    0x4(%ebp),%ebx   // extra 2
> > c10e26b1:       89 75 f0                mov    %esi,-0x10(%ebp) // extra 3
> > c10e26b4:       89 5d ec                mov    %ebx,-0x14(%ebp) // extra 4
> > c10e26b7:       e9 00 00 00 00          jmp    c10e26bc 
> > c10e26bc:       8b 45 d8                mov    -0x28(%ebp),%eax
> > c10e26bf:       83 c4 28                add    $0x28,%esp
> > c10e26c2:       5b                      pop    %ebx
> > c10e26c3:       5e                      pop    %esi
> > c10e26c4:       5f                      pop    %edi
> > c10e26c5:       c9                      leave
> > 
> > 
> > A fix would be to not declare an inline function but a macro...
> > 
> > #define trace_kmem_cache_alloc(...) \
> > 	if (static_branch(&__tracepoint_kmem_cache_alloc.key)) \
> > 		__DO_TRACE(&__tracepoint_kmem_cache_alloc,	\
> > 			...
> > 
> > Anyone has some clever idea how to make this possible ?
> 
> Right so you're not really supposed to use arguments that require
> evaluation in tracepoints, although I bet its common these days :/
> 
> The problem here is that its 'hard' to pass s in and have the
> TP_fast_assign() thing do the dereference because of the sl[auo]b thing.

I created a variant of tracepoints for userspace in my lttng-ust project
where I changed the invokation of a tracepoint to:

  tracepoint(provider, name, arg1, arg2, arg3, ..., arg10);

This allows me to much with a the tracepoint call-site since it becomes
a macro. This macro uses the __tracepoint_provider_name() static inline
underneath.

I just took a go at implementing the behavior proposed by Eric Dumazet
in the lttng-ust tree, it seems to work out nicely! Now doing this at
kernel-level would imply changing the trace_system_event(..) call-sites
into trace(system, event, ...), trace(system_event, ...) or
tracepoint(system, event, ...). Is that something you are willing to
consider doing ?

Diff for lttng-ust:

diff --git a/include/lttng/tracepoint.h b/include/lttng/tracepoint.h
index 2ca4598..8e3b604 100644
--- a/include/lttng/tracepoint.h
+++ b/include/lttng/tracepoint.h
@@ -35,8 +35,11 @@ extern "C" {
  * Tracepoints should be added to the instrumented code using the
  * "tracepoint()" macro.
  */
-#define tracepoint(provider, name, args...)	\
-		__trace_##provider##___##name(args)
+#define tracepoint(provider, name, args...)					\
+	do {									\
+		if (caa_unlikely(__tracepoint_##provider##___##name.state))	\
+			__trace_##provider##___##name(args);			\
+	} while (0)
 
 /*
  * it_func[0] is never NULL because there is at least one element in the array
@@ -148,13 +151,6 @@ extern "C" {
 #define _TP_ARGS_PROTO_DATA(...)	_TP_PROTO_DATA_N(_TP_NARGS(0, ##__VA_ARGS__), ##__VA_ARGS__)
 #define _TP_ARGS_VARS_DATA(...)		_TP_VARS_DATA_N(_TP_NARGS(0, ##__VA_ARGS__), ##__VA_ARGS__)
 
-#define __CHECK_TRACE(provider, name, proto, args)			\
-	do {								\
-		if (caa_unlikely(__tracepoint_##provider##___##name.state))	\
-			__DO_TRACE(&__tracepoint_##provider##___##name,	\
-				TP_PARAMS(proto), TP_PARAMS(args));	\
-	} while (0)
-
 /*
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
@@ -164,8 +160,8 @@ extern "C" {
 	extern struct tracepoint __tracepoint_##provider##___##name;	\
 	static inline void __trace_##provider##___##name(proto)		\
 	{								\
-		__CHECK_TRACE(provider, name, TP_PARAMS(data_proto),	\
-			      TP_PARAMS(data_args));			\
+		__DO_TRACE(&__tracepoint_##provider##___##name,		\
+			TP_PARAMS(data_proto), TP_PARAMS(data_args));	\
 	}								\
 	static inline int						\
 	__register_trace_##provider##___##name(void (*probe)(data_proto), void *data)	\



-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
