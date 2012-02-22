Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2BVDPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:15:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2BVDPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:15:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bleung@chromium.org designates 10.68.204.7 as permitted sender) smtp.mail=bleung@chromium.org; dkim=pass header.i=bleung@chromium.org
MIME-Version: 1.0
From: Benson Leung <bleung@chromium.org>
To: len.brown@intel.com, lucas.demarchi@profusion.mobi
Cc: linux-kernel@vger.kernel.org, vapier@chromium.org, bleung@chromium.org
Subject: [PATCH] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Tue, 21 Feb 2012 19:15:21 -0800
Message-Id: <1329880521-20868-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_energy_perf_policy reads cpuid using the cpuid instruction.
On i686, when building with PIC, this clobbers ebx, the PIC register.

Fixed using the same cpuid accessor function that vapier@chromium.org
created for i7z:
http://code.google.com/p/i7z/issues/detail?id=31

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 .../x86_energy_perf_policy.c                       |   25 ++++++++++++++++----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 33c5c7e..576fbf4 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -130,6 +130,23 @@ void cmdline(int argc, char **argv)
 	}
 }
 
+void cpuid (unsigned int info, unsigned int *eax, unsigned int *ebx,
+	    unsigned int *ecx, unsigned int *edx)
+{
+	unsigned int _eax = info, _ebx, _ecx, _edx;
+	asm volatile ("mov %%ebx, %%edi;" /* save ebx (for PIC) */
+		      "cpuid;"
+		      "mov %%ebx, %%esi;" /* pass to caller */
+		      "mov %%edi, %%ebx;" /* restore ebx */
+		      :"+a" (_eax), "=S" (_ebx), "=c" (_ecx), "=d" (_edx)
+		      :      /* inputs: eax is handled above */
+		      :"edi" /* clobbers: we hit edi directly */);
+	if (eax) *eax = _eax;
+	if (ebx) *ebx = _ebx;
+	if (ecx) *ecx = _ecx;
+	if (edx) *edx = _edx;
+}
+
 /*
  * validate_cpuid()
  * returns on success, quietly exits on failure (make verbose with -v)
@@ -141,9 +158,7 @@ void validate_cpuid(void)
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx),
-		"=d" (edx) : "a" (0));
-
+	cpuid(0, &max_level, &ebx, &ecx, &edx);
 	if (ebx != 0x756e6547 || edx != 0x49656e69 || ecx != 0x6c65746e) {
 		if (verbose)
 			fprintf(stderr, "%.4s%.4s%.4s != GenuineIntel",
@@ -151,7 +166,7 @@ void validate_cpuid(void)
 		exit(1);
 	}
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	cpuid(1, &fms, NULL, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -173,7 +188,7 @@ void validate_cpuid(void)
 	 * Support for MSR_IA32_ENERGY_PERF_BIAS
 	 * is indicated by CPUID.06H.ECX.bit3
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (6));
+	cpuid(6, &eax, &ebx, &ecx, &edx);
 	if (verbose)
 		printf("CPUID.06H.ECX: 0x%x\n", ecx);
 	if (!(ecx & (1 << 3))) {
-- 
1.7.1

