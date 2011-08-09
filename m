Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1HIMla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:41:30 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:61714 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab1HIMlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:41:20 -0400
X-AuditID: 12074425-b7b15ae000000f71-4e-4e412abf0a9f
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't already
Date: Tue,  9 Aug 2011 08:41:06 -0400
Message-Id: <aed368a81dc914d639aaa77665f06ae136fe38dc.1312893572.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312893572.git.luto@mit.edu>
References: <cover.1312893572.git.luto@mit.edu>
In-Reply-To: <cover.1312893572.git.luto@mit.edu>
References: <cover.1312893572.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsUixCmqrbtfy9HP4N5cA4u+K0fZLdqmOVrs
	fPiWzWL5vn5Gi8u75rBZbLnUzGpx9eFsFosfGx6zOnB43Gr7w+yxc9Zddo/Fe14yeWxa1cnm
	se7GV3aPz5vkAtiiuGxSUnMyy1KL9O0SuDJOrrvGXDCfp2LOk2bGBsZHnF2MnBwSAiYSXT92
	sEDYYhIX7q1n62Lk4hAS2Mco0T7vG5SznlFi7u5bjBDOUyaJxplzWUFa2ARUJDqWPmACsUUE
	DCS2rHzBClLELHCFUeLi/BvMIAlhgUCJC9sXgNksAqoSH+/PBWrg4OAVCJJYelceYrWcxJHL
	z8HmcALNWTN5L1i5kIC+xOFJM1lwiU9gFFjAyLCKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI10Iv
	N7NELzWldBMjKITZXVR3ME44pHSIUYCDUYmHl5PfwU+INbGsuDL3EKMkB5OSKO8TTUc/Ib6k
	/JTKjMTijPii0pzU4kOMEhzMSiK86RpAOd6UxMqq1KJ8mJQ0B4uSOO/rHUCTBNITS1KzU1ML
	UotgsjIcHEoSvBnAWBUSLEpNT61Iy8wpQUgzcXCCDOcBGi4KUsNbXJCYW5yZDpE/xagoJc5r
	C5IQAElklObB9cJSzCtGcaBXhHmFQap4gOkJrvsV0GAmoMH1dxxABpckIqSkGhjLr6lkmtZF
	fLX7MnOvso2Tv0rOnpw5QVXz/rxiPm4hbVbZq8Yr80Tyqsq1u1fCag2+n5N6/EtkpoiBRME0
	pwdp9hXMgQHJDafMOf7+NpWYuGFNk8bKu5u/qiv+el+qIfJPyU9offADfl5Rx4iIe1tF/3Lx
	RC+L+qfI0LelKGxD44r5p1gY3iixFGckGmoxFxUnAgDm2w3FDAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Intel DQ67SW (latest BIOS) disables monitor/mwait on the boot CPU
if TXT is enabled.  We're lucky that the system works at all, since
the feature is still enabled on other CPUs.

The obvious fix is to just re-enable it ourselves.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/cpu/intel.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7d02873..c49487f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -492,6 +492,30 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}
 	}
+
+	/* Enable monitor/mwait if BIOS didn't do it for us. */
+	if (!cpu_has(c, X86_FEATURE_MWAIT) && cpu_has(c, X86_FEATURE_XMM3)
+	    && c->x86 >= 6 && !(c->x86 == 6 && c->x86_model < 0x1c)
+	    && !(c->x86 == 0xf && c->x86_model < 3)) {
+		u64 misc_enable;
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
+
+		/*
+		 * Some non-SSE3 cpus will #GP.  We check for that,
+		 * but it can't hurt to be safe.
+		 */
+		wrmsr_safe(MSR_IA32_MISC_ENABLE, (u32)misc_enable,
+			   (u32)(misc_enable >> 32));
+
+		/* Re-read monitor capability. */
+		if (cpuid_ecx(1) & 0x8) {
+			set_cpu_cap(c, X86_FEATURE_MWAIT);
+
+			printk(KERN_WARNING FW_WARN "CPU #%d: IA32_MISC_ENABLE.ENABLE_MONITOR_FSM was not set\n",
+			       c->cpu_index);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.6

