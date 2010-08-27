Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0H0ITP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:19:15 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab0H0ITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:19:12 -0400
Subject: Re: 2.6.36-rc2-git4 - INFO: possible circular locking dependency
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>
In-Reply-To: <AANLkTinHbEW36D5R9NSrGgfbOC0Hri3Tg-fA0iR92Udi@mail.gmail.com>
References: <AANLkTinHbEW36D5R9NSrGgfbOC0Hri3Tg-fA0iR92Udi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 10:19:08 +0200
Message-ID: <1282897148.4377.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is due to

commit 5a652052fedbd7869572c757dd2ffc2ed420c69d
Author: Maxime Bizon <mbizon@freebox.fr>
Date:   Wed Jul 21 17:21:38 2010 +0200

    cfg80211: fix race between sysfs and cfg80211


The rfkill registration needs to be done after dropping all locks in
wiphy_register().

Maxime, can you please look at fixing this?

[full lockdep report preserved below]

johannes

On Thu, 2010-08-26 at 21:56 -0400, Miles Lane wrote:
> [ INFO: possible circular locking dependency detected ]
> 2.6.36-rc2-git4 #12
> -------------------------------------------------------
> kworker/0:3/3630 is trying to acquire lock:
>  (rtnl_mutex){+.+.+.}, at: [<ffffffff813396c7>] rtnl_lock+0x12/0x14
> 
> but task is already holding lock:
>  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa014b129>]
> rfkill_switch_all+0x24/0x49 [rfkill]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (rfkill_global_mutex){+.+.+.}:
>        [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
>        [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
>        [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
>        [<ffffffffa014b4ab>] rfkill_register+0x2b/0x29c [rfkill]
>        [<ffffffffa0185ba0>] wiphy_register+0x1ae/0x270 [cfg80211]
>        [<ffffffffa0206f01>] ieee80211_register_hw+0x1b4/0x3cf [mac80211]
>        [<ffffffffa0292e98>] iwl_ucode_callback+0x9e9/0xae3 [iwlagn]
>        [<ffffffff812d3e9d>] request_firmware_work_func+0x54/0x6f
>        [<ffffffff81065d15>] kthread+0x8c/0x94
>        [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10
> 
> -> #1 (cfg80211_mutex){+.+.+.}:
>        [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
>        [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
>        [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
>        [<ffffffffa018605e>] cfg80211_get_dev_from_ifindex+0x1b/0x7c [cfg80211]
>        [<ffffffffa0189f36>] cfg80211_wext_giwscan+0x58/0x990 [cfg80211]
>        [<ffffffff8139a3ce>] ioctl_standard_iw_point+0x1a8/0x272
>        [<ffffffff8139a529>] ioctl_standard_call+0x91/0xa7
>        [<ffffffff8139a687>] T.723+0xbd/0x12c
>        [<ffffffff8139a727>] wext_handle_ioctl+0x31/0x6d
>        [<ffffffff8133014e>] dev_ioctl+0x63d/0x67a
>        [<ffffffff8131afd9>] sock_ioctl+0x48/0x21d
>        [<ffffffff81102abd>] do_vfs_ioctl+0x4ba/0x509
>        [<ffffffff81102b5d>] sys_ioctl+0x51/0x74
>        [<ffffffff81009e02>] system_call_fastpath+0x16/0x1b
> 
> -> #0 (rtnl_mutex){+.+.+.}:
>        [<ffffffff810796b0>] __lock_acquire+0xa93/0xd9a
>        [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
>        [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
>        [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
>        [<ffffffff813396c7>] rtnl_lock+0x12/0x14
>        [<ffffffffa0185cb5>] cfg80211_rfkill_set_block+0x1a/0x7b [cfg80211]
>        [<ffffffffa014aed0>] rfkill_set_block+0x80/0xd5 [rfkill]
>        [<ffffffffa014b07e>] __rfkill_switch_all+0x3f/0x6f [rfkill]
>        [<ffffffffa014b13d>] rfkill_switch_all+0x38/0x49 [rfkill]
>        [<ffffffffa014b821>] rfkill_op_handler+0x105/0x136 [rfkill]
>        [<ffffffff81060708>] process_one_work+0x248/0x403
>        [<ffffffff81062620>] worker_thread+0x139/0x214
>        [<ffffffff81065d15>] kthread+0x8c/0x94
>        [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10
> 
> other info that might help us debug this:
> 
> 3 locks held by kworker/0:3/3630:
>  #0:  (events){+.+.+.}, at: [<ffffffff81060638>] process_one_work+0x178/0x403
>  #1:  ((rfkill_op_work).work){+.+...}, at: [<ffffffff81060638>]
> process_one_work+0x178/0x403
>  #2:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa014b129>]
> rfkill_switch_all+0x24/0x49 [rfkill]
> 
> stack backtrace:
> Pid: 3630, comm: kworker/0:3 Not tainted 2.6.36-rc2-git4 #12
> Call Trace:
>  [<ffffffff81078633>] print_circular_bug+0xa8/0xb7
>  [<ffffffff810796b0>] __lock_acquire+0xa93/0xd9a
>  [<ffffffff810767b3>] ? __bfs+0x23/0x1d8
>  [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
>  [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
>  [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
>  [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
>  [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
>  [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
>  [<ffffffffa014b129>] ? rfkill_switch_all+0x24/0x49 [rfkill]
>  [<ffffffff81077936>] ? mark_lock+0x2d/0x233
>  [<ffffffffa014b71c>] ? rfkill_op_handler+0x0/0x136 [rfkill]
>  [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
>  [<ffffffff813396c7>] rtnl_lock+0x12/0x14
>  [<ffffffffa0185cb5>] cfg80211_rfkill_set_block+0x1a/0x7b [cfg80211]
>  [<ffffffffa014aed0>] rfkill_set_block+0x80/0xd5 [rfkill]
>  [<ffffffffa014b07e>] __rfkill_switch_all+0x3f/0x6f [rfkill]
>  [<ffffffffa014b13d>] rfkill_switch_all+0x38/0x49 [rfkill]
>  [<ffffffffa014b821>] rfkill_op_handler+0x105/0x136 [rfkill]
>  [<ffffffff81060708>] process_one_work+0x248/0x403
>  [<ffffffff81060638>] ? process_one_work+0x178/0x403
>  [<ffffffff81062620>] worker_thread+0x139/0x214
>  [<ffffffff810624e7>] ? worker_thread+0x0/0x214
>  [<ffffffff81065d15>] kthread+0x8c/0x94
>  [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10
>  [<ffffffff813b0b14>] ? restore_args+0x0/0x30
>  [<ffffffff81065c89>] ? kthread+0x0/0x94
>  [<ffffffff8100ac20>] ? kernel_thread_helper+0x0/0x10
> wlan0: deauthenticating from 00:1b:2f:0e:ed:ba by local choice (reason=3)
> 


