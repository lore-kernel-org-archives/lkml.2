Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DTWtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:49:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44710 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1DTWtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:49:08 -0400
Date: Wed, 20 Apr 2011 11:30:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rcu stall.
Message-ID: <20110420183046.GQ2307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110420020215.GA30081@redhat.com>
 <20110420083616.GA1124@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420083616.GA1124@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:36:16AM +0200, Ingo Molnar wrote:
> 
> * Dave Jones <davej@redhat.com> wrote:
> 
> > Machine was under heavy load (300 or so running processes
> > calling random system calls). The rcu stall detector kicked in,
> > spewed this, and then the machine completely locked up.
> 
> Without having looked at it in detail, isnt this a lockup somewhere in the 
> wireless code:
> 
> >   [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
> >   [<ffffffff81082e4f>] ? arch_local_irq_restore+0x6/0xd
> >   [<ffffffff81084df8>] lock_acquired+0x20f/0x21e
> >   [<ffffffff814be9cc>] _raw_spin_lock+0x62/0x6a
> >   [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
> >   [<ffffffff814bf215>] ? _raw_spin_unlock+0x28/0x2c
> >   [<ffffffff8114f842>] simple_release_fs+0x22/0x57
> >   [<ffffffff811f53e9>] debugfs_remove_recursive+0x11f/0x16b
> >   [<ffffffffa037adf3>] ieee80211_debugfs_key_remove+0x1f/0x2e [mac80211]
> >   [<ffffffffa0373e7a>] __ieee80211_key_destroy+0x61/0x6d [mac80211]
> >   [<ffffffffa0374250>] ieee80211_key_link+0x12c/0x165 [mac80211]
> >   [<ffffffffa036b90e>] ieee80211_add_key+0xfb/0x133 [mac80211]
> >   [<ffffffffa0277ff4>] nl80211_new_key+0xe5/0x106 [cfg80211]
> >   [<ffffffffa026d2c5>] ? cfg80211_get_dev_from_ifindex+0x72/0x7a [cfg80211]
> >   [<ffffffff81422244>] genl_rcv_msg+0x1dc/0x207
> >   [<ffffffff81422068>] ? genl_rcv+0x2d/0x2d
> >   [<ffffffff81421c69>] netlink_rcv_skb+0x43/0x8f
> >   [<ffffffff81422061>] genl_rcv+0x26/0x2d
> >   [<ffffffff8142176a>] netlink_unicast+0xec/0x156
> >   [<ffffffff81421a53>] netlink_sendmsg+0x27f/0x2c0
> >   [<ffffffff813ed78c>] __sock_sendmsg+0x69/0x75
> >   [<ffffffff813ed905>] sock_sendmsg+0xa1/0xb6
> >   [<ffffffff81086c30>] ? lock_release+0x181/0x18e
> >   [<ffffffff81100de0>] ? might_fault+0xa5/0xac
> >   [<ffffffff81100d97>] ? might_fault+0x5c/0xac
> >   [<ffffffff813ec8e4>] ? copy_from_user+0x2f/0x31
> >   [<ffffffff813f707a>] ? copy_from_user+0x2f/0x31
> >   [<ffffffff813f7370>] ? verify_iovec+0x52/0xa6
> >   [<ffffffff813eece3>] sys_sendmsg+0x23a/0x2b8
> >   [<ffffffff81086d29>] ? lock_acquire+0xec/0xfb
> >   [<ffffffff81086c30>] ? lock_release+0x181/0x18e
> >   [<ffffffff8114b7d7>] ? mntput+0x26/0x28
> >   [<ffffffff811343bc>] ? fput+0x1e6/0x1f5
> >   [<ffffffff8113ba95>] ? path_put+0x1f/0x23
> >   [<ffffffff810a9f23>] ? audit_syscall_entry+0x11c/0x148
> >   [<ffffffff81255e4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >   [<ffffffff814c5d82>] system_call_fastpath+0x16/0x1b
> 
> RCU stall detector is simply the first thing that noticed the hang. Enabling 
> the regular lockup detector would probably have resulted in a similar looking 
> hang.

Hello, Dave,

In case the lockup detector would get you better information, you can
prevent RCU from checking for stall by setting the rcu_cpu_stall_suppress
module parameter to 1, either as a boot parameter or via sysfs.

							Thanx, Paul
