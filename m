Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0CSLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:09:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:41356 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0CSLJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hAiME3H0/CBGGQdwZDFcuNZCIoCb5P4WcMf2Wcch1vb9B8Mo9PAmLyMoCgJ1wuTTgj
         MnAGrDfd/ykW9rlGDrwrqqRQwAShZHvIFgRivjabk1IK6N1qODDyrvqn/A4iE2cPcMer
         7bGWv1wcPQ5P+Kg6iEkLDUqYMQVWA27exgLeU=
Date: Fri, 19 Mar 2010 12:09:22 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, amd: Restrict usage of c1e_idle()
Message-ID: <20100319110922.GA19614@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Currently c1e_idle returns true for all CPUs greater than or equal to
family 0xf model 0x40. This covers too many CPUs.

Meanwhile a respective erratum for the underlying problem was filed
(#400). This patch adds the logic to check whether erratum #400
applies to a given CPU.
Especially for CPUs where SMI/HW triggered C1e is not supported,
c1e_idle() doesn't need to be used. We can check this by looking at
the respective OSVW bit for erratum #400.

Cc: <stable@kernel.org> # .32.x .33.x
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/msr-index.h |    2 ++
 arch/x86/kernel/process.c        |   32 ++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1cd58cd..4604e6a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -105,6 +105,8 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
+#define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
+#define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ad95406..28ad9f4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -526,21 +526,37 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 }
 
 /*
- * Check for AMD CPUs, which have potentially C1E support
+ * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
+ * For more information see
+ * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
+ * - Erratum #365 for family 0x11 (not affected because C1e not in use)
  */
 static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 {
+	u64 val;
 	if (c->x86_vendor != X86_VENDOR_AMD)
-		return 0;
-
-	if (c->x86 < 0x0F)
-		return 0;
+		goto no_c1e_idle;
 
 	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
+	if (c->x86 == 0x0F && c->x86_model >= 0x40)
+		return 1;
 
-	return 1;
+	if (c->x86 == 0x10) {
+		/*
+		 * check OSVW bit for CPUs that are not affected
+		 * by erratum #400
+		 */
+		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+		if (val >= 2) {
+			rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+			if (!(val & BIT(1)))
+				goto no_c1e_idle;
+		}
+		return 1;
+	}
+
+no_c1e_idle:
+	return 0;
 }
 
 static cpumask_var_t c1e_mask;
-- 
1.6.4.2

