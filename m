Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab0J2XX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 19:23:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab0J2XXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 19:23:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] asm-generic/stat.h: support 64-bit file time_t for stat()
Date: Fri, 29 Oct 2010 08:25:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Michal Simek <monstr@monstr.eu>
References: <201010282020.o9SKKe4Y007068@farm-0012.internal.tilera.com>
In-Reply-To: <201010282020.o9SKKe4Y007068@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010290826.00087.arnd@arndb.de>
X-Provags-ID: V02:K0:IYMJRKdIeV4E5D1PG+Cb74zd4cm01vFfUKfKdFqzUED
 t6pyihWXbjLJAMGUojxIxyB5WcDab386+ZaC/PlVkE2oXThhIL
 Oij4l/UmrZJs+O2G1sEgsQeAKCvJxhVCOeP5HC9n6fLRCM68dp
 T9JtqOaw76RdGSk0Ub78oZLVJ13amHyTHyMAMewGvTVAPt29kB
 bV1fXr4hFNGerXUUq/PSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 October 2010, Chris Metcalf wrote:
> The existing asm-generic/stat.h specifies st_mtime, etc., as a 32-value,
> and works well for 32-bit architectures (currently microblaze, score,
> and 32-bit tile).  However, for 64-bit architectures it isn't sufficient
> to return 32 bits of time_t; this isn't good insurance against the 2037
> rollover.  (It also makes glibc support less convenient, since we can't
> use glibc's handy STAT_IS_KERNEL_STAT mode.)

Yes, this goes back to my ignoring the y2k38 problem when I introduced
that header. I couldn't think of a reason to make st_mtime longer
than 32 bits, and defined it in a way that would make the structure
compatible between 32 and 64 bit code.

> The only wrinkle is 32-bit userspace under 64-bit kernels taking advantage
> of COMPAT mode.  For these, we leave the "struct stat64" definitions with
> the "int" versions of the time_t and nsec fields, so that architectures
> can implement compat_sys_stat64() and friends with sys_stat64(), etc.,
> and get the expected 32-bit structure layout.  This requires a
> field-by-field copy in the kernel, implemented by the code guarded
> under __ARCH_WANT_STAT64.

Right. That reminds me that I shold go through the system call definitions
one day and make sure we don't actually build the syscalls into
the kernel that are not used on tile and other architectures using
the generic header files.

> The alternative is keeping the two structures the same shape on 64-bit
> kernels, which means a 64-bit time_t in "struct stat64" for 32-bit
> processes.  This is a little unnatural since 32-bit userspace can't
> do anything with 64 bits of time_t information, since time_t is just
> "long", not "int64_t"; and in any case 32-bit userspace might expect
> to be running under a 32-bit kernel, which can't provide the high 32
> bits anyway.  In the case of a 32-bit kernel we'd then be extending the
> kernel's 32-bit time_t to 64 bits, then truncating it back to 32 bits
> again in userspace, for no particular reason.  And, as mentioned above,
> if we have 64-bit time_t for 32-bit processes we can't easily use glibc's
> STAT_IS_KERNEL_STAT, since glibc's stat structure requires an embedded
> "struct timespec", which is a pair of "long" (32-bit) values in a 32-bit
> userspace.  "Inventive" solutions are possible, but are pretty hacky.

I'd like to have more opinions on that. Would it be less crazy
to ignore the y2k38 problem for new 32 bit architectures given that
we already know about it, or to make those architectures unnecessarily
slow, given that we still have 27+ years before it hits people in
a major way?

I think we have four alternatives here:

1. this patch, which is the easiest solution and keeps everything else
working, but not solving the y2k38 problem on 32 bit.

2. make __kernel_time_t 64 bit on new architectures, solving the y2k38
problem for them at the cost of run-time overhead and possibly application
porting effort.

3. make struct stat use a 64 bit time field on new architectures at the
cost of not using STAT_IS_KERNEL_STAT in 32 bit glibc.

4. leave struct stat as it is, and move to struct xstat that does
everything right from the start.

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Your patch looks correct for solution 1, I can forward it if we decide
to do it this way, or you can take it in your series.

Acked-by: Arnd Bergmann <arnd@arndb.de>

