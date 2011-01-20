Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1ATROl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:14:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35307 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1ATROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:14:40 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 12:14:39 EST
Date: Thu, 20 Jan 2011 17:08:45 +0000 (GMT)
From: Malcolm Scott <lkml@malc.org.uk>
X-X-Sender: mas90@callisto.malc.org.uk
To: linux-kernel@vger.kernel.org
Subject: XFS deadlock in 2.6.37
Message-ID: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've had the following deadlock happen twice on a 2.6.37 system with several 
XFS filesystems (including root) and no swap (may be relevant, considering 
that kswapd is one task involved here).  Some minor filesystem corruption 
resulted (but maybe only because the root fs couldn't be synced/umounted).

If you need any more info, please let me know.

--- first crash ---

[504603.250208] INFO: task kswapd0:37 blocked for more than 120 seconds.
[504603.261107] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504603.273465] kswapd0       D 0000000000000003     0    37      2 0x00000000
[504603.273473]  ffff88034428bc10 0000000000000046 ffff88034428bfd8 ffff88034428a000
[504603.273479]  0000000000013a80 ffff8803442903a0 ffff88034428bfd8 0000000000013a80
[504603.273483]  ffff88034572ad80 ffff880344290000 ffffffffffffff10 ffff880343a51e28
[504603.273488] Call Trace:
[504603.273500]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504603.273504]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504603.273541]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504603.273554]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504603.273567]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504603.273573]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504603.273577]  [<ffffffff81120420>] balance_pgdat+0x2b0/0x530
[504603.273580]  [<ffffffff811207df>] kswapd+0x13f/0x2b0
[504603.273585]  [<ffffffff81087d30>] ? autoremove_wake_function+0x0/0x40
[504603.273588]  [<ffffffff811206a0>] ? kswapd+0x0/0x2b0
[504603.273591]  [<ffffffff81087606>] kthread+0x96/0xa0
[504603.273596]  [<ffffffff8100cea4>] kernel_thread_helper+0x4/0x10
[504603.273599]  [<ffffffff81087570>] ? kthread+0x0/0xa0
[504603.273603]  [<ffffffff8100cea0>] ? kernel_thread_helper+0x0/0x10
[504603.273688] INFO: task apache2:28657 blocked for more than 120 seconds.
[504603.285217] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504603.298145] apache2       D 0000000000000003     0 28657  12480 0x00000000
[504603.298151]  ffff8802f91c7a10 0000000000000082 ffff8802f91c7fd8 ffff8802f91c6000
[504603.298155]  0000000000013a80 ffff8802b60703a0 ffff8802f91c7fd8 0000000000013a80
[504603.298160]  ffff88034713c440 ffff8802b6070000 0000000000000000 ffff880343a51e28
[504603.298165] Call Trace:
[504603.298174]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504603.298177]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504603.298208]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504603.298221]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504603.298234]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504603.298240]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504603.298243]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504603.298249]  [<ffffffff814cefa0>] ? skb_release_data+0x90/0xe0
[504603.298252]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504603.298256]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504603.298262]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504603.298265]  [<ffffffff81111f9e>] __get_free_pages+0xe/0x50
[504603.298270]  [<ffffffff81063ec6>] dup_task_struct+0x46/0x190
[504603.298273]  [<ffffffff8106442e>] copy_process+0xbe/0xe70
[504603.298278]  [<ffffffff8104ec1e>] ? __wake_up_sync_key+0x5e/0x80
[504603.298281]  [<ffffffff810652bd>] do_fork+0x8d/0x430
[504603.298286]  [<ffffffff81166825>] ? __fput+0x155/0x220
[504603.298289]  [<ffffffff81166915>] ? fput+0x25/0x30
[504603.298292]  [<ffffffff81163240>] ? filp_close+0x60/0x90
[504603.298296]  [<ffffffff810150c8>] sys_clone+0x28/0x30
[504603.298300]  [<ffffffff8100c3a3>] stub_clone+0x13/0x20
[504603.298303]  [<ffffffff8100c082>] ? system_call_fastpath+0x16/0x1b
[504603.298371] INFO: task Interface.cgi:14369 blocked for more than 120 seconds.
[504603.310680] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504603.323585] Interface.cgi D 0000000000000001     0 14369  28657 0x00000000
[504603.323590]  ffff880046155708 0000000000000086 ffff880046155fd8 ffff880046154000
[504603.323595]  0000000000013a80 ffff8800050edea0 ffff880046155fd8 0000000000013a80
[504603.323600]  ffff880347120000 ffff8800050edb00 ffff880046155708 ffff880343a51e28
[504603.323605] Call Trace:
[504603.323612]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504603.323616]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504603.323641]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504603.323654]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504603.323667]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504603.323672]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504603.323675]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504603.323679]  [<ffffffff81114d12>] ? prep_new_page+0x142/0x1b0
[504603.323682]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504603.323685]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504603.323691]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504603.323695]  [<ffffffff81153095>] new_slab+0x1f5/0x290
[504603.323698]  [<ffffffff81154a62>] __slab_alloc+0x1b2/0x390
[504603.323703]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[504603.323706]  [<ffffffff81157f7d>] __kmalloc_node_track_caller+0x8d/0x1a0
[504603.323710]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[504603.323713]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[504603.323717]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[504603.323721]  [<ffffffff81039459>] ? default_spin_lock_flags+0x9/0x10
[504603.323725]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[504603.323730]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[504603.323734]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[504603.323738]  [<ffffffff8116e761>] ? pipe_read+0x2b1/0x4b0
[504603.323742]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[504603.323748]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[504603.323753]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[504603.323756]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[504603.323759]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[504603.323763]  [<ffffffff81165771>] sys_write+0x51/0x90
[504603.323766]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[504603.323770] INFO: task php5-cgi:14376 blocked for more than 120 seconds.
[504603.335893] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504603.349265] php5-cgi      D 0000000000000001     0 14376  28657 0x00000000
[504603.349270]  ffff88003a02da10 0000000000000086 ffff88003a02dfd8 ffff88003a02c000
[504603.349275]  0000000000013a80 ffff88008cfcdea0 ffff88003a02dfd8 0000000000013a80
[504603.349280]  ffff880346b8db00 ffff88008cfcdb00 0000000000000000 ffff880343a51e28
[504603.349284] Call Trace:
[504603.349290]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504603.349293]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504603.349314]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504603.349326]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504603.349339]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504603.349343]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504603.349346]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504603.349350]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504603.349353]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504603.349358]  [<ffffffff812dc8ee>] ? radix_tree_lookup_slot+0xe/0x10
[504603.349364]  [<ffffffff8115ff5d>] ? mem_cgroup_charge_common+0x6d/0x90
[504603.349367]  [<ffffffff81119d9d>] ? lru_cache_add_lru+0x2d/0x50
[504603.349371]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504603.349374]  [<ffffffff81111f9e>] __get_free_pages+0xe/0x50
[504603.349379]  [<ffffffff81063ec6>] dup_task_struct+0x46/0x190
[504603.349382]  [<ffffffff8106442e>] copy_process+0xbe/0xe70
[504603.349386]  [<ffffffff8113846c>] ? change_protection.clone.4+0x21c/0x250
[504603.349391]  [<ffffffff815d3bb8>] ? do_page_fault+0x268/0x560
[504603.349394]  [<ffffffff810652bd>] do_fork+0x8d/0x430
[504603.349397]  [<ffffffff8113861d>] ? mprotect_fixup+0x17d/0x2d0
[504603.349401]  [<ffffffff810150c8>] sys_clone+0x28/0x30
[504603.349405]  [<ffffffff8100c3a3>] stub_clone+0x13/0x20
[504603.349408]  [<ffffffff8100c082>] ? system_call_fastpath+0x16/0x1b
[504603.349411] INFO: task quota:14379 blocked for more than 120 seconds.
[504603.361741] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504603.375377] quota         D 0000000000000000     0 14379  31799 0x00000000
[504603.375382]  ffff880064cafca8 0000000000000082 ffff880064caffd8 ffff880064cae000
[504603.375387]  0000000000013a80 ffff88024f7e9a60 ffff880064caffd8 0000000000013a80
[504603.375392]  ffff8802dce4db00 ffff88024f7e96c0 0000000000000000 ffff880343a51e28
[504603.375396] Call Trace:
[504603.375402]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504603.375422]  [<ffffffffa00cc7d7>] ? xfs_qm_dqget+0x317/0x420 [xfs]
[504603.375426]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504603.375438]  [<ffffffffa00cc1a5>] xfs_qm_dqput+0x165/0x1b0 [xfs]
[504603.375451]  [<ffffffffa00cefe6>] xfs_qm_scall_getquota+0xc6/0xe0 [xfs]
[504603.375464]  [<ffffffffa00d29a6>] xfs_fs_get_dqblk+0x66/0x70 [xfs]
[504603.375469]  [<ffffffff811bbeee>] quota_getxquota+0x3e/0x90
[504603.375473]  [<ffffffff811bc450>] do_quotactl+0x390/0x510
[504603.375478]  [<ffffffff8117a77f>] ? dput+0x8f/0x160
[504603.375481]  [<ffffffff811702c1>] ? path_put+0x31/0x40
[504603.375484]  [<ffffffff811bc680>] sys_quotactl+0xb0/0x130
[504603.375488]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[504723.370635] INFO: task kswapd0:37 blocked for more than 120 seconds.
[504723.382903] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504723.396847] kswapd0       D 0000000000000003     0    37      2 0x00000000
[504723.396853]  ffff88034428bc10 0000000000000046 ffff88034428bfd8 ffff88034428a000
[504723.396858]  0000000000013a80 ffff8803442903a0 ffff88034428bfd8 0000000000013a80
[504723.396863]  ffff88034572ad80 ffff880344290000 ffffffffffffff10 ffff880343a51e28
[504723.396868] Call Trace:
[504723.396879]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504723.396883]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504723.396920]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504723.396933]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504723.396946]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504723.396953]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504723.396956]  [<ffffffff81120420>] balance_pgdat+0x2b0/0x530
[504723.396960]  [<ffffffff811207df>] kswapd+0x13f/0x2b0
[504723.396965]  [<ffffffff81087d30>] ? autoremove_wake_function+0x0/0x40
[504723.396968]  [<ffffffff811206a0>] ? kswapd+0x0/0x2b0
[504723.396971]  [<ffffffff81087606>] kthread+0x96/0xa0
[504723.396976]  [<ffffffff8100cea4>] kernel_thread_helper+0x4/0x10
[504723.396979]  [<ffffffff81087570>] ? kthread+0x0/0xa0
[504723.396982]  [<ffffffff8100cea0>] ? kernel_thread_helper+0x0/0x10
[504723.397065] INFO: task apache2:28657 blocked for more than 120 seconds.
[504723.409887] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504723.424100] apache2       D 0000000000000003     0 28657  12480 0x00000000
[504723.424105]  ffff8802f91c7a10 0000000000000082 ffff8802f91c7fd8 ffff8802f91c6000
[504723.424110]  0000000000013a80 ffff8802b60703a0 ffff8802f91c7fd8 0000000000013a80
[504723.424115]  ffff88034713c440 ffff8802b6070000 0000000000000000 ffff880343a51e28
[504723.424119] Call Trace:
[504723.424125]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504723.424129]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504723.424149]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504723.424161]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504723.424174]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504723.424178]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504723.424181]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504723.424186]  [<ffffffff814cefa0>] ? skb_release_data+0x90/0xe0
[504723.424190]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504723.424193]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504723.424199]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504723.424202]  [<ffffffff81111f9e>] __get_free_pages+0xe/0x50
[504723.424207]  [<ffffffff81063ec6>] dup_task_struct+0x46/0x190
[504723.424210]  [<ffffffff8106442e>] copy_process+0xbe/0xe70
[504723.424214]  [<ffffffff8104ec1e>] ? __wake_up_sync_key+0x5e/0x80
[504723.424218]  [<ffffffff810652bd>] do_fork+0x8d/0x430
[504723.424222]  [<ffffffff81166825>] ? __fput+0x155/0x220
[504723.424226]  [<ffffffff81166915>] ? fput+0x25/0x30
[504723.424229]  [<ffffffff81163240>] ? filp_close+0x60/0x90
[504723.424233]  [<ffffffff810150c8>] sys_clone+0x28/0x30
[504723.424236]  [<ffffffff8100c3a3>] stub_clone+0x13/0x20
[504723.424239]  [<ffffffff8100c082>] ? system_call_fastpath+0x16/0x1b
[504723.424304] INFO: task Interface.cgi:14369 blocked for more than 120 seconds.
[504723.437737] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504723.452141] Interface.cgi D 0000000000000001     0 14369  28657 0x00000000
[504723.452145]  ffff880046155708 0000000000000086 ffff880046155fd8 ffff880046154000
[504723.452150]  0000000000013a80 ffff8800050edea0 ffff880046155fd8 0000000000013a80
[504723.452154]  ffff880347120000 ffff8800050edb00 ffff880046155708 ffff880343a51e28
[504723.452159] Call Trace:
[504723.452164]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504723.452168]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504723.452188]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504723.452201]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504723.452214]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504723.452218]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504723.452221]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504723.452224]  [<ffffffff81114d12>] ? prep_new_page+0x142/0x1b0
[504723.452227]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504723.452231]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504723.452236]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504723.452240]  [<ffffffff81153095>] new_slab+0x1f5/0x290
[504723.452243]  [<ffffffff81154a62>] __slab_alloc+0x1b2/0x390
[504723.452247]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[504723.452251]  [<ffffffff81157f7d>] __kmalloc_node_track_caller+0x8d/0x1a0
[504723.452254]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[504723.452258]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[504723.452261]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[504723.452265]  [<ffffffff81039459>] ? default_spin_lock_flags+0x9/0x10
[504723.452269]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[504723.452274]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[504723.452278]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[504723.452282]  [<ffffffff8116e761>] ? pipe_read+0x2b1/0x4b0
[504723.452286]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[504723.452291]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[504723.452296]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[504723.452299]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[504723.452302]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[504723.452305]  [<ffffffff81165771>] sys_write+0x51/0x90
[504723.452309]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[504723.452312] INFO: task php5-cgi:14376 blocked for more than 120 seconds.
[504723.465555] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504723.480032] php5-cgi      D 0000000000000001     0 14376  28657 0x00000000
[504723.480037]  ffff88003a02da10 0000000000000086 ffff88003a02dfd8 ffff88003a02c000
[504723.480042]  0000000000013a80 ffff88008cfcdea0 ffff88003a02dfd8 0000000000013a80
[504723.480046]  ffff880346b8db00 ffff88008cfcdb00 0000000000000000 ffff880343a51e28
[504723.480051] Call Trace:
[504723.480056]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504723.480060]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504723.480078]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[504723.480090]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[504723.480103]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
[504723.480107]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[504723.480110]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[504723.480114]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[504723.480117]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[504723.480122]  [<ffffffff812dc8ee>] ? radix_tree_lookup_slot+0xe/0x10
[504723.480127]  [<ffffffff8115ff5d>] ? mem_cgroup_charge_common+0x6d/0x90
[504723.480131]  [<ffffffff81119d9d>] ? lru_cache_add_lru+0x2d/0x50
[504723.480135]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[504723.480138]  [<ffffffff81111f9e>] __get_free_pages+0xe/0x50
[504723.480142]  [<ffffffff81063ec6>] dup_task_struct+0x46/0x190
[504723.480145]  [<ffffffff8106442e>] copy_process+0xbe/0xe70
[504723.480149]  [<ffffffff8113846c>] ? change_protection.clone.4+0x21c/0x250
[504723.480154]  [<ffffffff815d3bb8>] ? do_page_fault+0x268/0x560
[504723.480157]  [<ffffffff810652bd>] do_fork+0x8d/0x430
[504723.480160]  [<ffffffff8113861d>] ? mprotect_fixup+0x17d/0x2d0
[504723.480164]  [<ffffffff810150c8>] sys_clone+0x28/0x30
[504723.480167]  [<ffffffff8100c3a3>] stub_clone+0x13/0x20
[504723.480170]  [<ffffffff8100c082>] ? system_call_fastpath+0x16/0x1b
[504723.480174] INFO: task quota:14379 blocked for more than 120 seconds.
[504723.493339] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[504723.508084] quota         D 0000000000000000     0 14379  31799 0x00000000
[504723.508089]  ffff880064cafca8 0000000000000082 ffff880064caffd8 ffff880064cae000
[504723.508094]  0000000000013a80 ffff88024f7e9a60 ffff880064caffd8 0000000000013a80
[504723.508098]  ffff8802dce4db00 ffff88024f7e96c0 0000000000000000 ffff880343a51e28
[504723.508103] Call Trace:
[504723.508108]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[504723.508126]  [<ffffffffa00cc7d7>] ? xfs_qm_dqget+0x317/0x420 [xfs]
[504723.508129]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[504723.508142]  [<ffffffffa00cc1a5>] xfs_qm_dqput+0x165/0x1b0 [xfs]
[504723.508155]  [<ffffffffa00cefe6>] xfs_qm_scall_getquota+0xc6/0xe0 [xfs]
[504723.508168]  [<ffffffffa00d29a6>] xfs_fs_get_dqblk+0x66/0x70 [xfs]
[504723.508172]  [<ffffffff811bbeee>] quota_getxquota+0x3e/0x90
[504723.508176]  [<ffffffff811bc450>] do_quotactl+0x390/0x510
[504723.508181]  [<ffffffff8117a77f>] ? dput+0x8f/0x160
[504723.508184]  [<ffffffff811702c1>] ? path_put+0x31/0x40
[504723.508187]  [<ffffffff811bc680>] sys_quotactl+0xb0/0x130
[504723.508191]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b

--- second crash ---

[224162.720509] INFO: task kswapd0:37 blocked for more than 120 seconds.
[224162.732833] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224162.746586] kswapd0       D 0000000000000000     0    37      2 0x00000000
[224162.746593]  ffff88034428bc10 0000000000000046 ffff88034428bfd8 ffff88034428a000
[224162.746598]  0000000000013a80 ffff8803466c5ea0 ffff88034428bfd8 0000000000013a80
[224162.746603]  ffff8803467fc440 ffff8803466c5b00 ffffffffffffff10 ffff880343d41a28
[224162.746608] Call Trace:
[224162.746619]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224162.746624]  [<ffffffff815cfb6e>] ? _raw_spin_lock+0xe/0x20
[224162.746627]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224162.746667]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224162.746680]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224162.746693]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224162.746700]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224162.746703]  [<ffffffff81120420>] balance_pgdat+0x2b0/0x530
[224162.746707]  [<ffffffff811207df>] kswapd+0x13f/0x2b0
[224162.746712]  [<ffffffff81087d30>] ? autoremove_wake_function+0x0/0x40
[224162.746715]  [<ffffffff811206a0>] ? kswapd+0x0/0x2b0
[224162.746718]  [<ffffffff81087606>] kthread+0x96/0xa0
[224162.746722]  [<ffffffff8100cea4>] kernel_thread_helper+0x4/0x10
[224162.746726]  [<ffffffff81087570>] ? kthread+0x0/0xa0
[224162.746729]  [<ffffffff8100cea0>] ? kernel_thread_helper+0x0/0x10
[224162.746911] INFO: task quota:7861 blocked for more than 120 seconds.
[224162.759045] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224162.772610] quota         D 0000000000000001     0  7861  13705 0x00000000
[224162.772615]  ffff88008f3a3ca8 0000000000000086 ffff88008f3a3fd8 ffff88008f3a2000
[224162.772619]  0000000000013a80 ffff88008dec3120 ffff88008f3a3fd8 0000000000013a80
[224162.772624]  ffff8801198a8000 ffff88008dec2d80 ffffffff81060ac7 ffff880343d41a28
[224162.772628] Call Trace:
[224162.772633]  [<ffffffff81060ac7>] ? mutex_spin_on_owner+0x97/0xd0
[224162.772638]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224162.772656]  [<ffffffffa00d87d7>] ? xfs_qm_dqget+0x317/0x420 [xfs]
[224162.772660]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224162.772672]  [<ffffffffa00d81a5>] xfs_qm_dqput+0x165/0x1b0 [xfs]
[224162.772685]  [<ffffffffa00dafe6>] xfs_qm_scall_getquota+0xc6/0xe0 [xfs]
[224162.772698]  [<ffffffffa00de9a6>] xfs_fs_get_dqblk+0x66/0x70 [xfs]
[224162.772703]  [<ffffffff811bbeee>] quota_getxquota+0x3e/0x90
[224162.772707]  [<ffffffff811bc450>] do_quotactl+0x390/0x510
[224162.772712]  [<ffffffff8117a77f>] ? dput+0x8f/0x160
[224162.772716]  [<ffffffff811702c1>] ? path_put+0x31/0x40
[224162.772719]  [<ffffffff811bc680>] sys_quotactl+0xb0/0x130
[224162.772723]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224162.772727] INFO: task mutt_dotlock:8253 blocked for more than 120 seconds.
[224162.785572] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224162.799314] mutt_dotlock  D 0000000000000002     0  8253   8252 0x00000000
[224162.799318]  ffff880078ca9cb8 0000000000000086 ffff880078ca9fd8 ffff880078ca8000
[224162.799323]  0000000000013a80 ffff880075c71a60 ffff880078ca9fd8 0000000000013a80
[224162.799328]  ffff88030dae96c0 ffff880075c716c0 ffff880343550000 ffff880343d41a28
[224162.799332] Call Trace:
[224162.799337]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224162.799341]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224162.799358]  [<ffffffffa00d81a5>] xfs_qm_dqput+0x165/0x1b0 [xfs]
[224162.799370]  [<ffffffffa00d821e>] xfs_qm_dqrele+0x2e/0x70 [xfs]
[224162.799383]  [<ffffffffa00dd65f>] xfs_qm_dqdetach+0x3f/0x90 [xfs]
[224162.799405]  [<ffffffffa0132a12>] xfs_inactive+0x222/0x470 [xfs]
[224162.799425]  [<ffffffffa01407de>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
[224162.799429]  [<ffffffff8117c707>] evict+0x27/0xc0
[224162.799432]  [<ffffffff8117d34a>] iput_final+0x19a/0x2a0
[224162.799435]  [<ffffffff8117d48b>] iput+0x3b/0x50
[224162.799439]  [<ffffffff811728c0>] do_unlinkat+0x110/0x1d0
[224162.799443]  [<ffffffff8108eead>] ? commit_creds+0xed/0x1c0
[224162.799447]  [<ffffffff81174036>] sys_unlink+0x16/0x20
[224162.799450]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224282.790612] INFO: task kswapd0:37 blocked for more than 120 seconds.
[224282.803102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.817170] kswapd0       D 0000000000000000     0    37      2 0x00000000
[224282.817176]  ffff88034428bc10 0000000000000046 ffff88034428bfd8 ffff88034428a000
[224282.817181]  0000000000013a80 ffff8803466c5ea0 ffff88034428bfd8 0000000000013a80
[224282.817186]  ffff8803467fc440 ffff8803466c5b00 ffffffffffffff10 ffff880343d41a28
[224282.817191] Call Trace:
[224282.817201]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.817206]  [<ffffffff815cfb6e>] ? _raw_spin_lock+0xe/0x20
[224282.817210]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.817247]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.817260]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.817337]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.817344]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.817347]  [<ffffffff81120420>] balance_pgdat+0x2b0/0x530
[224282.817350]  [<ffffffff811207df>] kswapd+0x13f/0x2b0
[224282.817355]  [<ffffffff81087d30>] ? autoremove_wake_function+0x0/0x40
[224282.817359]  [<ffffffff811206a0>] ? kswapd+0x0/0x2b0
[224282.817362]  [<ffffffff81087606>] kthread+0x96/0xa0
[224282.817366]  [<ffffffff8100cea4>] kernel_thread_helper+0x4/0x10
[224282.817370]  [<ffffffff81087570>] ? kthread+0x0/0xa0
[224282.817373]  [<ffffffff8100cea0>] ? kernel_thread_helper+0x0/0x10
[224282.817392] INFO: task mysqld:1458 blocked for more than 120 seconds.
[224282.829992] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.843909] mysqld        D 0000000000000002     0  1458      1 0x00000000
[224282.843914]  ffff88033f0dda10 0000000000000086 ffff88033f0ddfd8 ffff88033f0dc000
[224282.843919]  0000000000013a80 ffff88034362b120 ffff88033f0ddfd8 0000000000013a80
[224282.843924]  ffff880343a18000 ffff88034362ad80 ffff88033f0dd9f0 ffff880343d41a28
[224282.843928] Call Trace:
[224282.843933]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.843937]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.843956]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.843969]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.843981]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.843986]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.843989]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.843994]  [<ffffffff81039459>] ? default_spin_lock_flags+0x9/0x10
[224282.843997]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.844001]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.844006]  [<ffffffff8114acdd>] alloc_pages_current+0x9d/0x110
[224282.844010]  [<ffffffff81111f9e>] __get_free_pages+0xe/0x50
[224282.844014]  [<ffffffff81063ec6>] dup_task_struct+0x46/0x190
[224282.844017]  [<ffffffff8106442e>] copy_process+0xbe/0xe70
[224282.844021]  [<ffffffff8104ecb3>] ? __wake_up+0x53/0x70
[224282.844025]  [<ffffffff815cfb6e>] ? _raw_spin_lock+0xe/0x20
[224282.844028]  [<ffffffff810652bd>] do_fork+0x8d/0x430
[224282.844032]  [<ffffffff815cfb6e>] ? _raw_spin_lock+0xe/0x20
[224282.844037]  [<ffffffff81174980>] ? setfl+0xf0/0x1b0
[224282.844042]  [<ffffffff812b0fa0>] ? aa_revalidate_sk+0x80/0x90
[224282.844047]  [<ffffffff810150c8>] sys_clone+0x28/0x30
[224282.844050]  [<ffffffff8100c3a3>] stub_clone+0x13/0x20
[224282.844053]  [<ffffffff8100c082>] ? system_call_fastpath+0x16/0x1b
[224282.844058] INFO: task mysqld:7461 blocked for more than 120 seconds.
[224282.856424] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.870358] mysqld        D 0000000000000001     0  7461      1 0x00000000
[224282.870363]  ffff88006bcc77c8 0000000000000086 ffff88006bcc7fd8 ffff88006bcc6000
[224282.870368]  0000000000013a80 ffff880067a41a60 ffff88006bcc7fd8 0000000000013a80
[224282.870373]  ffff8803472f8000 ffff880067a416c0 ffff88006bcc77c8 ffff880343d41a28
[224282.870377] Call Trace:
[224282.870382]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.870386]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.870408]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.870421]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.870434]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.870438]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.870441]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.870445]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.870448]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.870453]  [<ffffffff8115295b>] kmalloc_large_node+0x6b/0xc0
[224282.870457]  [<ffffffff81158045>] __kmalloc_node_track_caller+0x155/0x1a0
[224282.870462]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[224282.870466]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[224282.870469]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[224282.870473]  [<ffffffff8104ec1e>] ? __wake_up_sync_key+0x5e/0x80
[224282.870476]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[224282.870481]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[224282.870485]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[224282.870489]  [<ffffffff811736d9>] ? do_filp_open+0x169/0x670
[224282.870494]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[224282.870498]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[224282.870503]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[224282.870506]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[224282.870509]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[224282.870512]  [<ffffffff81165771>] sys_write+0x51/0x90
[224282.870516]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224282.870519] INFO: task mysqld:7470 blocked for more than 120 seconds.
[224282.883047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.897032] mysqld        D 0000000000000002     0  7470      1 0x00000000
[224282.897039]  ffff880078d1f7c8 0000000000000086 ffff880078d1ffd8 ffff880078d1e000
[224282.897047]  0000000000013a80 ffff880024e95ea0 ffff880078d1ffd8 0000000000013a80
[224282.897054]  ffff8800955216c0 ffff880024e95b00 0000000000000000 ffff880343d41a28
[224282.897062] Call Trace:
[224282.897069]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.897074]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.897097]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.897111]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.897124]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.897130]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.897134]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.897139]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.897143]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.897149]  [<ffffffff8115295b>] kmalloc_large_node+0x6b/0xc0
[224282.897154]  [<ffffffff81158045>] __kmalloc_node_track_caller+0x155/0x1a0
[224282.897159]  [<ffffffff81057535>] ? enqueue_entity+0x35/0x1c0
[224282.897164]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[224282.897169]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[224282.897174]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[224282.897178]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[224282.897184]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[224282.897188]  [<ffffffff81013a55>] ? native_sched_clock+0x15/0x70
[224282.897194]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[224282.897198]  [<ffffffff8105f8b0>] ? wake_up_state+0x10/0x20
[224282.897203]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[224282.897209]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[224282.897214]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[224282.897219]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[224282.897223]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[224282.897227]  [<ffffffff81165771>] sys_write+0x51/0x90
[224282.897231]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224282.897236] INFO: task mysqld:28656 blocked for more than 120 seconds.
[224282.910015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.924279] mysqld        D 0000000000000000     0 28656      1 0x00000000
[224282.924285]  ffff880078d137c8 0000000000000086 ffff880078d13fd8 ffff880078d12000
[224282.924290]  0000000000013a80 ffff880004943120 ffff880078d13fd8 0000000000013a80
[224282.924294]  ffff880343a18000 ffff880004942d80 ffff880078d137c8 ffff880343d41a28
[224282.924299] Call Trace:
[224282.924305]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.924308]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.924329]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.924342]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.924355]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.924359]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.924363]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.924366]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.924369]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.924374]  [<ffffffff8115295b>] kmalloc_large_node+0x6b/0xc0
[224282.924377]  [<ffffffff81158045>] __kmalloc_node_track_caller+0x155/0x1a0
[224282.924381]  [<ffffffff814cabfb>] ? sock_wfree+0x5b/0x70
[224282.924384]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[224282.924388]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[224282.924391]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[224282.924395]  [<ffffffff814cf0bc>] ? consume_skb+0x2c/0x80
[224282.924398]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[224282.924402]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[224282.924405]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[224282.924410]  [<ffffffff811736d9>] ? do_filp_open+0x169/0x670
[224282.924414]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[224282.924418]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[224282.924422]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[224282.924425]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[224282.924429]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[224282.924432]  [<ffffffff81165771>] sys_write+0x51/0x90
[224282.924436]  [<ffffffff81056b2c>] ? do_sched_setscheduler+0x7c/0x80
[224282.924439]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224282.924443] INFO: task mysqld:7848 blocked for more than 120 seconds.
[224282.937308] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.951644] mysqld        D 0000000000000003     0  7848      1 0x00000000
[224282.951651]  ffff88000eb837c8 0000000000000086 ffff88000eb83fd8 ffff88000eb82000
[224282.951659]  0000000000013a80 ffff8803091803a0 ffff88000eb83fd8 0000000000013a80
[224282.951666]  ffff88034713c440 ffff880309180000 0000000000000000 ffff880343d41a28
[224282.951674] Call Trace:
[224282.951680]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.951685]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.951706]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.951719]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.951733]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.951738]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.951743]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.951747]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.951752]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.951757]  [<ffffffff8115295b>] kmalloc_large_node+0x6b/0xc0
[224282.951762]  [<ffffffff81158045>] __kmalloc_node_track_caller+0x155/0x1a0
[224282.951766]  [<ffffffff814cabfb>] ? sock_wfree+0x5b/0x70
[224282.951771]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[224282.951776]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[224282.951780]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[224282.951785]  [<ffffffff8117c1a9>] ? touch_atime+0x69/0x190
[224282.951790]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[224282.951794]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[224282.951799]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[224282.951804]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[224282.951809]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[224282.951814]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[224282.951818]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[224282.951823]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[224282.951827]  [<ffffffff81165771>] sys_write+0x51/0x90
[224282.951832]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b
[224282.951836] INFO: task mysqld:7852 blocked for more than 120 seconds.
[224282.964878] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[224282.979407] mysqld        D 0000000000000001     0  7852      1 0x00000000
[224282.979411]  ffff88008f37b7c8 0000000000000086 ffff88008f37bfd8 ffff88008f37a000
[224282.979419]  0000000000013a80 ffff880037119a60 ffff88008f37bfd8 0000000000013a80
[224282.979426]  ffff880343414440 ffff8800371196c0 0000000000000000 ffff880343d41a28
[224282.979434] Call Trace:
[224282.979440]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
[224282.979445]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
[224282.979464]  [<ffffffffa00db709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
[224282.979477]  [<ffffffffa00dbaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
[224282.979491]  [<ffffffffa00dbb69>] xfs_qm_shake+0x59/0x70 [xfs]
[224282.979497]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
[224282.979501]  [<ffffffff8111fca7>] do_try_to_free_pages+0x277/0x370
[224282.979505]  [<ffffffff8111fff4>] try_to_free_pages+0x84/0x100
[224282.979510]  [<ffffffff811157d4>] __alloc_pages_nodemask+0x404/0x6d0
[224282.979515]  [<ffffffff8115295b>] kmalloc_large_node+0x6b/0xc0
[224282.979520]  [<ffffffff81158045>] __kmalloc_node_track_caller+0x155/0x1a0
[224282.979524]  [<ffffffff814ca7aa>] ? sock_alloc_send_pskb+0xea/0x250
[224282.979529]  [<ffffffff814cf6d3>] __alloc_skb+0x83/0x170
[224282.979534]  [<ffffffff814ca7aa>] sock_alloc_send_pskb+0xea/0x250
[224282.979538]  [<ffffffff8104ec1e>] ? __wake_up_sync_key+0x5e/0x80
[224282.979543]  [<ffffffff814ca925>] sock_alloc_send_skb+0x15/0x20
[224282.979548]  [<ffffffff81566c1d>] unix_stream_sendmsg+0x32d/0x470
[224282.979552]  [<ffffffff814c5f7e>] sock_aio_write+0x14e/0x160
[224282.979558]  [<ffffffff8113aa9d>] ? page_add_new_anon_rmap+0x8d/0xa0
[224282.979563]  [<ffffffff81164cc2>] do_sync_write+0xd2/0x110
[224282.979568]  [<ffffffff812afcd8>] ? apparmor_file_permission+0x18/0x20
[224282.979573]  [<ffffffff81279f0c>] ? security_file_permission+0x2c/0xb0
[224282.979577]  [<ffffffff811650fd>] ? rw_verify_area+0x5d/0xe0
[224282.979582]  [<ffffffff811654ed>] vfs_write+0x16d/0x190
[224282.979586]  [<ffffffff81165771>] sys_write+0x51/0x90
[224282.979590]  [<ffffffff8100c082>] system_call_fastpath+0x16/0x1b


-- 
Malcolm Scott

