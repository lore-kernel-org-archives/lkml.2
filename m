Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0E0OfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:35:11 -0400
Received: from king.tilera.com ([72.1.168.226]:37263 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab0E0OfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:35:09 -0400
Message-ID: <4BFE831A.8050002@tilera.com>
Date: Thu, 27 May 2010 10:35:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005271041.30519.arnd@arndb.de> <4BFE73DF.5090107@tilera.com> <201005271611.47963.arnd@arndb.de>
In-Reply-To: <201005271611.47963.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 14:35:07.0717 (UTC) FILETIME=[CDC74750:01CAFDA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2010 10:11 AM, Arnd Bergmann wrote:
>>> > > I see. AFAICT, all other architectures don't need the wrapper in
>>> > > the 32 bit native case because they define the syscall calling
>>> > > conventions in libc such that they match what the kernel
>>> > > expects for a 64 bit argument (typically split in two subsequent
>>> > > argument slots). Would that work for you as well?
>>>       
>>
>> > Yes, we could override this in libc.  My assumption was that it was
>> > cleaner to do it in the kernel, since we support uclibc and glibc, and
>> > doing it in the kernel meant only doing it in one place.
>>     
> That's not the way I meant. There are two options how (any) libc can
> implement this:
> 1. the calling conventions for user function calls and for kernel
>    function calls are the same, so you don't need to do anything here.
> 2. the calling conventions are different, so you already need a wrapper
>    in user space for 64 bit arguments to split them up and you could
>    to that in exactly the way that the kernel expects to be called.
>   

The issue is that libc support for 64-bit operands on 32-bit platforms
tends to look like "syscall(foo64, arg1, LOW(arg2), HIGH(arg2))".  This
naturally passes the arguments in consecutive registers, for a
register-based calling convention like ours.  However, invoking
"foo64(arg1, (u64)arg2)" passes the u64 argument in the next consecutive
even/odd numbered pair of registers on our architecture.  Arguably this
notion of register alignment isn't particularly helpful, but we opted to
do it this way when we settled on the API.  The upshot is that to match
this, userspace needs to do "syscall(foo64, arg1, dummy, LOW(arg2),
HIGH(arg2))".  So we need to provide these dummy-argument versions of
the syscall wrappers to all the libcs that we use (currently uclibc,
glibc, and sometimes newlib).  Where the 64-bit argument falls naturally
on an even register boundary we don't need to provide any kernel stub.

Basically the scenario is your #2 above, but userspace already has an
implementation of the user-space wrapper in the generic code, and I'm
trying to avoid having to provide a tile-specific version of it.

For reference, here's readahead() in glibc (overridden to be a pure
syscall wrapper for 64-bit architectures):

ssize_t
__readahead (int fd, off64_t offset, size_t count)
{
  return INLINE_SYSCALL (readahead, 4, fd,
                         __LONG_LONG_PAIR ((off_t) (offset >> 32),
                                           (off_t) (offset & 0xffffffff)),
                         count);
}


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


