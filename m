Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1JSOwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:52:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38455 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1JSOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 8/9] x86, RAS: Add attributes needed for HW injection
Date: Wed, 19 Oct 2011 16:51:05 +0200
Message-Id: <1319035866-29570-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

hw_inject denotes whether we want to do a hardware or a software
injection and, in the case of hardware injection, we want to do that on
a particular cpu, thus the 'cpu' attribute.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/ras/amd/mce-inject.c |   55 ++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/ras/amd/mce-inject.c b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
index 1b797bd..8646080 100644
--- a/arch/x86/kernel/cpu/ras/amd/mce-inject.c
+++ b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
@@ -77,6 +77,59 @@ static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
 }
 
 /*
+ * HW or SW injection
+ */
+static int hw_inj_get(void *data, u64 *val)
+{
+	struct mce *m = (struct mce *)data;
+
+	*val = !!(m->inject_flags & MCJ_HW_MSR_INJECT);
+
+	return 0;
+}
+
+static int hw_inj_set(void *data, u64 val)
+{
+	struct mce *m = (struct mce *)data;
+
+	switch (val) {
+	case 0:
+		m->inject_flags &= (u8)~MCJ_HW_MSR_INJECT;
+		break;
+
+	case 1:
+		m->inject_flags |= MCJ_HW_MSR_INJECT;
+		break;
+
+	default:
+		printk(KERN_ERR "%s: Only 0 or 1 allowed!\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hw_inj_fops, hw_inj_get, hw_inj_set, "%llu\n");
+
+/*
+ * On which CPU to inject?
+ */
+MCE_INJECT_GET(extcpu);
+
+static int inj_extcpu_set(void *data, u64 val)
+{
+	struct mce *m = (struct mce *)data;
+
+	if (val >= num_online_cpus()) {
+		printk(KERN_ERR "%s: Non-existent CPU: %llu\n", __func__, val);
+		return -EINVAL;
+	}
+	m->extcpu = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(extcpu_fops, inj_extcpu_get, inj_extcpu_set, "%llu\n");
+
+/*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
  */
@@ -116,6 +169,8 @@ struct dfs_node {
 	{ .name = "misc",	.fops = &misc_fops },
 	{ .name = "addr",	.fops = &addr_fops },
 	{ .name = "bank",	.fops = &bank_fops },
+	{ .name = "hw_inject",	.fops = &hw_inj_fops },
+	{ .name = "cpu",	.fops = &extcpu_fops },
 };
 
 static int __init init_mce_inject(void)
-- 
1.7.4.rc2

