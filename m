Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2HCQiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:38:46 -0400
Received: from osrc3.amd.com ([217.9.48.20]:47871 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2HCQiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:38:03 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/4] x86, CPU: Preset default tlb_flushall_shift on AMD
Date: Fri,  3 Aug 2012 18:37:49 +0200
Message-Id: <1344011869-21868-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344011869-21868-1-git-send-email-bp@amd64.org>
References: <1344011869-21868-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Run the mprotect.c microbenchmark on all our families >= K8 and preset
the flushall shift variable accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 48e9d33245d9..2da9e1d9838b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -737,6 +737,17 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 }
 #endif
 
+static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_invlpg)
+		return;
+
+	tlb_flushall_shift = 5;
+
+	if (c->x86 <= 0x11)
+		tlb_flushall_shift = 4;
+}
+
 static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 {
 	u32 ebx, eax, ecx, edx;
@@ -785,6 +796,8 @@ static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 		tlb_lli_2m[ENTRIES] = eax & mask;
 
 	tlb_lli_4m[ENTRIES] = tlb_lli_2m[ENTRIES] >> 1;
+
+	cpu_set_tlb_flushall_shift(c);
 }
 
 static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
-- 
1.7.11.rc1

