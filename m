Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab2J2VsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:48:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:48797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab2J2Vlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ivan Shugov <ivan.shugov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 38/54] ARM: at91: at91sam9g10: fix SOC type detection
Date: Mon, 29 Oct 2012 14:40:39 -0700
Message-Id: <20121029213806.981418075@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -146,7 +146,7 @@ static void __init soc_detect(u32 dbgu_b
 	}
 
 	/* at91sam9g10 */
-	if ((cidr & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
+	if ((socid & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
 		at91_soc_initdata.type = AT91_SOC_SAM9G10;
 		at91_boot_soc = at91sam9261_soc;
 	}


