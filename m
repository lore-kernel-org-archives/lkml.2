Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab2C3KOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:14:47 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:34627 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760630Ab2C3KOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:14:31 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/76] tboot: Add return values for tboot_sleep
Date: Fri, 30 Mar 2012 06:13:05 -0400
Message-id: <a1f37788a6d8c037e7d92fe4a0fe9ec0d713b21e.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

.. as appropiately. As tboot_sleep now returns values.
remove tboot_sleep_wrapper.

Suggested-and-Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Joseph Cihula <joseph.cihula@intel.com>
[v1: Return -1/0/+1 instead of ACPI_xx values]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 1a4ab7d..6410744 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -272,7 +272,7 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
 		offsetof(struct acpi_table_facs, firmware_waking_vector);
 }
 
-void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
+static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 {
 	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
 		/* S0,1,2: */ -1, -1, -1,
@@ -281,7 +281,7 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 		/* S5: */ TB_SHUTDOWN_S5 };
 
 	if (!tboot_enabled())
-		return;
+		return 0;
 
 	tboot_copy_fadt(&acpi_gbl_FADT);
 	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
@@ -292,15 +292,10 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 	if (sleep_state >= ACPI_S_STATE_COUNT ||
 	    acpi_shutdown_map[sleep_state] == -1) {
 		pr_warning("unsupported sleep state 0x%x\n", sleep_state);
-		return;
+		return -1;
 	}
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
-}
-static int tboot_sleep_wrapper(u8 sleep_state, u32 pm1a_control,
-			       u32 pm1b_control)
-{
-	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
 	return 0;
 }
 
@@ -352,7 +347,7 @@ static __init int tboot_late_init(void)
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
-	acpi_os_set_prepare_sleep(&tboot_sleep_wrapper);
+	acpi_os_set_prepare_sleep(&tboot_sleep);
 	return 0;
 }
 
-- 
1.7.10.rc2.19.gfae9d

