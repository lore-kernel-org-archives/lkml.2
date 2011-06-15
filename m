Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1FOTE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:04:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1FOTEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:04:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, davej@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        cpufreq@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] [CPUFREQ] powernow-k8: Don't notify of successful transition if we failed.
Date: Wed, 15 Jun 2011 15:01:59 -0400
Message-Id: <1308164520-14145-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
References: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DF901BC.00BC:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch if we failed the transition (either p-state or
voltage) we would still try to submit the "new" frequencies to cpufreq.
That is incorrect - also we could submit a non-existing frequency value
which would cause cpufreq to crash. The ultimate fix is in cpufreq
to deal with incorrect values, but this patch improves the error
recovery in the AMD powernowk8 driver.

The failure that was reported was as follow:

powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
powernow-k8: fid 0x2 (1000 MHz), vid 0x12
powernow-k8: fid 0xa (1800 MHz), vid 0xa
powernow-k8: fid 0xc (2000 MHz), vid 0x8
powernow-k8: fid 0xe (2200 MHz), vid 0x8
Marking TSC unstable due to cpufreq changes
powernow-k8: fid trans failed, fid 0x2, curr 0x0
BUG: unable to handle kernel paging request at ffff880807e07b78
IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
...

And transition fails and data->currfid ends up with 0. Since
the machine does not support 800Mhz value when the calculation is
done ('find_khz_freq_from_fid(data->currfid);') it reports the
new frequency as 800000 which is bogus. This patch fixes
the issue during target setting.

The patch however does not fix the issue in 'powernowk8_cpu_init'
where the pol->cur can also be set with the 800000 value:

          pol->cur = find_khz_freq_from_fid(data->currfid);
  dprintk("policy current frequency %d kHz\n", pol->cur);

  /* min/max the cpu is capable of */
  if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {

The fix for that looks to update cpufreq_frequency_table_cpuinfo to
check pol->cur.... but that would cause an regression in how the
acpi-cpufreq driver works (it sets cpu->cur after calling
cpufreq_frequency_table_cpuinfo). Instead the fix will be to let
cpufreq gracefully handle bogus data.

Reported-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
Tested-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 2368e38..7e4a664 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1079,8 +1079,10 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	}
 
 	res = transition_fid_vid(data, fid, vid);
-	freqs.new = find_khz_freq_from_fid(data->currfid);
+	if (res)
+		return res;
 
+	freqs.new = find_khz_freq_from_fid(data->currfid);
 	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
@@ -1112,6 +1114,9 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
 	}
 
 	res = transition_pstate(data, pstate);
+	if (res)
+		return res;
+
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
 	for_each_cpu(i, data->available_cores) {
-- 
1.7.4.1

