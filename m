Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1K1O62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:58:28 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:57985 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1K1O61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:58:27 -0500
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 09:58:27 EST
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX][PATCH] drivers/regulator/core.c: fix use after free bug
Date: Mon, 28 Nov 2011 15:38:37 +0100
Message-Id: <1322491117-9185-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling the kernel with CONFIG_PAGE_POISONING produces the following
crash upon removal of a driver that calls regulator_unregister():
|Unable to handle kernel paging request at virtual address ffef3fde
|pgd = c6564000
|[ffef3fde] *pgd=47dfe831, *pte=00000000, *ppte=00000000
|Internal error: Oops: 1 [#1] PREEMPT
|Modules linked in: snd_soc_mxs_pcm snd_soc_mxs_sgtl5000(-) snd_soc_mxs fixed ehci_hcd mxs_usbphy usbcore usb_common evdev snd_soc_sgtl5000 snd_soc_core regmap_spi snd_pcm snd_timer snd_page_alloc regmap_i2c gpio_pca953x tsc2007 [last unloaded: snd_mixer_oss]
|CPU: 0    Not tainted  (3.2.0-rc1-next-20111110-karo+ #13)
|PC is at kfree+0x44/0x17c
|LR is at regulator_unregister+0x7c/0xac
|pc : [<c009a6d8>]    lr : [<c0219a34>]    psr: 00000013
|sp : c650fe80  ip : c641c7e0  fp : beffea28
|r10: 00000000  r9 : c650e000  r8 : c7372b00
|r7 : ffef3fde  r6 : 6b6b6b6b  r5 : c72fd70c  r4 : c0219a34
|r3 : c09e2000  r2 : dffbfe5e  r1 : 00000000  r0 : 6b6b6b6b
|Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
|Control: 0005317f  Table: 46564000  DAC: 00000015
|Process modprobe (pid: 1281, stack limit = 0xc650e270)
|Stack: (0xc650fe80 to 0xc6510000)
|fe80: c73d17c0 c72fd70c c71b1300 c7274d80 c7372b00 c650e000 00000000 c0219a34
|fea0: c640ab00 bf0637a0 c7372b00 bf06382c c7372b00 c7274360 c71b1300 bf040a50
|fec0: c720abc0 bf040c44 00000000 bf0ce2b4 00000000 c650e000 c650ff48 c650e000
|fee0: 00cc5b28 bf041128 bf0ce2b4 bf0ce278 c78bc87c bf0ce0d8 c78bc848 c023f0e0
|ff00: c78bc848 c023dad8 c78bc848 bf0ce278 c78bc87c c023dbdc c047202c bf0ce278
|ff20: c049c440 c023cd64 c047202c 00000080 bf0ce4ec c005d250 beffe98c c03250f4
|ff40: 00000002 00000000 5f646e73 5f636f73 5f73786d 6c746773 30303035 c01ea700
|ff60: c650e000 00000001 c650ff7c c001e9a0 60000013 c7321a98 beffe98c c0325888
|ff80: 00ffea1c c87c8db6 00000001 beffea1c 00cc5ac0 00000001 00000081 c000f3c8
|ffa0: 00000000 c000f200 beffea1c 00cc5ac0 00cc5b28 00000080 beffe984 00000000
|ffc0: beffea1c 00cc5ac0 00000001 00000081 00cc5b28 0000c69c 00cc5acc beffea28
|ffe0: 00cc5430 beffe990 0000a42c 4028911c 60000010 00cc5b28 aaaaaaaa aaaaaaaa
|[<c009a6d8>] (kfree+0x44/0x17c) from [<c0219a34>] (regulator_unregister+0x7c/0xac)
|[<c0219a34>] (regulator_unregister+0x7c/0xac) from [<bf0637a0>] (ldo_regulator_remove+0x4c/0x94 [snd_soc_sgtl5000])
|[<bf0637a0>] (ldo_regulator_remove+0x4c/0x94 [snd_soc_sgtl5000]) from [<bf06382c>] (sgtl5000_remove+0x44/0x4c [snd_soc_sgtl5000])
|[<bf06382c>] (sgtl5000_remove+0x44/0x4c [snd_soc_sgtl5000]) from [<bf040a50>] (soc_remove_codec+0x1c/0x94 [snd_soc_core])
|[<bf040a50>] (soc_remove_codec+0x1c/0x94 [snd_soc_core]) from [<bf040c44>] (soc_remove_dai_link+0x108/0x24c [snd_soc_core])
|[<bf040c44>] (soc_remove_dai_link+0x108/0x24c [snd_soc_core]) from [<bf041128>] (snd_soc_unregister_card+0xd8/0x140 [snd_soc_core])
|[<bf041128>] (snd_soc_unregister_card+0xd8/0x140 [snd_soc_core]) from [<bf0ce0d8>] (mxs_sgtl5000_remove+0x20/0x28 [snd_soc_mxs_sgtl5000])
|[<bf0ce0d8>] (mxs_sgtl5000_remove+0x20/0x28 [snd_soc_mxs_sgtl5000]) from [<c023f0e0>] (platform_drv_remove+0x18/0x1c)
|[<c023f0e0>] (platform_drv_remove+0x18/0x1c) from [<c023dad8>] (__device_release_driver+0x58/0xa8)
|[<c023dad8>] (__device_release_driver+0x58/0xa8) from [<c023dbdc>] (driver_detach+0xb4/0xb8)
|[<c023dbdc>] (driver_detach+0xb4/0xb8) from [<c023cd64>] (bus_remove_driver+0x7c/0xc0)
|[<c023cd64>] (bus_remove_driver+0x7c/0xc0) from [<c005d250>] (sys_delete_module+0x204/0x270)
|[<c005d250>] (sys_delete_module+0x204/0x270) from [<c000f200>] (ret_fast_syscall+0x0/0x38)
|Code: e7932107 e0837107 e3120902 1597701c (e5973000) 
|---[ end trace fe04617c1a901602 ]---

This is caused by dereferencing 'rdev' after device_unregister() in
the regulator_unregister() function.
'rdev' is freed by device_unregister(), so it must not be dereferenced
after this call.


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 679f92e..648fa2a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2800,8 +2800,8 @@ void regulator_unregister(struct regulator_dev *rdev)
 	list_del(&rdev->list);
 	if (rdev->supply)
 		regulator_put(rdev->supply);
-	device_unregister(&rdev->dev);
 	kfree(rdev->constraints);
+	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_unregister);
-- 
1.5.6.5

