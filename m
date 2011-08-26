Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1HZXjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:39:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55341 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1HZXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:39:51 -0400
Message-ID: <4E582EAA.1040108@zytor.com>
Date: Fri, 26 Aug 2011 16:39:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
In-Reply-To: <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 04:13 PM, Linus Torvalds wrote:
>>
>> The extra bit would be masked off and only affect device drivers like
>> input which relies on is_compat().
> 
> So a couple of questions:
> 
>  - why do we need another system call model at all?

We think we can get more performance for a process which doesn't need
more than 4 GiB of virtual address space by allowing them to keep
pointers 4 bytes long, while still giving them the advantage of 16
64-bit registers, PC-relative addressing, and so on.  Furthermore, there
are users who seem more willing to port code known to not be 64-bit
clean to x32 than to do a whole new port.

If the question is "why not just thunk this in userspace", the answer is
that we'd like to take advantage of the compat layer already in the kernel.

If the question is "why not just use int $0x80" we actually did that in
early prototyping, but SYSCALL64 is much faster.

>  - And if that is clarified, why in the name of christ would you
> unshare something like 'sys_stat()' to begin with? I really that's
> just a crazy example, because otherwise I just have to assume that
> people are being stupid.

sys_stat is unshared because it involves data structures in memory.  In
x32, this invokes compat_sys_newstat just like you would from an i386
process.

In order to not create a completely new ABI we use the i386 in-memory
data structure layout everywhere, except of course for the ones where
the register set differences matter (for some of the signals.)

We have followed the 32-bit model fairly slavishly -- there is LFS vs
non-LFS for example -- to make the porting to x32 easier.  That doesn't
mean that there aren't system calls in our current list that are
unshared when they shouldn't be... I haven't done the full audit of the
list yet.

>  - Assuming the two others can be explained, and if this is relevant
> only for x86-64, why not put it in bit 62? Right now we do
> 
>      call *sys_call_table(,%rax,8)
> 
>    which means that the high three bits (in a 64-bit word) are the
> perfect place to put any flags: they'll be ignored without us having
> to do any masking at all (of course, we'd still have to think about
> the "cmpq $__NR_syscall_max,%rax" detail, so who knows).

First of all, loading a value into the high half of the 64-bit register
means using a 10-byte-long instruction instead of a 5-byte-long
instruction.  Second of all, we decided at some point (I don't know
when) that the system call number is %eax, not %rax, and we actually
mask off the top 32 bits already.  This change thus just means changing:

	movl	%eax, %eax

to

	andl	~0x40000000, %eax

Note that by keeping bit 31 intact we still do the right thing with the
compare.

(We avoided using bit 31 because there are number of places the kernel
assumes that a system call number expressed as either an int or a long
must be positive, and that a negative number represents a non-system
call kernel entry, e.g. interrupts.)

>> The question here is if anyone has a reason to believe this would be
>> unacceptable.
> 
> I think the real question is "why?". I think we're missing a lot of
> background for why we'd want yet another set of system calls at all,
> and why we'd want another state flag. Why can't the x32 code just use
> the native 64-bit system calls entirely?

I hope I have explained it above.

	-hpa
