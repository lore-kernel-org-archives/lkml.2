Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab2JWRac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:30:32 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:25501 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab2JWRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:30:30 -0400
Message-ID: <5086D432.4070008@tilera.com>
Date: Tue, 23 Oct 2012 13:30:26 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com> <20121019213548.GR2616@ZenIV.linux.org.uk> <5082A1F1.3080303@tilera.com> <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk>
In-Reply-To: <20121020171643.GU2616@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 1:16 PM, Al Viro wrote:
> On Sat, Oct 20, 2012 at 04:34:01PM +0100, Al Viro wrote:
>> On Sat, Oct 20, 2012 at 09:06:57AM -0400, Chris Metcalf wrote:
>>> First, the compat_sys_execve() declaration provided in
>>> arch/tile/include/asm/compat.h isn't right, so I deleted that (you had only
>>> deleted the PTREGS_SYSCALL trampoline declaration, _compat_sys_execve).
>>>
>>> However, then arch/tile/kernel/compat.c failed to build, because
>>> <linux/compat.h> is included before <asm/unistd.h>, and <asm/unistd.h>
>>> provides __ARCH_WANT_SYS_EXECVE, and so we end up with no declaration at
>>> all for compat_sys_execve.  For most platforms this is no big deal, but on
>>> tile we use the __SYSCALL #define to provide the actual syscall table, and
>>> for that to work we need a declaration in scope for each syscall at the
>>> time we create the table.
>>>
>>> The best solution seems likely to be to copy the other place in
>>> <linux/compat.h> where we need to do something configurable (that is,
>>> CONFIG_ARCH_WANT_OLD_COMPAT_IPC), and just convert __ARCH_WANT_SYS_EXECVE
>>> to be a Kconfig option.
>> Frankly, I hope to get rid of the damn thing completely.  By now we have
>> at least some variant of execve conversions for just about everything;
>> I certainly hope that by the beginning of the next cycle we'll have it
>> defined on everything.  And put unconditional declarations in syscalls.h
>> and compat.h
>>
>> Actually, we can make the declaration in linux/compat.h unconditional
>> right now.  The only obstacle is the situation on arm64; there the mainline
>> has C variant of that sucker (with struct pt_regs * in arguments) in
>> arch/arm64/kernel/sys_compat.c.  So we could ask Linus to pull
>> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64 execve
>> and then do the following in one patch:
>> 	introduce current_pt_regs() on tile (from your commit)
>> 	get rid of pt_regs * argument in tile compat_sys_execve(), making it
>> use current_pt_regs(); kill its wrapper
>> 	kill the declarations of compat_sys_execve()/_compat_sys_execve()
>> in tile asm/compat.h
>> 	make declaration in linux/compat.h unconditional
>> Note that this does *not* depend on kernel_thread/kernel_execve patch -
>> kernel_execve() is never going to hit compat_sys_execve(), since it's
>> only called from kernel threads and those are not going to be 32bit.
>> After that we can do kernel_thread/kernel_execve commit and
>> sys_execve() conversion with nothing outside of arch/tile touched.
> Another possible variant is for you to merge that branch from arm64 tree
> (only 3 commits it it) and then do as described above.  I.e. on top of
> that apply the thing below, followed by your kernel_thread()/kernel_execve()
> patch (sans current_pt_regs() part), followed by obviously massaged parts
> of generic sys_execve for tile patch I've sent.  FWIW, I've put the
> whole series (based at the end of arm64 branch) in signal.git#arch-tile.
> Comments?

I fetched the series from your arch-tile branch and built it, and it works
fine.  It looks good from my inspection:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

As you had suggested in an earlier email, I went ahead and eliminated the
special pt_regs handling for sigaltstack, rt_sigreturn, and clone.  (Also a
tilepro-specific syscall that was also using PTREG_SYSCALL.)  I'll send it
separately and you can include it in your tree if you like.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

