Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1JSOwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:52:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38450 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab1JSOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 7/9] x86, RAS: Add function enabling direct writes to MCE MSRs
Date: Wed, 19 Oct 2011 16:51:04 +0200
Message-Id: <1319035866-29570-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Normally, writing to MCE MSRs causes a #GP. Add a function to enable
direct accesses to those MSRs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/ras/amd/mce-inject.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/ras/amd/mce-inject.c b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
index fdec361..1b797bd 100644
--- a/arch/x86/kernel/cpu/ras/amd/mce-inject.c
+++ b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
@@ -53,6 +53,30 @@ DEFINE_SIMPLE_ATTRIBUTE(misc_fops, inj_misc_get, inj_misc_set, "%llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(addr_fops, inj_addr_get, inj_addr_set, "%llx\n");
 
 /*
+ * Caller needs to be make sure this cpu doesn't disappear
+ * from under us, i.e.: get_cpu/put_cpu.
+ */
+static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
+{
+	u32 l, h;
+	int err;
+
+	err = rdmsr_on_cpu(cpu, MSR_K7_HWCR, &l, &h);
+	if (err) {
+		printk(KERN_ERR "%s: error reading HWCR\n", __func__);
+		return err;
+	}
+
+	enable ? (l |= BIT(18)) : (l &= ~BIT(18));
+
+	err = wrmsr_on_cpu(cpu, MSR_K7_HWCR, l, h);
+	if (err)
+		printk(KERN_ERR "%s: error writing HWCR\n", __func__);
+
+	return err;
+}
+
+/*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
  */
-- 
1.7.4.rc2

