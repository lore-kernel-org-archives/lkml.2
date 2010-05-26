Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0EZXGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:06:02 -0400
Received: from king.tilera.com ([72.1.168.226]:24252 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab0EZXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:06:00 -0400
Message-ID: <4BFDA954.7070701@tilera.com>
Date: Wed, 26 May 2010 19:05:56 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BFBD68C.9060405@tilera.com> <4BFBE005.2070500@tilera.com> <201005251721.23782.arnd@arndb.de>
In-Reply-To: <201005251721.23782.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2010 23:05:59.0453 (UTC) FILETIME=[013944D0:01CAFD28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 5/25/2010 11:21 AM, Arnd Bergmann wrote (in private email):
> I just realized that the the sys_call_table is not yet
> being generated automatically. The code is only present
> in arch/score/kernel/sys_call_table.c.
>
> To do this correctly, you should take that file and
> put it into kernel/sys_call_table.c, configured with
> CONFIG_GENERIC_SYSCALLTABLE, which you then enable
> in your arch/tile/Kconfig.
> The unistd.h is also missing the compat syscall table
> entries. It would be good to extend the macros to cover
> that as well, similar to how it's done in
> arch/powerpc/include/asm/systbl.h.
>   

The hard part to applying this approach turned out to be the COMPAT code
for our 64-bit platform.  The approach I am using now is to extend
<linux/compat.h> with all the compat syscalls that are not currently
prototyped, and then to include a a set of #defines that allow all the
compat syscalls to be invoked as "compat_sys_foo()", e.g.

+/* Standard Linux functions that don't have "compat" versions. */
+#define compat_sys_accept sys_accept
+#define compat_sys_accept4 sys_accept4
+#define compat_sys_access sys_access
+#define compat_sys_acct sys_acct
[...]
+#define compat_sys_uselib sys_uselib
+#define compat_sys_vfork sys_vfork
+#define compat_sys_vhangup sys_vhangup
+#define compat_sys_write sys_write


With that in place, you can then use the "arch/score" mechanism to
generate not just the main syscall table, but the compat table as well,
by doing something like this:

+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (compat_##call),
+
+void *compat_sys_call_table[__NR_syscalls] = {
+       [0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};


To make this really work out, I also had to add a __SYSCALL_COMPAT
notion to <asm-generic/unistd.h>; when this is set, the __NR_xxx values
and the __SYSCALL stuff are set up as if for a 32-bit platform, even if
the real platform is 64-bit, so that the header can be used to create
the compat_sys_call_table[] properly.

I fixed a few other minor glitches too, like the fact that we need
sys_fadvise64_64 to be the "primary" syscall even in the 64-bit case
(not sys_fadvise64), and adding an __ARCH_WANT_SYNC_FILE_RANGE2 flag to
the generic ABI so platforms can request the use of that flavor of the
ABI instead.  (It makes a difference on our platform.)  And I took
Arnd's suggestion and added 16 architecture-specific syscalls from 244
to 259.

Note that it turns out not to be quite right to make the
sys_call_table.c a generic file, at least in our case, since you really
want to allow tweaking the actual syscall functions as part of
generating the sys_call_table[] array.  For example, on our 32-bit
platforms some of the 64-bit syscalls need wrappers since otherwise
there is a mismatch between the generic code in libc that splits 64-bit
values into 32-bit registers, and the actual registers pairs used by our
ABI for native 64-bit values.  In any case it's only half a dozen lines
of common code.  And in compat mode there are additional overrides you
want, such as using sys_newstat() for compat_sys_stat64(), if your
architecture will tolerate it, etc.

I'll send a complete patch later once I've finished digesting all the
various suggestions folks have sent, but this was a big enough piece
that I thought I'd at least summarize the design back to LKML in case
people would care to comment.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


