Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2AQUwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:52:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:56098 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2AQUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:52:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, joseph.cihula@intel.com,
        linux-acpi@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        len.brown@intel.com, rjw@sisk.pl, mingo@redhat.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] tboot: Add return values for tboot_sleep
Date: Tue, 17 Jan 2012 15:50:08 -0500
Message-Id: <1326833408-23685-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326833408-23685-1-git-send-email-konrad.wilk@oracle.com>
References: <1326833408-23685-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F15DF80.0027,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. as appropiately. As tboot_sleep now returns values.
remove tboot_sleep_wrapper.

Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Joseph Cihula <joseph.cihula@intel.com>
[v1: Return -1/0/+1 instead of ACPI_xx values]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

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
1.7.7.4

