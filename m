Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab0CaAAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:00:44 -0400
Received: from kroah.org ([198.145.64.141]:45451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab0C3XSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:03 2010
Message-Id: <20100330225702.878171130@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [095/116] x86, amd: Restrict usage of c1e_idle()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 035a02c1e1de31888e8b6adac0ff667971ac04db upstream.

Currently c1e_idle returns true for all CPUs greater than or equal to
family 0xf model 0x40. This covers too many CPUs.

Meanwhile a respective erratum for the underlying problem was filed
(#400). This patch adds the logic to check whether erratum #400
applies to a given CPU.
Especially for CPUs where SMI/HW triggered C1e is not supported,
c1e_idle() doesn't need to be used. We can check this by looking at
the respective OSVW bit for erratum #400.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100319110922.GA19614@alberich.amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/msr-index.h |    2 ++
 arch/x86/kernel/process.c        |   32 ++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -104,6 +104,8 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
+#define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
+#define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -439,21 +439,37 @@ static int __cpuinit mwait_usable(const
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
+
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
 
-	return 1;
+no_c1e_idle:
+	return 0;
 }
 
 static cpumask_var_t c1e_mask;


