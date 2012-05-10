Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2EJN0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab2EJN0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:26:50 -0400
Date: Thu, 10 May 2012 15:26:25 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
Message-ID: <20120510132625.GA1455@thinkpad.mammed.net>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
 <4FAA452A.1070909@gmail.com>
 <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins>
 <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins>
 <1336566644.2527.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336566644.2527.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 02:30:44PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 14:21 +0200, Peter Zijlstra wrote:
> > Does something like the below give any clues as to how we got there?
> 
> New version that checks we include the right cpu in build_sched_domain()
> too.. on a related note, we should add a printk-%p modifier for cpulist,
> this cpulist_scnprintf() stuff gets annoying.
> 
Logs produced with your patches:
 
[  141.699854] sched: Bonkers domain doesn't include its own cpu: 3 0-1,3
[  141.725038] sched: Bonkers domain doesn't include its own cpu: 3 0-1
[  141.725785] ------------[ cut here ]------------
[  141.726351] WARNING: at kernel/sched/core.c:6468 build_sched_domain+0x1a4/0x1b0()
[  141.727233] Hardware name: KVM
[  141.727597] Modules linked in: sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc crc32c_intel ghash_clmulni_intel microcode serio_raw e1000 virtio_balloon i2c_piix4 i2c_core floppy [last unloaded: scsi_wait_scan]
[  141.731149] Pid: 2659, comm: offV2.sh Not tainted 3.4.0-rc6+ #239
[  141.731853] Call Trace:
[  141.732166]  [<ffffffff81057bcf>] warn_slowpath_common+0x7f/0xc0
[  141.732866]  [<ffffffff81057c2a>] warn_slowpath_null+0x1a/0x20
[  141.733584]  [<ffffffff8108c3f4>] build_sched_domain+0x1a4/0x1b0
[  141.734317]  [<ffffffff810bbe9d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[  141.735102]  [<ffffffff810bbf3d>] ? trace_hardirqs_on+0xd/0x10
[  141.735775]  [<ffffffff810bbb2d>] ? mark_held_locks+0x7d/0x120
[  141.736496]  [<ffffffff81093713>] ? build_sched_domains+0x323/0x8f0
[  141.737249]  [<ffffffff81186618>] ? kmem_cache_alloc_trace+0x48/0x140
[  141.737978]  [<ffffffff810937b7>] build_sched_domains+0x3c7/0x8f0
[  141.738728]  [<ffffffff810945ab>] partition_sched_domains+0x2cb/0x4d0
[  141.739494]  [<ffffffff81094403>] ? partition_sched_domains+0x123/0x4d0
[  141.740287]  [<ffffffff810daca7>] cpuset_update_active_cpus+0x87/0x90
[  141.741042]  [<ffffffff8108c035>] cpuset_cpu_active+0x25/0x30
[  141.741711]  [<ffffffff815b598c>] notifier_call_chain+0x5c/0x120
[  141.742445]  [<ffffffff81085c4e>] __raw_notifier_call_chain+0xe/0x10
[  141.743197]  [<ffffffff8105a3b0>] __cpu_notify+0x20/0x40
[  141.743806]  [<ffffffff815a9cdd>] _cpu_up+0xc7/0x10e
[  141.744421]  [<ffffffff815a9d70>] cpu_up+0x4c/0x5c
[  141.744974]  [<ffffffff8159b96c>] store_online+0x9c/0xd0
[  141.745631]  [<ffffffff813aa590>] dev_attr_store+0x20/0x30
[  141.746306]  [<ffffffff812147a6>] sysfs_write_file+0xe6/0x170
[  141.746964]  [<ffffffff8119bfc8>] vfs_write+0xc8/0x190
[  141.747600]  [<ffffffff8119c191>] sys_write+0x51/0x90
[  141.748214]  [<ffffffff815ba469>] system_call_fastpath+0x16/0x1b
[  141.748926] ---[ end trace 09ac555cab7508f1 ]---
[  141.749516] sched: Bonkers domain doesn't include its own cpu: 3 0-1,3
[  141.750298] sched: Bonkers domain doesn't include its own cpu: 3 0-1
[  141.751039] ------------[ cut here ]------------
[  141.751594] WARNING: at kernel/sched/core.c:6468 build_sched_domain+0x1a4/0x1b0()
[  141.752473] Hardware name: KVM
[  141.752829] Modules linked in: sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc crc32c_intel ghash_clmulni_intel microcode serio_raw e1000 virtio_balloon i2c_piix4 i2c_core floppy [last unloaded: scsi_wait_scan]
[  141.756387] Pid: 2659, comm: offV2.sh Tainted: G        W    3.4.0-rc6+ #239
[  141.757231] Call Trace:
[  141.757533]  [<ffffffff81057bcf>] warn_slowpath_common+0x7f/0xc0
[  141.758251]  [<ffffffff81057c2a>] warn_slowpath_null+0x1a/0x20
[  141.758912]  [<ffffffff8108c3f4>] build_sched_domain+0x1a4/0x1b0
[  141.759640]  [<ffffffff810bbe9d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[  141.760446]  [<ffffffff810bbf3d>] ? trace_hardirqs_on+0xd/0x10
[  141.761133]  [<ffffffff810bbb2d>] ? mark_held_locks+0x7d/0x120
[  141.761820]  [<ffffffff81093713>] ? build_sched_domains+0x323/0x8f0
[  141.762590]  [<ffffffff81186618>] ? kmem_cache_alloc_trace+0x48/0x140
[  141.763368]  [<ffffffff810937b7>] build_sched_domains+0x3c7/0x8f0
[  141.764077]  [<ffffffff810945ab>] partition_sched_domains+0x2cb/0x4d0
[  141.764829]  [<ffffffff81094403>] ? partition_sched_domains+0x123/0x4d0
[  141.765631]  [<ffffffff810daca7>] cpuset_update_active_cpus+0x87/0x90
[  141.766399]  [<ffffffff8108c035>] cpuset_cpu_active+0x25/0x30
[  141.767074]  [<ffffffff815b598c>] notifier_call_chain+0x5c/0x120
[  141.767780]  [<ffffffff81085c4e>] __raw_notifier_call_chain+0xe/0x10
[  141.768549]  [<ffffffff8105a3b0>] __cpu_notify+0x20/0x40
[  141.769177]  [<ffffffff815a9cdd>] _cpu_up+0xc7/0x10e
[  141.769756]  [<ffffffff815a9d70>] cpu_up+0x4c/0x5c
[  141.770349]  [<ffffffff8159b96c>] store_online+0x9c/0xd0
[  141.770971]  [<ffffffff813aa590>] dev_attr_store+0x20/0x30
[  141.771632]  [<ffffffff812147a6>] sysfs_write_file+0xe6/0x170
[  141.772327]  [<ffffffff8119bfc8>] vfs_write+0xc8/0x190
[  141.772916]  [<ffffffff8119c191>] sys_write+0x51/0x90
[  141.773530]  [<ffffffff815ba469>] system_call_fastpath+0x16/0x1b
[  141.774251] ---[ end trace 09ac555cab7508f2 ]---
[  141.775040] sched: Topology is hosed for CPU-3!!
[  141.775596] sched: domain: NODE 0-1
[  141.776004] sched:  group: 0-1
[  141.776411] ------------[ cut here ]------------
[  141.776940] kernel BUG at kernel/sched/core.c:6088!
[  141.777394] invalid opcode: 0000 [#1] SMP 
[  141.777394] Dumping ftrace buffer:
[  141.777394]    (ftrace buffer empty)
[  141.777394] CPU 0 
[  141.777394] Modules linked in: sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc crc32c_intel ghash_clmulni_intel microcode serio_raw e1000 virtio_balloon i2c_piix4 i2c_core floppy [last unloaded: scsi_wait_scan]
[  141.777394] 
[  141.777394] Pid: 2659, comm: offV2.sh Tainted: G        W    3.4.0-rc6+ #239 Red Hat KVM
[  141.777394] RIP: 0010:[<ffffffff8108e115>]  [<ffffffff8108e115>] build_overlap_sched_groups+0x2e5/0x320
[  141.777394] RSP: 0018:ffff880037b21a88  EFLAGS: 00010246
[  141.777394] RAX: 0000000000000028 RBX: ffff880037b21ac8 RCX: 0000000043d543d4
[  141.777394] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
[  141.777394] RBP: ffff880037b21c08 R08: 0000000000000002 R09: 0000000000000000
[  141.777394] R10: 0720072007200720 R11: 0000000000000001 R12: ffff88007b21c700
[  141.777394] R13: ffff88007b21c718 R14: ffff88007b21c700 R15: 0000000000000001
[  141.777394] FS:  00007fe4009f3700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  141.777394] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  141.777394] CR2: 00007f03a8708580 CR3: 000000007a48e000 CR4: 00000000000007f0
[  141.777394] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.777394] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.777394] Process offV2.sh (pid: 2659, threadinfo ffff880037b20000, task ffff88007ac78000)
[  141.777394] Stack:
[  141.777394]  ffff88007a979c00 0000000000000003 0000000381a33300 0000000000010468
[  141.777394]  ffffffff81a332e8 0000000000000000 ffff88007b21c700 ffff88007a979d20
[  141.777394]  ffff003300312d30 ffffffff810bbe9d ffffffff81a45d20 0000000000000246
[  141.777394] Call Trace:
[  141.777394]  [<ffffffff810bbe9d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[  141.777394]  [<ffffffff810bbf3d>] ? trace_hardirqs_on+0xd/0x10
[  141.777394]  [<ffffffff810bbb2d>] ? mark_held_locks+0x7d/0x120
[  141.777394]  [<ffffffff81093713>] ? build_sched_domains+0x323/0x8f0
[  141.777394]  [<ffffffff81186618>] ? kmem_cache_alloc_trace+0x48/0x140
[  141.777394]  [<ffffffff81093864>] build_sched_domains+0x474/0x8f0
[  141.777394]  [<ffffffff810945ab>] partition_sched_domains+0x2cb/0x4d0
[  141.777394]  [<ffffffff81094403>] ? partition_sched_domains+0x123/0x4d0
[  141.777394]  [<ffffffff810daca7>] cpuset_update_active_cpus+0x87/0x90
[  141.777394]  [<ffffffff8108c035>] cpuset_cpu_active+0x25/0x30
[  141.777394]  [<ffffffff815b598c>] notifier_call_chain+0x5c/0x120
[  141.777394]  [<ffffffff81085c4e>] __raw_notifier_call_chain+0xe/0x10
[  141.777394]  [<ffffffff8105a3b0>] __cpu_notify+0x20/0x40
[  141.777394]  [<ffffffff815a9cdd>] _cpu_up+0xc7/0x10e
[  141.777394]  [<ffffffff815a9d70>] cpu_up+0x4c/0x5c
[  141.777394]  [<ffffffff8159b96c>] store_online+0x9c/0xd0
[  141.777394]  [<ffffffff813aa590>] dev_attr_store+0x20/0x30
[  141.777394]  [<ffffffff812147a6>] sysfs_write_file+0xe6/0x170
[  141.777394]  [<ffffffff8119bfc8>] vfs_write+0xc8/0x190
[  141.777394]  [<ffffffff8119c191>] sys_write+0x51/0x90
[  141.777394]  [<ffffffff815ba469>] system_call_fastpath+0x16/0x1b
[  141.777394] Code: 89 df e8 7f e2 26 00 48 8b 95 80 fe ff ff 31 c0 48 c7 c7 9f 5b 79 81 48 8b b2 00 01 00 00 48 89 da e8 ea fb 51 00 4d 85 f6 75 04 <0f> 0b eb fe 4d 89 f4 49 8d 54 24 18 b9 00 01 00 00 be 00 01 00 
[  141.777394] RIP  [<ffffffff8108e115>] build_overlap_sched_groups+0x2e5/0x320
[  141.777394]  RSP <ffff880037b21a88>
[  141.816980] ---[ end trace 09ac555cab7508f3 ]---
[  141.817563] Kernel panic - not syncing: Fatal exception


