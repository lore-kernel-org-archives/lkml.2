Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1EISgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:36:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55033 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1EISgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:32 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 3/6] EDAC, MCE, AMD: Add function to enable direct write to MCE MSRs
Date: Mon,  9 May 2011 20:35:52 +0200
Message-Id: <1304966155-9841-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304966155-9841-1-git-send-email-bp@amd64.org>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Normally, writing to MCE MSRs causes a #GP. Add a function to enable
direct access to those MSRs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd_inj.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index a4987e0..eb36e15 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -30,6 +30,30 @@ static struct edac_mce_attr mce_attr_##_name = __ATTR(_name, _mode, _show, _stor
 static struct kobject *mce_kobj;
 
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
  * Collect all the MCi_XXX settings
  */
 static struct mce i_mce;
-- 
1.7.4.rc2

