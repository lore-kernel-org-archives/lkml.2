Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab0DHUiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:38:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57856 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259Ab0DHUiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:38:10 -0400
Date: Thu, 8 Apr 2010 22:31:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100408203123.GA24632@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <4BBE1F92.3060802@redhat.com>
 <alpine.LFD.2.00.1004081128470.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004081128470.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, Apr 08, 2010 at 11:32:06AM -0700

Here we go, another night of testing starts... got more caffeine this
time :)

> > I haven't seen any places that insert VMAs by itself.
> > Several strange places that allocate them, but they
> > all appear to use the standard functions to insert them.
> 
> Yeah, it's complicated enough to add a vma with all the rbtree etc stuff 
> that I hope nobody actually cooks their own. But I too grepped for vma 
> allocations, and there were more of them than I expected, so...

... and of course, I just hit that WARN_ONCE on the first suspend (it did
suspend ok though):

[   88.078958] ------------[ cut here ]------------
[   88.079007] WARNING: at mm/memory.c:3110 handle_mm_fault+0x56/0x67c()
[   88.079032] Hardware name: System Product Name
[   88.079056] Mapping with no anon_vma
[   88.079082] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod k10temp 8250_pnp 8250 serial_core edac_core ohci_hcd pcspkr
[   88.079637] Pid: 1965, comm: console-kit-dae Not tainted 2.6.34-rc3-00290-g2156db9 #7
[   88.079676] Call Trace:
[   88.079713]  [<ffffffff81037ea8>] warn_slowpath_common+0x7c/0x94
[   88.079744]  [<ffffffff81037f17>] warn_slowpath_fmt+0x41/0x43
[   88.079774]  [<ffffffff810b857d>] handle_mm_fault+0x56/0x67c
[   88.079805]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   88.079838]  [<ffffffff810615ce>] ? put_lock_stats+0xe/0x27
[   88.079866]  [<ffffffff81062a55>] ? lock_release_holdtime+0x104/0x109
[   88.079898]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   88.079929]  [<ffffffff813f7de2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   88.079960]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   88.079988] ---[ end trace 154dd7f6249e1cc3 ]---

and then sysfs triggered that lockdep circular locking warning - I
thought it was fixed already :(


[  256.831204] =======================================================
[  256.831210] [ INFO: possible circular locking dependency detected ]
[  256.831216] 2.6.34-rc3-00290-g2156db9 #7
[  256.831221] -------------------------------------------------------
[  256.831226] hib.sh/2464 is trying to acquire lock:
[  256.831231]  (s_active#80){++++.+}, at: [<ffffffff81127412>] sysfs_addrm_finish+0x36/0x5f
[  256.831250] 
[  256.831252] but task is already holding lock:
[  256.831256]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8131bb52>] lock_policy_rwsem_write+0x4f/0x80
[  256.831271] 
[  256.831273] which lock already depends on the new lock.
[  256.831275] 
[  256.831278] 
[  256.831280] the existing dependency chain (in reverse order) is:
[  256.831284] 
[  256.831286] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  256.831294]        [<ffffffff8106790a>] __lock_acquire+0x1306/0x169f
[  256.831305]        [<ffffffff81067d95>] lock_acquire+0xf2/0x118
[  256.831314]        [<ffffffff813f727a>] down_read+0x4c/0x91
[  256.831323]        [<ffffffff8131c9f3>] lock_policy_rwsem_read+0x4f/0x80
[  256.831332]        [<ffffffff8131ca5c>] show+0x38/0x71
[  256.831341]        [<ffffffff81125ef0>] sysfs_read_file+0xb9/0x13e
[  256.831348]        [<ffffffff810d5901>] vfs_read+0xaf/0x150
[  256.831357]        [<ffffffff810d5a65>] sys_read+0x4a/0x71
[  256.831364]        [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[  256.831375] 
[  256.831376] -> #0 (s_active#80){++++.+}:
[  256.831385]        [<ffffffff810675c1>] __lock_acquire+0xfbd/0x169f
[  256.831385]        [<ffffffff81067d95>] lock_acquire+0xf2/0x118
[  256.831385]        [<ffffffff81126a79>] sysfs_deactivate+0x91/0xe6
[  256.831385]        [<ffffffff81127412>] sysfs_addrm_finish+0x36/0x5f
[  256.831385]        [<ffffffff81127504>] sysfs_remove_dir+0x7a/0x8d
[  256.831385]        [<ffffffff8118522e>] kobject_del+0x16/0x37
[  256.831385]        [<ffffffff8118528d>] kobject_release+0x3e/0x66
[  256.831385]        [<ffffffff811860d9>] kref_put+0x43/0x4d
[  256.831385]        [<ffffffff811851a9>] kobject_put+0x47/0x4b
[  256.831385]        [<ffffffff8131ba68>] __cpufreq_remove_dev+0x1e5/0x241
[  256.831385]        [<ffffffff813f4e33>] cpufreq_cpu_callback+0x67/0x7f
[  256.831385]        [<ffffffff8105846b>] notifier_call_chain+0x37/0x63
[  256.831385]        [<ffffffff81058505>] __raw_notifier_call_chain+0xe/0x10
[  256.831385]        [<ffffffff813e6091>] _cpu_down+0x98/0x2a6
[  256.831385]        [<ffffffff810396b1>] disable_nonboot_cpus+0x74/0x10d
[  256.831385]        [<ffffffff81075ac9>] hibernation_snapshot+0xac/0x1e1
[  256.831385]        [<ffffffff81075ccc>] hibernate+0xce/0x172
[  256.831385]        [<ffffffff81074a39>] state_store+0x5c/0xd3
[  256.831385]        [<ffffffff81184fb7>] kobj_attr_store+0x17/0x19
[  256.831385]        [<ffffffff81125dfb>] sysfs_write_file+0x108/0x144
[  256.831385]        [<ffffffff810d56c7>] vfs_write+0xb2/0x153
[  256.831385]        [<ffffffff810d582b>] sys_write+0x4a/0x71
[  256.831385]        [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[  256.831385] 
[  256.831385] other info that might help us debug this:
[  256.831385] 
[  256.831385] 6 locks held by hib.sh/2464:
[  256.831385]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81125d2f>] sysfs_write_file+0x3c/0x144
[  256.831385]  #1:  (s_active#49){.+.+.+}, at: [<ffffffff81125dda>] sysfs_write_file+0xe7/0x144
[  256.831385]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff81075c1a>] hibernate+0x1c/0x172
[  256.831385]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810395d1>] cpu_maps_update_begin+0x17/0x19
[  256.831385]  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039616>] cpu_hotplug_begin+0x2c/0x53
[  256.831385]  #5:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8131bb52>] lock_policy_rwsem_write+0x4f/0x80
[  256.831385] 
[  256.831385] stack backtrace:
[  256.831385] Pid: 2464, comm: hib.sh Tainted: G        W  2.6.34-rc3-00290-g2156db9 #7
[  256.831385] Call Trace:
[  256.831385]  [<ffffffff810643c3>] print_circular_bug+0xae/0xbd
[  256.831385]  [<ffffffff810675c1>] __lock_acquire+0xfbd/0x169f
[  256.831385]  [<ffffffff81127412>] ? sysfs_addrm_finish+0x36/0x5f
[  256.831385]  [<ffffffff81067d95>] lock_acquire+0xf2/0x118
[  256.831385]  [<ffffffff81127412>] ? sysfs_addrm_finish+0x36/0x5f
[  256.831385]  [<ffffffff81126a79>] sysfs_deactivate+0x91/0xe6
[  256.831385]  [<ffffffff81127412>] ? sysfs_addrm_finish+0x36/0x5f
[  256.831385]  [<ffffffff81063d12>] ? trace_hardirqs_on+0xd/0xf
[  256.831385]  [<ffffffff81126f3d>] ? release_sysfs_dirent+0x89/0xa9
[  256.831385]  [<ffffffff81127412>] sysfs_addrm_finish+0x36/0x5f
[  256.831385]  [<ffffffff81127504>] sysfs_remove_dir+0x7a/0x8d
[  256.831385]  [<ffffffff8118522e>] kobject_del+0x16/0x37
[  256.831385]  [<ffffffff8118528d>] kobject_release+0x3e/0x66
[  256.831385]  [<ffffffff8118524f>] ? kobject_release+0x0/0x66
[  256.831385]  [<ffffffff811860d9>] kref_put+0x43/0x4d
[  256.831385]  [<ffffffff811851a9>] kobject_put+0x47/0x4b
[  256.831385]  [<ffffffff8131ba68>] __cpufreq_remove_dev+0x1e5/0x241
[  256.831385]  [<ffffffff813f4e33>] cpufreq_cpu_callback+0x67/0x7f
[  256.831385]  [<ffffffff8105846b>] notifier_call_chain+0x37/0x63
[  256.831385]  [<ffffffff81058505>] __raw_notifier_call_chain+0xe/0x10
[  256.831385]  [<ffffffff813e6091>] _cpu_down+0x98/0x2a6
[  256.831385]  [<ffffffff810396b1>] disable_nonboot_cpus+0x74/0x10d
[  256.831385]  [<ffffffff81075ac9>] hibernation_snapshot+0xac/0x1e1
[  256.831385]  [<ffffffff81075ccc>] hibernate+0xce/0x172
[  256.831385]  [<ffffffff81074a39>] state_store+0x5c/0xd3
[  256.831385]  [<ffffffff81184fb7>] kobj_attr_store+0x17/0x19
[  256.831385]  [<ffffffff81125dfb>] sysfs_write_file+0x108/0x144
[  256.831385]  [<ffffffff810d56c7>] vfs_write+0xb2/0x153
[  256.831385]  [<ffffffff81063cda>] ? trace_hardirqs_on_caller+0x120/0x14b
[  256.831385]  [<ffffffff810d582b>] sys_write+0x4a/0x71
[  256.831385]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
Boris.
