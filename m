Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1H0AhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:37:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1H0AhA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:37:00 -0400
MIME-Version: 1.0
In-Reply-To: <4E582EAA.1040108@zytor.com>
References: <4E582577.2060805@zytor.com> <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Aug 2011 17:36:35 -0700
Message-ID: <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 4:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/26/2011 04:13 PM, Linus Torvalds wrote:
>>
>>  - why do we need another system call model at all?
>
> We think we can get more performance for a process which doesn't need
> more than 4 GiB of virtual address space by allowing them to keep
> pointers 4 bytes long, while still giving them the advantage of 16
> 64-bit registers, PC-relative addressing, and so on.  Furthermore, there
> are users who seem more willing to port code known to not be 64-bit
> clean to x32 than to do a whole new port.

Let me repeat: what the f*&% does that have to do with a new system call model?

NOTHING.

At most, it means that we should add a PROT_4G to the mmap() system
call, so that user space can say "I want the result in the low 4G"
range. But even that wouldn't need a new system call.

> If the question is "why not just thunk this in userspace", the answer is
> that we'd like to take advantage of the compat layer already in the kernel.

And you *still* don't answer the question, you just make up new red
herring sentences.

Apart from mmap() (and to a lesser degree brk()), the kernel almost
never makes up user pointers. It's user space that points to them, and
gives them as arguments. There'sa few system calls that take pointers
to pointers: execve(), readv/writev, send/recvmsg, but then the actual
*example* you give isn't even one of those.

> If the question is "why not just use int $0x80" we actually did that in
> early prototyping, but SYSCALL64 is much faster.

No. The actual question is "why are you giving crazy examples, and
what the f*ck is going on"?

> sys_stat is unshared because it involves data structures in memory.  In
> x32, this invokes compat_sys_newstat just like you would from an i386
> process.

.. and this is exactly the kind of answer that makes me go NAK NAK NAK.

Christ no.

If you are doing a new native x32 model, then you DAMN WELL USE THE
EXISTING "stat()" system call.

There is *ZERO* reason to not use it. Use the standard 64-bit
structure layout. Why the hell would it be a new system call?

That's what I'm arguing against. This kind of crazy "let's make up YET
ANOTHER interface, even though the existing interface would work".
WHY?

If you want to be compatible with "int 0x80" and old libraries, then I
really don't see why you would introduce *anything* new.

And if it is truly a new ABI, then damn it, use the existing 64-bit
system calls as far as possible.

The "mix and match randomly and then introduce new system calls
because you made a bad design decision" sounds just crazy.

                              Linus
