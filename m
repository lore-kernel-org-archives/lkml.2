Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2ATSiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:38:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55552 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2ATSiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:38:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH] arm/devicetree: don't bind devicetree-only machine_descs via MACH_TYPE_xxx
Date: Fri, 20 Jan 2012 11:37:41 -0700
Message-Id: <1327084661-21971-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that a DT only machine_desc (created with DT_MACHINE_START()
doesn't get selected by setup_machine_tags().  It also adds some documentation
to clarify that firmware should use ~0 in r1 if booting with a DT and a valid
machine number is not available.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Maydell <peter.maydell@linaro.org>
---
 Documentation/arm/Booting                       |    4 +++-
 Documentation/devicetree/booting-without-of.txt |    3 ++-
 arch/arm/kernel/setup.c                         |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm/Booting b/Documentation/arm/Booting
index a341d87..7d1b4bb 100644
--- a/Documentation/arm/Booting
+++ b/Documentation/arm/Booting
@@ -148,7 +148,9 @@ In either case, the following conditions must be met:
 
 - CPU register settings
   r0 = 0,
-  r1 = machine type number discovered in (3) above.
+  r1 = machine type number discovered in (3) above, or if booting with
+       a dtb then this may be set to ~0 if a valid MACH_TYPE_xxx value
+       does not exist for the machine.
   r2 = physical address of tagged list in system RAM, or
        physical address of device tree block (dtb) in system RAM
 
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 7c1329d..33e2b51 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -176,7 +176,8 @@ it with special cases.
 
                 r1 : Valid machine type number.  When using a device tree,
                 a single machine type number will often be assigned to
-                represent a class or family of SoCs.
+                represent a class or family of SoCs.  If a valid machine
+                type number is not assigned, then use ~0.
 
                 r2 : physical pointer to the device-tree block
                 (defined in chapter II) in RAM.  Device tree can be located
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 129fbd5..2b037a3 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -845,7 +845,7 @@ static struct machine_desc * __init setup_machine_tags(unsigned int nr)
 			break;
 		}
 
-	if (!mdesc) {
+	if (!mdesc || nr == ~0) {
 		early_print("\nError: unrecognized/unsupported machine ID"
 			" (r1 = 0x%08x).\n\n", nr);
 		dump_machine_table(); /* does not return */
-- 
1.7.5.4

