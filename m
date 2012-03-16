Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423060Ab2CPPtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:49:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37630 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332Ab2CPPtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <4F62F152.1040909@cs.ucla.edu>
References: <20120315192515.GA6585@intel.com>
	<20120315195000.7E3BE2C0A3@topped-with-meat.com>
	<CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com>
	<4F625570.7050003@cs.ucla.edu>
	<CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com>
	<4F6267B1.3090805@cs.ucla.edu>
	<CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
	<4F62F152.1040909@cs.ucla.edu>
Date: Fri, 16 Mar 2012 08:49:00 -0700
Message-ID: <CAMe9rOqz0bC6hb=f0BCGzaRHhdnqi65gFCF0h8S0Okgo7TjSsQ@mail.gmail.com>
Subject: Re: PATCH [3/n]: Add __snseconds_t and __SNSECONDS_T_TYPE
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        GNU C Library <libc-alpha@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:52 AM, Paul Eggert <eggert@cs.ucla.edu> wrote:
> On 03/15/2012 03:19 PM, H.J. Lu wrote:
>> https://lkml.org/lkml/2012/2/8/408
>
> That discussion does not seem to have considered the issue
> of pointers, nor the issue of printf that Russ Allbery pointed out.
> Here's an example from Kerrisk's "The Linux Programming Interface"
> <http://man7.org/tlpi/code/online/dist/timers/t_clock_nanosleep.c.html>
>
>            printf("... Remaining: %ld.%09ld",
>                    (long) remain.tv_sec, remain.tv_nsec);
>
> The proposed change breaks code like this.

This will print the lower 32bit of remain.tv_nsec since for x32 each integer
argument lakes a register or a 8byte slot.

>>>  struct timespec t;
>>>  long *p = &t->tv_nsec;
>>> Such applications work fine now and conform to POSIX
>>
>> GCC will complain about "incompatible pointer type".
>
> True, and admittedly taking the address of tv_nsec is rarer than
> printing it.  Still, it's just a warning and GCC goes ahead and builds
> the program, and such warnings are often ignored.
>
>> timespec is used in quite a few system calls. Checking all places
>> which need to sign-extend is quite complex.
>
> Many system calls copy timespec values from the kernel to the user;
> these would be unaffected.  For syscalls that copy from the user
> to the kernel, one could change glibc code like this:
>
>  /* The Linux kernel can in some situations update the timeout value.
>     We do not want that so use a local variable.  */
>  struct timespec tval;
>  if (timeout != NULL)
>    {
>      tval = *timeout;
>      timeout = &tval;
>    }
>
> (taken from glibc/sysdeps/unix/sysv/linux/pselect.c) to something like this:
>
>  /* The Linux kernel can in some situations update the timeout value,
>     or require a properly sign-extended timespec.  */
>  struct timespec tval;
>  if (timeout != NULL)
>    {
>      copy_timespec (&tval, timeout);
>      timeout = &tval;
>    }
>
> where copy_timespec is an inline function that merely copies on existing
> platforms, and also sign-extends tv_nsec on x32.  This doesn't appear complex,
> though admittedly it does slow things down slightly on x32.
>
> Another option, perhaps, would be to change the Linux kernel to
> know about x32 binaries and to sign-extend tv_nsec inside the kernel,
> when copying struct timespec objects from the user to the kernel.
>
> Yet another option, I guess, would be to change POSIX so that tv_nsec could
> be of type wider than 'long'.  However, this would seem to run afoul of
> POSIX's intent, which is that system types like suseconds_t should
> not be wider than 'long'; see
> <http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html>.
> This constraint is to support uses like 'printf'.
> Given the likelihood of breaking programs, it may be better simply
> to conform to POSIX in this area, rather than change POSIX.

I'd prefer to change POSIX. This isn't the only place where x32 isn't
100% compatible with POSIX.

-- 
H.J.
