Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2GGVan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:30:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2GGVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:30:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Sat, 7 Jul 2012 21:30:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
In-Reply-To: <20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207072130.37220.arnd@arndb.de>
X-Provags-ID: V02:K0:wQaoI0/ohJWf33xJS8IqOEs4LKZGIlJkCmkCF1OAlDT
 JTTMiOeLB/kO2gU6z2rDa5M5e67tRyjNC6YE0CP2N3IgZHDkgk
 u+tyALsvRdATOm8l8q0iJlvy3YItko9sMR0a9YndDbbF9GH/sb
 2Lzlc5H6goZG1WTF8eG3tPZvQHfognh4AhsKJURzM5AoNxmfZU
 NhelZ6LKp5tTsvQcR/lFvdQFoBA/CVpFRf1H8p1eILFC/RDrFN
 PxTBU25Cnjoy1HUJ9hf7A8mLVUkuI+nH3aVmIUrpBo+y3Eey0S
 /Xp5F9bSzoVFAep2bzoWf/D2jUJKgXEhjG3pfHRPRrMqNSpjbO
 0x2BnShRknll2lkczrCc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2012, Alan Cox wrote:
> >  arch/x86/include/asm/atomic64_32.h              |    1 +
> >  arch/x86/include/asm/atomic64_64.h              |    1 +
> >  arch/xtensa/kernel/syscall.c                    |    2 +-
> 
> This looks odd to say the least ?

See patch 1/36. I think it makes sense, though you could argue that
testing #ifdef atomic64_dec_if_positive would be nicer than testing
#ifdef ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE.

> The only other question I'd ask is given that ppc and x86 have both done
> 32/64bit separate architectures and then gone the other way is that
> something ARM 64bit needs to think about ?

It's the most debated question so far, in the private review that we've
done before, and in the public Linaro meetings. You are right that everyone
else merged their architectures (and sparc, mips in addition ot the ones
you mentioned, parisc and tile were always combined IIRC).

I've also touched on this question in my reply to Olof, but I can give
a longer summary of what we talked about before and what I got out of it.
The basic argument is

a) Pro merge: Avoid code duplication, because duplicate code leads to duplicate
bugs and extra maintainance overhead.

b) Pro split: Start with a fresh code base without all the legacy code that
we are currently in the process of reworking; Most code is actually
different anyway.

I was long undecided in this and tried to look at both sides, but I'm now
leaning towards b).
Look at what's actually in the arch trees:

* Assembly code: On the other architectures, the 32 and 64 bit instruction
sets are mostly identical, normally with additional instructions for 64 bit,
but in case of ARM AArch64, the instruction set is actually completely new
and it's not possible to write assembler in a way that builds on both
versions.

* System call interface: Most architectures use the same user space ABI
for 32 and 64 bit, with minor variations. In case of AArch64, we use the
new generic ABI, while 32 bit ARM uses one that has grown over a long
time and carries around a lot of legacy baggage. AArch64 has to emulate
the 32 bit ABI for running old user space, but the 32-bit compat
implementation cannot actually share any code with the native 32 bit
one.

* Platform support: In most architectures, there is a single system-level
architecture describing stuff like interrupt controllers, timers, SMP
initialization, etc, and that is usually shared between 32 and 64 bit.
On 32 bit ARM, we have about 50 distinct platforms, but some of them
have a lot in common with platforms of another architecture (arm/shmobile
with sh, arm/imx with powerpc/85xx, arm/rpc with x86, ...). The same code
is what we're reworking currently and moving out of arch/arm into drivers
whereever that makes sense.

* Basic infrastructure: pci support, ptrace, signal handling, dma-mapping,
etc. A lot of things that are copied between architectures are actually
completely generic and should just be moved into common code out of the
arch/ directory structure. It's better to share these between aarch64 and
multiple other new architectures than just between 32 and 64 bit ARM.

Given all of these things that we are not going to share anyway, I think
it's better to be flexible with the new code and clean up or try out
things that we would not be able to change easily in a merged code base
without running the risk of introducing many regressions for 32 bit systems.
The risk of duplicating code is still there, but I think we can deal with
that on a case-by-case basis and make sure we don't merge duplicate
files that should either be shared in one form or another, or that should
be done differently to start with.

	Arnd
