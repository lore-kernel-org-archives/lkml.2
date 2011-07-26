Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1GZAfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:35:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1GZAfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:35:36 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=n6SIYIHP9guV50b9y-kA:9 a=Iwtp-aVJJfeS8Ktj1CgA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: gcc-help@gcc.gnu.org, stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	 <1311625197.3526.35.camel@gandalf.stny.rr.com>
	 <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	 <CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 20:35:34 -0400
Message-ID: <1311640534.3526.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 19:50 -0400, Arnaud Lacombe wrote:

> gcc will only emits the warning at -Os. It seems to me that the
> resulting code clearly ends-up testing an uninitialized value, ie.
> assuming the following test-case:
> 
> extern void *e(void);
> extern void *f(void);
> extern void g(void);
> 
> void fn(void)
> {
>         void *b, *a;
> 
>         a = e();
>         if (a != 0)
>                 b = f();
>         if (a != 0 && b != 0)
>                 g();
> }
> 
> gcc 4.5.1 will generates the following x86-32 assembly:
> 
> % gcc -m32 -Wall -Os -c -S -o - kernel/trace/trace_printk.c
>         .file   "trace_printk.c"
> kernel/trace/trace_printk.c: In function 'fn':
> kernel/trace/trace_printk.c:7:8: warning: 'b' may be used
> uninitialized in this function
>         .text
> .globl fn
>         .type   fn, @function
> fn:
>         pushl   %ebp
>         movl    %esp, %ebp
>         pushl   %esi
>         pushl   %ebx
>         call    e
>         testl   %eax, %eax
>         movl    %eax, %ebx
>         je      .L2
>         call    f
>         movl    %eax, %esi
> .L2:
>         testl   %esi, %esi
>         je      .L1
>         testl   %ebx, %ebx
>         je      .L1
>         popl    %ebx
>         popl    %esi
>         popl    %ebp
>         jmp     g
> .L1:
>         popl    %ebx
>         popl    %esi
>         popl    %ebp
>         ret
>         .size   fn, .-fn
>         .ident  "GCC: (GNU) 4.5.1 20100924 (Red Hat 4.5.1-4)"
>         .section        .note.GNU-stack,"",@progbits
> 

I wrote a similar program and got the same results for both 4.5.1 and
4.6.0. but only with -Os and -O2 seems fine.

> It seems gcc transforms the conditional from:
> 
> if (a != NULL && b != NULL) ...
> 
> to
> 
> if (b != NULL && a != NULL) ...
> 
> In which case the warning is fully valid. I'm not sure what's the C
> standard guarantee in term of conditional test order. gcc 4.7.0 has
> the same behavior.

Yes it seems to be doing this :-/

This is a real bug!

-- Steve


