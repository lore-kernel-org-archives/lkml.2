Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1JSOvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:51:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38459 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab1JSOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:32 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 9/9] x86, RAS: Add an injector function
Date: Wed, 19 Oct 2011 16:51:06 +0200
Message-Id: <1319035866-29570-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Selectively inject either a real MCE or a sw-only version which
exercises the decoding code only. The hardware-injected MCE triggers a
machine check exception (#MC) so that the MCE handler can be bothered to
do something too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/ras/amd/mce-inject.c |   50 ++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/ras/amd/mce-inject.c b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
index 8646080..d798096 100644
--- a/arch/x86/kernel/cpu/ras/amd/mce-inject.c
+++ b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
@@ -129,6 +129,53 @@ static int inj_extcpu_set(void *data, u64 val)
 
 DEFINE_SIMPLE_ATTRIBUTE(extcpu_fops, inj_extcpu_get, inj_extcpu_set, "%llu\n");
 
+static void trigger_mce(void *info)
+{
+	asm volatile("int $18");
+}
+
+static void do_inject(void)
+{
+	u64 mcg_status = 0;
+	unsigned int cpu = i_mce.extcpu;
+	int this_cpu;
+	u8 b = i_mce.bank;
+
+	if (!(i_mce.inject_flags & MCJ_HW_MSR_INJECT)) {
+		amd_decode_mce(NULL, 0, &i_mce);
+		return;
+	}
+
+	/* prep MCE global settings for the injection */
+	mcg_status = MCG_STATUS_MCIP | MCG_STATUS_EIPV;
+
+	if (!(i_mce.status & MCI_STATUS_PCC))
+		mcg_status |= MCG_STATUS_RIPV;
+
+	this_cpu = get_cpu();
+
+	toggle_hw_mce_inject(cpu, true);
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCG_STATUS,
+		     (u32)mcg_status, (u32)(mcg_status >> 32));
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_STATUS(b),
+		     (u32)i_mce.status, (u32)(i_mce.status >> 32));
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_ADDR(b),
+		     (u32)i_mce.addr, (u32)(i_mce.addr >> 32));
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_MISC(b),
+		     (u32)i_mce.misc, (u32)(i_mce.misc >> 32));
+
+	toggle_hw_mce_inject(cpu, false);
+
+	smp_call_function_single(cpu, trigger_mce, NULL, 0);
+
+	put_cpu();
+
+}
+
 /*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
@@ -144,8 +191,7 @@ static int inj_bank_set(void *data, u64 val)
 		}
 
 	m->bank = val;
-
-	amd_decode_mce(NULL, 0, m);
+	do_inject();
 
 	return 0;
 }
-- 
1.7.4.rc2

