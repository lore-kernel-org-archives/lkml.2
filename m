Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1FPUOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:14:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27589 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab1FPUOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:14:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, cpufreq@vger.kernel.org,
        davej@redhat.com, bp@alien8.de, Mark.Langsdorf@amd.com,
        andre.przywara@amd.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] [CPUFREQ] powernow-k8: Don't notify of successful transition if we failed (vid case).
Date: Thu, 16 Jun 2011 15:36:39 -0400
Message-Id: <1308253000-6289-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308253000-6289-1-git-send-email-konrad.wilk@oracle.com>
References: <1308253000-6289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DFA6423.0108:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch if we failed the vid transition would still try to
submit the "new" frequencies to cpufreq.
That is incorrect - also we could submit a non-existing frequency value
which would cause cpufreq to crash. The ultimate fix is in cpufreq
to deal with incorrect values, but this patch improves the error
recovery in the AMD powernowk8 driver.

The failure that was reported was as follows:

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
cpufreq gracefully handle bogus data (another patch).

Acked-by: Borislav Petkov <bp@alien8.de>
CC: andre.przywara@amd.com
CC: Mark.Langsdorf@amd.com
Reported-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
Tested-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
[v1: Rebased on v3.0-rc2, reduced patch to deal with vid case]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/cpufreq/powernow-k8.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 83479b6..287c56f 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1079,6 +1079,9 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	}
 
 	res = transition_fid_vid(data, fid, vid);
+	if (res)
+		return res;
+
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
 	for_each_cpu(i, data->available_cores) {
-- 
1.7.4.1

