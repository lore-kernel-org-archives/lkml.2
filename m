Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2HGRog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35598 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab2HGRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 08/12] x86, microcode, AMD: Read CPUID(1).EAX on the correct cpu
Date: Tue,  7 Aug 2012 19:44:17 +0200
Message-Id: <1344361461-10076-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Read the CPUID(1).EAX leaf at the correct cpu and use it to search the
equivalence table for matching microcode patch. No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8fdf7d99b804..25d34b177482 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -82,6 +82,7 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
+	csig->sig = cpuid_eax(0x00000001);
 	csig->rev = c->microcode;
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
@@ -118,16 +119,15 @@ static unsigned int verify_ucode_size(int cpu, u32 patch_size,
 	return patch_size;
 }
 
-static u16 find_equiv_id(void)
+static u16 find_equiv_id(unsigned int cpu)
 {
-	unsigned int current_cpu_id, i = 0;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int i = 0;
 
 	BUG_ON(equiv_cpu_table == NULL);
 
-	current_cpu_id = cpuid_eax(0x00000001);
-
 	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (current_cpu_id == equiv_cpu_table[i].installed_cpu)
+		if (uci->cpu_sig.sig == equiv_cpu_table[i].installed_cpu)
 			return equiv_cpu_table[i].equiv_cpu;
 
 		i++;
@@ -150,7 +150,7 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 	patch_size = *(u32 *)(ucode_ptr + 4);
 	*current_size = patch_size + SECTION_HDR_SIZE;
 
-	equiv_cpu_id = find_equiv_id();
+	equiv_cpu_id = find_equiv_id(cpu);
 	if (!equiv_cpu_id)
 		return 0;
 
-- 
1.7.11.rc1

