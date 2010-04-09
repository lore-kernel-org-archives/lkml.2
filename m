Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0DIMxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 08:53:53 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:37865 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0DIMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 08:53:51 -0400
Message-ID: <4BBF2351.3040506@lumino.de>
Date: Fri, 09 Apr 2010 14:53:37 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de>	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>	<4BBDC7D4.6040301@lumino.de>	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>	<4BBF0784.2060002@lumino.de> <20100409125426.5bc200da@lxorguk.ukuu.org.uk>
In-Reply-To: <20100409125426.5bc200da@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 01:54 PM, Alan Cox wrote:
> Linux + glibc platforms don't "need" futex - you need fast user space
> locks. Futex is an implementation of those locks really based around
> platforms with atomic instructions. People were doing fast user space
> locks before Linus was even born and on machines without atomic
> operations.
>   
Of course you are right, but IMHO this is why FUTEX was invented (and
AFAIK, Linux himself did the first implementation). With FUTEX there is
a standard way of speeding up Posix compatible thread locking (by
implementing the user space part of FUTEX in the pthread part of libc
and defining a Kernel interface for the fast thread locking/unlocking
functions that is not (much ?) more arch depending than other Kernel
interfaces.

Of course you are right that my suggestion in fact contradicts to this
by defining the FUTEX Kernel interface to work on a kind of Handles
instead of user-space pointers (even though same would still use the
same C-type an in fact can be understood as pointers into the "Atomic
RAM, accessible only by some special ASM instructions).

Anyway, working on FUTEX for the arch allows for community based work
(in the library and in the Kernel code) instead of having anybody
interested do their own implementation right within the (propriety) user
code.

> Seperate out
> - the purpose for which the system exists (fast user locking)
>   
Yep.
> - the interfaces by which it must be presented (posix pthread mutex)
>   
IMHO the only decent "community-compatible" implementation is doing it
in a POSIX way and allowing for "standard Linux user space code", thus
using pthread_mutex_...() (pthreadLib, libc).
> - the implementation of the system
>   
Same as any and libc and Linux Kernel stuff:  community based and done
under GPL, modifying common (arch-independent) code only if necessary
and then in an as "compatible" way as possible.
> Nope. Glibc allows you to implement arch specific code for these locks
> which may not be FUTEX but need not be kernel based. 
Of course you are right again. But is there rally a libc version that
implements pthread_mutex() with user space locking without using FUTEX ?
I wonder what Kernel interface it uses to perform the waiting.

In fact I did a testing program to prepare the implementation of fast
user space locking. Here I tried out several methods e.g.
 - pthread_mutex_...()
 - system V sema
 - my own code (several variants taken from "Futexes are tricky by
Ulrich Drepper") for the user space part of FUTEX, using the FUTEX
Kernel interface
 - some hombrew buggy testing code

I ran this program on PC (libc using FUTEX) and NIOS (libc using Kernel
calls)

Based on this, I do suppose that creating any _working_ method for user
space based thread locking (on any new arch) will be at least as much
work as implementing FUTEX on same.

> The user space
> mechanics of the futex stuff include platform specific stuff for all
> platforms. 
The Kernel space part of FUTEX stuff also includes platform specific
code, at least with SMP designs, as it will need to work SMP-atomic.
> You might do the blocking kernel parts of it via the futex
> syscall but what matters are the uncontended fast paths which are arch
> specific C library code.
>   
The fast part needs atomic user space operations that are not existing
in the arch in question and thus need some help from the Kernel (i.e.:
the said "atomic region") and/or some dedicated hardware (this is what
this thread is about).
> You clearly need a pthread_mutex that is fast - but the idea that this
> means FUTEX is misleading and futex on each platform in the user space
> side is different per architecture anyway.
>   
I understand that FUTEX was invented to allow for a more "standard",
less platform depending way of implementing pthread_mutex: using the
platform's "atomic" macros for the user space part and the FUTEX system
call for the Kernel part should allow for platform independent library
source code for any arch that supports FUTEX.
> The idea that you need atomic operations to do fast user space locking is
> also of course wrong - you only need store ordering.
>   

I feel that store ordering is even more difficult to be implemented than
atomicness, but  I'm eager to learn about this.

I don't think the NIOS can provide this (the normal instruction set is
quite limited and the custom instructions can't access memory in a
normal way at all)

If it's only meant for non-SMP this is not a limitation for me right now.

If you think it could be done with NIOS: using store ordering, how can I
implement a  pthread_mutex_..() workalike ?

-Michael
