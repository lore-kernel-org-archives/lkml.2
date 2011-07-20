Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1GTIFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:05:33 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38439 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GTIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:05:29 -0400
Subject: Re: recursive locking: epoll.
From: Paul Bolle <pebolle@tiscali.nl>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, davidel@xmailserver.org
Date: Wed, 20 Jul 2011 10:05:23 +0200
In-Reply-To: <20110715210420.GA22551@redhat.com>
References: <4E1FF63F.4040704@gmail.com> <20110715210420.GA22551@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.3 (3.1.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311149128.2098.10.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 17:04 -0400, Dave Jones wrote:
> We just had a Fedora user report this lockdep trace.

0) Does this have a bugzilla.redhat.com number?

>   =============================================
>   [ INFO: possible recursive locking detected ]
>   3.0-0.rc7.git0.1.fc16.i686 #1
>   ---------------------------------------------
>   systemd-logind/651 is trying to acquire lock:
>    (&ep->mtx){+.+.+.}, at: [<c05285f1>] ep_scan_ready_list+0x32/0x154
>  
>   but task is already holding lock:
>    (&ep->mtx){+.+.+.}, at: [<c0528a90>] sys_epoll_ctl+0x103/0x481
>  
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
>  
>          CPU0
>          ----
>     lock(&ep->mtx);
>     lock(&ep->mtx);
>  
>    *** DEADLOCK ***
>  
>    May be due to missing lock nesting notation
>  
>   2 locks held by systemd-logind/651:
>    #0:  (epmutex){+.+.+.}, at: [<c0528a4b>] sys_epoll_ctl+0xbe/0x481
>    #1:  (&ep->mtx){+.+.+.}, at: [<c0528a90>] sys_epoll_ctl+0x103/0x481
>  
>   stack backtrace:
>   Pid: 651, comm: systemd-logind Not tainted 3.0-0.rc7.git0.1.fc16.i686 #1
>   Call Trace:
>    [<c08490fe>] ? printk+0x2d/0x2f
>    [<c046b2ef>] __lock_acquire+0x811/0xb63
>    [<c0407c77>] ? sched_clock+0x8/0xb
>    [<c045d190>] ? sched_clock_local+0x10/0x18b
>    [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
>    [<c046ba5e>] lock_acquire+0xad/0xe4
>    [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
>    [<c08506bd>] __mutex_lock_common+0x49/0x2ee
>    [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
>    [<c04332e6>] ? __might_sleep+0x29/0xfb
>    [<c046a912>] ? mark_lock+0x26/0x1f2
>    [<c0850a7c>] mutex_lock_nested+0x43/0x49
>    [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
>    [<c05285f1>] ep_scan_ready_list+0x32/0x154
>    [<c05281cb>] ? ep_remove+0x9b/0x9b
>    [<c0528727>] ep_poll_readyevents_proc+0x14/0x16
>    [<c05283d6>] ep_call_nested.constprop.2+0x6d/0x9a
>    [<c0528713>] ? ep_scan_ready_list+0x154/0x154
>    [<c05284d2>] ep_eventpoll_poll+0x45/0x55
>    [<c0528b8c>] sys_epoll_ctl+0x1ff/0x481
>    [<c05282fb>] ? ep_send_events_proc+0xd5/0xd5
>    [<c08521ac>] syscall_call+0x7/0xb

1) It seems I just ran into that deadlock too (on a Fedora Rawhide
system, running a vanilla 3.0-0.rc7). I tried to capture it with a small
digital camera, but using that camera for screenshots is apparently
beyond my skills. (I could try capturing this message over a serial
line, if needed.)

2) Luckily, I also hit a related warning rebooting into v2.6.39, which I
could just cut and paste from dmesg's output:

=============================================
[ INFO: possible recursive locking detected ]
2.6.39-0.local9.fc16.i686 #1
---------------------------------------------
systemd-logind/807 is trying to acquire lock:
 (&ep->mtx){+.+.+.}, at: [<c0524a05>] ep_scan_ready_list+0x32/0x154

but task is already holding lock:
 (&ep->mtx){+.+.+.}, at: [<c0524ea4>] sys_epoll_ctl+0x103/0x481

other info that might help us debug this:
2 locks held by systemd-logind/807:
 #0:  (epmutex){+.+.+.}, at: [<c0524e5f>] sys_epoll_ctl+0xbe/0x481
 #1:  (&ep->mtx){+.+.+.}, at: [<c0524ea4>] sys_epoll_ctl+0x103/0x481

stack backtrace:
Pid: 807, comm: systemd-logind Not tainted 2.6.39-0.local9.fc16.i686 #1
Call Trace:
 [<c080af85>] ? printk+0x2d/0x2f
 [<c04690b7>] __lock_acquire+0x78f/0xae1
 [<c040790c>] ? sched_clock+0x8/0xb
 [<c045b858>] ? sched_clock_local+0x10/0x18b
 [<c0524a05>] ? ep_scan_ready_list+0x32/0x154
 [<c046981e>] lock_acquire+0xbc/0xdc
 [<c0524a05>] ? ep_scan_ready_list+0x32/0x154
 [<c08127f3>] __mutex_lock_common+0x4a/0x2f0
 [<c0524a05>] ? ep_scan_ready_list+0x32/0x154
 [<c0432502>] ? __might_sleep+0x29/0xfb
 [<c0466a50>] ? trace_hardirqs_off+0xb/0xd
 [<c0812b4e>] mutex_lock_nested+0x39/0x3e
 [<c0524a05>] ? ep_scan_ready_list+0x32/0x154
 [<c0524a05>] ep_scan_ready_list+0x32/0x154
 [<c05245df>] ? ep_remove+0x9b/0x9b
 [<c0524b3b>] ep_poll_readyevents_proc+0x14/0x16
 [<c05247ea>] ep_call_nested.constprop.2+0x6d/0x9a
 [<c0524b27>] ? ep_scan_ready_list+0x154/0x154
 [<c05248e6>] ep_eventpoll_poll+0x45/0x55
 [<c0524fa0>] sys_epoll_ctl+0x1ff/0x481
 [<c052470f>] ? ep_send_events_proc+0xd5/0xd5
 [<c0819fdf>] sysenter_do_call+0x12/0x38

3) Apparently this is something that is triggered by a brand new version
of systemd (systemd-30-1.fc16.i686, compiled on July 13th, which I
installed just yesterday, July 19th), as I do not recall seeing this
before.

4) Feel free to prod me for more information. 


Paul Bolle

