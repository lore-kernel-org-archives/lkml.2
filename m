Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2BJXGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:06:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab2BJWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:32 -0500
MIME-Version: 1.0
Message-Id: <20120210222952.697089428@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>
Subject: [patch 86/86] [CPUFREQ] powernow-k8: Fix indexing issue
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit a8eb28480e9b637cc78b9aa5e08612ba97e1317a upstream.

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
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernow-k8.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -54,6 +54,9 @@ static DEFINE_PER_CPU(struct powernow_k8
 
 static int cpu_family = CPU_OPTERON;
 
+/* array to map SW pstate number to acpi state */
+static u32 ps_to_as[8];
+
 /* core performance boost */
 static bool cpb_capable, cpb_enabled;
 static struct msr __percpu *msrs;
@@ -80,9 +83,9 @@ static u32 find_khz_freq_from_fid(u32 fi
 }
 
 static u32 find_khz_freq_from_pstate(struct cpufreq_frequency_table *data,
-		u32 pstate)
+				     u32 pstate)
 {
-	return data[pstate].frequency;
+	return data[ps_to_as[pstate]].frequency;
 }
 
 /* Return the vco fid for an input fid
@@ -926,6 +929,9 @@ static int fill_powernow_table_pstate(st
 			invalidate_entry(powernow_table, i);
 			continue;
 		}
+
+		ps_to_as[index] = i;
+
 		/* Frequency may be rounded for these */
 		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 				 || boot_cpu_data.x86 == 0x11) {
@@ -1190,7 +1196,8 @@ static int powernowk8_target(struct cpuf
 	powernow_k8_acpi_pst_values(data, newstate);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		ret = transition_frequency_pstate(data, newstate);
+		ret = transition_frequency_pstate(data,
+			data->powernow_table[newstate].index);
 	else
 		ret = transition_frequency_fidvid(data, newstate);
 	if (ret) {
@@ -1203,7 +1210,7 @@ static int powernowk8_target(struct cpuf
 
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cur = find_khz_freq_from_pstate(data->powernow_table,
-				newstate);
+				data->powernow_table[newstate].index);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
 	ret = 0;


