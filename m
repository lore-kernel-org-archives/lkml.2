Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1GOVEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1GOVEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:04:23 -0400
Date: Fri, 15 Jul 2011 17:04:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: davidel@xmailserver.org
Subject: recursive locking: epoll.
Message-ID: <20110715210420.GA22551@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	davidel@xmailserver.org
References: <4E1FF63F.4040704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1FF63F.4040704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just had a Fedora user report this lockdep trace.

  =============================================
  [ INFO: possible recursive locking detected ]
  3.0-0.rc7.git0.1.fc16.i686 #1
  ---------------------------------------------
  systemd-logind/651 is trying to acquire lock:
   (&ep->mtx){+.+.+.}, at: [<c05285f1>] ep_scan_ready_list+0x32/0x154
 
  but task is already holding lock:
   (&ep->mtx){+.+.+.}, at: [<c0528a90>] sys_epoll_ctl+0x103/0x481
 
  other info that might help us debug this:
   Possible unsafe locking scenario:
 
         CPU0
         ----
    lock(&ep->mtx);
    lock(&ep->mtx);
 
   *** DEADLOCK ***
 
   May be due to missing lock nesting notation
 
  2 locks held by systemd-logind/651:
   #0:  (epmutex){+.+.+.}, at: [<c0528a4b>] sys_epoll_ctl+0xbe/0x481
   #1:  (&ep->mtx){+.+.+.}, at: [<c0528a90>] sys_epoll_ctl+0x103/0x481
 
  stack backtrace:
  Pid: 651, comm: systemd-logind Not tainted 3.0-0.rc7.git0.1.fc16.i686 #1
  Call Trace:
   [<c08490fe>] ? printk+0x2d/0x2f
   [<c046b2ef>] __lock_acquire+0x811/0xb63
   [<c0407c77>] ? sched_clock+0x8/0xb
   [<c045d190>] ? sched_clock_local+0x10/0x18b
   [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
   [<c046ba5e>] lock_acquire+0xad/0xe4
   [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
   [<c08506bd>] __mutex_lock_common+0x49/0x2ee
   [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
   [<c04332e6>] ? __might_sleep+0x29/0xfb
   [<c046a912>] ? mark_lock+0x26/0x1f2
   [<c0850a7c>] mutex_lock_nested+0x43/0x49
   [<c05285f1>] ? ep_scan_ready_list+0x32/0x154
   [<c05285f1>] ep_scan_ready_list+0x32/0x154
   [<c05281cb>] ? ep_remove+0x9b/0x9b
   [<c0528727>] ep_poll_readyevents_proc+0x14/0x16
   [<c05283d6>] ep_call_nested.constprop.2+0x6d/0x9a
   [<c0528713>] ? ep_scan_ready_list+0x154/0x154
   [<c05284d2>] ep_eventpoll_poll+0x45/0x55
   [<c0528b8c>] sys_epoll_ctl+0x1ff/0x481
   [<c05282fb>] ? ep_send_events_proc+0xd5/0xd5
   [<c08521ac>] syscall_call+0x7/0xb

