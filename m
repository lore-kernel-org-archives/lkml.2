Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2JPOxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:53:05 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45243 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab2JPOw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:52:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 4/6] x86, RAS: Add function enabling direct writes to MCE MSRs
Date: Tue, 16 Oct 2012 16:52:53 +0200
Message-Id: <1350399175-14477-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350399175-14477-1-git-send-email-bp@amd64.org>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Normally, writing to MCE MSRs causes a #GP. Add a function to enable
direct accesses to those MSRs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/ras/amd/mce-inject.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c
index 66969eab5591..c0c811579ce9 100644
--- a/arch/x86/ras/amd/mce-inject.c
+++ b/arch/x86/ras/amd/mce-inject.c
@@ -55,6 +55,30 @@ DEFINE_SIMPLE_ATTRIBUTE(misc_fops, inj_misc_get, inj_misc_set, "%llx\n");
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
+		pr_err("%s: error reading HWCR\n", __func__);
+		return err;
+	}
+
+	enable ? (l |= BIT(18)) : (l &= ~BIT(18));
+
+	err = wrmsr_on_cpu(cpu, MSR_K7_HWCR, l, h);
+	if (err)
+		pr_err("%s: error writing HWCR\n", __func__);
+
+	return err;
+}
+
+/*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
  */
-- 
1.8.0.rc2.4.g42e55a5

