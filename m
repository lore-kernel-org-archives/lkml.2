Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2HTUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:35:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2HTUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:34:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Date: Mon, 20 Aug 2012 20:34:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-22-git-send-email-catalin.marinas@arm.com> <20120820105308.GA906@elf.ucw.cz>
In-Reply-To: <20120820105308.GA906@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208202034.55135.arnd@arndb.de>
X-Provags-ID: V02:K0:mglmpDStT4MVSTIyndD4m4LGqW7B0lSIWgyBGdHMLo4
 Hy4oTZbjlNAj6G5J/p/biJbWFS6izsM93ZWBr6yDx2yVdsAfRW
 lxbhvHHuNcznrAEPTyoIoV8Kahz4hU5zZqJcqRejLDTeW0XLB0
 vvRtqrHkhw533pHlw98vb7i0eQeowH/SX7uATY5qYJQg9IAeb0
 O6iXqU1HJ6wNXVRx4cy+d13km5SHo/DaYOaWVT3M2qY09Hsm8W
 SpW8rXDIPlvC1ndqNvkvW9Km81JZJsI/XpR17lyBXs6fZI1yKY
 rRBqmwzpQdtmOAX4WnV9N7NA2pY2X7JPa1Xulacf8A3fqboG1T
 NmFtH7/n7cUkfdAE7bPU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Pavel Machek wrote:
> > This patch adds support for 32-bit applications. The vectors page is a
> > binary blob mapped into the application user space at 0xffff0000 (the
> > AArch64 toolchain does not support compilation of AArch32 code). Full
> > compatibility with ARMv7 user space is supported. The use of deprecated
> > ARMv7 functionality (SWP, CP15 barriers) has been disabled by default on
> > AArch64 kernels and unaligned LDM/STM is not supported.
> > 
> > Please note that only the ARM 32-bit EABI is supported, so no OABI
> > compatibility.
> 
> > +struct compat_statfs {
> > +     int             f_type;
> > +     int             f_bsize;
> > +     int             f_blocks;
> > +     int             f_bfree;
> > +     int             f_bavail;
> > +     int             f_files;
> > +     int             f_ffree;
> > +     compat_fsid_t   f_fsid;
> > +     int             f_namelen;      /* SunOS ignores this field. */
> 
> I'm sure it does. But is it good comment?

Good catch. It seems that some of the other compat platforms (x86,
sparc, powerpc) have the same thing. I guess the real solution would
be to introduce an asm-generic/compat.h file that contains a bunch
of those definitions, like

#ifndef compat_timespec
struct compat_timespec {
        compat_time_t   tv_sec;
        s32             tv_nsec;
};
#endif

#ifndef compat_timeval
struct compat_timeval {
        compat_time_t   tv_sec;
        s32             tv_usec;
};
#endif

#ifndef compat_sysctl
struct compat_sysctl {
        unsigned int    name;
        int             nlen;
        unsigned int    oldval;
        unsigned int    oldlenp;
        unsigned int    newval;
        unsigned int    newlen;
        unsigned int    __unused[4];
};
#endif

For the most part, arch/tile should have useful defaults, though not in the
case of struct statfs, because its 32 bit version does not have a statfs syscall
(it only has statfs64).

	Arnd
