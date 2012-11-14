Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2KNFvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55329 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932411Ab2KNFvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:18 -0500
Message-Id: <20121114053937.083509587@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ivan Shugov <ivan.shugov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 23/82] ARM: at91: at91sam9g10: fix SOC type detection
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Shugov <ivan.shugov@gmail.com>

commit 3d9a0183dd3423353e9e363bcc261c1220d05f9f upstream.

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
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-at91/setup.c |    2 +-
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


