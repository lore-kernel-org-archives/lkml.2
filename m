Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2JTNHC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 09:07:02 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:19122 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2JTNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 09:07:00 -0400
Message-ID: <5082A1F1.3080303@tilera.com>
Date: Sat, 20 Oct 2012 09:06:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com> <20121019213548.GR2616@ZenIV.linux.org.uk>
In-Reply-To: <20121019213548.GR2616@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 5:35 PM, Al Viro wrote:
> On Fri, Oct 19, 2012 at 04:25:12PM -0400, Chris Metcalf wrote:
>> Also provide an optimized current_pt_regs() while we're at it.
> Applied.  BTW, are you sure you want to record parent's pid and not tid?

By recording ->pid rather than ->pgid, we ARE recording the tid :-)

> Anyway, here's a followup on top of this one (again, completely untested) -
> switching to generic sys_execve().  Does that look right for you?

It does look right, but it doesn't quite work as-is.  But after some tweaks
it did yield a kernel that booted up userspace correctly, so I think it's
basically good.

First, the compat_sys_execve() declaration provided in
arch/tile/include/asm/compat.h isn't right, so I deleted that (you had only
deleted the PTREGS_SYSCALL trampoline declaration, _compat_sys_execve).

However, then arch/tile/kernel/compat.c failed to build, because
<linux/compat.h> is included before <asm/unistd.h>, and <asm/unistd.h>
provides __ARCH_WANT_SYS_EXECVE, and so we end up with no declaration at
all for compat_sys_execve.  For most platforms this is no big deal, but on
tile we use the __SYSCALL #define to provide the actual syscall table, and
for that to work we need a declaration in scope for each syscall at the
time we create the table.

The best solution seems likely to be to copy the other place in
<linux/compat.h> where we need to do something configurable (that is,
CONFIG_ARCH_WANT_OLD_COMPAT_IPC), and just convert __ARCH_WANT_SYS_EXECVE
to be a Kconfig option.

Another possibility is to pre-include <asm/unistd.h> in the tile compat.c
before including <linux/compat.h>.  This requires adding some #undefs for
_SC_3264, etc., in <asm-generic/unistd.h>, since we'll need to include the
header twice, once to satisfy <linux/compat.h>, and then again to actually
provide the body of the syscall array.  If we go down this path, I suspect
we should just make <linux/compat.h> include <asm/unistd.h>, so it gets the
__ARCH_WANT_SYS_EXECVE define provided.  Otherwise we have the ugly
requirement of requiring the C file to include specific headers in specific
order for it to work right.

> While
> we are at it, I wonder if any of PTREGS_SYSCALL wrappers are needed -
> current_pt_regs() would do just as well, won't it?  It's a couple of
> arithmetical operations vs. arith operation + branch; even if the latter
> is somehow cheaper, can't be cheaper by much.  And I'd expect it to be
> costlier, actually, what with the icache effects.

Yes, that's a good idea.  I'll look at it when I'm back in the office next
week.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

