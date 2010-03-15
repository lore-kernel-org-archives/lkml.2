Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936729Ab0COUc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:32:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:53589 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0COUcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:32:54 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: munroesj@us.ibm.com
Cc: "Ryan S. Arnold" <rsa@us.ibm.com>, linux-arch@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Lord <kernel@teksavvy.com>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1268665412.19726.75.camel@spokane1.rchland.ibm.com>
References: <1268628493.2355.2.camel@pasglop>
	 <1268665412.19726.75.camel@spokane1.rchland.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 07:32:23 +1100
Message-ID: <1268685143.2335.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The powerpc implementation of syscall is:
> 
> 
> ENTRY (syscall)
> 	mr   r0,r3
> 	mr   r3,r4
> 	mr   r4,r5
> 	mr   r5,r6
> 	mr   r6,r7
> 	mr   r7,r8
> 	mr   r8,r9
> 	sc
> 	PSEUDO_RET
> PSEUDO_END (syscall)

And my proposal is to make it instead:

#define syscall(__sysno, __args...)	__syscall(0,__sysno,__args)

ENTRY (__syscall)
	mr   r0,r4
 	mr   r3,r5
 	mr   r4,r6
 	mr   r5,r7
 	mr   r6,r8
 	mr   r7,r9
 	mr   r8,r10
 	sc
 	PSEUDO_RET
PSEUDO_END (__syscall)

> The ABI says:
> 
> "Long long arguments are considered to have 8-byte size and alignment.
> The same 8-byte arguments that must go in aligned pairs or registers are
> 8-byte aligned on the stack."

Right, that's what I'm explaining too.

> This implies that the SYS_fallocate call will skip a register to get the
> required alignment in the parameter save area.
> 
> for ppc32 on entry
> 
> r3 == SYS_fallocate
> r4 == fd
> r5 == mode
> r6 == not used
> r7, r8 == offset
> r9 == len

 len is 64-bit too afaik but let's ignore that for now

> This gets shifted to:
> 
> r0 == SYS_fallocate
> r3 == fd
> r4 == mode
> r5 == not used
> r6, r7 == offset
> r8 == len

Which is not correct, as the kernel expects:

r0 == SYS_fallocate
r3 == fd
r4 == mode
r5, r6 == offset
r7, r8 == len

> For syscall the vararg parms will be mirrored to the parameter save area
> but will not be used. The ABI does not talk to LE for this case.

Right, but the fact that we shift all args by -1- register means that we
break the 64-bit register pair alignment compared to the real syscall
which uses r0 instead for the syscall number. Hence my proposal to add
a dummy argument to restore that alignment.

As it is there is userspace code that does:

syscall(SYS_fallocate, fd, mode, offset, len);

Which works on x86 but is broken on ppc32 unless we do that change.

Cheers,
Ben.

> Ryan does the new ABI doc cover this?
> 
> > This will break because the first argument to syscall now shifts
> > everything by one register, which breaks the register pair alignment
> > (and I suppose archs with stack based calling convention can have
> > similar alignment issues even if x86 doesn't).
> > 
> > Ulrich, Steven, shouldn't we have glibc's syscall() take a long long as
> > it's first argument to correct that ? Either that or making it some kind
> > of macro wrapper around a __syscall(int dummy, int sysno, ...) ?
> > 
> > As it is, any 32-bit app using syscall() on any of the syscalls that
> > takes 64-bit arguments will be broken, unless the app itself breaks up
> > the argument, but the the order of the hi and lo part is different
> > between BE and LE architectures ;-)
> > 
> > So is there a more "correct" solution than another here ? Should powerpc
> > glibc be fixed at least so that syscall() keeps the alignment ?
> > 
> > Cheers,
> > Ben.
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


