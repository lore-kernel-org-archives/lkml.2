Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab0EYLSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:18:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0EYLSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:18:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: acquire_console_mutex: WARNING: at 2.6.33.4-rt20/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
Date: Tue, 25 May 2010 13:18:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100524225357.GA19513@aepfle.de>
In-Reply-To: <20100524225357.GA19513@aepfle.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251318.37242.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18/zYvl046CQf7WpG2E3pWQLpvHkwUI8nok5EZ
 BMqdvS47EgMoI9jmQFb18PsKP8/K8Zwf+M7a0xJgstl+C1THp/
 9jBfYbgajRpkD6LQpaGpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Olaf Hering wrote:
> I get this warning when busybox /sbin/init opens the console.
> It does not happen when CONFIG_PREEMPT_RT is enabled.
> Any ideas how to fix it for CONFIG_PREEMPT_DESKTOP?
> 
> [   16.450000] ------------[ cut here ]------------
> [   16.450000] WARNING: at /work/rt/linux-2.6.33-rt/kernel/mutex-debug.c:65 mutex_remove_waiter+0xe8/0x11c()
> [   16.450000] Modules linked in:
> [   16.450000] [<c0033e68>] (unwind_backtrace+0x0/0xdc) from [<c0324994>] (dump_stack+0x18/0x1c)
> [   16.450000] [<c0324994>] (dump_stack+0x18/0x1c) from [<c0049aec>] (warn_slowpath_common+0x50/0x68)
> [   16.450000] [<c0049aec>] (warn_slowpath_common+0x50/0x68) from [<c0049b1c>] (warn_slowpath_null+0x18/0x1c)
> [   16.450000] [<c0049b1c>] (warn_slowpath_null+0x18/0x1c) from [<c006d640>] (mutex_remove_waiter+0xe8/0x11c)
> [   16.450000] [<c006d640>] (mutex_remove_waiter+0xe8/0x11c) from [<c032709c>] (mutex_lock_nested+0x268/0x304)
> [   16.450000] [<c032709c>] (mutex_lock_nested+0x268/0x304) from [<c004a2d8>] (acquire_console_mutex+0x40/0x68)
> [   16.450000] [<c004a2d8>] (acquire_console_mutex+0x40/0x68) from [<c01d8420>] (con_open+0x18/0xc4)
> [   16.450000] [<c01d8420>] (con_open+0x18/0xc4) from [<c01c80dc>] (tty_open+0x398/0x55c)
> [   16.450000] [<c01c80dc>] (tty_open+0x398/0x55c) from [<c00ae628>] (chrdev_open+0x198/0x1bc)
> [   16.450000] [<c00ae628>] (chrdev_open+0x198/0x1bc) from [<c00a9928>] (__dentry_open+0x188/0x294)
> [   16.450000] [<c00a9928>] (__dentry_open+0x188/0x294) from [<c00a9b04>] (nameidata_to_filp+0x48/0x60)
> [   16.450000] [<c00a9b04>] (nameidata_to_filp+0x48/0x60) from [<c00b795c>] (do_filp_open+0x42c/0x8a8)
> [   16.450000] [<c00b795c>] (do_filp_open+0x42c/0x8a8) from [<c00a968c>] (do_sys_open+0x64/0x11c)
> [   16.450000] [<c00a968c>] (do_sys_open+0x64/0x11c) from [<c00a977c>] (sys_open+0x24/0x28)
> [   16.450000] [<c00a977c>] (sys_open+0x24/0x28) from [<c002e000>] (ret_fast_syscall+0x0/0x34)
> [   16.450000] ---[ end trace cdbe849ecfa1acdf ]---
> 
> The used config is shown after dmesg.

As a wild guess, this might happen because we drop the BKL in
mutex_lock_nested and might need to wait for it when we got the lock.
The reason that this surfaces in -rt would be that the console_sem
is replaced with a proper mutex there, on non-rt kernels this would
be invisible.

You could try to pull in the blk/tty branch from
http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git and enable
CONFIG_TTY_MUTEX to see if that gives you better lockdep output,
because that replaces the implicit dropping of the BKL with mutex operations
that lockdep is aware of.

	Arnd
