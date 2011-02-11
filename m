Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab1BKFFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 00:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1BKFFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 00:05:51 -0500
Date: Fri, 11 Feb 2011 00:02:47 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>
Subject: BUG at fs/namei.c:405 (nameidata_drop_rcu)
Message-ID: <20110211000247.5e8fbed8@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently hit this very early in nameidata_drop_rcu():

        BUG_ON(!(nd->flags & LOOKUP_RCU));

The user reports he ran "fuser /var/cache/yum" while logged in to
an X session with his home directory mounted via NFS4. Home dirs
are normally automounted, but manually mounting the dir still
reproduces the problem.

kernel BUG at fs/namei.c:405!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 0 
Modules linked in: fuse nfs lockd fscache nfs_acl rpcsec_gss_krb5 auth_rpcgss
des_generic sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm serio_raw snd_timer snd e1000e iTCO_wdt soundcore
snd_page_alloc i2c_i801 microcode iTCO_vendor_support firewire_ohci
firewire_core pata_acpi crc_itu_t ata_generic i915 drm_kms_helper drm
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 2689, comm: fuser Not tainted 2.6.38-0.rc3.git4.1.fc15.x86_64 #1
DQ45CB/DQ45CB
RIP: 0010:[<ffffffff8112a1f8>]  [<ffffffff8112a1f8>]
nameidata_drop_rcu+0x2d/0xca
RSP: 0018:ffff880057e9fc78  EFLAGS: 00010246
RAX: ffff880070715c80 RBX: ffff880057e9fdd0 RCX: ffff880057cb0b40
RDX: 0000000000000000 RSI: 00000000f42f9d10 RDI: ffff880057e9fdd0
RBP: ffff880057e9fc98 R08: 0000000000000000 R09: 00000000000007ff
R10: 00000000000007ff R11: ffff880065c9f180 R12: ffff880070684300
R13: ffff880065c9f180 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe65d919720(0000) GS:ffff880079800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001ac74b8 CR3: 0000000071fc0000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fuser (pid: 2689, threadinfo ffff880057e9e000, task ffff880070715c80)
Stack:
 00000000000007ff ffff880065c9f180 ffff880057e9fdd0 ffff880057e9fd10
 ffff880057e9fcb8 ffffffff8112ae6a ffff880057e9fdd0 0000000000000000
 ffff880057e9fcf8 ffffffff8112b004 ffff880052b47a80 ffff880057e9fdd0
Call Trace:
 [<ffffffff8112ae6a>] force_reval_path.isra.24+0x39/0x5a
 [<ffffffff8112b004>] do_follow_link+0x179/0x1e8
 [<ffffffff8112b32b>] link_path_walk+0x2b8/0x430
 [<ffffffff8112b6ce>] do_path_lookup+0x4d/0xf6
 [<ffffffff8112c4d0>] user_path_at+0x57/0x94
 [<ffffffff8146f37c>] ? _cond_resched+0xe/0x22
 [<ffffffff81124a2f>] ? might_fault+0x21/0x23
 [<ffffffff81124b28>] ? cp_new_stat+0xf7/0x10d
 [<ffffffff81124d16>] vfs_fstatat+0x39/0x63
 [<ffffffff81124d7b>] vfs_stat+0x1b/0x1d
 [<ffffffff81124e7a>] sys_newstat+0x1a/0x33
 [<ffffffff8112985f>] ? path_put+0x1f/0x23
 [<ffffffff81009bc2>] system_call_fastpath+0x16/0x1b
Code: 89 e5 41 55 41 54 53 41 52 0f 1f 44 00 00 65 48 8b 04 25 c0 cc 00 00 f6
47 40 40 48 89 fb 4c 8b a0 20 05 00 00 4c 8b 6f 08 75 02 <0f> 0b 48 83 7f 20 00
74 20 49 8d 7c 24 04 e8 a5 66 34 00 49 8b 
