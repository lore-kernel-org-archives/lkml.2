Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1HZXNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:13:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566Ab1HZXNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <4E582577.2060805@zytor.com>
References: <4E582577.2060805@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 16:13:10 -0700
Message-ID: <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 4:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Rather than duplicating the system call table, we are proposing to deal
> with that by setting bit 30 in the system call number across the board
> when called from x32, so we end up with:
>
> # Shared system call, sys_read (0)
>
> x86-64:         %eax = 0x00000000
> x32:            %eax = 0x40000000
>
> # Unshared system call, sys_stat (4/513)
>
> x86-64:         %eax = 0x00000004
> x32:            %eax = 0x40000201
>
> The extra bit would be masked off and only affect device drivers like
> input which relies on is_compat().

So a couple of questions:

 - why do we need another system call model at all?

 - And if that is clarified, why in the name of christ would you
unshare something like 'sys_stat()' to begin with? I really that's
just a crazy example, because otherwise I just have to assume that
people are being stupid.

 - Assuming the two others can be explained, and if this is relevant
only for x86-64, why not put it in bit 62? Right now we do

     call *sys_call_table(,%rax,8)

   which means that the high three bits (in a 64-bit word) are the
perfect place to put any flags: they'll be ignored without us having
to do any masking at all (of course, we'd still have to think about
the "cmpq $__NR_syscall_max,%rax" detail, so who knows).

> The question here is if anyone has a reason to believe this would be
> unacceptable.

I think the real question is "why?". I think we're missing a lot of
background for why we'd want yet another set of system calls at all,
and why we'd want another state flag. Why can't the x32 code just use
the native 64-bit system calls entirely?

                                   Linus
