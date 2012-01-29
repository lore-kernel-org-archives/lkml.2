Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2A2TUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 14:20:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44078 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2A2TUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 14:20:46 -0500
Date: Sun, 29 Jan 2012 14:21:17 -0500
Message-Id: <87vcnub9hu.fsf@gmail.com>
From: Michael D Labriola <michael.d.labriola@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>,
        Michael D Labriola <mlabriol@gdeb.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, reboot: remove VersaLogic Menlow reboot quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes the reboot quirk originally added by commit e19e074
(x86: Fix reboot problem on VersaLogic Menlow boards).

Testing with a VersaLogic Ocelot (VL-EPMs-21a rev 1.00 w/ BIOS 6.5.102)
revealed the following regarding the reboot hang problem:

- v2.6.37 reboot=bios was needed.

- v2.6.38-rc1: behavior changed, reboot=acpi is needed, reboot=kbd and
  reboot=bios result in system hang.

- v2.6.38: VersaLogic patch (e19e074 x86: Fix reboot problem on
  VersaLogic Menlow boards) was applied prior to v2.6.38-rc7.  This
  patch sets a quirk for VersaLogic Menlow boards that forces the use
  of reboot=bios, which doesn't work anymore.

- v3.2: It seems that commit 660e34c (x86: Reorder reboot method
  preferences) changed the default reboot method to acpi prior to
  v3.0-rc1, which means the default behavior is appropriate for the
  Ocelot.  No VersaLogic quirk is required.

The Ocelot board used for testing can successfully reboot w/out having to
pass any reboot= arguments for all 3 current versions of the BIOS.

Signed-off-by: Michael D Labriola <michael.d.labriola@gmail.com>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index b257f0e..d840e69 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -309,14 +309,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
-		.callback = set_bios_reboot,
-		.ident = "VersaLogic Menlow based board",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
-		},
-	},
 	{ /* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
-- 
1.7.1.1

