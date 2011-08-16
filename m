Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1HPRw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab1HPRw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:52:56 -0400
Date: Tue, 16 Aug 2011 12:48:09 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Oops in minixfs_statfs
Message-ID: <20110816164809.GE2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a bug open in Fedora for a while[1] where it's fairly easy to
generate an oops on a MinixV3 filesystem.  I've looked at it a bit and
it seems we're getting a negative number in this particular calculation
in fs/minix/bitmap.c, count_free:

	i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;

which causes the loop below it to access bh->b_data outside it's bounds.

I installed minix 3.1.8 (shoot me now) in a KVM guest today, and two out
of the three filesystems work fine.  / and /home are both relatively
small, and a df seems to return fairly accurate numbers.  However, a df
on /usr (which is ~768M) causes the oops.

I'm not familiar enough with minixfs to know what the above is trying to
actually accomplish.  I instrumented that function a bit and here is
some data from the 3 filesytems in question:

[   49.114984] imap_blocks 2 zmap_blocks 1 firstdatazone 205
log_zone_size 0 max_size 7fffffff magic 4d5a nzones 4000 blocksize: 1000

[   66.380824] imap_blocks 2 zmap_blocks 2 firstdatazone 2a2
log_zone_size 0 max_size 7fffffff magic 4d5a nzones a700 blocksize: 1000

[  516.859103] imap_blocks 7 zmap_blocks 7 firstdatazone c11
log_zone_size 0 max_size 7fffffff magic 4d5a nzones 3001c blocksize:
1000

The calculation of i on line 38 results in fffffe80 for the last
filesytem when minix_count_free_blocks is called for it.

Does anyone have an idea of what that particular section is trying to
count?  (As an aside, the numbits variable is slightly confusing because
it seems to be a number of blocks, not bits).  I'd be happy to continue
to poke at this, but I'm a bit stumped at the moment.

Oops output below.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=635266 (which is also
https://bugzilla.kernel.org/show_bug.cgi?id=18792)

[  518.991374] BUG: unable to handle kernel paging request at ffff88002fffd000
[  518.991379] IP: [<ffffffffa015c116>] count_free+0x116/0x1d4 [minix]
[  518.991385] PGD 1a06063 PUD 1a0a063 PMD 2fffa067 PTE 0
[  518.991389] Oops: 0000 [#1] SMP 
[  518.991396] CPU 0 
[  518.991397] Modules linked in: minix bnep bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables joydev microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer virtio_net virtio_balloon i2c_piix4 snd soundcore snd_page_alloc i2c_core uinput virtio_blk [last unloaded: minix]
[  518.991419] 
[  518.991421] Pid: 1140, comm: df Not tainted 3.1.0-0.rc2.git0.1.1.fc17.x86_64 #1 Bochs Bochs
[  518.991423] RIP: 0010:[<ffffffffa015c116>]  [<ffffffffa015c116>] count_free+0x116/0x1d4 [minix]
[  518.991427] RSP: 0018:ffff88001b6dfdd8  EFLAGS: 00010282
[  518.991428] RAX: 0000000015dc0000 RBX: 0000000083643b08 RCX: 0000000000000000
[  518.991430] RDX: ffff88001a23d000 RSI: 0000000000000001 RDI: 0000000000000202
[  518.991431] RBP: ffff88001b6dfe08 R08: 0000000000000002 R09: 0000000000000000
[  518.991432] R10: 0000ffff00066c0a R11: 0000000000000000 R12: ffff880011a1f870
[  518.991434] R13: 000000000002f40a R14: 00000000fffffe80 R15: 0000000000000006
[  518.991438] FS:  00007fd795a39720(0000) GS:ffff88002ee00000(0000) knlGS:0000000000000000
[  518.991439] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  518.991441] CR2: ffff88002fffd000 CR3: 0000000012323000 CR4: 00000000000006f0
[  518.991447] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  518.991450] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  518.991452] Process df (pid: 1140, threadinfo ffff88001b6de000, task ffff88001c6c0000)
[  518.991453] Stack:
[  518.991454]  0000000000000000 ffff880015f14390 ffff880015f14390 0000000000800017
[  518.991458]  0000000000000000 0000000000000000 ffff88001b6dfe28 ffffffffa015c391
[  518.991461]  0000000000000000 ffff88001b6dfef0 ffff88001b6dfe58 ffffffffa015e4c0
[  518.991464] Call Trace:
[  518.991467]  [<ffffffffa015c391>] minix_count_free_blocks+0x25/0x30 [minix]
[  518.991470]  [<ffffffffa015e4c0>] minix_statfs+0x58/0xaf [minix]
[  518.991486]  [<ffffffff8116862e>] statfs_by_dentry+0x56/0x6e
[  518.991489]  [<ffffffff81168661>] vfs_statfs+0x1b/0x94
[  518.991491]  [<ffffffff81168711>] user_statfs+0x37/0x4d
[  518.991494]  [<ffffffff8116878d>] sys_statfs+0x20/0x3f
[  518.991506]  [<ffffffff814f9419>] ? retint_swapgs+0x13/0x1b
[  518.991509]  [<ffffffff814ffdc2>] system_call_fastpath+0x16/0x1b
[  518.991510] Code: 16 a0 4a 8d 04 c5 00 00 00 00 49 0f af c7 49 29 c6 31 c0 49 c1 ee 04 45 01 f6 44 89 f1 e8 cb 20 39 e1 31 c0 eb 25 49 8b 54 24 28 <8a> 14 02 48 ff c0 48 89 d1 c0 fa 04 83 e1 0f 83 e2 0f 03 1c 8d 
[  518.991536] RIP  [<ffffffffa015c116>] count_free+0x116/0x1d4 [minix]
[  518.991539]  RSP <ffff88001b6dfdd8>
[  518.991540] CR2: ffff88002fffd000
[  518.991542] ---[ end trace 323fbee5fddba095 ]---
[  518.991548] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[  518.991549] in_atomic(): 0, irqs_disabled(): 1, pid: 1140, name: df
[  518.991551] INFO: lockdep is turned off.
[  518.991552] irq event stamp: 10574
[  518.991553] hardirqs last  enabled at (10573): [<ffffffff814f9434>] restore_args+0x0/0x30
[  518.991556] hardirqs last disabled at (10574): [<ffffffff814f98f6>] error_sti+0x5/0x6
[  518.991559] softirqs last  enabled at (10572): [<ffffffff81062c90>] __do_softirq+0x200/0x25a
[  518.991568] softirqs last disabled at (10557): [<ffffffff815020bc>] call_softirq+0x1c/0x30
[  518.991572] Pid: 1140, comm: df Tainted: G      D     3.1.0-0.rc2.git0.1.1.fc17.x86_64 #1
[  518.991573] Call Trace:
[  518.991580]  [<ffffffff8108dbd8>] ? print_irqtrace_events+0x9e/0xa2
[  518.991591]  [<ffffffff8104f7a6>] __might_sleep+0x103/0x108
[  518.991594]  [<ffffffff814f7bd4>] down_read+0x26/0x84
[  518.991599]  [<ffffffff8107dde3>] ? hrtimer_try_to_cancel+0x81/0x8f
[  518.991605]  [<ffffffff810a14ff>] acct_collect+0x4d/0x188
[  518.991608]  [<ffffffff81060062>] do_exit+0x223/0x831
[  518.991611]  [<ffffffff8105de56>] ? kmsg_dump+0x131/0x14f
[  518.991613]  [<ffffffff8105ddae>] ? kmsg_dump+0x89/0x14f
[  518.991615]  [<ffffffff814fa341>] oops_end+0xbc/0xc5
[  518.991619]  [<ffffffff814ed939>] no_context+0x208/0x217
[  518.991622]  [<ffffffff814edb18>] __bad_area_nosemaphore+0x1d0/0x1f1
[  518.991625]  [<ffffffff814f9013>] ? _raw_spin_unlock+0x28/0x3b
[  518.991627]  [<ffffffff814ed1aa>] ? pte_offset_kernel+0x19/0x3f
[  518.991629]  [<ffffffff814edb4c>] bad_area_nosemaphore+0x13/0x15
[  518.991631]  [<ffffffff814fc458>] do_page_fault+0x1b1/0x3a2
[  518.991633]  [<ffffffff8108b85d>] ? trace_hardirqs_off+0xd/0xf
[  518.991636]  [<ffffffff814f8fc8>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[  518.991638]  [<ffffffff8105cf16>] ? console_unlock+0x203/0x212
[  518.991640]  [<ffffffff8108b7f3>] ? trace_hardirqs_off_caller+0x33/0x90
[  518.991647]  [<ffffffff81252f2d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  518.991650]  [<ffffffff814f96b5>] page_fault+0x25/0x30
[  518.991653]  [<ffffffffa015c116>] ? count_free+0x116/0x1d4 [minix]
[  518.991657]  [<ffffffffa015c10d>] ? count_free+0x10d/0x1d4 [minix]
[  518.991659]  [<ffffffffa015c391>] minix_count_free_blocks+0x25/0x30 [minix]
[  518.991662]  [<ffffffffa015e4c0>] minix_statfs+0x58/0xaf [minix]
[  518.991664]  [<ffffffff8116862e>] statfs_by_dentry+0x56/0x6e
[  518.991667]  [<ffffffff81168661>] vfs_statfs+0x1b/0x94
[  518.991669]  [<ffffffff81168711>] user_statfs+0x37/0x4d
[  518.991671]  [<ffffffff8116878d>] sys_statfs+0x20/0x3f
[  518.991674]  [<ffffffff814f9419>] ? retint_swapgs+0x13/0x1b
[  518.991676]  [<ffffffff814ffdc2>] system_call_fastpath+0x16/0x1b

