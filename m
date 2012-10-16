Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2JPOyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:54:12 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45247 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab2JPOw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:52:59 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 6/6] x86, RAS: Add an injector function
Date: Tue, 16 Oct 2012 16:52:55 +0200
Message-Id: <1350399175-14477-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350399175-14477-1-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
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
 arch/x86/ras/amd/mce-inject.c | 50 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c
index b55d69fbd6e3..24a1c870cd18 100644
--- a/arch/x86/ras/amd/mce-inject.c
+++ b/arch/x86/ras/amd/mce-inject.c
@@ -131,6 +131,53 @@ static int inj_extcpu_set(void *data, u64 val)
 
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
+	if (!(i_mce.inject_flags & MCJ_EXCEPTION)) {
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
@@ -147,8 +194,7 @@ static int inj_bank_set(void *data, u64 val)
 	}
 
 	m->bank = val;
-
-	amd_decode_mce(NULL, 0, m);
+	do_inject();
 
 	return 0;
 }
-- 
1.8.0.rc2.4.g42e55a5

