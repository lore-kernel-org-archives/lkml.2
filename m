Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1EEQu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:50:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57992 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1EEQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:50:14 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/4] EDAC, MCE, AMD: Add an injector function
Date: Thu,  5 May 2011 18:49:36 +0200
Message-Id: <1304614176-7063-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304614176-7063-1-git-send-email-bp@amd64.org>
References: <1304614176-7063-1-git-send-email-bp@amd64.org>
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
 drivers/edac/mce_amd_inj.c |   49 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 3a50e0c..82cbf8c 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -160,6 +160,53 @@ static ssize_t edac_cpu_store(struct kobject *kobj, struct edac_mce_attr *attr,
 
 EDAC_MCE_ATTR(cpu, 0644, edac_cpu_show, edac_cpu_store);
 
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
@@ -185,7 +232,7 @@ static ssize_t edac_inject_bank_store(struct kobject *kobj,
 
 	i_mce.bank = value;
 
-	amd_decode_mce(NULL, 0, &i_mce);
+	do_inject();
 
 	return count;
 }
-- 
1.7.4.rc2

