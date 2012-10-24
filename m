Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab2JXPgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:36:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11081 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934861Ab2JXPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 2/8] ARM: at91: at91sam9g10: fix SOC type detection
Date: Wed, 24 Oct 2012 17:33:51 +0200
Message-ID: <044b1c5e664848af0159b45565183e71d212cf69.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Shugov <ivan.shugov@gmail.com>

Newer at91sam9g10 SoC revision can't be detected, so the kernel can't boot with
this kind of kernel panic:
"AT91: Impossible to detect the SOC type"

CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Atmel AT91SAM9G10-EK
Ignoring tag cmdline (using the default kernel command line)
bootconsole [earlycon0] enabled
Memory policy: ECC disabled, Data cache writeback
Kernel panic - not syncing: AT91: Impossible to detect the SOC type
[<c00133d4>] (unwind_backtrace+0x0/0xe0) from [<c02366dc>] (panic+0x78/0x1cc)
[<c02366dc>] (panic+0x78/0x1cc) from [<c02fa35c>] (at91_map_io+0x90/0xc8)
[<c02fa35c>] (at91_map_io+0x90/0xc8) from [<c02f9860>] (paging_init+0x564/0x6d0)
[<c02f9860>] (paging_init+0x564/0x6d0) from [<c02f7914>] (setup_arch+0x464/0x704)
[<c02f7914>] (setup_arch+0x464/0x704) from [<c02f44f8>] (start_kernel+0x6c/0x2d4)
[<c02f44f8>] (start_kernel+0x6c/0x2d4) from [<20008040>] (0x20008040)

The reason for this is that the Debug Unit Chip ID Register has changed between
Engineering Sample and definitive revision of the SoC. Changing the check of
cidr to socid will address the problem. We do not integrate this check to the
list just above because we also have to make sure that the extended id is
disregarded.

Signed-off-by: Ivan Shugov <ivan.shugov@gmail.com>
[nicolas.ferre@atmel.com: change commit message]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> [v3.1] # since commit 8c3583b6
---
 arch/arm/mach-at91/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index da9881b..6a3d4bb 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -151,7 +151,7 @@ static void __init soc_detect(u32 dbgu_base)
 	}
 
 	/* at91sam9g10 */
-	if ((cidr & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
+	if ((socid & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
 		at91_soc_initdata.type = AT91_SOC_SAM9G10;
 		at91_boot_soc = at91sam9261_soc;
 	}
-- 
1.7.11.3

