Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab2BBTIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:08:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44265 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2BBTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120202184209.GD2518@linux.vnet.ibm.com>
References: <20120201151918.GC16714@quack.suse.cz> <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb> <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
 <1328128874.15992.6430.camel@triegel.csb> <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
 <20120201224554.GK2382@linux.vnet.ibm.com> <CA+55aFyzYO0CMZOgdrVV0PdG2DkbwTQG7eE7N3bp=0tQmruFEQ@mail.gmail.com>
 <20120202184209.GD2518@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Feb 2012 11:08:25 -0800
X-Google-Sender-Auth: dHcJIuXJga1Loe8Mz5J44Eg6aXo
Message-ID: <CA+55aFyYxzED4OoYvb3nbET7_zyP5mGhEa2w_QCvQOx55bVjHg@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: paulmck@linux.vnet.ibm.com
Cc: Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 10:42 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> SMP-atomic or percpu atomic? Or both?
>
> Only SMP-atomic.

And I assume that since the compiler does them, that would now make it
impossible for us to gather a list of all the 'lock' prefixes so that
we can undo them if it turns out that we are running on a UP machine.

When we do SMP operations, we don't just add a "lock" prefix to it. We do this:

  #define LOCK_PREFIX_HERE \
                ".section .smp_locks,\"a\"\n"   \
                ".balign 4\n"                   \
                ".long 671f - .\n" /* offset */ \
                ".previous\n"                   \
                "671:"

  #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "

and I'm sure you know that, but I'm not sure the gcc people realize
the kinds of games we play to make things work better.

Sure, "everything will be SMP" some day, but running UP kernels is
likely still going to remain a good idea in virtualized environments,
for example. And having to make it a compile-time option is *not* a
good idea.

So compiler intrisics are often *worse* than doing it by hand for us
for all these kinds of reasons. They aren't generally geared towards
the very specialized needs that a kernel has.

Of course, maybe even user space would want some kind of way to
automatically strip 'lock' prefixes from a binary, so maybe the
compiler would have some kind of support like this too.

(And no, disassembling the binary in order to find lock prefixes is
*not* the answer, at least not for the kernel)

>> We need both variants in the kernel. If the compiler generates one of
>> them for us, that doesn't really much help.
>
> I must admit that the non-x86 per-CPU atomics are, ummm, "interesting".

Most non-x86 cpu's would probably be better off treating them the same
as smp-atomics (load-locked + store-conditional), but right now we
have this insane generic infrastructure for having versions that are
irq-safe by disabling interrupts etc. Ugh. Mainly because nobody
really is willing to work on and fix up the 25 architectures that
really don't matter.

              Linus
