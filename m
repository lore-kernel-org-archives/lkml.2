Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1EISgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:36:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55050 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1EISgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:40 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 6/6] EDAC, MCE, AMD: Add an injector function
Date: Mon,  9 May 2011 20:35:55 +0200
Message-Id: <1304966155-9841-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304966155-9841-1-git-send-email-bp@amd64.org>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
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
 drivers/edac/mce_amd_inj.c |   50 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 592871f..45e8122 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
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
+	if (!(i_mce.inject_flags & MCJ_HW_INJECT)) {
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
@@ -146,8 +193,7 @@ static int inj_bank_set(void *data, u64 val)
 		}
 
 	m->bank = val;
-
-	amd_decode_mce(NULL, 0, m);
+	do_inject();
 
 	return 0;
 }
-- 
1.7.4.rc2

