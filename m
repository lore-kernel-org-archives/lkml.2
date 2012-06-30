Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2F3T4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:56:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45176 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2F3T4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:56:11 -0400
Date: Sat, 30 Jun 2012 12:55:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Zdenek Kabelac <zkabelac@redhat.com>
cc: LVM general discussion and development <linux-lvm@redhat.com>,
        amwang@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression with FALLOC_FL_PUNCH_HOLE in 3.5-rc kernel
In-Reply-To: <4FEEE5E5.5060800@redhat.com>
Message-ID: <alpine.LSU.2.00.1206301217590.1728@eggly.anvils>
References: <4FEEE5E5.5060800@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012, Zdenek Kabelac wrote:
> 
> When I've used 3.5-rc kernels - I've noticed kernel deadlocks.
> Ooops log included. After some experimenting - reliable way to hit this oops
> is to run lvm test suite for 10 minutes. Since 3.5 merge window does not
> included anything related to this oops I've went for bisect.

Thanks a lot for reporting, and going to such effort to find
a reproducible testcase that you could bisect on.

> 
> Game result is commit: 3f31d07571eeea18a7d34db9af21d2285b807a17
> 
> mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE

But this leaves me very puzzled.

Is the "lvm test suite" what I find at git.fedorahosted.org/git/lvm2.git
under tests/ ?

I see no mention of madvise or MADV_REMOVE or fallocate or anything
related in that git tree.

If you have something else running at the same time, which happens to use
madvise(,,MADV_REMOVE) on a filesystem which the commit above now enables
it on (I guess ext4 from the =y in your config), then I suppose we should
start searching for improper memory freeing or scribbling in its holepunch
support: something that might be corrupting the dm_region in your oops.

I'll be surprised if that is the case, but it's something that you can
easily check by inserting a WARN_ON(1) in mm/madvise.c madvise_remove():
that should tell us what process is using it.

I'm not an LVM user, so I doubt I'll be able to reproduce your setup.

Any ideas from the DM guys?  Has anyone else seen anything like this?

Do all your oopses look like this one?

Thanks,
Hugh

> 
> My HW - t61, 4GB
> 
> Zdenek
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000178
> IP: [<ffffffffa031204d>] dm_rh_region_context+0xd/0x20 [dm_region_hash]
> PGD 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU 1
> Modules linked in: dm_raid raid456 async_raid6_recov async_memcpy async_pq
> async_xor xor async_tx raid6_pq raid1 md_mod reiserfs xfs dm_mirror
> dm_region_hash dm_log dm_snapshot ip6_tables ebtable_nat ebtables
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT iptable_mangle xt_tcpudp iptable_filter ip_tables
> x_tables bridge stp llc ipv6 snd_hda_codec_analog arc4 hid_generic iwl3945
> iwlegacy microcode psmouse serio_raw mac80211 i2c_i801 i2c_core snd_hda_intel
> snd_hda_codec cfg80211 lpc_ich mfd_core snd_pcm snd_page_alloc e1000e
> snd_timer wmi thinkpad_acpi nvram snd soundcore evdev usbhid hid binfmt_misc
> loop vhost_net tun kvm_intel nfsd kvm exportfs nfs_acl auth_rpcgss lockd
> sunrpc dm_mod autofs4 pcmcia sr_mod cdrom sdhci_pci sdhci mmc_core
> yenta_socket ehci_hcd uhci_hcd usbcore usb_common video backlight
> 
> Pid: 8691, comm: kworker/1:0 Not tainted 3.5.0-rc4-00006-g6fe139e #73 LENOVO
> 6464CTO/6464CTO
> RIP: 0010:[<ffffffffa031204d>]  [<ffffffffa031204d>]
> dm_rh_region_context+0xd/0x20 [dm_region_hash]
> RSP: 0018:ffff880126b77c68  EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff880121423450 RCX: 0000000000002607
> RDX: ffff880121676e40 RSI: 0000000000000000 RDI: ffff880121676e40
> RBP: ffff880126b77cb0 R08: 000060fec8800fe0 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff880121626400
> R13: ffff880121676e40 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff880137400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000178 CR3: 0000000134a40000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/1:0 (pid: 8691, threadinfo ffff880126b76000, task
> ffff8801344ca310)
> Stack:
>  ffffffffa0332ac3 ffff880126b77c80 0000000000000000 ffff880126b77cb0
>  ffff880121423450 ffff880121626400 ffffffffa0332a90 0000000000000000
>  0000000000000000 ffff880126b77d00 ffffffffa00eca04 ffff880126b77ce0
> Call Trace:
>  [<ffffffffa0332ac3>] ? recovery_complete+0x33/0x170 [dm_mirror]
>  [<ffffffffa0332a90>] ? recover+0x1a0/0x1a0 [dm_mirror]
>  [<ffffffffa00eca04>] run_complete_job+0x74/0xd0 [dm_mod]
>  [<ffffffffa00ed525>] process_jobs+0x95/0x120 [dm_mod]
>  [<ffffffffa00ec990>] ? wake+0x20/0x20 [dm_mod]
>  [<ffffffffa00ed5e9>] do_work+0x39/0x80 [dm_mod]
>  [<ffffffff81060065>] process_one_work+0x1a5/0x6b0
>  [<ffffffff8105ffff>] ? process_one_work+0x13f/0x6b0
>  [<ffffffff815299c9>] ? _raw_spin_lock_irq+0x19/0x80
>  [<ffffffffa00ed5b0>] ? process_jobs+0x120/0x120 [dm_mod]
>  [<ffffffff810608ee>] worker_thread+0x12e/0x2d0
>  [<ffffffff810607c0>] ? rescuer_thread+0x210/0x210
>  [<ffffffff81069cf2>] kthread+0xa2/0xb0
>  [<ffffffff81533334>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81076e3c>] ? finish_task_switch+0x7c/0x120
>  [<ffffffff8152a54b>] ? _raw_spin_unlock_irq+0x3b/0x60
>  [<ffffffff8152a85d>] ? retint_restore_args+0xe/0xe
>  [<ffffffff81069c50>] ? kthread_worker_fn+0x1a0/0x1a0
>  [<ffffffff81533330>] ? gs_change+0xb/0xb
> Code: 89 e5 66 66 66 66 90 48 8b 06 8b 4f 04 5d 48 2b 87 80 01 00 00 48 d3 e8
> c3 0f 1f 44 00 00 55 48 89 e5 66 66 66 66 90 48 8b 07 5d <48> 8b 80 78 01 00
> 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48
> RIP  [<ffffffffa031204d>] dm_rh_region_context+0xd/0x20 [dm_region_hash]
>  RSP <ffff880126b77c68>
> CR2: 0000000000000178
> 
> 
> # bad: [cfaf025112d3856637ff34a767ef785ef5cf2ca9] Linux 3.5-rc2
> # good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
> git bisect start 'v3.5-rc2' 'v3.4'
> # good: [3813d4024a75562baf77d3907fb6afbf8f9c8232] Merge tag 'ia64-3.5-merge'
> of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
> git bisect good 3813d4024a75562baf77d3907fb6afbf8f9c8232
> # good: [5723aa993d83803157c22327e90cd59e3dcbe879] x86: use the new generic
> strnlen_user() function
> git bisect good 5723aa993d83803157c22327e90cd59e3dcbe879
> # bad: [a70f35af4e49f87ba4b6c4b30220fbb66cd74af6] Merge branch
> 'for-3.5/drivers' of git://git.kernel.dk/linux-block
> git bisect bad a70f35af4e49f87ba4b6c4b30220fbb66cd74af6
> # good: [53f2c4a8fd882009a2a75c5b72d6898c0808616e] Merge tag 'nfs-for-3.5-1'
> of git://git.linux-nfs.org/projects/trondmy/linux-nfs
> git bisect good 53f2c4a8fd882009a2a75c5b72d6898c0808616e
> # bad: [227d1e4319ffd8729781941d92f4ae4d85beecd9] Merge branch 'for-linus' of
> git://git.linaro.org/people/rmk/linux-arm
> git bisect bad 227d1e4319ffd8729781941d92f4ae4d85beecd9
> # bad: [be9cd873e2a706a688e37224d48e135efd8c0d26] mm/buddy: dump
> PG_compound_lock page flag
> git bisect bad be9cd873e2a706a688e37224d48e135efd8c0d26
> # good: [1cb3642a68c983ada0f4090a4dac1d70a96126ca] mfd: mc13xxx core should
> not be user visible
> git bisect good 1cb3642a68c983ada0f4090a4dac1d70a96126ca
> # good: [bde8bd8a1d5242589ddcaef8e017b48b207c4729] mm/vmstat.c: remove debug
> fs entries on failure of file creation and made extfrag_debug_root dentry
> local
> git bisect good bde8bd8a1d5242589ddcaef8e017b48b207c4729
> # good: [549381e19cc7874bb15f0e4760c1004d4fe28d8a] mm: bootmem: remove
> redundant offset check when finally freeing bootmem
> git bisect good 549381e19cc7874bb15f0e4760c1004d4fe28d8a
> # good: [bde05d1ccd512696b09db9dd2e5f33ad19152605] shmem: replace page if
> mapping excludes its zone
> git bisect good bde05d1ccd512696b09db9dd2e5f33ad19152605
> # bad: [17cf28afea2a1112f240a3a2da8af883be024811] mm/fs: remove
> truncate_range
> git bisect bad 17cf28afea2a1112f240a3a2da8af883be024811
> # good: [ec9516fbc5fa814014991e1ae7f8860127122105] tmpfs: optimize clearing
> when writing
> git bisect good ec9516fbc5fa814014991e1ae7f8860127122105
