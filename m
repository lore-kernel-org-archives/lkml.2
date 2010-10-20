Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0JTAoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0JTAoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:44:19 -0400
Date: Tue, 19 Oct 2010 20:43:34 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101020004334.GA2014@redhat.com>
References: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
 <20101019142820.GA14520@Krystal>
 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
 <1287521757.16971.397.camel@gandalf.stny.rr.com>
 <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>
 <1287523439.16971.433.camel@gandalf.stny.rr.com>
 <4CBE122B.9020807@zytor.com>
 <1287527005.16971.527.camel@gandalf.stny.rr.com>
 <364b3c9b09b8b02f6804634a2fc927b4.squirrel@programming.kicks-ass.net>
 <4CBE2C1B.6070500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBE2C1B.6070500@zytor.com>
User-Agent: Mutt/1.5.20 (2010-07-18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 04:39:07PM -0700, H. Peter Anvin wrote:
> On 10/19/2010 03:27 PM, Peter Zijlstra wrote:
> > 
> > Due to not actually having a sane key type the above is not easy to
> > implement, but I tried:
> > 
> > #define _SWITCH_POINT(x)\
> > ({                                                              \
> >         __label__ jl_enabled;                                   \
> >         bool ret = true;                                        \
> >         JUMP_LABEL(x, jl_enabled);                              \
> >         ret = false;                                            \
> > jl_enabled:                                                     \
> >         ret;            })
> > 
> > #define SWITCH_POINT(x) unlikely(_SWITCH_POINT(x))
> > 
> > #define COND_STMT(key, stmt)                                    \
> > do {                                                            \
> >         if (SWITCH_POINT(key)) {                                \
> >                 stmt;                                           \
> >         }                                                       \
> > } while (0)
> > 
> > 
> > and that's still generating these double jumps.
> > 
> 
> I just experimented with it, and the ({...}) construct doesn't work,
> because it looks like a merged flow of control to gcc.
> 
> Replacing the ({ ... }) with an inline does indeed remove the double
> jumps.
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index b67cb18..2ff829d 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -61,12 +61,22 @@ static inline int jump_label_text_reserved(void
> *start, void *end)
> 
>  #endif
> 
> +static __always_inline __pure bool _SWITCH_POINT(void *x)
> +{
> +       asm goto("# SWITCH_POINT %0\n\t"
> +                ".byte 0x66,0x66,0x66,0x66,0x90\n"
> +                "1:"
> +                : : "i" (x) : : jl_enabled);
> +       return false;
> +jl_enabled:
> +       return true;
> +}
> +
> +#define SWITCH_POINT(x)        unlikely(_SWITCH_POINT(x))
> +
>  #define COND_STMT(key, stmt)                                   \
>  do {                                                           \
> -       __label__ jl_enabled;                                   \
> -       JUMP_LABEL(key, jl_enabled);                            \
> -       if (0) {                                                \
> -jl_enabled:                                                    \
> +       if (SWITCH_POINT(key)) {                                \
>                 stmt;                                           \
>         }                                                       \
>  } while (0)
> 
> 
> The key here seems to be to not use the JUMP_LABEL macro as implemented;
> I have utterly failed to make JUMP_LABEL() do the right thing.
> 

ok, I tried this out for the tracepoint code, but I still seem to be
getting the double jump.

patch:


diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 1947a12..7bc2537 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -66,12 +66,22 @@ static inline void jump_label_unlock(void) {}
 
 #endif
 
+static __always_inline __pure bool _SWITCH_POINT(void *x)
+{
+	asm goto("# SWITCH_POINT %0\n\t"
+		 ".byte 0x66,0x66,0x66,0x66,0x90\n"
+		 "1:"
+		 : : "i" (x) : : jl_enabled);
+	return false;
+jl_enabled:
+	return true;
+}
+
+#define SWITCH_POINT(x)        unlikely(_SWITCH_POINT(x))
+
 #define COND_STMT(key, stmt)					\
 do {								\
-	__label__ jl_enabled;					\
-	JUMP_LABEL(key, jl_enabled);				\
-	if (0) {						\
-jl_enabled:							\
+	if (SWITCH_POINT(key)) {                                \
 		stmt;						\
 	}							\
 } while (0)
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index a4a90b6..1f8d14f 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -146,12 +146,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
-		return;							\
-do_trace:								\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args));			\
+		COND_STMT(&__tracepoint_##name.state, __DO_TRACE(&__tracepoint_##name, TP_PROTO(data_proto), TP_ARGS(data_args)));						     \
 	}								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\


disassemly:

ffffffff810360a6 <set_task_cpu>:
ffffffff810360a6:       55                      push   %rbp
ffffffff810360a7:       48 89 e5                mov    %rsp,%rbp
ffffffff810360aa:       41 55                   push   %r13
ffffffff810360ac:       41 54                   push   %r12
ffffffff810360ae:       41 89 f4                mov    %esi,%r12d
ffffffff810360b1:       53                      push   %rbx
ffffffff810360b2:       48 89 fb                mov    %rdi,%rbx
ffffffff810360b5:       48 81 ec b8 00 00 00    sub    $0xb8,%rsp
ffffffff810360bc:       66 66 66 66 90          data32 data32 data32
xchg %ax,%ax
ffffffff810360c1:       eb 19                   jmp    ffffffff810360dc
<set_task_cpu+0x36>
ffffffff810360c3:       49 8b 7d 08             mov    0x8(%r13),%rdi
ffffffff810360c7:       44 89 e2                mov    %r12d,%edx
ffffffff810360ca:       48 89 de                mov    %rbx,%rsi
ffffffff810360cd:       41 ff 55 00             callq  *0x0(%r13)
ffffffff810360d1:       49 83 c5 10             add    $0x10,%r13
ffffffff810360d5:       49 83 7d 00 00          cmpq   $0x0,0x0(%r13)
ffffffff810360da:       eb 6c                   jmp    ffffffff81036148
<set_task_cpu+0xa2>
ffffffff810360dc:       48 8b 43 08             mov    0x8(%rbx),%rax
ffffffff810360e0:       44 39 60 18             cmp    %r12d,0x18(%rax)
ffffffff810360e4:       74 37                   je     ffffffff8103611d
<set_task_cpu+0x77>
ffffffff810360e6:       48 ff 83 98 00 00 00    incq   0x98(%rbx)
ffffffff810360ed:       e9 00 00 00 00          jmpq   ffffffff810360f2
<set_task_cpu+0x4c>
ffffffff810360f2:       eb 29                   jmp    ffffffff8103611d
<set_task_cpu+0x77>
ffffffff810360f4:       4c 8d ad 30 ff ff ff    lea    -0xd0(%rbp),%r13
ffffffff810360fb:       4c 89 ef                mov    %r13,%rdi
ffffffff810360fe:       e8 c7 94 ff ff          callq  ffffffff8102f5ca
<perf_fetch_caller_regs>
ffffffff81036103:       45 31 c0                xor    %r8d,%r8d
ffffffff81036106:       4c 89 e9                mov    %r13,%rcx
ffffffff81036109:       ba 01 00 00 00          mov    $0x1,%edx
ffffffff8103610e:       be 01 00 00 00          mov    $0x1,%esi
ffffffff81036113:       bf 04 00 00 00          mov    $0x4,%edi
ffffffff81036118:       e8 67 19 07 00          callq  ffffffff810a7a84
<__perf_sw_event>
ffffffff8103611d:       44 89 e6                mov    %r12d,%esi
ffffffff81036120:       48 89 df                mov    %rbx,%rdi
ffffffff81036123:       e8 2f 75 ff ff          callq  ffffffff8102d657
<set_task_rq>
ffffffff81036128:       48 8b 43 08             mov    0x8(%rbx),%rax
ffffffff8103612c:       44 89 60 18             mov    %r12d,0x18(%rax)
ffffffff81036130:       48 81 c4 b8 00 00 00    add    $0xb8,%rsp
ffffffff81036137:       5b                      pop    %rbx
ffffffff81036138:       41 5c                   pop    %r12
ffffffff8103613a:       41 5d                   pop    %r13
ffffffff8103613c:       c9                      leaveq
ffffffff8103613d:       c3                      retq
ffffffff8103613e:       4c 8b 2d 3b 26 a9 00    mov
0xa9263b(%rip),%r13        # ffffffff81ac8780
<__tracepoint_sched_migrate_task+0x20>
ffffffff81036145:       4d 85 ed                test   %r13,%r13
ffffffff81036148:       0f 85 75 ff ff ff       jne    ffffffff810360c3
<set_task_cpu+0x1d>
ffffffff8103614e:       eb 8c                   jmp    ffffffff810360dc
<set_task_cpu+0x36>



I'm using gcc (GCC) 4.5.1 20100812

is my patch wrong?

thanks,

-Jason
