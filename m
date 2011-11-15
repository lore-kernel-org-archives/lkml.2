Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1KOVdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:33:23 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39123 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab1KOVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/7] tboot: Add return values for tboot_sleep
Date: Tue, 15 Nov 2011 16:31:06 -0500
Message-Id: <1321392671-9128-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EC2DA45.0038,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. as appropiately. As tboot_sleep now returns values, we are free
to remove the tboot_sleep_wrapper function altogether.

Suggested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 751d673..5ab5362 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -273,7 +273,8 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
 		offsetof(struct acpi_table_facs, firmware_waking_vector);
 }
 
-void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
+static acpi_status tboot_sleep(u8 sleep_state, u32 pm1a_control,
+			       u32 pm1b_control)
 {
 	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
 		/* S0,1,2: */ -1, -1, -1,
@@ -282,7 +283,7 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 		/* S5: */ TB_SHUTDOWN_S5 };
 
 	if (!tboot_enabled())
-		return;
+		return AE_OK;
 
 	tboot_copy_fadt(&acpi_gbl_FADT);
 	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
@@ -293,10 +294,12 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 	if (sleep_state >= ACPI_S_STATE_COUNT ||
 	    acpi_shutdown_map[sleep_state] == -1) {
 		pr_warning("unsupported sleep state 0x%x\n", sleep_state);
-		return;
+		return AE_ERROR;
 	}
 
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
+
+	return AE_OK;
 }
 static acpi_status tboot_sleep_wrapper(u8 sleep_state, u32 pm1a_control,
 		u32 pm1b_control)
@@ -353,7 +356,7 @@ static __init int tboot_late_init(void)
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
-	acpi_os_prepare_sleep_register(&tboot_sleep_wrapper);
+	acpi_os_prepare_sleep_register(&tboot_sleep);
 	return 0;
 }
 
-- 
1.7.7.1

