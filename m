Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab0COOye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:54:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48525 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965103Ab0COOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:54:30 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Steven Munroe <munroesj@linux.vnet.ibm.com>
Reply-To: munroesj@us.ibm.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: linux-arch@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Lord <kernel@teksavvy.com>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1268628493.2355.2.camel@pasglop>
References: <1268628493.2355.2.camel@pasglop>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 15 Mar 2010 10:03:32 -0500
Message-Id: <1268665412.19726.75.camel@spokane1.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 15:48 +1100, Benjamin Herrenschmidt wrote:
> Hoy there !
> 
> This may have been discussed earlier (I have some vague memories...) but
> I just hit a problem with that again (Mark: hint, it's in hdparm's
> fallocate) so I'd like a bit of a refresh here on what is the "right
> thing" to do...
> 
> So some syscalls want a 64-bit argument. Let's take fallocate() as our
> example. So we already know that we have to be extra careful since some
> 32-bit arch will pass this into 2 registers (or stack slots) which need
> to be aligned, and so we tend to already take care of making sure that
> the said 64-bit argument is either defined as 2x32-bit arguments, or
> defined as 1x64 bit argument aligned to 2x32-bit in the argument list.
> 
> So far so good...
> 
> The problem is when user space tries to use the same trick for calling
> those functions using glibc-provided syscall() function. In this
> example, hdparm does:
> 
> err = syscall(SYS_fallocate, fd, mode, offset, len);
> 
> With "offset" being a 64-bit argument.
> 

The powerpc implementation of syscall is:


ENTRY (syscall)
	mr   r0,r3
	mr   r3,r4
	mr   r4,r5
	mr   r5,r6
	mr   r6,r7
	mr   r7,r8
	mr   r8,r9
	sc
	PSEUDO_RET
PSEUDO_END (syscall)

The ABI says:

"Long long arguments are considered to have 8-byte size and alignment.
The same 8-byte arguments that must go in aligned pairs or registers are
8-byte aligned on the stack."

This implies that the SYS_fallocate call will skip a register to get the
required alignment in the parameter save area.

for ppc32 on entry

r3 == SYS_fallocate
r4 == fd
r5 == mode
r6 == not used
r7, r8 == offset
r9 == len

This gets shifted to:

r0 == SYS_fallocate
r3 == fd
r4 == mode
r5 == not used
r6, r7 == offset
r8 == len

For syscall the vararg parms will be mirrored to the parameter save area
but will not be used. The ABI does not talk to LE for this case.

Ryan does the new ABI doc cover this?

> This will break because the first argument to syscall now shifts
> everything by one register, which breaks the register pair alignment
> (and I suppose archs with stack based calling convention can have
> similar alignment issues even if x86 doesn't).
> 
> Ulrich, Steven, shouldn't we have glibc's syscall() take a long long as
> it's first argument to correct that ? Either that or making it some kind
> of macro wrapper around a __syscall(int dummy, int sysno, ...) ?
> 
> As it is, any 32-bit app using syscall() on any of the syscalls that
> takes 64-bit arguments will be broken, unless the app itself breaks up
> the argument, but the the order of the hi and lo part is different
> between BE and LE architectures ;-)
> 
> So is there a more "correct" solution than another here ? Should powerpc
> glibc be fixed at least so that syscall() keeps the alignment ?
> 
> Cheers,
> Ben.
> 
> 

