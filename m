Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1HZVtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab1HZVtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:49:32 -0400
Date: Fri, 26 Aug 2011 17:49:30 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ext4 lockdep trace (3.1.0rc3)
Message-ID: <20110826214930.GA21818@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just hit this while building a kernel.  Laptop wedged for a few seconds
during the final link, and this was in the log when it unwedged.

	Dave

 =================================
 [ INFO: inconsistent lock state ]
 3.1.0-rc3+ #148
 ---------------------------------
 inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
 kswapd0/32 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (&sb->s_type->i_mutex_key#14){+.+.?.}, at: [<ffffffff811cea13>] ext4_evict_inode+0x76/0x33c
 {RECLAIM_FS-ON-W} state was registered at:
   [<ffffffff810913fe>] mark_held_locks+0x6d/0x95
   [<ffffffff81091a19>] lockdep_trace_alloc+0x9f/0xc2
   [<ffffffff811333b0>] slab_pre_alloc_hook+0x1e/0x4f
   [<ffffffff81136d89>] kmem_cache_alloc+0x29/0x15a
   [<ffffffff8115aa00>] __d_alloc+0x26/0x168
   [<ffffffff8115ad5c>] d_alloc+0x1f/0x62
   [<ffffffff81150de6>] d_alloc_and_lookup+0x2c/0x6b
   [<ffffffff81151c2d>] walk_component+0x215/0x3e8
   [<ffffffff811524b8>] link_path_walk+0x189/0x43b
   [<ffffffff81152b12>] path_lookupat+0x5a/0x2af
   [<ffffffff81152d8f>] do_path_lookup+0x28/0x97
   [<ffffffff81152f73>] user_path_at+0x59/0x96
   [<ffffffff8114b8e6>] vfs_fstatat+0x44/0x6e
   [<ffffffff8114b94b>] vfs_stat+0x1b/0x1d
   [<ffffffff8114ba4a>] sys_newstat+0x1a/0x33
   [<ffffffff814f1e42>] system_call_fastpath+0x16/0x1b
 irq event stamp: 671039
 hardirqs last  enabled at (671039): [<ffffffff810c8130>] __call_rcu+0x18c/0x19d
 hardirqs last disabled at (671038): [<ffffffff810c8026>] __call_rcu+0x82/0x19d
 softirqs last  enabled at (670754): [<ffffffff8106481f>] __do_softirq+0x1fd/0x257
 softirqs last disabled at (670749): [<ffffffff814f413c>] call_softirq+0x1c/0x30
 
 other info that might help us debug this:
  Possible unsafe locking scenario:
 
        CPU0
        ----
   lock(&sb->s_type->i_mutex_key);
   <Interrupt>
     lock(&sb->s_type->i_mutex_key);
 
  *** DEADLOCK ***
 
 2 locks held by kswapd0/32:
  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8110626b>] shrink_slab+0x39/0x2ef
  #1:  (&type->s_umount_key#21){++++..}, at: [<ffffffff8114a251>] grab_super_passive+0x57/0x7b
 
 stack backtrace:
 Pid: 32, comm: kswapd0 Tainted: G        W   3.1.0-rc3+ #148
 Call Trace:
  [<ffffffff810810a1>] ? up+0x39/0x3e
  [<ffffffff814e1151>] print_usage_bug+0x1e7/0x1f8
  [<ffffffff8101bb8d>] ? save_stack_trace+0x2c/0x49
  [<ffffffff8108f6ca>] ? print_irq_inversion_bug.part.19+0x1a0/0x1a0
  [<ffffffff8108fdf8>] mark_lock+0x106/0x220
  [<ffffffff810902a6>] __lock_acquire+0x394/0xcf7
  [<ffffffff8101bb8d>] ? save_stack_trace+0x2c/0x49
  [<ffffffff8108d0b0>] ? __bfs+0x137/0x1c7
  [<ffffffff811cea13>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff810910ff>] lock_acquire+0xf3/0x13e
  [<ffffffff811cea13>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff814e9ed5>] ? __mutex_lock_common+0x3d/0x44a
  [<ffffffff814ea3dd>] ? mutex_lock_nested+0x3b/0x40
  [<ffffffff811cea13>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff814e9efd>] __mutex_lock_common+0x65/0x44a
  [<ffffffff811cea13>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff810820bf>] ? local_clock+0x35/0x4c
  [<ffffffff8115ce19>] ? evict+0x8b/0x153
  [<ffffffff8108d88a>] ? put_lock_stats+0xe/0x29
  [<ffffffff8108df0e>] ? lock_release_holdtime.part.10+0x59/0x62
  [<ffffffff8115ce19>] ? evict+0x8b/0x153
  [<ffffffff814ea3dd>] mutex_lock_nested+0x3b/0x40
  [<ffffffff811cea13>] ext4_evict_inode+0x76/0x33c
  [<ffffffff8115ce27>] evict+0x99/0x153
  [<ffffffff8115d0ad>] dispose_list+0x32/0x43
  [<ffffffff8115dd43>] prune_icache_sb+0x257/0x266
  [<ffffffff8114a34f>] prune_super+0xda/0x145
  [<ffffffff811063d0>] shrink_slab+0x19e/0x2ef
  [<ffffffff811093fe>] balance_pgdat+0x2e7/0x57e
  [<ffffffff811099ce>] kswapd+0x339/0x392
  [<ffffffff8107c56c>] ? __init_waitqueue_head+0x4b/0x4b
  [<ffffffff81109695>] ? balance_pgdat+0x57e/0x57e
  [<ffffffff8107bcf1>] kthread+0xa8/0xb0
  [<ffffffff814eed1e>] ? sub_preempt_count+0xa1/0xb4
  [<ffffffff814f4044>] kernel_thread_helper+0x4/0x10
  [<ffffffff814ec1b8>] ? retint_restore_args+0x13/0x13
  [<ffffffff8107bc49>] ? __init_kthread_worker+0x5a/0x5a
  [<ffffffff814f4040>] ? gs_change+0x13/0x13
 
