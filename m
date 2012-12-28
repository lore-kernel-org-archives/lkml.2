Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2L1Oxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 09:53:44 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:49139 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2L1Oxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 09:53:41 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86, reboot: skip reboot_fixups in early boot phase
Date: Fri, 28 Dec 2012 22:50:23 +0900
Message-Id: <1356702623-9430-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot phase, PCI bus subsystem is not yet initialized.
If panic is occured in early boot phase and panic_timeout is set,
code flow go into emergency_restart() and hit mach_reboot_fixups(), then
encounter another panic. When second panic, we can't hold a panic_lock, so
code flow go into panic_smp_self_stop() which prevent system to restart.

For avoid second panic, skip reboot_fixups in early boot phase.
It makes panic_timeout works in early boot phase.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index c8e41e9..b9b8ec9 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -89,6 +89,10 @@ void mach_reboot_fixups(void)
 	if (in_interrupt())
 		return;
 
+	/* During early boot phase, PCI is not yet initialized */
+	if (system_state == SYSTEM_BOOTING)
+		return;
+
 	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
 		cur = &(fixups_table[i]);
 		dev = pci_get_device(cur->vendor, cur->device, NULL);
-- 
1.7.9.5

