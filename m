Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2DXUxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:53:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59395 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2DXUxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:53:02 -0400
Date: Tue, 24 Apr 2012 21:52:55 +0100
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: martin.nyhus@gmx.com, Matthew Garrett <mjg@redhat.com>,
        kernelmail.jms@gmail.com, linux-kernel@vger.kernel.org
Subject: Oops in -rc series fixed by [PATCH] dell-laptop: Terminate quirks
 list properly
Message-ID: <20120424205255.GB3766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi guys,

This is to confirm that Martin's change which is now in -next fixes an oops on
my Dell MXG071 (also known as the XPS M1730):



[PATCH] dell-laptop: Terminate quirks list properly

Martin Nyhus
Thu, 15 Mar 2012 10:28:34 -0700

Add missing DMI_NONE entry to end of the quirks list so
dmi_check_system() won't read past the end of the list.

Signed-off-by: Martin Nyhus <martin.ny...@gmx.com>
---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c 
b/drivers/platform/x86/dell-laptop.c
index a05fc9c..e6c08ee 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -212,6 +212,7 @@ static struct dmi_system_id __devinitdata dell_quirks[] = {
                },
                .driver_data = &quirk_dell_vostro_v130,
        },
+       { }
 };
 
 static struct calling_interface_buffer *buffer;
-- 
1.7.7.6




This oops is in the current -rc series originally appearing in -rc1 and I 
had bisected it to Acelan's commit:

commit 2a748853ca395c48ea75baa250f7cea6f0f23dbf
Author: AceLan Kao <acelan.kao@canonical.com>
Date:   Thu Nov 17 15:30:42 2011 +0800

    dell-laptop: add 3 machines that has touchpad LED

    Add "Vostro 3555", "Inspiron N311z", and "Inspiron M5110" into quirks,
    so that they could have touchpad LED function work.

    Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>



Reverting this patch or adding my machine to the quirk array also fixes it
but obviously terminating the list properly is preferable ;-)



Sample oops below.


[   16.083634] BUG: unable to handle kernel paging request at 000000400fb00000
[   16.083663] IP: [<ffffffff812375a4>] strstr+0x30/0x68
[   16.083677] PGD 13472f067 PUD 0
[   16.083686] Oops: 0000 [#1] SMP
[   16.083695] CPU 1
[   16.083699] Modules linked in: dell_laptop(+) nand(+) iwlegacy nand_ids mtd nand_ecc sdhci_pci sdhci firewire_ohci mmc_core firewire_core nouveau ttm drm_kms_helper intel_agp intel_gtt mxm_wmi
[   16.083750]
[   16.083755] Pid: 1644, comm: modprobe Not tainted 3.4.0-rc2 #121 Dell Inc. MXG071                          /0KX412
[   16.083773] RIP: 0010:[<ffffffff812375a4>]  [<ffffffff812375a4>] strstr+0x30/0x68
[   16.083787] RSP: 0018:ffff880131855d98  EFLAGS: 00010217
[   16.083795] RAX: 0000000000000000 RBX: 000000400fb00000 RCX: ffffffffffffffff
[   16.083804] RDX: 000000000000000e RSI: ffffffffa0115aa1 RDI: 000000400fb00000
[   16.083814] RBP: ffff880131855db8 R08: 0000000000000049 R09: 0000000000000001
[   16.083823] R10: ffff88013b40b000 R11: 00000000000014b6 R12: 0000000000000011
[   16.083833] R13: ffffffffa0115aa1 R14: ffffffffffffffff R15: 0000000000000001
[   16.083844] FS:  00007fbe5c729720(0000) GS:ffff88013b400000(0000) knlGS:0000000000000000
[   16.083855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.083863] CR2: 000000400fb00000 CR3: 000000013472b000 CR4: 00000000000007e0
[   16.083873] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.083883] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   16.083893] Process modprobe (pid: 1644, threadinfo ffff880131854000, task ffff880134710000)
[   16.083904] Stack:
[   16.083908]  ffffffffa0115a90 0000000000000000 ffffffffa0115ae0 0000000000000001
[   16.083929]  ffff880131855de8 ffffffff813c9e9b 0000000000000049 ffffffffa0115a90
[   16.083944]  0000000000000000 0000000000000000 ffff880131855e08 ffffffff813c9f07
[   16.083960] Call Trace:
[   16.083970]  [<ffffffff813c9e9b>] dmi_matches+0x69/0x85
[   16.083979]  [<ffffffff813c9f07>] dmi_check_system+0x1c/0x49
[   16.083992]  [<ffffffffa011809d>] ? find_tokens+0x9d/0x9d [dell_laptop]
[   16.084003]  [<ffffffffa01180da>] dell_init+0x3d/0x4d6 [dell_laptop]
[   16.084015]  [<ffffffff81052a7d>] ? up_read+0x21/0x38
[   16.084024]  [<ffffffffa011809d>] ? find_tokens+0x9d/0x9d [dell_laptop]
[   16.084036]  [<ffffffff8100020f>] do_one_initcall+0x7f/0x134
[   16.084046]  [<ffffffff8108729c>] sys_init_module+0x17c0/0x1a21
[   16.084058]  [<ffffffff815df412>] system_call_fastpath+0x16/0x1b
[   16.084066] Code: e5 41 56 49 83 ce ff 4c 89 f1 41 55 49 89 f5 41 54 53 48 89 fb 48 89 f7 f2 ae 48 f7 d1 49 89 cc 4d 01 f4 74 32 4c 89 f1 48 89 df <f2> ae 49 89 ce 49 f7 d6 49 ff ce eb 18 4c 89 e2 4c 89 ee 48 89
[   16.084186] RIP  [<ffffffff812375a4>] strstr+0x30/0x68
[   16.084186]  RSP <ffff880131855d98>
[   16.084186] CR2: 000000400fb00000
[   16.092359] ---[ end trace fcf966b4631646a9 ]---


Cheers,
Julie

