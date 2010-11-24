Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0KXW0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:26:21 -0500
Received: from build.ihdev.net ([178.63.197.118]:58597 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab0KXW0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:26:20 -0500
Date: Wed, 24 Nov 2010 17:26:17 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
Message-ID: <20101124222617.GC8691@build.ihdev.net>
References: <20101124135249.GA7282@build.ihdev.net>
 <4CED2251.3020708@suse.cz>
 <20101124170326.GB7282@build.ihdev.net>
 <4CED6ACF.9000402@suse.cz>
 <4CED6B53.50408@suse.cz>
 <20101124215339.GA8691@build.ihdev.net>
 <4CED8B86.6070607@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED8B86.6070607@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 11:02:46PM +0100, Jiri Slaby wrote:
> On 11/24/2010 10:53 PM, Sergey Lapin wrote:
> > Initially I run it, everything is ok.
> > Then I run it and get error and backtrace.
> > And if I run it again, everything is ok again, repeatedly. Probably some resources are properly
> > set up in error condition, and not in normal condition.
> > 
> > I use ARM machine for testing and x86, bug is architecture-independent.
> > 
> > addr2lines:
> > c01bc110 drivers/tty/tty_ldisc.c:499
> 
> Got it. Does this fixes the warning?
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -454,6 +454,8 @@ static int tty_ldisc_open(struct tty_struct *tty,
> struct tty_ldisc *ld)
>                  /* BTM here locks versus a hangup event */
>                 WARN_ON(!tty_locked());
>                 ret = ld->ops->open(tty);
> +               if (ret)
> +                       clear_bit(TTY_LDISC_OPEN, &tty->flags);
>                 return ret;
>         }
>         return 0;
> 
> thanks,
> -- 
> js
> suse labs
This one fixes this particular backtrace, but now we have another one, which happens less often
only every 3 times of executing problem and never on ENOMEM case:

------------[ cut here ]------------
WARNING: at drivers/tty/tty_ldisc.c:475 tty_ldisc_close+0x24/0x64()

Modules linked in:
[<c002c694>] (unwind_backtrace+0x0/0xe4) from [<c0037ad4>] (warn_slowpath_common+0x4c/0x64)
[<c0037ad4>] (warn_slowpath_common+0x4c/0x64) from [<c0037b04>] (warn_slowpath_null+0x18/0x1c)
[<c0037b04>] (warn_slowpath_null+0x18/0x1c) from [<c01bb810>] (tty_ldisc_close+0x24/0x64)
[<c01bb810>] (tty_ldisc_close+0x24/0x64) from [<c01bba1c>] (tty_ldisc_release+0x3c/0x70)
[<c01bba1c>] (tty_ldisc_release+0x3c/0x70) from [<c01b6cf0>] (tty_release+0x41c/0x480)
[<c01b6cf0>] (tty_release+0x41c/0x480) from [<c00a7374>] (fput+0x108/0x200)
[<c00a7374>] (fput+0x108/0x200) from [<c00a46b0>] (filp_close+0x6c/0x78)
[<c00a46b0>] (filp_close+0x6c/0x78) from [<c00399d8>] (put_files_struct+0x80/0xdc)
[<c00399d8>] (put_files_struct+0x80/0xdc) from [<c003b014>] (do_exit+0x1a8/0x6b4)
[<c003b014>] (do_exit+0x1a8/0x6b4) from [<c003b5e0>] (do_group_exit+0xc0/0xf4)
[<c003b5e0>] (do_group_exit+0xc0/0xf4) from [<c003b624>] (sys_exit_group+0x10/0x1c)
[<c003b624>] (sys_exit_group+0x10/0x1c) from [<c0027a80>] (ret_fast_syscall+0x0/0x2c)
---[ end trace 59483134a28e9f56 ]---

addr2lines:
c01bb810 arch/arm/include/asm/irqflags.h:53
c01bba1c drivers/tty/tty_ldisc.c:377
c01b6cf0 drivers/tty/tty_io.c:1763
c00a7374 fs/file_table.c:249
c00a46b0 fs/open.c:960
c00399d8 kernel/exit.c:495
c003b014 kernel/exit.c:985
c003b5e0 include/linux/sched.h:2213
c003b624 kernel/exit.c:1106

ENOMEM case is one which still wonders me, especially why it happens every second run.

Thanks a lot,
S.

