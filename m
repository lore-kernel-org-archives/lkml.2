Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2DYPw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:52:56 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50999 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2DYPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:52:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] x86, MCE, AMD: Disable error thresholding bank 4 on some models
Date: Wed, 25 Apr 2012 17:52:03 +0200
Message-Id: <1335369123-23196-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1335369123-23196-1-git-send-email-bp@amd64.org>
References: <1335369123-23196-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Turn off MC4_MISC thresholding banks on models which have them but that
particular processor implementation does not supply applicable error
sources to be counted.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09c087d..888fbf9d0adf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1423,6 +1423,43 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 */
 		 if (c->x86 == 6 && banks > 0)
 			mce_banks[0].ctl = 0;
+
+		 /*
+		  * Turn off MC4_MISC thresholding banks on those models since
+		  * they're not supported there.
+		  */
+		 if (c->x86 == 0x15 &&
+		     (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
+			 int i;
+			 u64 val, hwcr;
+			 bool need_toggle;
+			 u32 msrs[] = {
+				0x00000413, /* MC4_MISC0 */
+				0xc0000408, /* MC4_MISC1 */
+			 };
+
+			 rdmsrl(MSR_K7_HWCR, hwcr);
+
+			 /* McStatusWrEn has to be set */
+			 need_toggle = !(hwcr & BIT(18));
+
+			 if (need_toggle)
+				 wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
+
+			 for (i = 0; i < ARRAY_SIZE(msrs); i++) {
+				 rdmsrl(msrs[i], val);
+
+				 /* CntP bit set? */
+				 if (val & BIT(62)) {
+					 val &= ~BIT(62);
+					 wrmsrl(msrs[i], val);
+				 }
+			 }
+
+			 /* restore old settings */
+			 if (need_toggle)
+				 wrmsrl(MSR_K7_HWCR, hwcr);
+		 }
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
-- 
1.7.9.3.362.g71319

