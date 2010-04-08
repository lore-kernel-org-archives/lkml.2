Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab0DHOPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:15:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0DHOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:15:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: atomic RAM ?
Date: Thu, 8 Apr 2010 16:15:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw
References: <4BBD86A5.5030109@lumino.de> <20100408.051453.231567150.davem@davemloft.net> <4BBDCC6E.3060702@lumino.de>
In-Reply-To: <4BBDCC6E.3060702@lumino.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004081615.01151.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18TAQIGEGn61JGLKp8sCViIg7/NMd/BQM15Gpi
 LkDW65/0OyGILegs69bWBLxTT7zDQ0YYE3nDNPRFjz8tchXuDN
 Lj4A6fz2+ka4/0UgaW1Mg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Michael Schnell wrote:
> On 04/08/2010 02:14 PM, David Miller wrote:
> > Using the spinlock array idea also doesn't work in userspace
> > because any signal handler that tries to do an atomic on the
> > same object will deadlock on the spinlock.
> >   
> Yep. I was beeing afraid of signal issues when thinking about this stuff
> (on and off for several months :) ), too.
> 
> That is why I finally think that a completely hardware based solution
> for each necessary atomic operation is necessary, as well to do Futex
> (if not using said "atomic region" workaround for non-SMP), as to do SMP.

One really expensive but safe way to do atomic operations is to always
have them done on one CPU only, and provide a mechanism for other CPUs
to ask for an atomic operation using an inter-processor-interrupt.

> I finally think that this might be possible in a decent way with custom
> instructions using a - say - 1K Word internal FPGA memory space. But
> this might need some changes in the non-arch dependent Kernel and/or
> library code as the atomic macros would work on "handles" instead of
> pointers (of course these handles would be the old pointers with
> "normal" archs) and the words used by the macros would need to be
> explicitly allocated and deallocated instead of potentially being just
> static variables - even though the "atomic_allocate" macro would just
> create a static variable for "normal archs" and return it's address.

Why can't you do a hash by memory address for this?

I would guess you can define an instruction to atomically set and check
a bit in a shared array of implementation-specific size, by passing
a token in that by convention is the memory address you want to lock.

Given two priviledged instructions

/* returns one if we got the lock, zero if someone else holds it */
bool hashlock_addr(volatile void *addr);
void hashunlock_addr(volatile void *addr);

you can do

int atomic_add_return(int i, atomic_t *v)
{
	int temp;

	while (!hashlock_addr(v))
		;
	smp_rmb();
	temp = v->counter;
	temp += i;
	v->counter = temp;
	smp_wmb();
	hashunlock_addr(v);
}

static inline unsigned long __cmpxchg(volatile unsigned long *m,
                                      unsigned long old, unsigned long new)
{
        unsigned long retval;
        unsigned long flags;

        while (!hashlock_addr(m))
		;
	smp_rmb()
        retval = *m;
        if (retval == old) {
                *m = new;
		smp_wmb();
	}
        hashunlock_addr(m);
        return retval;
}

Anything else you can build on top of these two, including the system calls
that are used from user applications. Since you never hold that bit lock for
more than a few cycles, you could do with much less than 1K bits, in theory
a single global mutex (ignoring the address entirely) would be enough.

That said, a real load-locked/store-conditional would be much more powerful,
in particular because it can also be used from user space, and it is typically
more efficient because it uses the same mechanisms as the cache coherency
protocol.

	Arnd
