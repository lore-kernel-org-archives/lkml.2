Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1HIW12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 18:27:28 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10475 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1HIW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 18:27:27 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: wim@iguana.be
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Message-Id: <20110809222833.2900.70975.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH] watchdog: hpwdt: prevent multiple "NMI occurred" messages
Date: Tue,  9 Aug 2011 22:27:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On platforms with no iCRU support don't print two, (possibly conflicting), 
"NMI occurred" messages when the firmware is unable to source the NMI.

Please note that one of the enhancements to the v1.3.0 hpwdt driver is to panic and allow 
KDUMP to succeed even on NMIs that are unknown to the platform firmware.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Reviewed-by: Thomas Mingarelli <thomas.mingarelli@hp.com>

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 410fba4..809cbda 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -494,15 +494,16 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		asminline_call(&cmn_regs, cru_rom_addr);
 	die_nmi_called = 1;
 	spin_unlock_irqrestore(&rom_lock, rom_pl);
+
+	if (allow_kdump)
+		hpwdt_stop();
+
 	if (!is_icru) {
 		if (cmn_regs.u1.ral == 0) {
-			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			panic("An NMI occurred, "
 				"but unable to determine source.\n");
 		}
 	}
-
-	if (allow_kdump)
-		hpwdt_stop();
 	panic("An NMI occurred, please see the Integrated "
 		"Management Log for details.\n");
 
