Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2D3LGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:06:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58090 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070Ab2D3LGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:06:04 -0400
Date: Mon, 30 Apr 2012 12:04:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: lockdep reports about recursive locking in kmemleak
Message-ID: <20120430110420.GL10632@arm.com>
References: <4F9A835C.2020801@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9A835C.2020801@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:30:36PM +0100, Andrey Vagin wrote:
> I found a following message in dmesg. Probably we should to do something 
> similar as for debug_objects, it sets own class for parent->list_lock. 
> Does anyone want to fix that?
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.3.0+ #87 Not tainted
> ---------------------------------------------
> udevd/847 is trying to acquire lock:
>   (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff811783f1>] 
> cache_alloc_refill+0xa1/0x300
> 
> but task is already holding lock:
>   (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81177628>] 
> cache_flusharray+0x68/0x180
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&(&parent->list_lock)->rlock);
>    lock(&(&parent->list_lock)->rlock);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
> 1 lock held by udevd/847:
>   #0:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81177628>] 
> cache_flusharray+0x68/0x180

I'm not sure what the right fix is (cc'ing Christoph for the slab.c
code). The lockdep warning is not in kmemleak, it just happens that
cache_flusharray() (holding an l3->list_lock) triggers a new allocation
via debug_object_activate() and kmemleak also tries to allocate its
metadata, causing a cache_alloc_refill() call which acquires a
different l3->list_lock, hence the lockdep warning.

Below is a quick fix but I don't know whether it could hide a real
problem in the future:

diff --git a/mm/slab.c b/mm/slab.c
index e901a36..3d2bfc6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3143,7 +3143,7 @@ retry:
 	l3 = cachep->nodelists[node];
 
 	BUG_ON(ac->avail > 0 || !l3);
-	spin_lock(&l3->list_lock);
+	spin_lock_nested(&l3->list_lock, SINGLE_DEPTH_NESTING);
 
 	/* See if we can refill from the shared array */
 	if (l3->shared && transfer_objects(ac, l3->shared, batchcount)) {


I'm leaving the original stack trace below for reference.

Catalin

> stack backtrace:
> Pid: 847, comm: udevd Not tainted 3.3.0+ #87
> Call Trace:
>   [<ffffffff810b835a>] __lock_acquire+0x126a/0x1730
>   [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
>   [<ffffffff810b88d1>] lock_acquire+0xb1/0x1a0
>   [<ffffffff811783f1>] ? cache_alloc_refill+0xa1/0x300
>   [<ffffffff8118cdb9>] ? create_object+0x39/0x2e0
>   [<ffffffff8153a141>] _raw_spin_lock+0x41/0x50
>   [<ffffffff811783f1>] ? cache_alloc_refill+0xa1/0x300
>   [<ffffffff811783f1>] cache_alloc_refill+0xa1/0x300
>   [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
>   [<ffffffff8118cdb9>] ? create_object+0x39/0x2e0
>   [<ffffffff81179cbc>] kmem_cache_alloc+0x2cc/0x320
>   [<ffffffff8118cdb9>] create_object+0x39/0x2e0
>   [<ffffffff810b73f2>] ? __lock_acquire+0x302/0x1730
>   [<ffffffff8151fade>] kmemleak_alloc+0x5e/0xc0
>   [<ffffffff81179b2c>] kmem_cache_alloc+0x13c/0x320
>   [<ffffffff81294d99>] __debug_object_init+0x3b9/0x3d0
>   [<ffffffff812944fa>] ? debug_object_activate+0xca/0x190
>   [<ffffffff81294dff>] debug_object_init+0x1f/0x30
>   [<ffffffff810767d7>] rcuhead_fixup_activate+0x27/0x70
>   [<ffffffff81293d35>] debug_object_fixup+0x15/0x20
>   [<ffffffff8129450c>] debug_object_activate+0xdc/0x190
>   [<ffffffff81177b50>] ? kmem_cache_shrink+0x70/0x70
>   [<ffffffff810f0d12>] __call_rcu+0x42/0x1e0
>   [<ffffffff810f0ee5>] call_rcu_sched+0x15/0x20
>   [<ffffffff81177113>] slab_destroy+0x153/0x160
>   [<ffffffff81177628>] ? cache_flusharray+0x68/0x180
>   [<ffffffff81177179>] free_block+0x59/0x230
>   [<ffffffff81177655>] cache_flusharray+0x95/0x180
>   [<ffffffff81176dbf>] ? kmem_cache_free+0x11f/0x320
>   [<ffffffff81176f6c>] kmem_cache_free+0x2cc/0x320
>   [<ffffffff8115b5b1>] ? __put_anon_vma+0x61/0xb0
>   [<ffffffff8115b5b1>] __put_anon_vma+0x61/0xb0
>   [<ffffffff8115bb8b>] unlink_anon_vmas+0x13b/0x1a0
>   [<ffffffff8114fac1>] free_pgtables+0x91/0x120
>   [<ffffffff81156101>] exit_mmap+0xb1/0x120
>   [<ffffffff8104e24b>] mmput+0x7b/0x120
>   [<ffffffff81053d68>] exit_mm+0x108/0x130
>   [<ffffffff8153aa70>] ? _raw_spin_unlock_irq+0x30/0x50
>   [<ffffffff81056277>] do_exit+0x167/0x970
>   [<ffffffff811b36c3>] ? mntput+0x23/0x40
>   [<ffffffff81192f6d>] ? fput+0x1ad/0x280
>   [<ffffffff8153ae59>] ? retint_swapgs+0x13/0x1b
>   [<ffffffff81056adb>] do_group_exit+0x5b/0xd0
>   [<ffffffff81056b67>] sys_exit_group+0x17/0x20
>   [<ffffffff81543729>] system_call_fastpath+0x16/0x1b
