Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1DOPVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:21:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53138 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1DOPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:21:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 4/4] EDAC, MCE, AMD: Add an injector function
Date: Fri, 15 Apr 2011 17:20:27 +0200
Message-Id: <1302880827-22457-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1302880827-22457-1-git-send-email-bp@amd64.org>
References: <1302880827-22457-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Selectively inject either a real MCE or a sw-only version to verify only
the decoding code. The hardware-injected MCE triggers the machine check
exception so that the MCE handler can be exercised too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd_inj.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 3a50e0c..1a05d45 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -160,6 +160,43 @@ static ssize_t edac_cpu_store(struct kobject *kobj, struct edac_mce_attr *attr,
 
 EDAC_MCE_ATTR(cpu, 0644, edac_cpu_show, edac_cpu_store);
 
+static void trigger_mce(void *info)
+{
+	asm volatile("int $18");
+}
+
+static void do_inject(void)
+{
+	unsigned int cpu = i_mce.extcpu;
+	int this_cpu;
+	u8 b = i_mce.bank;
+
+
+	/* HW injection */
+	if (!(i_mce.inject_flags & MCJ_HW_INJECT)) {
+		amd_decode_mce(NULL, 0, &i_mce);
+		return;
+	}
+
+	this_cpu = get_cpu();
+
+	toggle_hw_mce_inject(cpu, true);
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_STATUS(b),
+		     (u32)i_mce.status, (u32)(i_mce.status >> 32));
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_ADDR(b),
+		     (u32)i_mce.addr, (u32)(i_mce.addr >> 32));
+
+	wrmsr_on_cpu(cpu, MSR_IA32_MCx_MISC(b),
+		     (u32)i_mce.misc, (u32)(i_mce.misc >> 32));
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
@@ -185,7 +222,7 @@ static ssize_t edac_inject_bank_store(struct kobject *kobj,
 
 	i_mce.bank = value;
 
-	amd_decode_mce(NULL, 0, &i_mce);
+	do_inject();
 
 	return count;
 }
-- 
1.7.4.rc2

