Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab1GKSqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:46:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab1GKSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:46:23 -0400
From: Naohiro Aota <naota@elisp.net>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@tuxera.com>, Eric Sandeen <sandeen@redhat.com>,
        Naohiro Aota <naota@elisp.net>, Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] hfsplus: Add record offset check
Date: Tue, 12 Jul 2011 03:46:03 +0900
Message-ID: <87mxgku044.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I have general protection fault when I'm using hfsplus. This
fault seems to be caused by "record offset" which is larger than "node
size".

I've verified this with setting probe and look value of recoff using
perf like this:

perf probe -m hfsplus -a 'hfsplus_brec_keylen:13 recoff node->tree->node_size'

it printed following line showing recoff get larger than node_size

mplayer-18734 [003] 21506.855550: hfsplus_brec_keylen: (hfsplus_brec_keylen+0x5d/0xc0 [hfsplus]) recoff=3333 node_size=2000

Though this fault doesn't stop kernel entirely, it stop filesystem and
suspend to work (because user process is blocked and so it cannot
freeze any more), so it's really annoying.

>From 5278a51f2a140efcc63119cc4226735f79c1fce4 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naota@elisp.net>
Date: Tue, 12 Jul 2011 02:54:13 +0900
Subject: [PATCH] hfsplus: Add record offset check

Corrupted disk may return record offset which is larger than node size
and cause general protection fault like below:

	[162346.360154] general protection fault: 0000 [#1] SMP
	[162346.360178] CPU 3
	[162346.360182] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ip6table_filter ip6_tables iptable_filter ip_tables x_tables ipv6 kvm_intel kvm rtc hfsplus btrfs zlib_deflate zlib_inflate nouveau snd_hda_codec_hdmi arc4 brcmsmac(C) brcmutil(C) mac80211 snd_hda_codec_cirrus snd_hda_intel snd_hda_codec ttm drm_kms_helper drm snd_hwdep cfg80211 tg3 snd_pcm snd_timer snd usb_storage hid_apple i2c_algo_bit usbhid applesmc hwmon libphy uhci_hcd mxm_wmi uvcvideo rfkill wmi bcm5974 input_polldev intel_ips crc_ccitt soundcore snd_page_alloc sg apple_bl video battery ac button
	[162346.360331]
	[162346.360335] Pid: 11835, comm: mplayer Tainted: G         C  3.0.0-rc4 #37 Apple Inc. MacBookPro6,2/Mac-F22586C8
	[162346.360349] RIP: 0010:[<ffffffff8124c9f5>]  [<ffffffff8124c9f5>] memcpy+0x105/0x120
	[162346.360365] RSP: 0018:ffff880010b7f530  EFLAGS: 00010202
	[162346.360371] RAX: ffff880010b7f5b6 RBX: ffff880010b7f5b6 RCX: 0000000000000952
	[162346.360378] RDX: 0000000000000002 RSI: db73880000000952 RDI: ffff880010b7f5b6
	[162346.360385] RBP: ffff880010b7f598 R08: 0000000000000013 R09: 0000160000000000
	[162346.360478] R10: 6db6db6db6db6db7 R11: ffff880000000000 R12: 0000000000000002
	[162346.360485] R13: 0000000000000002 R14: 0000000000000002 R15: ffff88015083f600
	[162346.360493] FS:  00007f1a14ee5720(0000) GS:ffff88016bcc0000(0000) knlGS:0000000000000000
	[162346.360500] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[162346.360506] CR2: 0000000000561080 CR3: 0000000109731000 CR4: 00000000000006e0
	[162346.360513] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[162346.360520] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	[162346.360527] Process mplayer (pid: 11835, threadinfo ffff880010b7e000, task ffff880061cfaf70)
	[162346.360536] Stack:
	[162346.360542]  ffffffffa04608f6 ffff880010b7f5a8 ffff880000000000 6db6db6db6db6db7
	[162346.360563]  0000160000000000 0000000000000013 0000000000000000 0000000000000011
	[162346.360583]  ffff88015083f600 ffff88015083f600 ffff880010b7f918 0000000000000032
	[162346.360603] Call Trace:
	[162346.360617]  [<ffffffffa04608f6>] ? hfsplus_bnode_read+0xc6/0x170 [hfsplus]
	[162346.360633]  [<ffffffffa04609bd>] hfsplus_bnode_read_u16+0x1d/0x30 [hfsplus]
	[162346.360663]  [<ffffffffa0462999>] hfsplus_brec_keylen+0x69/0x90 [hfsplus]
	[162346.360672]  [<ffffffffa046329b>] __hplusfs_brec_find+0x6b/0x170 [hfsplus]
	[162346.360682]  [<ffffffffa0463476>] hfsplus_brec_find+0xd6/0x140 [hfsplus]
	[162346.360691]  [<ffffffffa0463507>] hfsplus_brec_read+0x27/0x70 [hfsplus]
	[162346.360700]  [<ffffffffa045e3f8>] hfsplus_find_cat+0x48/0xe0 [hfsplus]
	[162346.360710]  [<ffffffff810311e2>] ? __wake_up+0x32/0x70
	[162346.360717]  [<ffffffff810311e2>] ? __wake_up+0x32/0x70
	[162346.360724]  [<ffffffff81031203>] ? __wake_up+0x53/0x70
	[162346.360732]  [<ffffffff812412cd>] ? _atomic_dec_and_lock+0x4d/0x70
	[162346.360741]  [<ffffffffa0461f1b>] ? hfsplus_bnode_find+0x2b/0x300 [hfsplus]
	[162346.360750]  [<ffffffffa04631d8>] ? hfsplus_find_init+0x58/0x70 [hfsplus]
	[162346.360759]  [<ffffffffa04631d8>] ? hfsplus_find_init+0x58/0x70 [hfsplus]
	[162346.360769]  [<ffffffff814729fc>] ? mutex_lock_nested+0x24c/0x300
	[162346.360777]  [<ffffffffa04631d8>] ? hfsplus_find_init+0x58/0x70 [hfsplus]
	[162346.360786]  [<ffffffffa045a84e>] hfsplus_iget+0x10e/0x240 [hfsplus]
	[162346.360795]  [<ffffffff81472c1e>] ? mutex_unlock+0xe/0x10
	[162346.360803]  [<ffffffffa045fc34>] hfsplus_lookup+0x1f4/0x2e0 [hfsplus]
	[162346.360816]  [<ffffffff81150bb5>] ? __d_lookup+0xe5/0x1a0
	[162346.360824]  [<ffffffff811f2cea>] ? char2uni+0x1a/0x50
	[162346.360831]  [<ffffffff8114f961>] ? d_alloc+0x141/0x1e0
	[162346.360837]  [<ffffffff8114f961>] ? d_alloc+0x141/0x1e0
	[162346.360846]  [<ffffffff810793f3>] ? lockdep_init_map+0xa3/0x510
	[162346.360854]  [<ffffffff8114f9bb>] ? d_alloc+0x19b/0x1e0
	[162346.360861]  [<ffffffff8147437b>] ? _raw_spin_unlock+0x2b/0x40
	[162346.360869]  [<ffffffff81143495>] d_alloc_and_lookup+0x45/0x90
	[162346.360876]  [<ffffffff81150ca5>] ? d_lookup+0x35/0x60
	[162346.360883]  [<ffffffff81145b32>] do_lookup+0x2a2/0x320
	[162346.360890]  [<ffffffff81147408>] do_last+0x128/0x800
	[162346.361366]  [<ffffffff81147c60>] path_openat+0xd0/0x420
	[162346.361827]  [<ffffffff81102a2c>] ? might_fault+0x5c/0xb0
	[162346.362266]  [<ffffffff81102a2c>] ? might_fault+0x5c/0xb0
	[162346.362682]  [<ffffffff81147ff9>] do_filp_open+0x49/0xa0
	[162346.363075]  [<ffffffff8147437b>] ? _raw_spin_unlock+0x2b/0x40
	[162346.363444]  [<ffffffff81155284>] ? alloc_fd+0xf4/0x150
	[162346.363801]  [<ffffffff81137891>] do_sys_open+0x101/0x1d0
	[162346.364151]  [<ffffffff81137980>] sys_open+0x20/0x30
	[162346.364494]  [<ffffffff8147c62b>] system_call_fastpath+0x16/0x1b
	[162346.364828] Code: 84 00 00 00 00 00 48 83 fa 04 72 1a 8b 0e 44 8b 44 16 fc 89 0f 44 89 44 17 fc c3 66 66 2e 0f 1f 84 00 00 00 00 00 83 fa 00 74 10
	[162346.364896]  8a 06 44 88 07 48 ff c7 48 ff c6 ff ca 75 f0 c3 90 90 90 90
	[162346.365562] RIP  [<ffffffff8124c9f5>] memcpy+0x105/0x120
	[162346.365921]  RSP <ffff880010b7f530>
	[162346.377129] ---[ end trace 9e30a1640c65bf31 ]---

This patch add guard for this situation.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/hfsplus/brec.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
index 2312de3..5c51d04 100644
--- a/fs/hfsplus/brec.c
+++ b/fs/hfsplus/brec.c
@@ -43,6 +43,10 @@ u16 hfs_brec_keylen(struct hfs_bnode *node, u16 rec)
 			node->tree->node_size - (rec + 1) * 2);
 		if (!recoff)
 			return 0;
+		if (recoff >= node->tree->node_size) {
+			printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
+			return 0;
+		}
 
 		retval = hfs_bnode_read_u16(node, recoff) + 2;
 		if (retval > node->tree->max_key_len + 2) {
-- 
1.7.6

