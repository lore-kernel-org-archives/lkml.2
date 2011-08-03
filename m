Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1HCPrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:47:39 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:45307 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952Ab1HCPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:47:27 -0400
X-AuditID: 1209190d-b7be0ae000000a16-ca-4e396ced4df5
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't already
Date: Wed,  3 Aug 2011 11:47:17 -0400
Message-Id: <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312386029.git.luto@mit.edu>
References: <cover.1312386029.git.luto@mit.edu>
In-Reply-To: <cover.1312386029.git.luto@mit.edu>
References: <cover.1312386029.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsUixCmqrfs2x9LPoO2VmEXflaPsFm3THC0u
	75rDZvFjw2NWBxaPnbPusnss3vOSyWPTqk42j8+b5AJYorhsUlJzMstSi/TtErgy3n3ax16w
	havi9+Um1gbGVRxdjJwcEgImEgsudbNA2GISF+6tZ+ti5OIQEtjHKPHr51UmCGc9o8S2Z2+h
	nKdMEncfvmACaWETUJHoWPoAzBYRMJDYsvIFK4jNLOAqcWDbU0YQW1jAT+Lw89NgcRYBVYnO
	f7eZQWxegSCJVydWQK2Wkzhy+TnYHE6gOcdbF4LZQgL6En//LmDFJT6BUWABI8MqRtmU3Crd
	3MTMnOLUZN3i5MS8vNQiXSO93MwSvdSU0k2M4DCU5N3B+O6g0iFGAQ5GJR7e4iRLPyHWxLLi
	ytxDjJIcTEqivKm5QCG+pPyUyozE4oz4otKc1OJDjBIczEoivO28QDnelMTKqtSifJiUNAeL
	kjivmvd/XyGB9MSS1OzU1ILUIpisDAeHkgTvR2C8CQkWpaanVqRl5pQgpJk4OEGG8wAN3wRS
	w1tckJhbnJkOkT/FqCglznseJCEAksgozYPrhaWJV4ziQK8I83bGA1XxAFMMXPcroMFMQIP/
	v7cAGVySiJCSamA8/cKJ4SeHO4MAw/PJ5azHHYp3eXZvqHoveUY55Nb8Gw6zpyy89dqSw6Hw
	/93KjSvKUtsLAnhuPoz9OaN0f3rh1vCabYs/yNbHr4lOlbM4sCqDMdbLyvSEkJjW1VQ3hgL7
	1nO9c2RM5m3d86BfdDnzsW6pR9ffznn65ObUrbVW2wqdvjHejG5UYinOSDTUYi4qTgQAPdCD
	Ue4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Sandy Bridge machine with an Intel BIOS that enables
monitor/mwait on all but the boot CPU.  With this patch, intel_idle
works.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/cpu/intel.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 6b20fef..a3339a1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -487,6 +487,26 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
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
+		if (cpuid_ecx(1) & 0x8)
+			set_cpu_cap(c, X86_FEATURE_MWAIT);
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.6

