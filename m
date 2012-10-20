Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2JTPeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:34:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38763 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2JTPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:34:04 -0400
Date: Sat, 20 Oct 2012 16:34:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and
 GENERIC_KERNEL_EXECVE
Message-ID: <20121020153401.GT2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
 <20121019213548.GR2616@ZenIV.linux.org.uk>
 <5082A1F1.3080303@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5082A1F1.3080303@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 09:06:57AM -0400, Chris Metcalf wrote:
> First, the compat_sys_execve() declaration provided in
> arch/tile/include/asm/compat.h isn't right, so I deleted that (you had only
> deleted the PTREGS_SYSCALL trampoline declaration, _compat_sys_execve).
> 
> However, then arch/tile/kernel/compat.c failed to build, because
> <linux/compat.h> is included before <asm/unistd.h>, and <asm/unistd.h>
> provides __ARCH_WANT_SYS_EXECVE, and so we end up with no declaration at
> all for compat_sys_execve.  For most platforms this is no big deal, but on
> tile we use the __SYSCALL #define to provide the actual syscall table, and
> for that to work we need a declaration in scope for each syscall at the
> time we create the table.
> 
> The best solution seems likely to be to copy the other place in
> <linux/compat.h> where we need to do something configurable (that is,
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC), and just convert __ARCH_WANT_SYS_EXECVE
> to be a Kconfig option.

Frankly, I hope to get rid of the damn thing completely.  By now we have
at least some variant of execve conversions for just about everything;
I certainly hope that by the beginning of the next cycle we'll have it
defined on everything.  And put unconditional declarations in syscalls.h
and compat.h

Actually, we can make the declaration in linux/compat.h unconditional
right now.  The only obstacle is the situation on arm64; there the mainline
has C variant of that sucker (with struct pt_regs * in arguments) in
arch/arm64/kernel/sys_compat.c.  So we could ask Linus to pull
git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64 execve
and then do the following in one patch:
	introduce current_pt_regs() on tile (from your commit)
	get rid of pt_regs * argument in tile compat_sys_execve(), making it
use current_pt_regs(); kill its wrapper
	kill the declarations of compat_sys_execve()/_compat_sys_execve()
in tile asm/compat.h
	make declaration in linux/compat.h unconditional
Note that this does *not* depend on kernel_thread/kernel_execve patch -
kernel_execve() is never going to hit compat_sys_execve(), since it's
only called from kernel threads and those are not going to be 32bit.
After that we can do kernel_thread/kernel_execve commit and
sys_execve() conversion with nothing outside of arch/tile touched.

Comments?  If Catalin feels that arm64 series needs more testing, we could
reorder it a bit - all we really need there is getting rid of pt_regs argument
in compat_sys_execve() and just as on tile, that isn't tied into kernel_execve
and kernel_thread issues.

FWIW, it's my fault - I assumed that it would be easier to sort the compat
side of things out on per-arch basis.  Should've consolidated *that* first
(unlike sys_execve(), that doesn't have any prereqs), followed by the
infrastructure for kernel_thread/kernel_execve/sys_execve series, followed
by the per-architecture conversions.  Too late for that now, of course,
and fortunately the mess is fairly small.
