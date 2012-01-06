Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2AFO6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:58:13 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27934 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab2AFO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:58:12 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LXDTKH-02-5WZ-02
X-M-MSG: 
Date: Fri, 6 Jan 2012 15:57:55 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dave Jones <davej@redhat.com>
CC: <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] powernow-k8: Fix indexing issue
Message-ID: <20120106145755.GK24451@alberich.amd.com>
References: <20120106145500.GI24451@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120106145500.GI24451@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The driver uses the pstate number from the status register as index in
its table of ACPI pstates (powernow_table). This is wrong as this is
not a 1-to-1 mapping.

For example we can have _PSS information to just utilize Pstate 0 and
Pstate 4, ie.

  powernow-k8: Core Performance Boosting: on.
  powernow-k8:    0 : pstate 0 (2200 MHz)
  powernow-k8:    1 : pstate 4 (1400 MHz)

In this example the driver's powernow_table has just 2 entries. Using
the pstate number (4) as index into this table is just plain wrong.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/cpufreq/powernow-k8.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index e0329f9..ad683ec 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -54,6 +54,9 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 
 static int cpu_family = CPU_OPTERON;
 
+/* array to map SW pstate number to acpi state */
+static u32 ps_to_as[8];
+
 /* core performance boost */
 static bool cpb_capable, cpb_enabled;
 static struct msr __percpu *msrs;
@@ -80,9 +83,9 @@ static u32 find_khz_freq_from_fid(u32 fid)
 }
 
 static u32 find_khz_freq_from_pstate(struct cpufreq_frequency_table *data,
-		u32 pstate)
+				     u32 pstate)
 {
-	return data[pstate].frequency;
+	return data[ps_to_as[pstate]].frequency;
 }
 
 /* Return the vco fid for an input fid
@@ -926,6 +929,9 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 			invalidate_entry(powernow_table, i);
 			continue;
 		}
+
+		ps_to_as[index] = i;
+
 		/* Frequency may be rounded for these */
 		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 				 || boot_cpu_data.x86 == 0x11) {
@@ -1190,7 +1196,8 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	powernow_k8_acpi_pst_values(data, newstate);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		ret = transition_frequency_pstate(data, newstate);
+		ret = transition_frequency_pstate(data,
+			data->powernow_table[newstate].index);
 	else
 		ret = transition_frequency_fidvid(data, newstate);
 	if (ret) {
@@ -1203,7 +1210,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cur = find_khz_freq_from_pstate(data->powernow_table,
-				newstate);
+				data->powernow_table[newstate].index);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	ret = 0;
-- 
1.7.8.1



