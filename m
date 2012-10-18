Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2JROrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:47:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35815 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2JROrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:47:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: pawel@osciak.com
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2] drivers/media/v4l2-core/videobuf2-core.c: fix error return code
Date: Thu, 18 Oct 2012 16:47:04 +0200
Message-Id: <1350571624-4666-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <5075AB4F.3030709@samsung.com>
References: <5075AB4F.3030709@samsung.com>
cc: kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a NULL pointer dereference bug at __vb2_init_fileio().
The NULL pointer deference happens at videobuf2-core.c:

static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
                loff_t *ppos, int nonblock, int read)
{
...
        if (!q->fileio) {
                ret = __vb2_init_fileio(q, read);
                dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
                if (ret)
                        return ret;
        }
        fileio = q->fileio; // NULL pointer deference here
...
}

It was tested with vivi driver and qv4l2 for selecting read() as capture method.
The OOPS happened when I've artificially forced the error by commenting the line:
	if (fileio->bufs[i].vaddr == NULL)

But it was fixed after applying this patch.

[ 9002.451154] BUG: unable to handle kernel NULL pointer dereference at 0000000000000370
[ 9002.451266] IP: [<ffffffffa038c429>] __vb2_perform_fileio+0x69/0x620 [videobuf2_core]
[ 9002.451365] PGD 1df491067 PUD 196d12067 PMD 0
[ 9002.451431] Oops: 0000 [#1] SMP
[ 9002.451481] Modules linked in: vivi(O) v4l2_common videobuf2_core(O) videobuf2_vmalloc(O) videobuf2_memops(O) videodev hidp fuse ebtable_nat ebtables snd_hda_codec_hdmi snd_hda_codec_realtek ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle lockd sunrpc bridge stp llc rfcomm bnep btusb bluetooth pl2303 ip6t_REJECT snd_usb_audio nf_conntrack_ipv6 nf_defrag_ipv6 snd_usbmidi_lib snd_rawmidi ip6table_filter nf_conntrack_ipv4 ip6_tables nf_defrag_ipv4 xt_state nf_conntrack be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp \
libiscsi scsi_transport_iscsi iTCO_wdt iTCO_vendor_support arc4 binfmt_misc media iwldvm mac80211 coretemp snd_hda_intel snd_hda_codec crc32c_intel snd_hwdep ghash_clmulni_intel snd_seq snd_seq_device microcode snd_pcm cdc_ncm usbnet mii cdc_wdm cdc_acm i915 snd_page_alloc i2c_algo_bit drm_kms_helper iwlwifi lpc_ich snd_timer sdhci_pci mfd_core drm toshiba_acpi sdhci snd sparse_keymap e1000e mmc_core cfg80211 i2c_core soundcore mei rfkill wmi video toshiba_bluetooth vhost_net tun macvtap macvlan kvm_intel kvm uinput [last unloaded: videobuf2_memops]
[ 9002.453105] CPU 1
[ 9002.453136] Pid: 13830, comm: qv4l2 Tainted: G           O 3.6.1-1.local.fc17.x86_64 #1 TOSHIBA PORTEGE R830/Portable PC
[ 9002.453251] RIP: 0010:[<ffffffffa038c429>]  [<ffffffffa038c429>] __vb2_perform_fileio+0x69/0x620 [videobuf2_core]
[ 9002.453368] RSP: 0018:ffff8801ed37fdf8  EFLAGS: 00010246
[ 9002.453427] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000011b55
[ 9002.453502] RDX: 0000000000011b54 RSI: ffff88024e256f68 RDI: ffff88023fdc9c00
[ 9002.453576] RBP: ffff8801ed37fe58 R08: 0000000000016aa0 R09: 0000000000000001
[ 9002.453651] R10: 0000000000000075 R11: 0000000000000800 R12: ffff8801bcde0580
[ 9002.453726] R13: ffff8801bcde0608 R14: 00000000000e1000 R15: 00000000024f0ee0
[ 9002.453801] FS:  00007f19308f17c0(0000) GS:ffff88024e240000(0000) knlGS:0000000000000000
[ 9002.453886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9002.453948] CR2: 0000000000000370 CR3: 00000001df7df000 CR4: 00000000000407e0
[ 9002.454023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9002.454098] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9002.454175] Process qv4l2 (pid: 13830, threadinfo ffff8801ed37e000, task ffff8801f24b9710)
[ 9002.454260] Stack:
[ 9002.454284]  0000000000000000 0000000000000000 0000000000000800 0000000000000001
[ 9002.454379]  ffff8801ed37ff50 0000000000000000 ffff88023d56c610 ffff8801bcde0108
[ 9002.454473]  ffff8801bcde0580 00000000000e1000 ffff8801ed37ff50 ffff88023d56c600
[ 9002.454566] Call Trace:
[ 9002.454604]  [<ffffffffa038cb54>] vb2_read+0x14/0x20 [videobuf2_core]
[ 9002.454676]  [<ffffffffa038cc07>] vb2_fop_read+0xa7/0x4a0 [videobuf2_core]
[ 9002.454757]  [<ffffffffa03dc5e0>] v4l2_read+0xf0/0x140 [videodev]
[ 9002.454853]  [<ffffffff8118e911>] ? rw_verify_area+0x61/0xf0
[ 9002.454918]  [<ffffffff8118eda9>] vfs_read+0xa9/0x180
[ 9002.454976]  [<ffffffff8118eeca>] sys_read+0x4a/0x90
[ 9002.455035]  [<ffffffff816226e9>] system_call_fastpath+0x16/0x1b
[ 9002.455100] Code: 4d 85 ff 48 c7 c0 ea ff ff ff 0f 84 b1 00 00 00 49 8b 9d f8 01 00 00 48 85 db 0f 84 32 04 00 00 49 c7 85 f8 01 00 00 00 00 00 00 <8b> 83 70 03 00 00 4c 63 c0 89 45 cc 4b 8d 04 40 4c 8d 64 c3 70
[ 9002.455605] RIP  [<ffffffffa038c429>] __vb2_perform_fileio+0x69/0x620 [videobuf2_core]
[ 9002.455697]  RSP <ffff8801ed37fdf8>
[ 9002.455746] CR2: 0000000000000370
[ 9002.485830] ---[ end trace e865b84b28e31f5b ]---

This was found when looking for functions that return non-negative
values on error. A simplified version of the semantic match that 
finds this problem is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
	Updated commit message

 drivers/media/v4l2-core/videobuf2-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 432df11..dad10af 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1878,8 +1878,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 */
 	for (i = 0; i < q->num_buffers; i++) {
 		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
-		if (fileio->bufs[i].vaddr == NULL)
+		if (fileio->bufs[i].vaddr == NULL) {
+			ret = -EFAULT;
 			goto err_reqbufs;
+		}
 		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
 	}
 
-- 
1.7.11.7

