Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2LZMSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:18:16 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49529 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2LZMSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:18:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121225223045.GA23445@liondog.tnic>
References: <20121225223045.GA23445@liondog.tnic>
Date: Wed, 26 Dec 2012 20:18:13 +0800
Message-ID: <CAJd=RBBsJBnDyfC5QUtRwnMFBXATrhxT9t0heNRpNv5DEqe4Fg@mail.gmail.com>
Subject: Re: kvm lockdep splat with 3.8-rc1+
From: Hillf Danton <dhillf@gmail.com>
To: Borislav Petkov <bp@alien8.de>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 6:30 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi all,
>
> just saw this in dmesg while running -rc1 + tip/master:
>
>
> [ 6983.694615] =============================================
> [ 6983.694617] [ INFO: possible recursive locking detected ]
> [ 6983.694620] 3.8.0-rc1+ #26 Not tainted
> [ 6983.694621] ---------------------------------------------
> [ 6983.694623] kvm/20461 is trying to acquire lock:
> [ 6983.694625]  (&anon_vma->rwsem){++++..}, at: [<ffffffff8111d2c8>] mm_take_all_locks+0x148/0x1a0
> [ 6983.694636]
> [ 6983.694636] but task is already holding lock:
> [ 6983.694638]  (&anon_vma->rwsem){++++..}, at: [<ffffffff8111d2c8>] mm_take_all_locks+0x148/0x1a0
> [ 6983.694645]
> [ 6983.694645] other info that might help us debug this:
> [ 6983.694647]  Possible unsafe locking scenario:
> [ 6983.694647]
> [ 6983.694649]        CPU0
> [ 6983.694650]        ----
> [ 6983.694651]   lock(&anon_vma->rwsem);
> [ 6983.694654]   lock(&anon_vma->rwsem);
> [ 6983.694657]
> [ 6983.694657]  *** DEADLOCK ***
> [ 6983.694657]
> [ 6983.694659]  May be due to missing lock nesting notation
> [ 6983.694659]
> [ 6983.694661] 4 locks held by kvm/20461:
> [ 6983.694663]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8112afb3>] do_mmu_notifier_register+0x153/0x180
> [ 6983.694670]  #1:  (mm_all_locks_mutex){+.+...}, at: [<ffffffff8111d1bc>] mm_take_all_locks+0x3c/0x1a0
> [ 6983.694678]  #2:  (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff8111d24d>] mm_take_all_locks+0xcd/0x1a0
> [ 6983.694686]  #3:  (&anon_vma->rwsem){++++..}, at: [<ffffffff8111d2c8>] mm_take_all_locks+0x148/0x1a0
> [ 6983.694694]
> [ 6983.694694] stack backtrace:
> [ 6983.694696] Pid: 20461, comm: kvm Not tainted 3.8.0-rc1+ #26
> [ 6983.694698] Call Trace:
> [ 6983.694704]  [<ffffffff8109c2fa>] __lock_acquire+0x89a/0x1f30
> [ 6983.694708]  [<ffffffff810978ed>] ? trace_hardirqs_off+0xd/0x10
> [ 6983.694711]  [<ffffffff81099b8d>] ? mark_held_locks+0x8d/0x110
> [ 6983.694714]  [<ffffffff8111d24d>] ? mm_take_all_locks+0xcd/0x1a0
> [ 6983.694718]  [<ffffffff8109e05e>] lock_acquire+0x9e/0x1f0
> [ 6983.694720]  [<ffffffff8111d2c8>] ? mm_take_all_locks+0x148/0x1a0
> [ 6983.694724]  [<ffffffff81097ace>] ? put_lock_stats.isra.17+0xe/0x40
> [ 6983.694728]  [<ffffffff81519949>] down_write+0x49/0x90
> [ 6983.694731]  [<ffffffff8111d2c8>] ? mm_take_all_locks+0x148/0x1a0
> [ 6983.694734]  [<ffffffff8111d2c8>] mm_take_all_locks+0x148/0x1a0
> [ 6983.694737]  [<ffffffff8112afb3>] ? do_mmu_notifier_register+0x153/0x180
> [ 6983.694740]  [<ffffffff8112aedf>] do_mmu_notifier_register+0x7f/0x180
> [ 6983.694742]  [<ffffffff8112b013>] mmu_notifier_register+0x13/0x20
> [ 6983.694765]  [<ffffffffa00e665d>] kvm_dev_ioctl+0x3cd/0x4f0 [kvm]
> [ 6983.694768]  [<ffffffff8114bcb0>] do_vfs_ioctl+0x90/0x570
> [ 6983.694772]  [<ffffffff81157403>] ? fget_light+0x323/0x4c0
> [ 6983.694775]  [<ffffffff8114c1e0>] sys_ioctl+0x50/0x90
> [ 6983.694781]  [<ffffffff8123a25e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 6983.694785]  [<ffffffff8151d4c2>] system_call_fastpath+0x16/0x1b

Hey Boris,

Can you please test with 5a505085f0 and 4fc3f1d66b reverted?

Hillf
