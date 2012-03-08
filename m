Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2CHD2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:28:41 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38416 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2CHD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:28:39 -0500
Message-ID: <4F582754.6050303@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 11:28:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [BUG] soft lockup occur while using cpu cgroup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030718-3568-0000-0000-000001553021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

I created 7 cpu type cgroup and start kernbench in each of them, then
got soft lockup bug after several hours.

My testing environment is an x86 server with redhat6.2 on it, and I'm
using tip kernel tree: 3.3.0-rc6+, and all cgroup subsys will be mounted
automatically.

My testing step is:
1. use command "cgcreate -g cpu:/subcgx", x is 1~7, to create 7 cpu cgroup
2. start 7 shell and use command "echo $$ > /cgroup/cpu/subcgx/tasks" to
attach each shell to each cgroup.
3. start kernbench in each shell.

I have extract all the different bug log, like:

1:
BUG: soft lockup - CPU#1 stuck for 23s! [cc1:4501]

Call Trace:
 [<ffffffff81046b2e>] native_flush_tlb_others+0xe/0x10
 [<ffffffff81046c3f>] flush_tlb_page+0x5f/0xb0
 [<ffffffff81142cb1>] ptep_clear_flush+0x41/0x60
 [<ffffffff8113d703>] try_to_unmap_one+0xb3/0x450
 [<ffffffff8113e15d>] try_to_unmap_file+0xad/0x2c0
 [<ffffffff8113e417>] try_to_unmap+0x47/0x80
 [<ffffffff8111e858>] shrink_page_list+0x2d8/0x670
 [<ffffffff8111fbaf>] shrink_inactive_list+0x1df/0x530
 [<ffffffff811206d9>] shrink_mem_cgroup_zone+0x259/0x320
 [<ffffffff81120803>] shrink_zone+0x63/0xb0
 [<ffffffff811208c6>] shrink_zones+0x76/0x200
 [<ffffffff81120aef>] do_try_to_free_pages+0x9f/0x3e0
 [<ffffffff811210bb>] try_to_free_pages+0x9b/0x120
 [<ffffffff8111edfa>] ? wakeup_kswapd+0x4a/0x140
 [<ffffffff81114f9e>] __alloc_pages_slowpath+0x31e/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff811506fa>] alloc_pages_vma+0x9a/0x150
 [<ffffffff811442b2>] read_swap_cache_async+0xf2/0x150
 [<ffffffff81144b89>] ? valid_swaphandles+0x69/0x150
 [<ffffffff81144397>] swapin_readahead+0x87/0xc0
 [<ffffffff81134335>] do_swap_page+0x115/0x630
 [<ffffffff81133d7e>] ? do_wp_page+0x38e/0x830
 [<ffffffff81134f9a>] handle_pte_fault+0x1aa/0x210
 [<ffffffff811351d5>] handle_mm_fault+0x1d5/0x350
 [<ffffffff81504c0e>] do_page_fault+0x13e/0x460
 [<ffffffff81189fb3>] ? mntput+0x23/0x40
 [<ffffffff8116dfbb>] ? __fput+0x16b/0x240
 [<ffffffff815016a5>] page_fault+0x25/0x30

2:
BUG: soft lockup - CPU#6 stuck for 23s! [cc1:5186]

Call Trace:
 [<ffffffff81046b10>] ? flush_tlb_others_ipi+0x130/0x140
 [<ffffffff81046b2e>] native_flush_tlb_others+0xe/0x10
 [<ffffffff81046c3f>] flush_tlb_page+0x5f/0xb0
 [<ffffffff81142cb1>] ptep_clear_flush+0x41/0x60
 [<ffffffff8113d703>] try_to_unmap_one+0xb3/0x450
 [<ffffffff81126ccd>] ? vma_prio_tree_next+0x3d/0x70
 [<ffffffff8113e15d>] try_to_unmap_file+0xad/0x2c0
 [<ffffffff8109ac0d>] ? ktime_get_ts+0xad/0xe0
 [<ffffffff8113e417>] try_to_unmap+0x47/0x80
 [<ffffffff8111e858>] shrink_page_list+0x2d8/0x670
 [<ffffffff8111fbaf>] shrink_inactive_list+0x1df/0x530
 [<ffffffff811206d9>] shrink_mem_cgroup_zone+0x259/0x320
 [<ffffffff81120803>] shrink_zone+0x63/0xb0
 [<ffffffff811208c6>] shrink_zones+0x76/0x200
 [<ffffffff81120aef>] do_try_to_free_pages+0x9f/0x3e0
 [<ffffffff811210bb>] try_to_free_pages+0x9b/0x120
 [<ffffffff8111edfa>] ? wakeup_kswapd+0x4a/0x140
 [<ffffffff81114f9e>] __alloc_pages_slowpath+0x31e/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff811506fa>] alloc_pages_vma+0x9a/0x150
 [<ffffffff811442b2>] read_swap_cache_async+0xf2/0x150
 [<ffffffff81144b89>] ? valid_swaphandles+0x69/0x150
 [<ffffffff81144397>] swapin_readahead+0x87/0xc0
 [<ffffffff81134335>] do_swap_page+0x115/0x630
 [<ffffffff81133d7e>] ? do_wp_page+0x38e/0x830
 [<ffffffff81134f9a>] handle_pte_fault+0x1aa/0x210
 [<ffffffff811351d5>] handle_mm_fault+0x1d5/0x350
 [<ffffffff81504c0e>] do_page_fault+0x13e/0x460
 [<ffffffff81085320>] ? __dequeue_entity+0x30/0x50
 [<ffffffff810127b2>] ? __switch_to+0x1a2/0x440
 [<ffffffff814ffe87>] ? __schedule+0x3f7/0x730
 [<ffffffff815016a5>] page_fault+0x25/0x30

3:
BUG: soft lockup - CPU#10 stuck for 22s! [cc1:31966]

Call Trace:
 [<ffffffff81114ad0>] ? page_alloc_cpu_notify+0x60/0x60
 [<ffffffff810a85c2>] smp_call_function+0x22/0x30
 [<ffffffff810a85fb>] on_each_cpu+0x2b/0x70
 [<ffffffff81112a4c>] drain_all_pages+0x1c/0x20
 [<ffffffff81114ffa>] __alloc_pages_slowpath+0x37a/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff811506fa>] alloc_pages_vma+0x9a/0x150
 [<ffffffff811442b2>] read_swap_cache_async+0xf2/0x150
 [<ffffffff81144b89>] ? valid_swaphandles+0x69/0x150
 [<ffffffff81144397>] swapin_readahead+0x87/0xc0
 [<ffffffff81134335>] do_swap_page+0x115/0x630
 [<ffffffff81133d7e>] ? do_wp_page+0x38e/0x830
 [<ffffffff81134f9a>] handle_pte_fault+0x1aa/0x210
 [<ffffffff811351d5>] handle_mm_fault+0x1d5/0x350
 [<ffffffff81504c0e>] do_page_fault+0x13e/0x460
 [<ffffffff81085320>] ? __dequeue_entity+0x30/0x50
 [<ffffffff810127b2>] ? __switch_to+0x1a2/0x440
 [<ffffffff814ffe87>] ? __schedule+0x3f7/0x730
 [<ffffffff815016a5>] page_fault+0x25/0x30

4:
BUG: soft lockup - CPU#11 stuck for 23s! [cc1:9614]

Call Trace:
 [<ffffffff8116ec25>] grab_super_passive+0x25/0xa0
 [<ffffffff8116ece1>] prune_super+0x41/0x1c0
 [<ffffffff8111ef91>] shrink_slab+0xa1/0x2c0
 [<ffffffff811208ea>] ? shrink_zones+0x9a/0x200
 [<ffffffff81120d33>] do_try_to_free_pages+0x2e3/0x3e0
 [<ffffffff811210bb>] try_to_free_pages+0x9b/0x120
 [<ffffffff8111edfa>] ? wakeup_kswapd+0x4a/0x140
 [<ffffffff81114f9e>] __alloc_pages_slowpath+0x31e/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff8114efca>] alloc_pages_current+0xaa/0x110
 [<ffffffff8110c07f>] __page_cache_alloc+0x8f/0xb0
 [<ffffffff8110d04f>] filemap_fault+0x1af/0x4b0
 [<ffffffff81165d2e>] ? mem_cgroup_update_page_stat+0x1e/0x100
 [<ffffffff811348c2>] __do_fault+0x72/0x5a0
 [<ffffffff81134ed7>] handle_pte_fault+0xe7/0x210
 [<ffffffff811351d5>] handle_mm_fault+0x1d5/0x350
 [<ffffffff81504c0e>] do_page_fault+0x13e/0x460
 [<ffffffff81189fb3>] ? mntput+0x23/0x40
 [<ffffffff8116dfbb>] ? __fput+0x16b/0x240
 [<ffffffff815016a5>] page_fault+0x25/0x30

5:
BUG: soft lockup - CPU#11 stuck for 23s! [gnome-session:6449]

Call Trace:
 [<ffffffff8116ea8d>] put_super+0x1d/0x40
 [<ffffffff8116ebf2>] drop_super+0x22/0x30
 [<ffffffff8116ee39>] prune_super+0x199/0x1c0
 [<ffffffff8111ef91>] shrink_slab+0xa1/0x2c0
 [<ffffffff811208ea>] ? shrink_zones+0x9a/0x200
 [<ffffffff81120d33>] do_try_to_free_pages+0x2e3/0x3e0
 [<ffffffff811210bb>] try_to_free_pages+0x9b/0x120
 [<ffffffff8111edfa>] ? wakeup_kswapd+0x4a/0x140
 [<ffffffff81114f9e>] __alloc_pages_slowpath+0x31e/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff8114efca>] alloc_pages_current+0xaa/0x110
 [<ffffffff8110c07f>] __page_cache_alloc+0x8f/0xb0
 [<ffffffff8110d04f>] filemap_fault+0x1af/0x4b0
 [<ffffffff81165d2e>] ? mem_cgroup_update_page_stat+0x1e/0x100
 [<ffffffff811348c2>] __do_fault+0x72/0x5a0
 [<ffffffff81134ed7>] handle_pte_fault+0xe7/0x210
 [<ffffffff811351d5>] handle_mm_fault+0x1d5/0x350
 [<ffffffff81504c0e>] do_page_fault+0x13e/0x460
 [<ffffffff811fa9db>] ? security_file_permission+0x8b/0x90
 [<ffffffff815016a5>] page_fault+0x25/0x30

6:
BUG: soft lockup - CPU#2 stuck for 40s! [kworker/2:1:17511]

Call Trace:
 [<ffffffff810515b7>] exit_notify+0x17/0x190
 [<ffffffff81052679>] do_exit+0x1f9/0x470
 [<ffffffff8106ab50>] ? manage_workers+0x120/0x120
 [<ffffffff8106fbc5>] kthread+0x95/0xb0
 [<ffffffff8150a7e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106fb30>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff8150a7e0>] ? gs_change+0x13/0x13

As the "mem_cgroup" appears lots of time, so at first I think this is
caused by mem cgroup, so I umount all the other cgroup subsys besides
cpu cgroup and test again, but issue still exist, the new log is like:

BUG: soft lockup - CPU#0 stuck for 22s! [cc1:15411]

Call Trace:
 [<ffffffff81114ad0>] ? page_alloc_cpu_notify+0x60/0x60
 [<ffffffff810a85c2>] smp_call_function+0x22/0x30
 [<ffffffff810a85fb>] on_each_cpu+0x2b/0x70
 [<ffffffff81112a4c>] drain_all_pages+0x1c/0x20
 [<ffffffff81114ffa>] __alloc_pages_slowpath+0x37a/0x710
 [<ffffffff8111060f>] ? zone_watermark_ok+0x1f/0x30
 [<ffffffff81115534>] __alloc_pages_nodemask+0x1a4/0x1f0
 [<ffffffff8114efca>] alloc_pages_current+0xaa/0x110
 [<ffffffff8110c07f>] __page_cache_alloc+0x8f/0xb0
 [<ffffffff8110ce3f>] find_or_create_page+0x4f/0xb0
 [<ffffffff8119b3ac>] grow_dev_page+0x3c/0x210
 [<ffffffff8119b95c>] __getblk_slow+0x9c/0x130
 [<ffffffff8119ba56>] __getblk+0x66/0x70
 [<ffffffff8119c412>] __breadahead+0x12/0x40
 [<ffffffffa00ae7d6>] __ext4_get_inode_loc+0x346/0x400 [ext4]
 [<ffffffffa00b0d06>] ext4_iget+0x86/0x820 [ext4]
 [<ffffffffa00b52f5>] ext4_lookup+0xa5/0x120 [ext4]
 [<ffffffff81176fc5>] d_alloc_and_lookup+0x45/0x90
 [<ffffffff81182655>] ? d_lookup+0x35/0x60
 [<ffffffff81178e28>] do_lookup+0x278/0x390
 [<ffffffff811fa44c>] ? security_inode_permission+0x1c/0x30
 [<ffffffff81179b51>] do_last+0xe1/0x830
 [<ffffffff8117abf6>] path_openat+0xd6/0x3e0
 [<ffffffff81177ec5>] ? putname+0x35/0x50
 [<ffffffff8117c593>] ? user_path_at_empty+0x63/0xa0
 [<ffffffff8117b019>] do_filp_open+0x49/0xa0
 [<ffffffff81256c5a>] ? strncpy_from_user+0x4a/0x90
 [<ffffffff811777d0>] ? getname_flags+0x1d0/0x280
 [<ffffffff81187d6d>] ? alloc_fd+0x4d/0x120
 [<ffffffff8116b788>] do_sys_open+0x108/0x1e0
 [<ffffffff810c7fec>] ? __audit_syscall_entry+0xcc/0x210
 [<ffffffff8116b8a1>] sys_open+0x21/0x30
 [<ffffffff815094e9>] system_call_fastpath+0x16/0x1b

So I think this is some issue related to mm and cgroup's combination,
please tell me if you need more info of the log :)

Regards,
Michael Wang

