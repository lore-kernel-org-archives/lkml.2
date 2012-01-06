Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2AFO4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:56:38 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:31813
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758734Ab2AFO4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:56:36 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LXDTI4-02-5U1-02
X-M-MSG: 
Date: Fri, 6 Jan 2012 15:56:31 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dave Jones <davej@redhat.com>
CC: <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] powernow-k8: Avoid Pstate MSR accesses on systems
 supporting CPB
Message-ID: <20120106145631.GJ24451@alberich.amd.com>
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


Due to CPB we can't directly map SW Pstates to Pstate MSRs. Get rid of
the paranoia check. (assuming that the ACPI Pstate information is
correct.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/cpufreq/powernow-k8.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index bce576d..e0329f9 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -926,23 +926,24 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 			invalidate_entry(powernow_table, i);
 			continue;
 		}
-		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
-		if (!(hi & HW_PSTATE_VALID_MASK)) {
-			pr_debug("invalid pstate %d, ignoring\n", index);
-			invalidate_entry(powernow_table, i);
-			continue;
-		}
-
-		powernow_table[i].index = index;
-
 		/* Frequency may be rounded for these */
 		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 				 || boot_cpu_data.x86 == 0x11) {
+
+			rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
+			if (!(hi & HW_PSTATE_VALID_MASK)) {
+				pr_debug("invalid pstate %d, ignoring\n", index);
+				invalidate_entry(powernow_table, i);
+				continue;
+			}
+
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
 			powernow_table[i].frequency =
 				data->acpi_data.states[i].core_frequency * 1000;
+
+		powernow_table[i].index = index;
 	}
 	return 0;
 }
-- 
1.7.8.1



