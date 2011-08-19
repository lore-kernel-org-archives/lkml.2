Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1HSWDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:03:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1HSWDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:03:44 -0400
Date: Fri, 19 Aug 2011 17:57:54 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jaxboe@fusionio.com
Subject: 3.1.0-rc2 block related lockdep report.
Message-ID: <20110819215754.GA12746@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this while running kvm. (this is from the host)

	Dave

=================================
[ INFO: inconsistent lock state ]
3.1.0-rc2+ #139
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
qemu-kvm/8194 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (pcpu_alloc_mutex){+.+.?.}, at: [<ffffffff81110b78>] pcpu_alloc+0x6f/0x80b
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8109138e>] mark_held_locks+0x6d/0x95
  [<ffffffff810919a9>] lockdep_trace_alloc+0x9f/0xc2
  [<ffffffff8113168c>] slab_pre_alloc_hook+0x1e/0x4f
  [<ffffffff81133c16>] __kmalloc+0x64/0x12f
  [<ffffffff81110164>] pcpu_mem_alloc+0x5e/0x67
  [<ffffffff8111026b>] pcpu_extend_area_map+0x2b/0xd4
  [<ffffffff81110cc8>] pcpu_alloc+0x1bf/0x80b
  [<ffffffff81111324>] __alloc_percpu+0x10/0x12
  [<ffffffff81135651>] kmem_cache_open+0x2cc/0x2d6
  [<ffffffff81135834>] kmem_cache_create+0x1d9/0x281
  [<ffffffff812bcd01>] acpi_os_create_cache+0x1d/0x2d
  [<ffffffff812e4d26>] acpi_ut_create_caches+0x26/0xb0
  [<ffffffff812e76d2>] acpi_ut_init_globals+0xe/0x244
  [<ffffffff81d7881f>] acpi_initialize_subsystem+0x35/0xae
  [<ffffffff81d77539>] acpi_early_init+0x5c/0xf7
  [<ffffffff81d48b9e>] start_kernel+0x3dd/0x3f7
  [<ffffffff81d482c4>] x86_64_start_reservations+0xaf/0xb3
  [<ffffffff81d483ca>] x86_64_start_kernel+0x102/0x111
irq event stamp: 140939
hardirqs last  enabled at (140939): [<ffffffff814e1c55>] __slab_alloc+0x41c/0x43d
hardirqs last disabled at (140938): [<ffffffff814e187e>] __slab_alloc+0x45/0x43d
softirqs last  enabled at (140484): [<ffffffff8106481f>] __do_softirq+0x1fd/0x257
softirqs last disabled at (140461): [<ffffffff814f19fc>] call_softirq+0x1c/0x30

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(pcpu_alloc_mutex);
  <Interrupt>
    lock(pcpu_alloc_mutex);

 *** DEADLOCK ***

1 lock held by qemu-kvm/8194:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff814ec328>] do_page_fault+0x188/0x39d

stack backtrace:
Pid: 8194, comm: qemu-kvm Tainted: G        W   3.1.0-rc2+ #139
Call Trace:
 [<ffffffff81081031>] ? up+0x39/0x3e
 [<ffffffff814dea37>] print_usage_bug+0x1e7/0x1f8
 [<ffffffff8101bb8d>] ? save_stack_trace+0x2c/0x49
 [<ffffffff8108f65a>] ? print_irq_inversion_bug.part.19+0x1a0/0x1a0
 [<ffffffff8108fd88>] mark_lock+0x106/0x220
 [<ffffffff81090236>] __lock_acquire+0x394/0xcf7
 [<ffffffff814e9318>] ? _raw_spin_unlock+0x32/0x54
 [<ffffffff814e932d>] ? _raw_spin_unlock+0x47/0x54
 [<ffffffff811339d2>] ? deactivate_slab+0x293/0x2b9
 [<ffffffff81110b78>] ? pcpu_alloc+0x6f/0x80b
 [<ffffffff8109108f>] lock_acquire+0xf3/0x13e
 [<ffffffff81110b78>] ? pcpu_alloc+0x6f/0x80b
 [<ffffffff814e7c9d>] ? mutex_lock_nested+0x3b/0x40
 [<ffffffff81110b78>] ? pcpu_alloc+0x6f/0x80b
 [<ffffffff814e77bd>] __mutex_lock_common+0x65/0x44a
 [<ffffffff81110b78>] ? pcpu_alloc+0x6f/0x80b
 [<ffffffff810914e3>] ? trace_hardirqs_on_caller+0x12d/0x164
 [<ffffffff814e1c61>] ? __slab_alloc+0x428/0x43d
 [<ffffffff81266500>] ? kzalloc_node+0x14/0x16
 [<ffffffff814e7c9d>] mutex_lock_nested+0x3b/0x40
 [<ffffffff81110b78>] pcpu_alloc+0x6f/0x80b
 [<ffffffff81266500>] ? kzalloc_node+0x14/0x16
 [<ffffffff81133b8b>] ? __kmalloc_node+0x146/0x16d
 [<ffffffff81266500>] ? kzalloc_node+0x14/0x16
 [<ffffffff81111324>] __alloc_percpu+0x10/0x12
 [<ffffffff81264fab>] blkio_alloc_blkg_stats+0x1d/0x31
 [<ffffffff8126653c>] throtl_alloc_tg+0x3a/0xdf
 [<ffffffff81266f4e>] blk_throtl_bio+0x14b/0x38e
 [<ffffffff81016224>] ? __cycles_2_ns+0xe/0x3a
 [<ffffffff8108202e>] ? local_clock+0x14/0x4c
 [<ffffffff810164da>] ? native_sched_clock+0x34/0x36
 [<ffffffff81259e7a>] generic_make_request+0x2e8/0x419
 [<ffffffff814e937f>] ? _raw_spin_unlock_irqrestore+0x45/0x7a
 [<ffffffff810fd7a7>] ? test_set_page_writeback+0xcc/0xfd
 [<ffffffff8125a089>] submit_bio+0xde/0xfd
 [<ffffffff810fd441>] ? account_page_writeback+0x13/0x15
 [<ffffffff810fd7c6>] ? test_set_page_writeback+0xeb/0xfd
 [<ffffffff81122161>] swap_writepage+0x94/0x9f
 [<ffffffff811082b1>] shmem_writepage+0x192/0x1d8
 [<ffffffff811056b6>] shrink_page_list+0x402/0x795
 [<ffffffff81105e82>] shrink_inactive_list+0x22c/0x3e6
 [<ffffffff8109138e>] ? mark_held_locks+0x6d/0x95
 [<ffffffff81106755>] shrink_zone+0x445/0x588
 [<ffffffff81168463>] ? wakeup_flusher_threads+0xcf/0xd8
 [<ffffffff811683c6>] ? wakeup_flusher_threads+0x32/0xd8
 [<ffffffff81106c0d>] do_try_to_free_pages+0x107/0x318
 [<ffffffff811071a1>] try_to_free_pages+0xd5/0x175
 [<ffffffff810fcfff>] __alloc_pages_nodemask+0x501/0x7b7
 [<ffffffff810dc435>] ? trace_preempt_on+0x15/0x28
 [<ffffffff8108de9e>] ? lock_release_holdtime.part.10+0x59/0x62
 [<ffffffff8112bdbc>] alloc_pages_vma+0xf5/0xfa
 [<ffffffff8113b4be>] do_huge_pmd_anonymous_page+0xb3/0x274
 [<ffffffff8111226b>] ? pmd_offset+0x19/0x3f
 [<ffffffff8111547f>] handle_mm_fault+0xfd/0x1b8
 [<ffffffff814ec328>] ? do_page_fault+0x188/0x39d
 [<ffffffff814ec4f6>] do_page_fault+0x356/0x39d
 [<ffffffff8108fcaf>] ? mark_lock+0x2d/0x220
 [<ffffffff810dc40c>] ? time_hardirqs_off+0x1b/0x2f
 [<ffffffff8108d8ff>] ? trace_hardirqs_off_caller+0x3f/0x9c
 [<ffffffff81279dfd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814e9d25>] page_fault+0x25/0x30
 [<ffffffff810f4d23>] ? file_read_actor+0x39/0x12a
 [<ffffffff810f6d60>] generic_file_aio_read+0x3fd/0x655
 [<ffffffff81016224>] ? __cycles_2_ns+0xe/0x3a
 [<ffffffff8108202e>] ? local_clock+0x14/0x4c
 [<ffffffff81145359>] do_sync_read+0xbf/0xff
 [<ffffffff812282b9>] ? security_file_permission+0x2e/0x33
 [<ffffffff811456cc>] ? rw_verify_area+0xb6/0xd3
 [<ffffffff81145a59>] vfs_read+0xac/0xf3
 [<ffffffff81146fe1>] ? fget_light+0x97/0xa2
 [<ffffffff81145be5>] sys_pread64+0x5d/0x79
 [<ffffffff814ef702>] system_call_fastpath+0x16/0x1b
