Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab1JQPZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:25:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34632 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1JQPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:25:35 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, microcode, AMD: Add microcode revision to /proc/cpuinfo
Date: Mon, 17 Oct 2011 17:25:15 +0200
Message-Id: <1318865115-9904-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1318865115-9904-1-git-send-email-bp@amd64.org>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Enable microcode revision output for AMD after
506ed6b53e00ba303ad778122f08e1fca7cf5efb did it for Intel.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c       |    4 ++++
 arch/x86/kernel/microcode_amd.c |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b13ed39..c193b8d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -412,6 +412,8 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
+	u32 dummy;
+
 	early_init_amd_mc(c);
 
 	/*
@@ -446,6 +448,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	if (c != &boot_cpu_data)
 		return;
 
+	rdmsr(MSR_AMD64_PATCH_LEVEL, c->microcode, dummy);
+
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
 		if (c->x86 > 0x10 ||
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 591be0e..d494799 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -74,14 +74,13 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	u32 dummy;
 
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
 		pr_warning("CPU%d: family %d not supported\n", cpu, c->x86);
 		return -1;
 	}
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
+	csig->rev = c->microcode;
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
 	return 0;
@@ -130,6 +129,7 @@ static int apply_microcode_amd(int cpu)
 	int cpu_num = raw_smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	struct microcode_amd *mc_amd = uci->mc;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -150,6 +150,7 @@ static int apply_microcode_amd(int cpu)
 
 	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
+	c->microcode = rev;
 
 	return 0;
 }
-- 
1.7.4.rc2

