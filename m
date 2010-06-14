Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0FNRvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:51:09 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60870 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753227Ab0FNRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:51:07 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Airlie <airlied@linux.ie>
Subject: [PATCH] intel_agp: Don't oops with zero stolen memory
Date: Mon, 14 Jun 2010 19:50:57 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006141950.59409.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When "onboard video memory" is set do "disabled" in BIOS on Asus P4P800-VM
board (i865G), kernel oopses with memory corruption:
https://bugs.freedesktop.org/show_bug.cgi?id=28430

Fix that by cleanly aborting the initialization.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -urp linux-2.6.35-rc2-orig/drivers/char/agp/intel-gtt.c linux-2.6.35-rc2/drivers/char/agp/intel-gtt.c
--- linux-2.6.35-rc2-orig/drivers/char/agp/intel-gtt.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc2/drivers/char/agp/intel-gtt.c	2010-06-14 19:14:05.000000000 +0200
@@ -797,6 +797,10 @@ static int intel_i830_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 
@@ -1279,6 +1283,11 @@ static int intel_i915_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.gtt);
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 
@@ -1387,6 +1396,11 @@ static int intel_i965_create_gatt_table(
 
 	/* we have to call this as early as possible after the MMIO base address is known */
 	intel_i830_init_gtt_entries();
+	if (intel_private.gtt_entries == 0) {
+		iounmap(intel_private.gtt);
+		iounmap(intel_private.registers);
+		return -ENOMEM;
+	}
 
 	agp_bridge->gatt_table = NULL;
 

-- 
Ondrej Zary
