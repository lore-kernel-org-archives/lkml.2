Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1ITJQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:16:38 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58279 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab1ITJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:16:36 -0400
Message-ID: <4E7859EC.4070904@linux.vnet.ibm.com>
Date: Tue, 20 Sep 2011 14:46:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [BUG] INFO: inconsistent lock state
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running kernel compilation along with suspend/resume
tests using the pm_test framework (at the processors level),
lockdep reports inconsistent lock state.
This is with Kernel 3.0.4.

Excerpt of the log:
kernel: [ 8221.176651] Freezing user space processes ... (elapsed 0.01 seconds) done.
kernel: [ 8221.247173] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
kernel: [ 8221.321962] PM: Preallocating image memory... 
kernel: [ 8221.768104] =================================
kernel: [ 8221.806233] [ INFO: inconsistent lock state ]
kernel: [ 8221.842744] 3.0.4 #1
kernel: [ 8221.861076] ---------------------------------
kernel: [ 8221.897583] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kernel: [ 8221.952270] test_processors/5971 [HC0[0]:SC0[0]:HE1:SE1] takes:
kernel: [ 8222.001872]  (&sb->s_type->i_mutex_key#13){+.+.?.}, at: [<ffffffffa01262ee>] ext4_evict_inode+0x2e/0x3d0 [ext4]
kernel: [ 8222.086774] {RECLAIM_FS-ON-W} state was registered at:
kernel: [ 8222.129821]   [<ffffffff810a6033>] mark_held_locks+0x73/0xa0
kernel: [ 8222.177316]   [<ffffffff810a60ff>] lockdep_trace_alloc+0x9f/0xd0
kernel: [ 8222.227720]   [<ffffffff81164dd6>] kmem_cache_alloc+0x36/0x1f0
kernel: [ 8222.276675]   [<ffffffff81191927>] d_alloc+0x27/0x1d0
kernel: [ 8222.319078]   [<ffffffff811864dd>] d_alloc_and_lookup+0x2d/0x90
kernel: [ 8222.368755]   [<ffffffff81188473>] do_lookup+0x2b3/0x300
kernel: [ 8222.413340]   [<ffffffff8118983f>] link_path_walk+0x18f/0x930
kernel: [ 8222.461564]   [<ffffffff8118a665>] path_lookupat+0x55/0x690
kernel: [ 8222.508330]   [<ffffffff8118acd1>] do_path_lookup+0x31/0xc0
kernel: [ 8222.555098]   [<ffffffff8118b9c9>] user_path_at+0x59/0xa0
kernel: [ 8222.600413]   [<ffffffff8118018c>] vfs_fstatat+0x4c/0x90
kernel: [ 8222.645001]   [<ffffffff811802fb>] vfs_stat+0x1b/0x20
kernel: [ 8222.687397]   [<ffffffff81180324>] sys_newstat+0x24/0x50
kernel: [ 8222.731986]   [<ffffffff8152fa82>] system_call_fastpath+0x16/0x1b
kernel: [ 8222.783119] irq event stamp: 2109279487
kernel: [ 8222.815258] hardirqs last  enabled at (2109279487): [<ffffffff81526fe0>] _raw_spin_unlock_irq+0x30/0x40
kernel: [ 8222.894087] hardirqs last disabled at (2109279486): [<ffffffff8152665f>] _raw_spin_lock_irq+0x1f/0x80
kernel: [ 8222.971464] softirqs last  enabled at (2109279484): [<ffffffff8106ea7c>] __do_softirq+0x14c/0x250
kernel: [ 8223.045929] softirqs last disabled at (2109279461): [<ffffffff81530d3c>] call_softirq+0x1c/0x30
kernel: [ 8223.118941] 
kernel: [ 8223.118942] other info that might help us debug this:
kernel: [ 8223.173776]  Possible unsafe locking scenario:
kernel: [ 8223.173777] 
kernel: [ 8223.223525]        CPU0
kernel: [ 8223.244031]        ----
kernel: [ 8223.264541]   lock(&sb->s_type->i_mutex_key);
kernel: [ 8223.301204]   <Interrupt>
kernel: [ 8223.323168]     lock(&sb->s_type->i_mutex_key);
kernel: [ 8223.361284] 
kernel: [ 8223.361285]  *** DEADLOCK ***
kernel: [ 8223.361285] 
kernel: [ 8223.411172] 5 locks held by test_processors/5971:
kernel: [ 8223.450586]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811ee0a4>] sysfs_write_file+0x44/0x170
kernel: [ 8223.524561]  #1:  (s_active#79){.+.+.+}, at: [<ffffffff811ee12d>] sysfs_write_file+0xcd/0x170
kernel: [ 8223.596444]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff810b8a7c>] hibernate+0x1c/0x200
kernel: [ 8223.660968]  #3:  (shrinker_rwsem){++++..}, at: [<ffffffff8112b98d>] shrink_slab+0x3d/0x1b0
kernel: [ 8223.731320]  #4:  (iprune_sem){.+.+.-}, at: [<ffffffff81196cc1>] prune_icache+0x31/0x310
kernel: [ 8223.799493] 
kernel: [ 8223.799493] stack backtrace:
kernel: [ 8223.836149] Pid: 5971, comm: test_processors Not tainted 3.0.4 #1
kernel: [ 8223.887194] Call Trace:
kernel: [ 8223.907706]  [<ffffffff810a5439>] print_usage_bug+0x179/0x180
kernel: [ 8223.955846]  [<ffffffff810a5440>] ? print_usage_bug+0x180/0x180
kernel: [ 8224.005444]  [<ffffffff810a5aae>] mark_lock_irq+0xfe/0x290
kernel: [ 8224.051402]  [<ffffffff810a5d91>] mark_lock+0x151/0x1f0
kernel: [ 8224.095182]  [<ffffffff810a5ef6>] mark_irqflags+0xc6/0x190
kernel: [ 8224.141139]  [<ffffffff810a7624>] __lock_acquire+0x344/0x4f0
kernel: [ 8224.188555]  [<ffffffff810a7e84>] lock_acquire+0xa4/0x130
kernel: [ 8224.233792]  [<ffffffffa01262ee>] ? ext4_evict_inode+0x2e/0x3d0 [ext4]
kernel: [ 8224.288477]  [<ffffffff81524fed>] __mutex_lock_common+0x4d/0x3f0
kernel: [ 8224.338805]  [<ffffffffa01262ee>] ? ext4_evict_inode+0x2e/0x3d0 [ext4]
kernel: [ 8224.393486]  [<ffffffff810a190d>] ? trace_hardirqs_off+0xd/0x10
kernel: [ 8224.443082]  [<ffffffff8109439f>] ? local_clock+0x6f/0x80
kernel: [ 8224.488323]  [<ffffffffa01262ee>] ? ext4_evict_inode+0x2e/0x3d0 [ext4]
kernel: [ 8224.543012]  [<ffffffff810a5865>] ? lock_release_holdtime+0x35/0x180
kernel: [ 8224.596243]  [<ffffffff810a7c99>] ? __lock_release+0x129/0x190
kernel: [ 8224.645122]  [<ffffffff811966d5>] ? evict+0x75/0x180
kernel: [ 8224.686721]  [<ffffffff815254fa>] mutex_lock_nested+0x4a/0x60
kernel: [ 8224.734871]  [<ffffffffa01262ee>] ext4_evict_inode+0x2e/0x3d0 [ext4]
kernel: [ 8224.788104]  [<ffffffff811966e3>] evict+0x83/0x180
kernel: [ 8224.828248]  [<ffffffff81196827>] dispose_list+0x47/0x60
kernel: [ 8224.872752]  [<ffffffff81196de5>] prune_icache+0x155/0x310
kernel: [ 8224.918708]  [<ffffffff81196fe6>] shrink_icache_memory+0x46/0x50
kernel: [ 8224.969034]  [<ffffffff8112ba82>] shrink_slab+0x132/0x1b0
kernel: [ 8225.014268]  [<ffffffff8112db02>] do_try_to_free_pages+0x2d2/0x3c0
kernel: [ 8225.066044]  [<ffffffff8112dcad>] shrink_all_memory+0xbd/0xf0
kernel: [ 8225.114192]  [<ffffffff81136d76>] ? next_online_pgdat+0x26/0x50
kernel: [ 8225.163789]  [<ffffffff810ba6a5>] hibernate_preallocate_memory+0x1e5/0x2a0
kernel: [ 8225.221379]  [<ffffffff810b896d>] hibernation_snapshot+0x8d/0x180
kernel: [ 8225.272424]  [<ffffffff810b8b58>] hibernate+0xf8/0x200
kernel: [ 8225.315476]  [<ffffffff810b6ffc>] state_store+0xec/0x100
kernel: [ 8225.359984]  [<ffffffff8125f8b7>] kobj_attr_store+0x17/0x20
kernel: [ 8225.406670]  [<ffffffff811ee146>] sysfs_write_file+0xe6/0x170
kernel: [ 8225.454809]  [<ffffffff8117afd0>] vfs_write+0xd0/0x1a0
kernel: [ 8225.497856]  [<ffffffff8117b1a4>] sys_write+0x54/0xa0
kernel: [ 8225.540180]  [<ffffffff8152fa82>] system_call_fastpath+0x16/0x1b
kernel: [ 8226.890288] done (allocated 2511433 pages)
kernel: [ 8226.924630] PM: Allocated 10045732 kbytes in 5.54 seconds (1813.30 MB/s)

 
-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
