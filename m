Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2KDIrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:47:46 -0500
Received: from science.horizon.com ([71.41.210.146]:34282 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751522Ab2KDIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:47:44 -0500
Date: 4 Nov 2012 03:47:43 -0500
Message-ID: <20121104084743.21804.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: oleg@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/1] percpu_rw_semaphore: reimplement to not block the readers unnecessarily
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grand poo-bah Linus wrote:
> Now, I doubt you'll find an architecture or C compiler where this will
> actually ever make a difference, but the fact remains that you
> shouldn't use signed integers for counters like this. You should use
> unsigned, and you should rely on the well-defined modulo-2**n
> semantics.

Actually, this is another C standard undefined case that recent versions of
GCC exploit for optimization.

When using signed integers, GCC's optimizer assumes that, if b > 0,
then a + b > a.

For example, the loop:
	for (i = 1; i; i++)
		/* Code */
will never terminate!  Feed the following to gcc -O2 and see for yourself:

extern void foo(int x);

void bar(void)
{
	int i;
	for (i = 0; i >= 0; i++)
		foo(i);
}

here's what I get:

        .file   "test.c"
        .text
        .p2align 4,,15
        .globl  bar
        .type   bar, @function
bar:
.LFB0:
        .cfi_startproc
        pushl   %ebx
        .cfi_def_cfa_offset 8
        .cfi_offset 3, -8
        movl    $1, %ebx
        subl    $24, %esp
        .cfi_def_cfa_offset 32
        .p2align 4,,7
        .p2align 3
.L2:
        movl    %ebx, (%esp)
        addl    $1, %ebx
        call    foo
        jmp     .L2
        .cfi_endproc
.LFE0:
        .size   bar, .-bar
        .ident  "GCC: (Debian 4.7.2-4) 4.7.2"
        .section        .note.GNU-stack,"",@progbits

Notice the lack of test in the "jmp .L2" loop.

It can even handle more complicated cases like:

void bar(int j)
{
        int i = 0;
        do {
                foo(i);
                if (j >= 0)
                        i += j;
                else
                        i -= j;
        } while (i >= 0);
}

... which gcc -O3 neatly splits into two infinite loops, as if I had written:

void bar(int j)
{
        int i = 0;
	if (j >= 0)
		for (; ; i += j)
			foo(i);
	else
		for (; ; i -= j)
			foo(i);
}
