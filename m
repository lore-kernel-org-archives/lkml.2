Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2KNQ0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:26:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49404 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664Ab2KNQ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:26:37 -0500
Message-ID: <50A3C631.8010301@zytor.com>
Date: Wed, 14 Nov 2012 08:26:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: new architectures, time_t __kernel_long_t
References: <201211141218.02105.arnd@arndb.de>
In-Reply-To: <201211141218.02105.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 04:18 AM, Arnd Bergmann wrote:
> Since we are in the review phase for two new architectures that we
> should be merging into the mainline kernel, I think we need to
> come up with a solution for making them use a proper 64-bit time_t.
>
> Right now, the only 32-bit user space interface we have to use 64-bit
> time_t is the x32 side of x86-64, and that works by overriding all
> "long" sized types to be 64 bit at the ABI level, which we don't
> want for pure 32 bit architectures.

Sort of.  Either way, the kernel headers aren't really x32-clean yet, so 
we have an opportunity to do things more cleanly as we are implementing 
this.

> I would suggest we make 64-bit time_t, clock_t and suseconds_t the
> default in include/asm-generic/posix_types.h and change all existing
> 32 bit users of that file to provide an override to define these
> as "long".

We also need snseconds_t: POSIX stupidly enough demands that the 
nanosecond field in struct timespec is "long", but that is really not 
appropriate.  Unfortunately there are existing architectures (e.g. 
SPARC) where we can't use suseconds_t either, so we are trying to push a 
new snseconds_t type into POSIX.

> The other types that are used as 64 bit on x32 are ino_t, nlink_t,
> size_t, ssize_t, ptrdiff_t, and off_t.

ptrdiff_t obviously not... although __kernel_ptrdiff_t is (as the 
pointers are 64 bits in kernel space.)  Similarly, size_t and ssize_t 
are only 32 bits in user space and we override them for compatibility 
with the native kernel.

> Obviously, we want to use 64-bit off_t, but this is achieved already
> through loff_t, which is used in all places in the asm-generic
> ABI anyway (the syscalls using off_t are stripped out). I don't
> think we want to have the other ones set to 64 bit on ARC or Meta,
> although I'm not 100% sure about ino_t and nlink_t.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

