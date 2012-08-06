Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2HFRBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:01:13 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57559 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2HFRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:00:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v1 2/4] x86, CPU: Push TLB detection CPUID check down
Date: Mon,  6 Aug 2012 19:00:37 +0200
Message-Id: <1344272439-29080-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344272439-29080-1-git-send-email-bp@amd64.org>
References: <1344272439-29080-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Push the max CPUID leaf check into the ->detect_tlb function and remove
general test case from the generic path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/common.c | 3 +--
 arch/x86/kernel/cpu/intel.c  | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d239977f361f..080f4a737e3e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -940,8 +940,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	if (boot_cpu_data.cpuid_level >= 2)
-		cpu_detect_tlb(&boot_cpu_data);
+	cpu_detect_tlb(&boot_cpu_data);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 0a4ce2980a5a..198e019a531a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -648,6 +648,10 @@ static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 	int i, j, n;
 	unsigned int regs[4];
 	unsigned char *desc = (unsigned char *)regs;
+
+	if (c->cpuid_level < 2)
+		return;
+
 	/* Number of times to iterate */
 	n = cpuid_eax(2) & 0xFF;
 
-- 
1.7.11.rc1

