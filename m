Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2JQCl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab2JQCl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:41:26 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Arvind R ." <arvino55@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH EDAC 1/3] i82975x_edac: Fix dimm label initialization
Date: Tue, 16 Oct 2012 23:41:08 -0300
Message-Id: <8992ed2f4295eab137e1713fa16be5546a759373.1350440633.git.mchehab@redhat.com>
In-Reply-To: <cover.1350440633.git.mchehab@redhat.com>
References: <cover.1350440633.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has only 4 hardcoded labels, but allows much more memory.
Fix it by removing the hardcoded logic, using snprintf() instead.

[   19.833972] general protection fault: 0000 [#1] SMP
[   19.837733] Modules linked in: i82975x_edac(+) edac_core firewire_ohci firewire_core crc_itu_t nouveau mxm_wmi wmi video i2c_algo_bit drm_kms_helper ttm drm i2c_core
[   19.837733] CPU 0
[   19.837733] Pid: 390, comm: udevd Not tainted 3.6.1-1.fc17.x86_64.debug #1 Dell Inc.                 Precision WorkStation 390    /0MY510
[   19.837733] RIP: 0010:[<ffffffff813463a8>]  [<ffffffff813463a8>] strncpy+0x18/0x30
[   19.837733] RSP: 0018:ffff880078535b68  EFLAGS: 00010202
[   19.837733] RAX: ffff880069fa9708 RBX: ffff880078588000 RCX: ffff880069fa9708
[   19.837733] RDX: 000000000000001f RSI: 5f706f5f63616465 RDI: ffff880069fa9708
[   19.837733] RBP: ffff880078535b68 R08: ffff880069fa9727 R09: 000000000000fffe
[   19.837733] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[   19.837733] R13: 0000000000000000 R14: ffff880069fa9290 R15: ffff880079624a80
[   19.837733] FS:  00007f3de01ee840(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[   19.837733] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.837733] CR2: 00007f3de00b9000 CR3: 0000000078dbc000 CR4: 00000000000007f0
[   19.837733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   19.837733] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   19.837733] Process udevd (pid: 390, threadinfo ffff880078534000, task ffff880079642450)
[   19.837733] Stack:
[   19.837733]  ffff880078535c18 ffffffffa017c6b8 00040000816d627f ffff880079624a88
[   19.837733]  ffffc90004cd6000 ffff880079624520 ffff88007ac21148 0000000000000000
[   19.837733]  0000000000000000 0004000000000000 feda000078535bc8 ffffffff810d696d
[   19.837733] Call Trace:
[   19.837733]  [<ffffffffa017c6b8>] i82975x_init_one+0x2e6/0x3e6 [i82975x_edac]
...

Fix bug reported at:
	https://bugzilla.redhat.com/show_bug.cgi?id=848149
And, very likely:
	https://bbs.archlinux.org/viewtopic.php?id=148033
	https://bugzilla.kernel.org/show_bug.cgi?id=47171

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/edac/i82975x_edac.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 069e26c..a980204 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -370,10 +370,6 @@ static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
 static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		struct pci_dev *pdev, void __iomem *mch_window)
 {
-	static const char *labels[4] = {
-							"DIMM A1", "DIMM A2",
-							"DIMM B1", "DIMM B2"
-						};
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
@@ -423,9 +419,10 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			dimm = mci->csrows[index]->channels[chan]->dimm;
 
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
-			strncpy(csrow->channels[chan]->dimm->label,
-					labels[(index >> 1) + (chan * 2)],
-					EDAC_MC_LABEL_LEN);
+
+			snprintf(csrow->channels[chan]->dimm->label, EDAC_MC_LABEL_LEN, "DIMM %c%d",
+				 (chan == 0) ? 'A' : 'B',
+				 index);
 			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
 			dimm->dtype = i82975x_dram_type(mch_window, index);
 			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
-- 
1.7.11.7

