Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1BNKBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:01:23 -0500
Received: from server103.greatnet.de ([83.133.97.6]:38330 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:00:23 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@readhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        yinghai@kernel.org, ak@linux.intel.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, henne@nachtwindheim.de
Subject: [PATCH 3/6] x86: ifdef INTR_REMAP code out
Date: Mon, 14 Feb 2011 11:00:09 +0100
Message-Id: <1297677612-12405-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping is only available on 64-bit machines,
so it has no place in lapic_resume() for 32bit machines.

Compilation on 32bit machines would produce errors here.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/apic/apic.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 27a7497..999c531 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2109,12 +2109,15 @@ static int lapic_resume(struct sys_device *dev)
 	unsigned long flags;
 	int maxlvt;
 	int ret = 0;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
 		return 0;
 
 	local_irq_save(flags);
+
+#ifdef CONFIG_INTR_REMAP
+	struct IO_APIC_route_entry **ioapic_entries = NULL;
+
 	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
@@ -2133,6 +2136,7 @@ static int lapic_resume(struct sys_device *dev)
 		mask_IO_APIC_setup(ioapic_entries);
 		legacy_pic->mask_all();
 	}
+#endif
 
 	if (x2apic_mode)
 		enable_x2apic();
@@ -2173,6 +2177,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
+#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled) {
 		reenable_intr_remapping(x2apic_mode);
 		legacy_pic->restore_mask();
@@ -2180,6 +2185,7 @@ static int lapic_resume(struct sys_device *dev)
 		free_ioapic_entries(ioapic_entries);
 	}
 restore:
+#endif
 	local_irq_restore(flags);
 
 	return ret;
-- 
1.7.2.3

