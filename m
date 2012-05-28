Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2E1Sr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:47:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2E1Sr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:47:26 -0400
Date: Mon, 28 May 2012 20:47:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: tty: AB-BA between tty->legacy_mutex and devpts_mutex
Message-ID: <alpine.LNX.2.00.1205282044410.15057@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

======================================================
[ INFO: possible circular locking dependency detected ]
3.4.0-08219-g238d69d #11 Not tainted
-------------------------------------------------------
blogd/265 is trying to acquire lock:
 (devpts_mutex){+.+.+.}, at: [<ffffffff8134d696>] pty_close+0x166/0x190

but task is already holding lock:
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f632>] tty_lock+0x22/0x29

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&tty->legacy_mutex){+.+.+.}:
       [<ffffffff8109df67>] validate_chain+0x637/0x730
       [<ffffffff8109e357>] __lock_acquire+0x2f7/0x500
       [<ffffffff8109e669>] lock_acquire+0x109/0x140
       [<ffffffff8150c13c>] __mutex_lock_common+0x5c/0x450
       [<ffffffff8150c65e>] mutex_lock_nested+0x3e/0x50
       [<ffffffff8150f632>] tty_lock+0x22/0x29
       [<ffffffff813454d7>] tty_init_dev+0x77/0x150
       [<ffffffff8134d9a6>] ptmx_open+0xa6/0x180
       [<ffffffff81177cd6>] chrdev_open+0xd6/0x1a0
       [<ffffffff81171984>] __dentry_open+0x214/0x310
       [<ffffffff81171b73>] nameidata_to_filp+0x73/0x80
       [<ffffffff811813c8>] do_last+0x438/0x7f0
       [<ffffffff81182630>] path_openat+0xd0/0x400
       [<ffffffff81182a73>] do_filp_open+0x43/0xa0
       [<ffffffff81172cb2>] do_sys_open+0x152/0x1e0
       [<ffffffff81172d7c>] sys_open+0x1c/0x20
       [<ffffffff815179b9>] system_call_fastpath+0x16/0x1b

-> #0 (devpts_mutex){+.+.+.}:
       [<ffffffff8109d8ce>] check_prev_add+0x3de/0x440
       [<ffffffff8109df67>] validate_chain+0x637/0x730
       [<ffffffff8109e357>] __lock_acquire+0x2f7/0x500
       [<ffffffff8109e669>] lock_acquire+0x109/0x140
       [<ffffffff8150c13c>] __mutex_lock_common+0x5c/0x450
       [<ffffffff8150c65e>] mutex_lock_nested+0x3e/0x50
       [<ffffffff8134d696>] pty_close+0x166/0x190
       [<ffffffff81344f41>] tty_release+0xf1/0x490
       [<ffffffff8117572a>] __fput+0xca/0x240
       [<ffffffff811758bd>] fput+0x1d/0x30
       [<ffffffff81171500>] filp_close+0x60/0x90
       [<ffffffff811715cd>] sys_close+0x9d/0x100
       [<ffffffff815179b9>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&tty->legacy_mutex);
                               lock(devpts_mutex);
                               lock(&tty->legacy_mutex);
  lock(devpts_mutex);

 *** DEADLOCK ***

1 lock held by blogd/265:
 #0:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f632>] tty_lock+0x22/0x29

stack backtrace:
Pid: 265, comm: blogd Not tainted 3.4.0-08219-g238d69d #11
Call Trace:
 [<ffffffff8109b89f>] print_circular_bug+0x10f/0x120
 [<ffffffff8109d8ce>] check_prev_add+0x3de/0x440
 [<ffffffff8109e86e>] ? lock_release_non_nested+0x1ce/0x320
 [<ffffffff8109df67>] validate_chain+0x637/0x730
 [<ffffffff8109e357>] __lock_acquire+0x2f7/0x500
 [<ffffffff8109e669>] lock_acquire+0x109/0x140
 [<ffffffff8134d696>] ? pty_close+0x166/0x190
 [<ffffffff8150c13c>] __mutex_lock_common+0x5c/0x450
 [<ffffffff8134d696>] ? pty_close+0x166/0x190
 [<ffffffff8134d696>] ? pty_close+0x166/0x190
 [<ffffffff8109d2bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8150c65e>] mutex_lock_nested+0x3e/0x50
 [<ffffffff8134d696>] pty_close+0x166/0x190
 [<ffffffff81344f41>] tty_release+0xf1/0x490
 [<ffffffff8134ab3c>] ? put_ldisc+0x6c/0xf0
 [<ffffffff8109e357>] ? __lock_acquire+0x2f7/0x500
 [<ffffffff81192ac0>] ? mntput_no_expire+0x40/0x180
 [<ffffffff8117572a>] __fput+0xca/0x240
 [<ffffffff811758bd>] fput+0x1d/0x30
 [<ffffffff81171500>] filp_close+0x60/0x90
 [<ffffffff811715cd>] sys_close+0x9d/0x100
 [<ffffffff815179b9>] system_call_fastpath+0x16/0x1b

This deadlock scenario doesn't really seem realistic, as it's between 
open()/close(). Not being really familiar with tty layer, I am not sure 
what the proper lock ordering in this case is, I am just reporting for you 
guys to decide how to get rid of this one.

Thanks,

-- 
Jiri Kosina
SUSE Labs
