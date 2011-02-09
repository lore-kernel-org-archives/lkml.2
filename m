Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1BIUKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1BIUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:32 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=SA4EXLrJR6cA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=0Y16Lu4m3PjY_nyvzEwA:9 a=LJRcRVQRR_jXoArqnToA:7 a=9jDK7Hm0FO8LKrdTzirWF_Y9AQ0A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110209200249.111932716@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Feb 2011 15:02:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is for x86_64 right now)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Andi Kleen gcc 4.6.0 now supports -mfentry with the -pg option
to place a call to __fentry__ at the very beginning of the function
instead of after the fact.

The old way:

00000000000000c4 <atomic_long_add>:
      c4:       55                      push   %rbp
      c5:       48 89 e5                mov    %rsp,%rbp
      c8:       e8 00 00 00 00          callq  cd <atomic_long_add+0x9>
                        c9: R_X86_64_PC32       mcount-0x4
      cd:       f0 48 01 3e             lock add %rdi,(%rsi)
      d1:       c9                      leaveq 
      d2:       c3                      retq   

The new way:

000000000000009e <atomic_long_add>:
      9e:       e8 00 00 00 00          callq  a3 <atomic_long_add+0x5>
                        9f: R_X86_64_PC32       __fentry__-0x4
      a3:       55                      push   %rbp
      a4:       48 89 e5                mov    %rsp,%rbp
      a7:       f0 48 01 3e             lock add %rdi,(%rsi)
      ab:       5d                      pop    %rbp
      ac:       c3                      retq   

Note, with -mfentry, frame pointers is no longer required
by the function tracer. But this patch series still requires
FRAME_POINTER to be set, since I need to figure out a good way to
enable FRAME_POINTER only if gcc doesn't support this. But that can
come later.

With the new __fentry__, we could possible record the parameters
of a function call. This may take some work, and perhaps be
a little like kprobes. But it is doable.

This is still just RFC. I only wrote the code to support x86_64
even though gcc 4.6.0 also supports i386. I figured I would post
this first to get peoples reactions before converting
i386 too. Other archs can soon follow.

-- Steve

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/tracing/fentry


Steven Rostedt (4):
      ftrace: Make recordmcount.c handle __fentry__
      ftrace: Add -mfentry to Makefile on function tracer
      ftrace: Do not test frame pointers if -mfentry is used
      ftrace/x86: Add support for -mfentry to x86_64

----
 Makefile                             |    6 +++++-
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/ftrace.h        |    7 ++++++-
 arch/x86/kernel/entry_64.S           |   17 ++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c     |    6 +++++-
 kernel/trace/Kconfig                 |    5 +++++
 kernel/trace/trace_functions_graph.c |    5 ++++-
 scripts/recordmcount.h               |    4 +++-
 8 files changed, 45 insertions(+), 6 deletions(-)
