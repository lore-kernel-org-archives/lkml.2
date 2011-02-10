Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1BJCiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:38:13 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56756 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1BJCiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:38:12 -0500
X-AuditID: b753bd60-a454dba0000001d0-d5-4d534f8fc945
X-AuditID: b753bd60-a454dba0000001d0-d5-4d534f8fc945
Message-ID: <4D534F8B.7030908@hitachi.com>
Date: Thu, 10 Feb 2011 11:38:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <20110209200249.111932716@goodmis.org>
In-Reply-To: <20110209200249.111932716@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/10 5:02), Steven Rostedt wrote:
> Thanks to Andi Kleen gcc 4.6.0 now supports -mfentry with the -pg option
> to place a call to __fentry__ at the very beginning of the function
> instead of after the fact.
> 
> The old way:
> 
> 00000000000000c4 <atomic_long_add>:
>       c4:       55                      push   %rbp
>       c5:       48 89 e5                mov    %rsp,%rbp
>       c8:       e8 00 00 00 00          callq  cd <atomic_long_add+0x9>
>                         c9: R_X86_64_PC32       mcount-0x4
>       cd:       f0 48 01 3e             lock add %rdi,(%rsi)
>       d1:       c9                      leaveq 
>       d2:       c3                      retq   
> 
> The new way:
> 
> 000000000000009e <atomic_long_add>:
>       9e:       e8 00 00 00 00          callq  a3 <atomic_long_add+0x5>
>                         9f: R_X86_64_PC32       __fentry__-0x4
>       a3:       55                      push   %rbp
>       a4:       48 89 e5                mov    %rsp,%rbp
>       a7:       f0 48 01 3e             lock add %rdi,(%rsi)
>       ab:       5d                      pop    %rbp
>       ac:       c3                      retq   
> 
> Note, with -mfentry, frame pointers is no longer required
> by the function tracer. But this patch series still requires
> FRAME_POINTER to be set, since I need to figure out a good way to
> enable FRAME_POINTER only if gcc doesn't support this. But that can
> come later.
> 
> With the new __fentry__, we could possible record the parameters
> of a function call. This may take some work, and perhaps be
> a little like kprobes. But it is doable.

Hm, very interesting. With this feature and dynamic-ftrace,
it may be possible to use it automatically instead of kprobes
via kprobe-events when user probes function entry.

Thanks,

> This is still just RFC. I only wrote the code to support x86_64
> even though gcc 4.6.0 also supports i386. I figured I would post
> this first to get peoples reactions before converting
> i386 too. Other archs can soon follow.
> 
> -- Steve
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/tracing/fentry
> 
> 
> Steven Rostedt (4):
>       ftrace: Make recordmcount.c handle __fentry__
>       ftrace: Add -mfentry to Makefile on function tracer
>       ftrace: Do not test frame pointers if -mfentry is used
>       ftrace/x86: Add support for -mfentry to x86_64
> 
> ----
>  Makefile                             |    6 +++++-
>  arch/x86/Kconfig                     |    1 +
>  arch/x86/include/asm/ftrace.h        |    7 ++++++-
>  arch/x86/kernel/entry_64.S           |   17 ++++++++++++++++-
>  arch/x86/kernel/x8664_ksyms_64.c     |    6 +++++-
>  kernel/trace/Kconfig                 |    5 +++++
>  kernel/trace/trace_functions_graph.c |    5 ++++-
>  scripts/recordmcount.h               |    4 +++-
>  8 files changed, 45 insertions(+), 6 deletions(-)


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
