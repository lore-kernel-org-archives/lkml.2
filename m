Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1AGKSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:18:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54444 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1AGKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:18:42 -0500
Message-ID: <4D26E82D.1060204@oracle.com>
Date: Fri, 07 Jan 2011 18:17:17 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: jeremy@goop.org, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, xen-devel@lists.xensource.com,
        gurudas.pai@oracle.com, guru.anbalagane@oracle.com,
        greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch] xenfb: fix xenfb suspend/resume race.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when do migration test, we hit the panic as below:

<1>BUG: unable to handle kernel paging request at 0000000b819fdb98
<1>IP: [<ffffffff812a588f>] notify_remote_via_irq+0x13/0x34
<4>PGD 94b10067 PUD 0
<0>Oops: 0000 [#1] SMP
<0>last sysfs file: /sys/class/misc/autofs/dev
<4>CPU 3
<4>Modules linked in: autofs4(U) hidp(U) nfs(U) fscache(U) nfs_acl(U)
auth_rpcgss(U) rfcomm(U) l2cap(U) bluetooth(U) rfkill(U) lockd(U) sunrpc(U)
nf_conntrack_netbios_ns(U) ipt_REJECT(U) nf_conntrack_ipv4(U)
nf_defrag_ipv4(U) xt_state(U) nf_conntrack(U) iptable_filter(U) ip_tables(U)
ip6t_REJECT(U) xt_tcpudp(U) ip6table_filter(U) ip6_tables(U) x_tables(U)
ipv6(U) parport_pc(U) lp(U) parport(U) snd_seq_dummy(U) snd_seq_oss(U)
snd_seq_midi_event(U) snd_seq(U) snd_seq_device(U) snd_pcm_oss(U)
snd_mixer_oss(U) snd_pcm(U) snd_timer(U) snd(U) soundcore(U)
snd_page_alloc(U) joydev(U) xen_netfront(U) pcspkr(U) xen_blkfront(U)
uhci_hcd(U) ohci_hcd(U) ehci_hcd(U)
Pid: 18, comm: events/3 Not tainted 2.6.32
RIP: e030:[<ffffffff812a588f>]  [<ffffffff812a588f>]
ify_remote_via_irq+0x13/0x34
RSP: e02b:ffff8800e7bf7bd0  EFLAGS: 00010202
RAX: ffff8800e61c8000 RBX: ffff8800e62f82c0 RCX: 0000000000000000
RDX: 00000000000001e3 RSI: ffff8800e7bf7c68 RDI: 0000000bfffffff4
RBP: ffff8800e7bf7be0 R08: 00000000000001e2 R09: ffff8800e62f82c0
R10: 0000000000000001 R11: ffff8800e6386110 R12: 0000000000000000
R13: 0000000000000007 R14: ffff8800e62f82e0 R15: 0000000000000240
FS:  00007f409d3906e0(0000) GS:ffff8800028b8000(0000)
GS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000b819fdb98 CR3: 000000003ee3b000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/3 (pid: 18, threadinfo ffff8800e7bf6000, task
f8800e7bf4540)
Stack:
 0000000000000200 ffff8800e61c8000 ffff8800e7bf7c00 ffffffff812712c9
<0> ffffffff8100ea5f ffffffff81438d80 ffff8800e7bf7cd0 ffffffff812714ee
<0> 0000000000000000 ffffffff81270568 000000000000e030 0000000000010202
Call Trace:
 [<ffffffff812712c9>] xenfb_send_event+0x5c/0x5e
 [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
 [<ffffffff812714ee>] xenfb_refresh+0x1b1/0x1d7
 [<ffffffff81270568>] ? sys_imageblit+0x1ac/0x458
 [<ffffffff81271786>] xenfb_imageblit+0x2f/0x34
 [<ffffffff8126a3e5>] soft_cursor+0x1b5/0x1c8
 [<ffffffff8126a137>] bit_cursor+0x4b6/0x4d7
 [<ffffffff8100ea5f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
 [<ffffffff81269c81>] ? bit_cursor+0x0/0x4d7
 [<ffffffff812656b7>] fb_flashcursor+0xff/0x111
 [<ffffffff812655b8>] ? fb_flashcursor+0x0/0x111
 [<ffffffff81071812>] worker_thread+0x14d/0x1ed
 [<ffffffff81075a8c>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff81438d80>] ? _spin_unlock_irqrestore+0x16/0x18
 [<ffffffff810716c5>] ? worker_thread+0x0/0x1ed
 [<ffffffff810756e3>] kthread+0x6e/0x76
 [<ffffffff81012dea>] child_rip+0xa/0x20
 [<ffffffff81011fd1>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8101275d>] ? retint_restore_args+0x5/0x6
 [<ffffffff81012de0>] ? child_rip+0x0/0x20
Code: 6b ff 0c 8b 87 a4 db 9f 81 66 85 c0 74 08 0f b7 f8 e8 3b ff ff ff c9
c3 55 48 89 e5 48 83 ec 10 0f 1f 44 00 00 89 ff 48 6b ff 0c <8b> 87 a4 db 9f
81 66 85 c0 74 14 48 8d 75 f0 0f b7 c0 bf 04 00
RIP  [<ffffffff812a588f>] notify_remote_via_irq+0x13/0x34
 RSP <ffff8800e7bf7bd0>
CR2: 0000000b819fdb98
---[ end trace 098b4b74827595d0 ]---

The root cause of race between the resume and reconnecting to the backend
Clear update_wanted flag of xenfb before disconnect backend would fix this issue.
Also below patch will fixed mem leak when connect to xenfb backend failed.


Signed-off-by: Joe Jin <joe.jin@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 xen-fbfront.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index dc72563..f2d9eb5 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -616,6 +616,8 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
 
 static void xenfb_disconnect_backend(struct xenfb_info *info)
 {
+	/* Prevent xenfb refresh */
+	info->update_wanted = 0;
 	if (info->irq >= 0)
 		unbind_from_irqhandler(info->irq, info);
 	info->irq = -1;
