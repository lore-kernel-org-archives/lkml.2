Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0E3VjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 17:39:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:13128 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0E3VjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 17:39:13 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283rgF+SkOsw8xqo3A=
X-RZG-CLASS-ID: mo00
Date: Sun, 30 May 2010 23:39:02 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: acquire_console_mutex: WARNING: at
 2.6.33.4-rt20/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
Message-ID: <20100530213902.GA3619@aepfle.de>
References: <20100524225357.GA19513@aepfle.de>
 <201005251318.37242.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201005251318.37242.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, Arnd Bergmann wrote:

> On Tuesday 25 May 2010, Olaf Hering wrote:
> > I get this warning when busybox /sbin/init opens the console.
> > It does not happen when CONFIG_PREEMPT_RT is enabled.
> > Any ideas how to fix it for CONFIG_PREEMPT_DESKTOP?
> > 
> > [   16.450000] ------------[ cut here ]------------
> > [   16.450000] WARNING: at /work/rt/linux-2.6.33-rt/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
> > [   16.450000] Modules linked in:
> > [   16.450000] [<c0033e68>] (unwind_backtrace+0x0/0xdc) from [<c0324994>] (dump_stack+0x18/0x1c)
> > [   16.450000] [<c0324994>] (dump_stack+0x18/0x1c) from [<c0049aec>] (warn_slowpath_common+0x50/0x68)
> > [   16.450000] [<c0049aec>] (warn_slowpath_common+0x50/0x68) from [<c0049b1c>] (warn_slowpath_null+0x18/0x1c)
> > [   16.450000] [<c0049b1c>] (warn_slowpath_null+0x18/0x1c) from [<c006d640>] (mutex_remove_waiter+0xe8/0x11c)
> > [   16.450000] [<c006d640>] (mutex_remove_waiter+0xe8/0x11c) from [<c032709c>] (mutex_lock_nested+0x268/0x304)
> > [   16.450000] [<c032709c>] (mutex_lock_nested+0x268/0x304) from [<c004a2d8>] (acquire_console_mutex+0x40/0x68)
> > [   16.450000] [<c004a2d8>] (acquire_console_mutex+0x40/0x68) from [<c01d8420>] (con_open+0x18/0xc4)
> > [   16.450000] [<c01d8420>] (con_open+0x18/0xc4) from [<c01c80dc>] (tty_open+0x398/0x55c)
> > [   16.450000] [<c01c80dc>] (tty_open+0x398/0x55c) from [<c00ae628>] (chrdev_open+0x198/0x1bc)
> > [   16.450000] [<c00ae628>] (chrdev_open+0x198/0x1bc) from [<c00a9928>] (__dentry_open+0x188/0x294)
> > [   16.450000] [<c00a9928>] (__dentry_open+0x188/0x294) from [<c00a9b04>] (nameidata_to_filp+0x48/0x60)
> > [   16.450000] [<c00a9b04>] (nameidata_to_filp+0x48/0x60) from [<c00b795c>] (do_filp_open+0x42c/0x8a8)
> > [   16.450000] [<c00b795c>] (do_filp_open+0x42c/0x8a8) from [<c00a968c>] (do_sys_open+0x64/0x11c)
> > [   16.450000] [<c00a968c>] (do_sys_open+0x64/0x11c) from [<c00a977c>] (sys_open+0x24/0x28)
> > [   16.450000] [<c00a977c>] (sys_open+0x24/0x28) from [<c002e000>] (ret_fast_syscall+0x0/0x34)
> > [   16.450000] ---[ end trace cdbe849ecfa1acdf ]---
> > 
> > The used config is shown after dmesg.
> 
> As a wild guess, this might happen because we drop the BKL in
> mutex_lock_nested and might need to wait for it when we got the lock.
> The reason that this surfaces in -rt would be that the console_sem
> is replaced with a proper mutex there, on non-rt kernels this would
> be invisible.
> 
> You could try to pull in the blk/tty branch from
> http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git and enable
> CONFIG_TTY_MUTEX to see if that gives you better lockdep output,
> because that replaces the implicit dropping of the BKL with mutex operations
> that lockdep is aware of.

CONFIG_TTY_MUTEX depends on SMP and this ARM system does not support
CONFIG_SMP, its hidden by Kconfig dependencies.


Olaf
