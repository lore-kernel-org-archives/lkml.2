Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0KXVxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:53:43 -0500
Received: from build.ihdev.net ([178.63.197.118]:54321 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0KXVxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:53:42 -0500
Date: Wed, 24 Nov 2010 16:53:39 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
Message-ID: <20101124215339.GA8691@build.ihdev.net>
References: <20101124135249.GA7282@build.ihdev.net>
 <4CED2251.3020708@suse.cz>
 <20101124170326.GB7282@build.ihdev.net>
 <4CED6ACF.9000402@suse.cz>
 <4CED6B53.50408@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED6B53.50408@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 08:45:23PM +0100, Jiri Slaby wrote:
> On 11/24/2010 08:43 PM, Jiri Slaby wrote:
> > Could you provide disassembly of tty_set_ldisc? E.g. by extracting it from:
> > objdump -d drivers/tty/tty_ldisc.o
> 
> Or maybe better after linking:
> objdump -d vmlinux
> 
> thanks,
> -- 
> js
> suse labs

This is reproduced on second run of application I submitted on my previous mail:

WARNING: at drivers/tty/tty_ldisc.c:451 tty_ldisc_open+0x3c/0x9c()
Modules linked in:
[<c002c694>] (unwind_backtrace+0x0/0xe4) from [<c0037ad4>] (warn_slowpath_common+0x4c/0x64)
[<c0037ad4>] (warn_slowpath_common+0x4c/0x64) from [<c0037b04>] (warn_slowpath_null+0x18/0x1c)
[<c0037b04>] (warn_slowpath_null+0x18/0x1c) from [<c01bb88c>] (tty_ldisc_open+0x3c/0x9c)
[<c01bb88c>] (tty_ldisc_open+0x3c/0x9c) from [<c01bc110>] (tty_set_ldisc+0x328/0x454)
[<c01bc110>] (tty_set_ldisc+0x328/0x454) from [<c01b6624>] (tty_ioctl+0x83c/0xac4)
[<c01b6624>] (tty_ioctl+0x83c/0xac4) from [<c00b383c>] (vfs_ioctl+0x20/0x3c)
[<c00b383c>] (vfs_ioctl+0x20/0x3c) from [<c00b3f9c>] (do_vfs_ioctl+0x540/0x598)
[<c00b3f9c>] (do_vfs_ioctl+0x540/0x598) from [<c00b4028>] (sys_ioctl+0x34/0x54)
[<c00b4028>] (sys_ioctl+0x34/0x54) from [<c0027a80>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 478cfbb6d09c3354 ]---
can't set ldisc: Cannot allocate memory
root@sheevaplug:~# ./a.out /dev/ttyS1 
.
^C
root@sheevaplug:~# ./a.out /dev/ttyS1 
------------[ cut here ]------------
WARNING: at drivers/tty/tty_ldisc.c:451 tty_ldisc_open+0x3c/0x9c()
Modules linked in:
[<c002c694>] (unwind_backtrace+0x0/0xe4) from [<c0037ad4>] (warn_slowpath_common+0x4c/0x64)
[<c0037ad4>] (warn_slowpath_common+0x4c/0x64) from [<c0037b04>] (warn_slowpath_null+0x18/0x1c)
[<c0037b04>] (warn_slowpath_null+0x18/0x1c) from [<c01bb88c>] (tty_ldisc_open+0x3c/0x9c)
[<c01bb88c>] (tty_ldisc_open+0x3c/0x9c) from [<c01bc110>] (tty_set_ldisc+0x328/0x454)
[<c01bc110>] (tty_set_ldisc+0x328/0x454) from [<c01b6624>] (tty_ioctl+0x83c/0xac4)
[<c01b6624>] (tty_ioctl+0x83c/0xac4) from [<c00b383c>] (vfs_ioctl+0x20/0x3c)
[<c00b383c>] (vfs_ioctl+0x20/0x3c) from [<c00b3f9c>] (do_vfs_ioctl+0x540/0x598)
[<c00b3f9c>] (do_vfs_ioctl+0x540/0x598) from [<c00b4028>] (sys_ioctl+0x34/0x54)
[<c00b4028>] (sys_ioctl+0x34/0x54) from [<c0027a80>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 478cfbb6d09c3355 ]---
can't set ldisc: Cannot allocate memory

Initially I run it, everything is ok.
Then I run it and get error and backtrace.
And if I run it again, everything is ok again, repeatedly. Probably some resources are properly
set up in error condition, and not in normal condition.

I use ARM machine for testing and x86, bug is architecture-independent.

addr2lines:
c01bb88c drivers/tty/tty_ldisc.c:452
c01bc110 drivers/tty/tty_ldisc.c:499
c01b6624 drivers/tty/tty_io.c:2402
c00b383c fs/ioctl.c:44
c00b3f9c fs/ioctl.c:596
c00b4028 include/linux/file.h:26



