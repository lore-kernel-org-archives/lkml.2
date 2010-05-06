Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab0EFPrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:47:53 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:48220 "EHLO
	mail180-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755727Ab0EFPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:47:52 -0400
X-Greylist: delayed 1448 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 11:47:51 EDT
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L20838-01-HH7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] oprofile/x86: reordering some functions
Date: Thu, 6 May 2010 15:26:12 +0200
Message-ID: <1273152374-9392-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reordering some functions. Necessary for the next patch. No functional
changes.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |  134 +++++++++++++++++++++---------------------
 1 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 94b5481..7de0572 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -364,56 +364,6 @@ static struct notifier_block profile_exceptions_nb = {
 	.priority = 2
 };
 
-static int nmi_setup(void)
-{
-	int err = 0;
-	int cpu;
-
-	if (!allocate_msrs())
-		return -ENOMEM;
-
-	/* We need to serialize save and setup for HT because the subset
-	 * of msrs are distinct for save and setup operations
-	 */
-
-	/* Assume saved/restored counters are the same on all CPUs */
-	err = model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
-	if (err)
-		goto fail;
-
-	for_each_possible_cpu(cpu) {
-		if (!cpu)
-			continue;
-
-		memcpy(per_cpu(cpu_msrs, cpu).counters,
-		       per_cpu(cpu_msrs, 0).counters,
-		       sizeof(struct op_msr) * model->num_counters);
-
-		memcpy(per_cpu(cpu_msrs, cpu).controls,
-		       per_cpu(cpu_msrs, 0).controls,
-		       sizeof(struct op_msr) * model->num_controls);
-
-		mux_clone(cpu);
-	}
-
-	nmi_enabled = 0;
-	ctr_running = 0;
-	barrier();
-	err = register_die_notifier(&profile_exceptions_nb);
-	if (err)
-		goto fail;
-
-	get_online_cpus();
-	on_each_cpu(nmi_cpu_setup, NULL, 1);
-	nmi_enabled = 1;
-	put_online_cpus();
-
-	return 0;
-fail:
-	free_msrs();
-	return err;
-}
-
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
@@ -449,23 +399,6 @@ static void nmi_cpu_shutdown(void *dummy)
 	nmi_cpu_restore_registers(msrs);
 }
 
-static void nmi_shutdown(void)
-{
-	struct op_msrs *msrs;
-
-	get_online_cpus();
-	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
-	nmi_enabled = 0;
-	ctr_running = 0;
-	put_online_cpus();
-	barrier();
-	unregister_die_notifier(&profile_exceptions_nb);
-	msrs = &get_cpu_var(cpu_msrs);
-	model->shutdown(msrs);
-	free_msrs();
-	put_cpu_var(cpu_msrs);
-}
-
 static void nmi_cpu_up(void *dummy)
 {
 	if (nmi_enabled)
@@ -531,6 +464,73 @@ static struct notifier_block oprofile_cpu_nb = {
 	.notifier_call = oprofile_cpu_notifier
 };
 
+static int nmi_setup(void)
+{
+	int err = 0;
+	int cpu;
+
+	if (!allocate_msrs())
+		return -ENOMEM;
+
+	/* We need to serialize save and setup for HT because the subset
+	 * of msrs are distinct for save and setup operations
+	 */
+
+	/* Assume saved/restored counters are the same on all CPUs */
+	err = model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	if (err)
+		goto fail;
+
+	for_each_possible_cpu(cpu) {
+		if (!cpu)
+			continue;
+
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+		       per_cpu(cpu_msrs, 0).counters,
+		       sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+		       per_cpu(cpu_msrs, 0).controls,
+		       sizeof(struct op_msr) * model->num_controls);
+
+		mux_clone(cpu);
+	}
+
+	nmi_enabled = 0;
+	ctr_running = 0;
+	barrier();
+	err = register_die_notifier(&profile_exceptions_nb);
+	if (err)
+		goto fail;
+
+	get_online_cpus();
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
+	nmi_enabled = 1;
+	put_online_cpus();
+
+	return 0;
+fail:
+	free_msrs();
+	return err;
+}
+
+static void nmi_shutdown(void)
+{
+	struct op_msrs *msrs;
+
+	get_online_cpus();
+	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
+	nmi_enabled = 0;
+	ctr_running = 0;
+	put_online_cpus();
+	barrier();
+	unregister_die_notifier(&profile_exceptions_nb);
+	msrs = &get_cpu_var(cpu_msrs);
+	model->shutdown(msrs);
+	free_msrs();
+	put_cpu_var(cpu_msrs);
+}
+
 #ifdef CONFIG_PM
 
 static int nmi_suspend(struct sys_device *dev, pm_message_t state)
-- 
1.7.0.3


