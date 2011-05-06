Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1EFCpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 22:45:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55330 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1EFCp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 22:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=UCKdIr6U3w5KPhFF/yTvIHLbT3aLW2cEqdVFWwjNjutVEeiPbpZd7udvX/Xvt1qryC
         dAJUgaZyrpX5JSSNcbtd6FFDPnnUpA8Yi0Ii1OoPtUHMHCeG3kP4bvuALjqk+bWnAwnH
         WF/yVCrZnRYDsSmm4AsgfgkL6ChHRT1CGnd64=
MIME-Version: 1.0
In-Reply-To: <BANLkTinBLW5X+OZKfpL6Ld6GyM4Q0GLZ5A@mail.gmail.com>
References: <BANLkTinBLW5X+OZKfpL6Ld6GyM4Q0GLZ5A@mail.gmail.com>
Date: Thu, 5 May 2011 22:45:28 -0400
Message-ID: <BANLkTimMHt2WpidjRGe8Q-+6UYUy2noorw@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at mm/slub.c:824
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 10:34 PM, Miles Lane <miles.lane@gmail.com> wrote:
> BUG: sleeping function called from invalid context at mm/slub.c:824
> in_atomic(): 1, irqs_disabled(): 0, pid: 1632, name: cupsd
> 2 locks held by cupsd/1632:
>  #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8105bd3d>] do_prlimit+0x62/0x191
>  #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8105bd70>]
> do_prlimit+0x95/0x191
> Pid: 1632, comm: cupsd Not tainted 2.6.39-rc6-git2 #2
> Call Trace:
>  [<ffffffff8103bbc0>] __might_sleep+0x10d/0x112
>  [<ffffffff810f9eba>] slab_pre_alloc_hook.clone.33+0x30/0x36
>  [<ffffffff810fae17>] kmem_cache_alloc+0x22/0x12f
>  [<ffffffff81069af5>] prepare_creds+0x35/0xe4
>  [<ffffffff811d51c2>] aa_replace_current_profile+0x37/0xad
>  [<ffffffff811d92b1>] aa_current_profile+0x42/0x4a
>  [<ffffffff811d92d4>] apparmor_task_setrlimit+0x1b/0x3d
>  [<ffffffff811d35bd>] security_task_setrlimit+0x11/0x13
>  [<ffffffff8105bdb0>] do_prlimit+0xd5/0x191
>  [<ffffffff8105c0f5>] sys_setrlimit+0x3e/0x47
>  [<ffffffff8142f3d2>] system_call_fastpath+0x16/0x1b

Possibly related -- Got this during suspend in the same boot session:


[ 2476.176906] [ INFO: inconsistent lock state ]
[ 2476.176915] 2.6.39-rc6-git2 #2
[ 2476.176921] ---------------------------------
[ 2476.176928] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 2476.176939] kswapd0/497 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2476.176947]  (&(&p->alloc_lock)->rlock){+.+.?.}, at:
[<ffffffff8106afaf>] refrigerator+0x23/0xd5
[ 2476.176969] {RECLAIM_FS-ON-W} state was registered at:
[ 2476.176977]   [<ffffffff810756ff>] mark_held_locks+0x50/0x72
[ 2476.176988]   [<ffffffff81075df4>] lockdep_trace_alloc+0xa8/0xcc
[ 2476.177000]   [<ffffffff810f9ea2>] slab_pre_alloc_hook.clone.33+0x18/0x36
[ 2476.177013]   [<ffffffff810fae17>] kmem_cache_alloc+0x22/0x12f
[ 2476.177024]   [<ffffffff81069af5>] prepare_creds+0x35/0xe4
[ 2476.177035]   [<ffffffff811d51c2>] aa_replace_current_profile+0x37/0xad
[ 2476.177049]   [<ffffffff811d92b1>] aa_current_profile+0x42/0x4a
[ 2476.177060]   [<ffffffff811d92d4>] apparmor_task_setrlimit+0x1b/0x3d
[ 2476.177072]   [<ffffffff811d35bd>] security_task_setrlimit+0x11/0x13
[ 2476.177086]   [<ffffffff8105bdb0>] do_prlimit+0xd5/0x191
[ 2476.177097]   [<ffffffff8105c0f5>] sys_setrlimit+0x3e/0x47
[ 2476.177108]   [<ffffffff8142f3d2>] system_call_fastpath+0x16/0x1b
[ 2476.177122] irq event stamp: 35
[ 2476.177128] hardirqs last  enabled at (35): [<ffffffff81429376>]
_raw_spin_unlock_irqrestore+0x40/0x75
[ 2476.177145] hardirqs last disabled at (34): [<ffffffff81428e44>]
_raw_spin_lock_irqsave+0x1a/0x57
[ 2476.177159] softirqs last  enabled at (0): [<ffffffff8104588e>]
copy_process+0x396/0x1236
[ 2476.177174] softirqs last disabled at (0): [<          (null)>]
      (null)
[ 2476.177186]
[ 2476.177187] other info that might help us debug this:
[ 2476.177196] no locks held by kswapd0/497.
[ 2476.177202]
[ 2476.177203] stack backtrace:
[ 2476.177211] Pid: 497, comm: kswapd0 Not tainted 2.6.39-rc6-git2 #2
[ 2476.177220] Call Trace:
[ 2476.177228]  [<ffffffff8107548d>] valid_state+0x17e/0x190
[ 2476.177239]  [<ffffffff81074c07>] ? print_irq_inversion_bug+0x12e/0x12e
[ 2476.177250]  [<ffffffff8107557e>] mark_lock+0xdf/0x210
[ 2476.177260]  [<ffffffff81076c5c>] __lock_acquire+0x3db/0xdc7
[ 2476.177272]  [<ffffffff8103c5eb>] ? finish_task_switch+0x42/0xa5
[ 2476.177283]  [<ffffffff814293d6>] ? _raw_spin_unlock_irq+0x2b/0x5c
[ 2476.177294]  [<ffffffff8106afaf>] ? refrigerator+0x23/0xd5
[ 2476.177305]  [<ffffffff81077bb7>] lock_acquire+0x109/0x133
[ 2476.177315]  [<ffffffff8106afaf>] ? refrigerator+0x23/0xd5
[ 2476.177326]  [<ffffffff8120fd1e>] ? do_raw_spin_lock+0x75/0x136
[ 2476.177337]  [<ffffffff8120d51e>] ? hweight_long+0xa/0xb
[ 2476.177348]  [<ffffffff81428d71>] _raw_spin_lock+0x36/0x45
[ 2476.177358]  [<ffffffff8106afaf>] ? refrigerator+0x23/0xd5
[ 2476.177369]  [<ffffffff8106afaf>] refrigerator+0x23/0xd5
[ 2476.177380]  [<ffffffff81063da5>] ? finish_wait+0x59/0x62
[ 2476.177391]  [<ffffffff810d34b3>] try_to_freeze+0x28/0x2f
[ 2476.177402]  [<ffffffff810d58f1>] kswapd+0x2a6/0x872
[ 2476.177413]  [<ffffffff8103e312>] ? get_parent_ip+0x11/0x41
[ 2476.177423]  [<ffffffff8103c5eb>] ? finish_task_switch+0x42/0xa5
[ 2476.177434]  [<ffffffff81063c59>] ? wake_up_bit+0x25/0x25
[ 2476.177445]  [<ffffffff810d564b>] ? shrink_zone+0x41d/0x41d
[ 2476.177455]  [<ffffffff810636be>] kthread+0x9d/0xa5
[ 2476.177466]  [<ffffffff81075860>] ? trace_hardirqs_on_caller+0x13f/0x172
[ 2476.177478]  [<ffffffff81430564>] kernel_thread_helper+0x4/0x10
[ 2476.177488]  [<ffffffff8103c5eb>] ? finish_task_switch+0x42/0xa5
[ 2476.177500]  [<ffffffff814299d8>] ? retint_restore_args+0x13/0x13
[ 2476.177511]  [<ffffffff81063621>] ? __init_kthread_worker+0x56/0x56
[ 2476.177522]  [<ffffffff81430560>] ? gs_change+0x13/0x13
[ 2476.189975] (elapsed 0.01 seconds) done.
[ 2476.190080] Suspending console(s) (use no_console_suspend to debug)
