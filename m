Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2JHRMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:12:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60605 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2JHRLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:11:49 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/6] x86, RAS: Add attributes needed for HW injection
Date: Mon,  8 Oct 2012 19:11:32 +0200
Message-Id: <1349716293-16723-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349716293-16723-1-git-send-email-bp@amd64.org>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

hw_inject denotes whether we want to do a hardware or a software
injection and, in the case of hardware injection, we want to do that on
a particular cpu, thus the 'cpu' attribute.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/ras/amd/mce-inject.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c
index c0c811579ce9..b55d69fbd6e3 100644
--- a/arch/x86/ras/amd/mce-inject.c
+++ b/arch/x86/ras/amd/mce-inject.c
@@ -79,6 +79,59 @@ static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
 }
 
 /*
+ * HW or SW injection
+ */
+static int hw_inj_get(void *data, u64 *val)
+{
+	struct mce *m = (struct mce *)data;
+
+	*val = !!(m->inject_flags & MCJ_EXCEPTION);
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
+		m->inject_flags &= (u8)~MCJ_EXCEPTION;
+		break;
+
+	case 1:
+		m->inject_flags |= MCJ_EXCEPTION;
+		break;
+
+	default:
+		pr_err("%s: Only 0 or 1 allowed!\n", __func__);
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
+	if (val >= nr_cpu_ids || !cpu_online(val)) {
+		pr_err("%s: Invalid CPU: %llu\n", __func__, val);
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
@@ -119,6 +172,8 @@ struct dfs_node {
 	{ .name = "misc",	.fops = &misc_fops },
 	{ .name = "addr",	.fops = &addr_fops },
 	{ .name = "bank",	.fops = &bank_fops },
+	{ .name = "hw_inject",	.fops = &hw_inj_fops },
+	{ .name = "cpu",	.fops = &extcpu_fops },
 };
 
 static int __init init_mce_inject(void)
-- 
1.8.0.rc0.18.gf84667d

