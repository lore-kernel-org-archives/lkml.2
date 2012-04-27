Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab2D0Lau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 07:30:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32138 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923Ab2D0Lat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 07:30:49 -0400
Message-ID: <4F9A835C.2020801@openvz.org>
Date: Fri, 27 Apr 2012 15:30:36 +0400
From: Andrey Vagin <avagin@openvz.org>
Reply-To: avagin@openvz.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: lockdep reports about recursive locking in kmemleak
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found a following message in dmesg. Probably we should to do something 
similar as for debug_objects, it sets own class for parent->list_lock. 
Does anyone want to fix that?

=============================================
[ INFO: possible recursive locking detected ]
3.3.0+ #87 Not tainted
---------------------------------------------
udevd/847 is trying to acquire lock:
  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff811783f1>] 
cache_alloc_refill+0xa1/0x300

but task is already holding lock:
  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81177628>] 
cache_flusharray+0x68/0x180

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&(&parent->list_lock)->rlock);
   lock(&(&parent->list_lock)->rlock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

1 lock held by udevd/847:
  #0:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81177628>] 
cache_flusharray+0x68/0x180

stack backtrace:
Pid: 847, comm: udevd Not tainted 3.3.0+ #87
Call Trace:
  [<ffffffff810b835a>] __lock_acquire+0x126a/0x1730
  [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
  [<ffffffff810b88d1>] lock_acquire+0xb1/0x1a0
  [<ffffffff811783f1>] ? cache_alloc_refill+0xa1/0x300
  [<ffffffff8118cdb9>] ? create_object+0x39/0x2e0
  [<ffffffff8153a141>] _raw_spin_lock+0x41/0x50
  [<ffffffff811783f1>] ? cache_alloc_refill+0xa1/0x300
  [<ffffffff811783f1>] cache_alloc_refill+0xa1/0x300
  [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
  [<ffffffff8118cdb9>] ? create_object+0x39/0x2e0
  [<ffffffff81179cbc>] kmem_cache_alloc+0x2cc/0x320
  [<ffffffff8118cdb9>] create_object+0x39/0x2e0
  [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
  [<ffffffff8151fade>] kmemleak_alloc+0x5e/0xc0
  [<ffffffff81179b2c>] kmem_cache_alloc+0x13c/0x320
  [<ffffffff81294d99>] __debug_object_init+0x3b9/0x3d0
  [<ffffffff812944fa>] ? debug_object_activate+0xca/0x190
  [<ffffffff81294dff>] debug_object_init+0x1f/0x30
  [<ffffffff810767d7>] rcuhead_fixup_activate+0x27/0x70
  [<ffffffff81293d35>] debug_object_fixup+0x15/0x20
  [<ffffffff8129450c>] debug_object_activate+0xdc/0x190
  [<ffffffff81177b50>] ? kmem_cache_shrink+0x70/0x70
  [<ffffffff810f0d12>] __call_rcu+0x42/0x1e0
  [<ffffffff810f0ee5>] call_rcu_sched+0x15/0x20
  [<ffffffff81177113>] slab_destroy+0x153/0x160
  [<ffffffff81177628>] ? cache_flusharray+0x68/0x180
  [<ffffffff81177179>] free_block+0x59/0x230
  [<ffffffff81177655>] cache_flusharray+0x95/0x180
  [<ffffffff81176dbf>] ? kmem_cache_free+0x11f/0x320
  [<ffffffff81176f6c>] kmem_cache_free+0x2cc/0x320
  [<ffffffff8115b5b1>] ? __put_anon_vma+0x61/0xb0
  [<ffffffff8115b5b1>] __put_anon_vma+0x61/0xb0
  [<ffffffff8115bb8b>] unlink_anon_vmas+0x13b/0x1a0
  [<ffffffff8114fac1>] free_pgtables+0x91/0x120
  [<ffffffff81156101>] exit_mmap+0xb1/0x120
  [<ffffffff8104e24b>] mmput+0x7b/0x120
  [<ffffffff81053d68>] exit_mm+0x108/0x130
  [<ffffffff8153aa70>] ? _raw_spin_unlock_irq+0x30/0x50
  [<ffffffff81056277>] do_exit+0x167/0x970
  [<ffffffff811b36c3>] ? mntput+0x23/0x40
  [<ffffffff81192f6d>] ? fput+0x1ad/0x280
  [<ffffffff8153ae59>] ? retint_swapgs+0x13/0x1b
  [<ffffffff81056adb>] do_group_exit+0x5b/0xd0
  [<ffffffff81056b67>] sys_exit_group+0x17/0x20
  [<ffffffff81543729>] system_call_fastpath+0x16/0x1b



