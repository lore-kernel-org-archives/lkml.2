Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2IFWoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:44:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50075 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2IFWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:44:15 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Organization: Deep Root Systems, LLC
References: <20120906122948.GC29202@arwen.pp.htv.fi>
	<1346935540-1792-1-git-send-email-balbi@ti.com>
Date: Thu, 06 Sep 2012 15:44:13 -0700
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com> (Felipe Balbi's
	message of "Thu, 6 Sep 2012 15:45:19 +0300")
Message-ID: <87harahiv6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

> Hi guys,
>
> here's v4 of the omap uart patchset. No changes other than a rebase on top of
> Greg's tty-next branch and Tony's Acked-by being added to a couple patches
>
> Note: I'm resending the series with Vikram's Software Flow Control fix anyway
> as it can just be ignored if it's decided it needs to go into this merge
> window.

Sorry to be late to the party... just getting back from some time off.

I'm assuming that this was not tested with PM, so decided I better do it
myself seeing that Greg is has already merge it.  To test, I merged
Greg's tty-next branch with v3.6-rc4 and did some PM testing.

The bad news is that it doesn't even compile (see reply to [PATCH v4
20/21]).  

Also, there is a big WARNING on boot[1], which seems to be triggered by
a new check added for v3.6-rc3[2].  This appears to be introduced by
$SUBJECT series, because I don't see it on vanilla v3.6-rc4.

The good news is that after hacking to fix up the compile problems,
basic PM testing seems to be fine: idle to retention and off as well as
suspend to retention and off work fine on 3430/n900, 3530/Overo,
3730/OveroSTORM, 3730/Beagle-xM.

Kevin


[1]
[    8.745666] WARNING: at /work/kernel/omap/pm/drivers/tty/tty_io.c:1420 tty_init_dev+0x14c/0x17c()
[    8.755218] tty_init_dev: ttyO driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    8.765991] Modules linked in:
[    8.769287] [<c0013d90>] (unwind_backtrace+0x0/0xf0) from [<c0036eec>] (warn_slowpath_common+0x4c/0x64)
[    8.779327] [<c0036eec>] (warn_slowpath_common+0x4c/0x64) from [<c0036f98>] (warn_slowpath_fmt+0x30/0x40)
[    8.789550] [<c0036f98>] (warn_slowpath_fmt+0x30/0x40) from [<c02c626c>] (tty_init_dev+0x14c/0x17c)
[    8.799224] [<c02c626c>] (tty_init_dev+0x14c/0x17c) from [<c02c68a4>] (tty_open+0x11c/0x52c)
[    8.808258] [<c02c68a4>] (tty_open+0x11c/0x52c) from [<c00f86ac>] (chrdev_open+0x90/0x15c)
[    8.817108] [<c00f86ac>] (chrdev_open+0x90/0x15c) from [<c00f2b74>] (do_dentry_open+0x1e8/0x270)
[    8.826507] [<c00f2b74>] (do_dentry_open+0x1e8/0x270) from [<c00f2c30>] (finish_open+0x34/0x4c)
[    8.835784] [<c00f2c30>] (finish_open+0x34/0x4c) from [<c0102028>] (do_last.isra.21+0x5b0/0xbbc)
[    8.845184] [<c0102028>] (do_last.isra.21+0x5b0/0xbbc) from [<c01026dc>] (path_openat+0xa8/0x44c)
[    8.854675] [<c01026dc>] (path_openat+0xa8/0x44c) from [<c0102d34>] (do_filp_open+0x2c/0x80)
[    8.863708] [<c0102d34>] (do_filp_open+0x2c/0x80) from [<c00f3b6c>] (do_sys_open+0xe8/0x184)
[    8.872711] [<c00f3b6c>] (do_sys_open+0xe8/0x184) from [<c000db20>] (ret_fast_syscall+0x0/0x3c)
[    8.882019] ---[ end trace e9bf408c37051346 ]---

[2]
commit 5d4121c04b3577e37e389b3553d442f44bb346d7
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Fri Aug 17 14:27:52 2012 +0200

    TTY: check if tty->port is assigned
    
    And if not, complain loudly. None in-kernel module should trigger
    that, but let us find out for sure. On the other hand, all the
    out-of-tree modules will hit that. Give them some time (maybe one
    release) to catch up.
    
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

