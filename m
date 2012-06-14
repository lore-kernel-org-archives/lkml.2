Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2FNUTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:19:01 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53391 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2FNUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:18:59 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: Release netlink socket properly
Date: Thu, 14 Jun 2012 13:18:56 -0700
Message-Id: <1339705136-12503-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the gdm72xx driver to properly release a netlink
socket using netlink_kernel_release. It fixes the following kernel
crash, which occurs after repeatedly suspending and resuming a system.

   kernel BUG at /home/benchan/trunk/src/third_party/kernel/files/mm/slub.c:3471!
   invalid opcode: 0000 [#1] SMP
   CPU 2
   Modules linked in: asix usbnet snd_hda_codec_hdmi
   snd_hda_codec_cirrus i2c_dev uinput snd_hda_intel snd_hda_codec
   snd_hwdep snd_pcm snd_timer bluetooth snd_page_alloc fuse aesni_intel
   cryptd isl29018(C) aes_x86_64 industrialio(C) memconsole nm10_gpio
   rtc_cmos nf_conntrack_ipv6 nf_defrag_ipv6 r8169 ath9k mac80211
   ip6table_filter ath9k_common ath9k_hw ath cfg80211 xt_mark ip6_tables
   uvcvideo videobuf2_core videodev videobuf2_vmalloc videobuf2_memops
   gdmwm(C) joydev

   Pid: 3125, comm: kworker/u:30 Tainted: G        WC   3.4.0 #1
   RIP: 0010:[<ffffffff810cda19>]  [<ffffffff810cda19>] kfree+0x67/0xca
   RSP: 0018:ffff880134977d60  EFLAGS: 00010246
   RAX: 4000000000000400 RBX: ffffffff818832a0 RCX: 0000000000000000
   RDX: 4000000000000000 RSI: 0000000000000000 RDI: ffffffff818832a0
   RBP: ffff880134977d80 R08: 00000000ffffffff R09: ffffea00000620c0
   R10: ffffffff8111b729 R11: ffff880149fb3840 R12: ffffffff81a08840
   R13: ffffffff813f5bc3 R14: ffffffff8138ed84 R15: 0000000000000000
   FS:  0000000000000000(0000) GS:ffff88014fb00000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
   CR2: 00007f7cad963110 CR3: 000000000180b000 CR4: 00000000000407e0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
   Process kworker/u:30 (pid: 3125, threadinfo ffff880134976000, task ffff8801330647e0)
   Stack:
    0000000000000002 ffffffff818832a0 ffffffff81a08840 ffff880134977df0
    ffff880134977da0 ffffffff813f5bc3 ffff880134977df0 ffffffff81883250
    ffff880134977dd0 ffffffff8138e64c 0000000180150010 ffffffff81883250
   Call Trace:
    [<ffffffff813f5bc3>] ipv4_sysctl_exit_net+0x23/0x27
    [<ffffffff8138e64c>] ops_exit_list+0x27/0x50
    [<ffffffff8138ee72>] cleanup_net+0xee/0x17c
    [<ffffffff81040c64>] process_one_work+0x199/0x2b8
    [<ffffffff810416e4>] worker_thread+0x13c/0x222
    [<ffffffff810415a8>] ? manage_workers.isra.26+0x171/0x171
    [<ffffffff8104506d>] kthread+0x8b/0x93
    [<ffffffff8145b414>] kernel_thread_helper+0x4/0x10
    [<ffffffff81044fe2>] ? __init_kthread_worker+0x39/0x39
    [<ffffffff8145b410>] ? gs_change+0xb/0xb
   Code: 83 c4 10 49 83 3c 24 00 eb e4 48 83 fb 10 76 76 48 89 df e8 17
   e1 ff ff 49 89 c1 48 8b 00 a8 80 75 15 49 f7 01 00 c0 00 00 75 02
   <0f> 0b 4c 89 cf e8 b8 b4 fd ff eb 4f 4c 8b 55 08 49 8b 79 30 48
   RIP  [<ffffffff810cda19>] kfree+0x67/0xca
    RSP <ffff880134977d60>

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/netlink_k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 1c74b08..9fa432d 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -103,7 +103,7 @@ struct sock *netlink_init(int unit, void (*cb)(struct net_device *dev, u16 type,
 
 void netlink_exit(struct sock *sock)
 {
-	sock_release(sock->sk_socket);
+	netlink_kernel_release(sock);
 }
 
 int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
-- 
1.7.7.3

