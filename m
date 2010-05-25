Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab0EYPEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:04:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab0EYPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:03:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>, Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Tue, 25 May 2010 17:03:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005242053.25594.arnd@arndb.de> <4BFBD68C.9060405@tilera.com>
In-Reply-To: <4BFBD68C.9060405@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251703.11613.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4FzvfLrC5wLPQseJ9wA4VXLkkoBID0hoEBeA
 O9udBFKuej8JHdLYc+Vmnx2eCgidlkjby7SP/Zn+PH8R2WwvZy
 PmUDLaH5xAIrWJkyKW8gA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Chris Metcalf wrote:
> I looked at the diff of the set of syscalls you provide and the ones
> we've been using.
> 
> Specific questions:
> 
> - How do you propose representing the architecture-specific syscalls? 
> We have three "very special" syscalls that are negative numbers, which I
> won't worry about, since they'll be out of the normal numbering
> sequence.  But we also have a few others (cmpxchg_baddr, raise_fpe,
> flush_cache) that we'll need a numbering location for.  I see that you
> already have an empty block from 244 (today) to 1023; perhaps
> architectures should just use 1023 on down?  I'll do this for now.

I would keep allocating from the bottom. For now, maybe we should just
reserve 16 arch specific syscall numbers starting at 244, and add

#define __NR_tile_cmpxchg_baddr (__NR_arch_specific_syscall + 0)
#define __NR_tile_raise_fpe	(__NR_arch_specific_syscall + 1)
#define __NR_tile_flush_cache	(__NR_arch_specific_syscall + 2)

to your own unistd.h.
 
> - You renamed __NR__llseek to __NR_llseek, which of course seems pretty
> reasonable, but libc expects to see the former (both glibc and uclibc). 
> Is it worth requiring non-standard libc code?  I may just add
> __NR__llseek as an alias in my unistd.h for now.

That was probably just a mistake on my side. The only other
architecture using the generic version so far is score, so
maybe Chen Liqin can comment on how he dealt with this and
if he depends on the definition now.

> - Are you planning to keep all the ifdef'ed syscalls going forward? 
> Because honestly, I'd rather just enable __ARCH_WANT_SYSCALL_NO_AT,
> etc., and use the kernel implementations, since otherwise I'll have to
> go into both uclibc and glibc and add a bunch of extra Tilera-specific
> code and then try to push that up to their community, when really I just
> want to have the Tilera architecture userspace support be as generic as
> possible.

The idea was to only have them around as a transitional helper for
new architectures while getting merged, but nothing should ever
use these in production.

While glibc and uclibc are currently still lacking support for these,
the intention was for both to provide the wrappers in the architecture
independent code like they already do for a lot of other system calls.
Maybe Ulrich can comment on how we would get there, in particular if
we would want to add those helpers to glibc himself or if he would prefer
you to send a patch to do that.

There really should be no code required in glibc to deal with the
generic ABI, other than the parts that deal with the specific register
layout and calling conventions. We're not there yet, but my hope
is that tile is the last architecture that needs to worry about this
and once you get it working with common code, future architectures
just work.

> The result seems positive overall; I'm certainly happy to dump, e.g.,
> "nice" and "stime", since they have obvious userspace wrappers (and in
> fact libc is already geared up to use them if available).  And a few
> other syscalls in the Tile list aren't even implemented but were just
> brought over from x86 "in case", like afs_syscall, putpmsg, and getpmsg,
> so I'm happy to abandon them as well.  And "sysfs" is commented out of
> uclibc, and not present in glibc, so no big loss there.  Other than that
> I think the set of supported syscalls will only change by a couple --
> and more importantly, from my point of view, Tilera gets to stay
> automatically synced to any new syscalls added to Linux going forward. 
> So this is good.

ok.

> I assume that folks are committing to not changing any of the existing
> numbers, ifdefs, etc. in asm-generic/unistd.h; if we're the only
> architecture using it, no one might notice until we did. :-)

There is also score using it, but yes, we try very hard not to break
the ABI and any patch modifying these files normally gets posted to
the linux-arch and/or linux-api mailing lists that you should probably
subscribe to as well.

	Arnd
