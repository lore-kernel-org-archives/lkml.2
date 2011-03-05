Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1CEBA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:56 -0500
Received: from kroah.org ([198.145.64.141]:50441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507Ab1CEBAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.246381576@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [58/73] fix cfg80211_wext_siwfreq lock ordering...
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit 4f919a3bc54da01db829c520ce4b1fabfde1c3f7 upstream.

I previously managed to reproduce a hang while scanning wireless
channels (reproducible with airodump-ng hopping channels); subsequent
lockdep instrumentation revealed a lock ordering issue.

Without knowing the design intent, it looks like the locks should be
taken in reverse order; please comment.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.38-rc5-341cd #4
-------------------------------------------------------
airodump-ng/15445 is trying to acquire lock:
 (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff816b1266>]
cfg80211_wext_siwfreq+0xc6/0x100

but task is already holding lock:
 (&wdev->mtx){+.+.+.}, at: [<ffffffff816b125c>] cfg80211_wext_siwfreq+0xbc/0x100

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&wdev->mtx){+.+.+.}:
       [<ffffffff810a79d6>] lock_acquire+0xc6/0x280
       [<ffffffff816d6bce>] mutex_lock_nested+0x6e/0x4b0
       [<ffffffff81696080>] cfg80211_netdev_notifier_call+0x430/0x5f0
       [<ffffffff8109351b>] notifier_call_chain+0x8b/0x100
       [<ffffffff810935b1>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff81576d92>] call_netdevice_notifiers+0x32/0x60
       [<ffffffff815771a4>] __dev_notify_flags+0x34/0x80
       [<ffffffff81577230>] dev_change_flags+0x40/0x70
       [<ffffffff8158587c>] do_setlink+0x1fc/0x8d0
       [<ffffffff81586042>] rtnl_setlink+0xf2/0x140
       [<ffffffff81586923>] rtnetlink_rcv_msg+0x163/0x270
       [<ffffffff8159d741>] netlink_rcv_skb+0xa1/0xd0
       [<ffffffff815867b0>] rtnetlink_rcv+0x20/0x30
       [<ffffffff8159d39a>] netlink_unicast+0x2ba/0x300
       [<ffffffff8159dd57>] netlink_sendmsg+0x267/0x3e0
       [<ffffffff8155e364>] sock_sendmsg+0xe4/0x110
       [<ffffffff8155f3a3>] sys_sendmsg+0x253/0x3b0
       [<ffffffff81003192>] system_call_fastpath+0x16/0x1b

-> #0 (&rdev->devlist_mtx){+.+.+.}:
       [<ffffffff810a7222>] __lock_acquire+0x1622/0x1d10
       [<ffffffff810a79d6>] lock_acquire+0xc6/0x280
       [<ffffffff816d6bce>] mutex_lock_nested+0x6e/0x4b0
       [<ffffffff816b1266>] cfg80211_wext_siwfreq+0xc6/0x100
       [<ffffffff816b2fad>] ioctl_standard_call+0x5d/0xd0
       [<ffffffff816b3223>] T.808+0x163/0x170
       [<ffffffff816b326a>] wext_handle_ioctl+0x3a/0x90
       [<ffffffff815798d2>] dev_ioctl+0x6f2/0x830
       [<ffffffff8155cf3d>] sock_ioctl+0xfd/0x290
       [<ffffffff8117dffd>] do_vfs_ioctl+0x9d/0x590
       [<ffffffff8117e53a>] sys_ioctl+0x4a/0x80
       [<ffffffff81003192>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

2 locks held by airodump-ng/15445:
 #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81586782>] rtnl_lock+0x12/0x20
 #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffff816b125c>]
cfg80211_wext_siwfreq+0xbc/0x100

stack backtrace:
Pid: 15445, comm: airodump-ng Not tainted 2.6.38-rc5-341cd #4
Call Trace:
 [<ffffffff810a3f0a>] ? print_circular_bug+0xfa/0x100
 [<ffffffff810a7222>] ? __lock_acquire+0x1622/0x1d10
 [<ffffffff810a1f99>] ? trace_hardirqs_off_caller+0x29/0xc0
 [<ffffffff810a79d6>] ? lock_acquire+0xc6/0x280
 [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
 [<ffffffff810a31d7>] ? mark_held_locks+0x67/0x90
 [<ffffffff816d6bce>] ? mutex_lock_nested+0x6e/0x4b0
 [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
 [<ffffffff810a31d7>] ? mark_held_locks+0x67/0x90
 [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
 [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
 [<ffffffff816b2fad>] ? ioctl_standard_call+0x5d/0xd0
 [<ffffffff8157818b>] ? __dev_get_by_name+0x9b/0xc0
 [<ffffffff816b2f50>] ? ioctl_standard_call+0x0/0xd0
 [<ffffffff816b3223>] ? T.808+0x163/0x170
 [<ffffffff8112ddf2>] ? might_fault+0x72/0xd0
 [<ffffffff816b326a>] ? wext_handle_ioctl+0x3a/0x90
 [<ffffffff8112de3b>] ? might_fault+0xbb/0xd0
 [<ffffffff815798d2>] ? dev_ioctl+0x6f2/0x830
 [<ffffffff810a1bae>] ? put_lock_stats+0xe/0x40
 [<ffffffff810a1c8c>] ? lock_release_holdtime+0xac/0x150
 [<ffffffff8155cf3d>] ? sock_ioctl+0xfd/0x290
 [<ffffffff8117dffd>] ? do_vfs_ioctl+0x9d/0x590
 [<ffffffff8116c8ff>] ? fget_light+0x1df/0x3c0
 [<ffffffff8117e53a>] ? sys_ioctl+0x4a/0x80
 [<ffffffff81003192>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/wext-compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -802,11 +802,11 @@ int cfg80211_wext_siwfreq(struct net_dev
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
-		wdev_lock(wdev);
 		mutex_lock(&rdev->devlist_mtx);
+		wdev_lock(wdev);
 		err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
-		mutex_unlock(&rdev->devlist_mtx);
 		wdev_unlock(wdev);
+		mutex_unlock(&rdev->devlist_mtx);
 		return err;
 	default:
 		return -EOPNOTSUPP;


