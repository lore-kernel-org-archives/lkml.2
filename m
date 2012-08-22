Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2HVXn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:43:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2HVXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:43:26 -0400
Date: Wed, 22 Aug 2012 16:43:12 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-5f5b747282c6cc57b91baba37f76de27398b9e60@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-9-git-send-email-bp@amd64.org>
References: <1344361461-10076-9-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD: Read CPUID(1).
 EAX on the correct cpu
Git-Commit-ID: 5f5b747282c6cc57b91baba37f76de27398b9e60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:43:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f5b747282c6cc57b91baba37f76de27398b9e60
Gitweb:     http://git.kernel.org/tip/5f5b747282c6cc57b91baba37f76de27398b9e60
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 25 Jul 2012 20:06:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:15:50 -0700

x86, microcode, AMD: Read CPUID(1).EAX on the correct cpu

Read the CPUID(1).EAX leaf at the correct cpu and use it to search the
equivalence table for matching microcode patch. No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-9-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8fdf7d9..25d34b1 100644
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
 
