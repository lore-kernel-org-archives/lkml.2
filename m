Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0EYNy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:54:28 -0400
Received: from king.tilera.com ([72.1.168.226]:42417 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006Ab0EYNyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:54:24 -0400
Message-ID: <4BFBD68C.9060405@tilera.com>
Date: Tue, 25 May 2010 09:54:20 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005240008.16497.arnd@arndb.de> <4BFA9B4E.9010200@tilera.com> <201005242053.25594.arnd@arndb.de>
In-Reply-To: <201005242053.25594.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2010 13:54:21.0829 (UTC) FILETIME=[C716E350:01CAFC11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/2010 2:53 PM, Arnd Bergmann wrote:
> Note that the asm-generic version defines 244 numbers, while you have
> a total of 313 numbers. You obviously need the extra arch specific
> syscalls (e.g cmpxchg), so we need to reserve some space for those
> in the generic header. All the other ones that are in your version but
> not in the generic version are very likely not needed (unless I made
> a mistake in the generic code).
>   

I looked at the diff of the set of syscalls you provide and the ones
we've been using.

Specific questions:

- How do you propose representing the architecture-specific syscalls? 
We have three "very special" syscalls that are negative numbers, which I
won't worry about, since they'll be out of the normal numbering
sequence.  But we also have a few others (cmpxchg_baddr, raise_fpe,
flush_cache) that we'll need a numbering location for.  I see that you
already have an empty block from 244 (today) to 1023; perhaps
architectures should just use 1023 on down?  I'll do this for now.

- You renamed __NR__llseek to __NR_llseek, which of course seems pretty
reasonable, but libc expects to see the former (both glibc and uclibc). 
Is it worth requiring non-standard libc code?  I may just add
__NR__llseek as an alias in my unistd.h for now.

- Are you planning to keep all the ifdef'ed syscalls going forward? 
Because honestly, I'd rather just enable __ARCH_WANT_SYSCALL_NO_AT,
etc., and use the kernel implementations, since otherwise I'll have to
go into both uclibc and glibc and add a bunch of extra Tilera-specific
code and then try to push that up to their community, when really I just
want to have the Tilera architecture userspace support be as generic as
possible.

The result seems positive overall; I'm certainly happy to dump, e.g.,
"nice" and "stime", since they have obvious userspace wrappers (and in
fact libc is already geared up to use them if available).  And a few
other syscalls in the Tile list aren't even implemented but were just
brought over from x86 "in case", like afs_syscall, putpmsg, and getpmsg,
so I'm happy to abandon them as well.  And "sysfs" is commented out of
uclibc, and not present in glibc, so no big loss there.  Other than that
I think the set of supported syscalls will only change by a couple --
and more importantly, from my point of view, Tilera gets to stay
automatically synced to any new syscalls added to Linux going forward. 
So this is good.

I assume that folks are committing to not changing any of the existing
numbers, ifdefs, etc. in asm-generic/unistd.h; if we're the only
architecture using it, no one might notice until we did. :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


