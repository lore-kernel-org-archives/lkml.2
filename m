Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992571Ab2KOJOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:14:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2KOJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:14:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: new architectures, time_t __kernel_long_t
Date: Thu, 15 Nov 2012 09:14:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
References: <201211141218.02105.arnd@arndb.de> <50A3C631.8010301@zytor.com>
In-Reply-To: <50A3C631.8010301@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211150914.22835.arnd@arndb.de>
X-Provags-ID: V02:K0:+qRxbS/r0OARWVbhnc0orpnm4n+g8tNOP7+E+58nAVV
 sNnxkVNvuHrkUyMqeMOMft3FPDgsEb/xEjrL1UOJePjqU2xvGz
 xjDaXToKmMrNvjQzIZ9eywAnDvZDssU2O8SOD6DF/J9fjalN0S
 KLWt7myZIuMxqO11NVcK5Z+Nj/tymc1uIYlejXc3R9eDGUcXFu
 hNnipfpbxiN/FQD00tP+WN0u/O1Vhvbd0SZlihp8MJEUauVPdW
 mpglc2i/YHKv3VX4wa3X12sp/o0I48RVS/xUMKjMbdWPSJjhUQ
 5Eo5MJT8QML6DY1ySB7OVJEDvdzo9pSZCsmbtTCZeD8FQNwfYv
 FB++rZTse6cCTHJDVeWU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012, H. Peter Anvin wrote:
> On 11/14/2012 04:18 AM, Arnd Bergmann wrote:
> > Since we are in the review phase for two new architectures that we
> > should be merging into the mainline kernel, I think we need to
> > come up with a solution for making them use a proper 64-bit time_t.
> >
> > Right now, the only 32-bit user space interface we have to use 64-bit
> > time_t is the x32 side of x86-64, and that works by overriding all
> > "long" sized types to be 64 bit at the ABI level, which we don't
> > want for pure 32 bit architectures.
> 
> Sort of.  Either way, the kernel headers aren't really x32-clean yet, so 
> we have an opportunity to do things more cleanly as we are implementing 
> this.

Ah, I didn't know that. How does one build an x32 libc then?

> > I would suggest we make 64-bit time_t, clock_t and suseconds_t the
> > default in include/asm-generic/posix_types.h and change all existing
> > 32 bit users of that file to provide an override to define these
> > as "long".
> 
> We also need snseconds_t: POSIX stupidly enough demands that the 
> nanosecond field in struct timespec is "long", but that is really not 
> appropriate.  Unfortunately there are existing architectures (e.g. 
> SPARC) where we can't use suseconds_t either, so we are trying to push a 
> new snseconds_t type into POSIX.

Right.

> > The other types that are used as 64 bit on x32 are ino_t, nlink_t,
> > size_t, ssize_t, ptrdiff_t, and off_t.
> 
> ptrdiff_t obviously not... although __kernel_ptrdiff_t is (as the 
> pointers are 64 bits in kernel space.)  Similarly, size_t and ssize_t 
> are only 32 bits in user space and we override them for compatibility 
> with the native kernel.

For ARC and Meta, the pointers in kernel space are never 64 bit. For x32,
they could in theory be 32 bit if one was to do a native x32 kernel port
(which I hope nobody will do).

The __kernel_* types are never about what the kernel actually has (user space
should not care), they are about what the ABI defines that are are using.

We could in theory define all the above (and __kernel_ulong_t) to be 64 bit
wide on all new architectures, which would allow doing 64 bit port later
without a compat layer, but that benefit would be far outweighed by the
complexity and cost of passing 64-bit arguments in two registers for a lot
of syscalls.

	Arnd
