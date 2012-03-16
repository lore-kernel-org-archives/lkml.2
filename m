Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032625Ab2CPH7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:59:11 -0400
Received: from smtp.cs.ucla.edu ([131.179.128.62]:41042 "EHLO smtp.cs.ucla.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032600Ab2CPH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:59:09 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2012 03:59:09 EDT
Message-ID: <4F62F152.1040909@cs.ucla.edu>
Date: Fri, 16 Mar 2012 00:52:50 -0700
From: Paul Eggert <eggert@cs.ucla.edu>
Organization: UCLA Computer Science Department
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        GNU C Library <libc-alpha@sourceware.org>
Subject: Re: PATCH [3/n]: Add __snseconds_t and __SNSECONDS_T_TYPE
References: <20120315192515.GA6585@intel.com> <20120315195000.7E3BE2C0A3@topped-with-meat.com> <CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com> <4F625570.7050003@cs.ucla.edu> <CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com> <4F6267B1.3090805@cs.ucla.edu> <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
In-Reply-To: <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 03:19 PM, H.J. Lu wrote:
> https://lkml.org/lkml/2012/2/8/408

That discussion does not seem to have considered the issue
of pointers, nor the issue of printf that Russ Allbery pointed out.
Here's an example from Kerrisk's "The Linux Programming Interface"
<http://man7.org/tlpi/code/online/dist/timers/t_clock_nanosleep.c.html>

            printf("... Remaining: %ld.%09ld",
                    (long) remain.tv_sec, remain.tv_nsec);

The proposed change breaks code like this.

>>  struct timespec t;
>>  long *p = &t->tv_nsec;
>> Such applications work fine now and conform to POSIX
> 
> GCC will complain about "incompatible pointer type".

True, and admittedly taking the address of tv_nsec is rarer than
printing it.  Still, it's just a warning and GCC goes ahead and builds
the program, and such warnings are often ignored.

> timespec is used in quite a few system calls. Checking all places
> which need to sign-extend is quite complex.

Many system calls copy timespec values from the kernel to the user;
these would be unaffected.  For syscalls that copy from the user
to the kernel, one could change glibc code like this:

  /* The Linux kernel can in some situations update the timeout value.          
     We do not want that so use a local variable.  */
  struct timespec tval;
  if (timeout != NULL)
    {
      tval = *timeout;
      timeout = &tval;
    }

(taken from glibc/sysdeps/unix/sysv/linux/pselect.c) to something like this:

  /* The Linux kernel can in some situations update the timeout value,
     or require a properly sign-extended timespec.  */
  struct timespec tval;
  if (timeout != NULL)
    {
      copy_timespec (&tval, timeout);
      timeout = &tval;
    }

where copy_timespec is an inline function that merely copies on existing
platforms, and also sign-extends tv_nsec on x32.  This doesn't appear complex,
though admittedly it does slow things down slightly on x32.

Another option, perhaps, would be to change the Linux kernel to
know about x32 binaries and to sign-extend tv_nsec inside the kernel,
when copying struct timespec objects from the user to the kernel.

Yet another option, I guess, would be to change POSIX so that tv_nsec could
be of type wider than 'long'.  However, this would seem to run afoul of
POSIX's intent, which is that system types like suseconds_t should
not be wider than 'long'; see
<http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html>.
This constraint is to support uses like 'printf'.
Given the likelihood of breaking programs, it may be better simply
to conform to POSIX in this area, rather than change POSIX.
