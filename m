Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1BQMhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:37:15 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49866 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1BQMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:37:12 -0500
X-AuditID: b753bd60-a50bbba000004916-f6-4d5d1674b7e2
X-AuditID: b753bd60-a50bbba000004916-f6-4d5d1674b7e2
Message-ID: <4D5D1672.6070206@hitachi.com>
Date: Thu, 17 Feb 2011 21:37:06 +0900
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
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <20110209200249.111932716@goodmis.org>
In-Reply-To: <20110209200249.111932716@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
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
> 
> This is still just RFC. I only wrote the code to support x86_64
> even though gcc 4.6.0 also supports i386. I figured I would post
> this first to get peoples reactions before converting
> i386 too. Other archs can soon follow.

Oops! with this change, current kprobes might not be able to probe
the entry of functions, because that is always reserved by ftrace!
I think we need to have some new interface for replacing each other
safely...

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
