Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768432Ab2KOQlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:41:21 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59774 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768408Ab2KOQlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:41:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121017161953.GZ2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
	<CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
	<20121017160702.GY2616@ZenIV.linux.org.uk>
	<20121017161953.GZ2616@ZenIV.linux.org.uk>
Date: Thu, 15 Nov 2012 17:41:16 +0100
Message-ID: <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
Subject: Re: new execve/kernel_thread design
From: Michal Simek <monstr@monstr.eu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

2012/10/17 Al Viro <viro@zeniv.linux.org.uk>:
> On Wed, Oct 17, 2012 at 05:07:03PM +0100, Al Viro wrote:
>> What happens during boot is this:
>>       * init_task (not to be confused with init) is used as current during
>> infrastructure initializations.  Once everything needed for scheduler and
>> for working fork is set, we spawn two threads - future init and future
>> kthreadd.  The last thing we do with init_task is telling init that kthreadd
>> has been spawned.  After that init_task turns itself into an idle thread.
>>       * future init waits for kthreadd to be spawned (it would be more
>> natural to fork them in opposite order, but we want init to have PID 1 -
>> too much stuff in userland depends on that).  Then it does the rest of
>> initialization, including setting up initramfs contents.  And does
>> kernel_execve() on /init.  Note that this is a task that had been created
>> by kernel_thread() and is currently in function called from
>> ret_from_kernel_thread().  Its kernel stack has been set up by copy_thread().
>> That's where pt_regs need to be set up; note that they'll be passed to
>> start_thread() before you return to userland.  If there are any magic bits
>> in pt_regs needed by return-from-syscall code, set them in kthread case of
>> copy_thread().
>
> PS: I suspect that we end up with the wrong value in childregs->msr;
> start_thread() only add MSR_UMS there.  I'd suggest running the kernel
> with these patches + printk childregs->msr the very first time start_thread()
> is called and see what it prints, then working kernel + such printk and
> compare the results...

sorry for taking this so long.
I have looked at it and fix it.

Here is the branch based on rc5 (information below)
and here is giweb.
http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=shortlog;h=refs/heads/viro/arch-microblaze-rc5

I have also looked at your sys_fork / sys_vfork / sys_clone unification
and I have fixed it for Microblaze.

Also I have done some tests on it for sure.

I would add sys_execve/kernel_execve/kernel_thread patches to my next branch.
Are you OK with that?

Do you need to test anything else for MB?

Thanks,
Michal


The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:
  Linus Torvalds (1):
        Linux 3.7-rc5

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git viro/arch-microblaze-rc5

Al Viro (5):
      microblaze: switch to generic kernel_thread()
      microblaze: switch to generic kernel_execve()
      microblaze: switch to generic sys_execve()
      generic sys_fork / sys_vfork / sys_clone
      microblaze: switch to generic fork/vfork/clone

Michal Simek (3):
      microblaze: Fix bug with schedule_tail
      microblaze: Define current_pt_regs
      microblaze: Remove BIP from childregs

 arch/Kconfig                            |   11 ++++
 arch/microblaze/Kconfig                 |    3 +
 arch/microblaze/include/asm/processor.h |   10 +---
 arch/microblaze/include/asm/unistd.h    |    6 ++
 arch/microblaze/kernel/entry-nommu.S    |   20 +++-----
 arch/microblaze/kernel/entry.S          |   57 ++++-------------------
 arch/microblaze/kernel/process.c        |   77 ++++++++++---------------------
 arch/microblaze/kernel/sys_microblaze.c |   53 ---------------------
 arch/microblaze/kernel/syscall_table.S  |    6 +--
 include/asm-generic/syscalls.h          |    7 +--
 kernel/fork.c                           |   43 +++++++++++++++++
 11 files changed, 111 insertions(+), 182 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
