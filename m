Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab1BVUOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:14 -0500
Received: from kroah.org ([198.145.64.141]:47884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1BVUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:13 -0500
Date: Tue, 22 Feb 2011 12:02:22 -0800
From: Greg KH <greg@kroah.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: stable@kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [2.6.38-rc5, patch] fix cfg80211_wext_siwfreq lock
 ordering...
Message-ID: <20110222200222.GA11679@kroah.com>
References: <AANLkTi=OSZhT0OGN_3Jzw=zh1U_QjhB+vR8SxidM5Zge@mail.gmail.com>
 <1298305510.3836.7.camel@jlt3.sipsolutions.net>
 <AANLkTik752Qyy9RTz4h_C=amyjm+EjmUzUc=TGt7S1EM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik752Qyy9RTz4h_C=amyjm+EjmUzUc=TGt7S1EM@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:15:47AM +0800, Daniel J Blueman wrote:
> On 22 February 2011 00:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-02-22 at 00:11 +0800, Daniel J Blueman wrote:
> >> I previously managed to reproduce a hang while scanning wireless
> >> channels (reproducible with airodump-ng hopping channels); subsequent
> >> lockdep instrumentation revealed a lock ordering issue [1].
> >>
> >> Without knowing the design intent, it looks like the locks should be
> >> taken in reverse order; please comment.
> >>
> >> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> >>
> >> --- [1]
> >
> > Yeah, looks this way, thanks.
> >
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >
> >> =======================================================
> >> [ INFO: possible circular locking dependency detected ]
> >> 2.6.38-rc5-341cd #4
> >> -------------------------------------------------------
> >> airodump-ng/15445 is trying to acquire lock:
> >>  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff816b1266>]
> >> cfg80211_wext_siwfreq+0xc6/0x100
> >>
> >> but task is already holding lock:
> >>  (&wdev->mtx){+.+.+.}, at: [<ffffffff816b125c>] cfg80211_wext_siwfreq+0xbc/0x100
> >>
> >> which lock already depends on the new lock.
> >>
> >> the existing dependency chain (in reverse order) is:
> >>
> >> -> #1 (&wdev->mtx){+.+.+.}:
> >>        [<ffffffff810a79d6>] lock_acquire+0xc6/0x280
> >>        [<ffffffff816d6bce>] mutex_lock_nested+0x6e/0x4b0
> >>        [<ffffffff81696080>] cfg80211_netdev_notifier_call+0x430/0x5f0
> >>        [<ffffffff8109351b>] notifier_call_chain+0x8b/0x100
> >>        [<ffffffff810935b1>] raw_notifier_call_chain+0x11/0x20
> >>        [<ffffffff81576d92>] call_netdevice_notifiers+0x32/0x60
> >>        [<ffffffff815771a4>] __dev_notify_flags+0x34/0x80
> >>        [<ffffffff81577230>] dev_change_flags+0x40/0x70
> >>        [<ffffffff8158587c>] do_setlink+0x1fc/0x8d0
> >>        [<ffffffff81586042>] rtnl_setlink+0xf2/0x140
> >>        [<ffffffff81586923>] rtnetlink_rcv_msg+0x163/0x270
> >>        [<ffffffff8159d741>] netlink_rcv_skb+0xa1/0xd0
> >>        [<ffffffff815867b0>] rtnetlink_rcv+0x20/0x30
> >>        [<ffffffff8159d39a>] netlink_unicast+0x2ba/0x300
> >>        [<ffffffff8159dd57>] netlink_sendmsg+0x267/0x3e0
> >>        [<ffffffff8155e364>] sock_sendmsg+0xe4/0x110
> >>        [<ffffffff8155f3a3>] sys_sendmsg+0x253/0x3b0
> >>        [<ffffffff81003192>] system_call_fastpath+0x16/0x1b
> >>
> >> -> #0 (&rdev->devlist_mtx){+.+.+.}:
> >>        [<ffffffff810a7222>] __lock_acquire+0x1622/0x1d10
> >>        [<ffffffff810a79d6>] lock_acquire+0xc6/0x280
> >>        [<ffffffff816d6bce>] mutex_lock_nested+0x6e/0x4b0
> >>        [<ffffffff816b1266>] cfg80211_wext_siwfreq+0xc6/0x100
> >>        [<ffffffff816b2fad>] ioctl_standard_call+0x5d/0xd0
> >>        [<ffffffff816b3223>] T.808+0x163/0x170
> >>        [<ffffffff816b326a>] wext_handle_ioctl+0x3a/0x90
> >>        [<ffffffff815798d2>] dev_ioctl+0x6f2/0x830
> >>        [<ffffffff8155cf3d>] sock_ioctl+0xfd/0x290
> >>        [<ffffffff8117dffd>] do_vfs_ioctl+0x9d/0x590
> >>        [<ffffffff8117e53a>] sys_ioctl+0x4a/0x80
> >>        [<ffffffff81003192>] system_call_fastpath+0x16/0x1b
> >>
> >> other info that might help us debug this:
> >>
> >> 2 locks held by airodump-ng/15445:
> >>  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81586782>] rtnl_lock+0x12/0x20
> >>  #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffff816b125c>]
> >> cfg80211_wext_siwfreq+0xbc/0x100
> >>
> >> stack backtrace:
> >> Pid: 15445, comm: airodump-ng Not tainted 2.6.38-rc5-341cd #4
> >> Call Trace:
> >>  [<ffffffff810a3f0a>] ? print_circular_bug+0xfa/0x100
> >>  [<ffffffff810a7222>] ? __lock_acquire+0x1622/0x1d10
> >>  [<ffffffff810a1f99>] ? trace_hardirqs_off_caller+0x29/0xc0
> >>  [<ffffffff810a79d6>] ? lock_acquire+0xc6/0x280
> >>  [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
> >>  [<ffffffff810a31d7>] ? mark_held_locks+0x67/0x90
> >>  [<ffffffff816d6bce>] ? mutex_lock_nested+0x6e/0x4b0
> >>  [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
> >>  [<ffffffff810a31d7>] ? mark_held_locks+0x67/0x90
> >>  [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
> >>  [<ffffffff816b1266>] ? cfg80211_wext_siwfreq+0xc6/0x100
> >>  [<ffffffff816b2fad>] ? ioctl_standard_call+0x5d/0xd0
> >>  [<ffffffff8157818b>] ? __dev_get_by_name+0x9b/0xc0
> >>  [<ffffffff816b2f50>] ? ioctl_standard_call+0x0/0xd0
> >>  [<ffffffff816b3223>] ? T.808+0x163/0x170
> >>  [<ffffffff8112ddf2>] ? might_fault+0x72/0xd0
> >>  [<ffffffff816b326a>] ? wext_handle_ioctl+0x3a/0x90
> >>  [<ffffffff8112de3b>] ? might_fault+0xbb/0xd0
> >>  [<ffffffff815798d2>] ? dev_ioctl+0x6f2/0x830
> >>  [<ffffffff810a1bae>] ? put_lock_stats+0xe/0x40
> >>  [<ffffffff810a1c8c>] ? lock_release_holdtime+0xac/0x150
> >>  [<ffffffff8155cf3d>] ? sock_ioctl+0xfd/0x290
> >>  [<ffffffff8117dffd>] ? do_vfs_ioctl+0x9d/0x590
> >>  [<ffffffff8116c8ff>] ? fget_light+0x1df/0x3c0
> >>  [<ffffffff8117e53a>] ? sys_ioctl+0x4a/0x80
> >>  [<ffffffff81003192>] ? system_call_fastpath+0x16/0x1b
> >>
> >> --- [2]
> >>
> >> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> >> index 3e5dbd4..d112f03 100644
> >> --- a/net/wireless/wext-compat.c
> >> +++ b/net/wireless/wext-compat.c
> >> @@ -802,11 +802,11 @@ int cfg80211_wext_siwfreq(struct net_device *dev,
> >>                       return freq;
> >>               if (freq == 0)
> >>                       return -EINVAL;
> >> -             wdev_lock(wdev);
> >>               mutex_lock(&rdev->devlist_mtx);
> >> +             wdev_lock(wdev);
> >>               err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
> >> -             mutex_unlock(&rdev->devlist_mtx);
> >>               wdev_unlock(wdev);
> >> +             mutex_unlock(&rdev->devlist_mtx);
> >>               return err;
> >>       default:
> >>               return -EOPNOTSUPP;
> 
> Please consider for -stable. This patch resolves the lock ordering
> case my test exposed, and passes lockdep and extended testing.

Consider what?  What is the git commit id of this patch in Linus's tree?

confused,

greg k-h
