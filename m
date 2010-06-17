Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab0FQRHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:07:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:58521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0FQRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:07:03 -0400
Date: Thu, 17 Jun 2010 17:06:42 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com>
References: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: AMD errata checking framework
Message-ID: <tip-48327dd572aaf9924c3dc4f8ad3189d506b11390@git.kernel.org>
Git-Commit-ID: 48327dd572aaf9924c3dc4f8ad3189d506b11390
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 17:06:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48327dd572aaf9924c3dc4f8ad3189d506b11390
Gitweb:     http://git.kernel.org/tip/48327dd572aaf9924c3dc4f8ad3189d506b11390
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 16 Jun 2010 11:48:52 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Jun 2010 17:28:04 -0700

x86, cpu: AMD errata checking framework

Errata are defined using the AMD_LEGACY_ERRATUM() or AMD_OSVW_ERRATUM()
macros. The latter is intended for newer errata that have an OSVW id
assigned, which it takes as first argument. Both take a variable number
of family-specific model-stepping ranges created by AMD_MODEL_RANGE().

Iff an erratum has an OSVW id, OSVW is available on the CPU, and the
OSVW id is known to the hardware, it is used to determine whether an
erratum is present. Otherwise, the model-stepping ranges are matched
against the boot CPU to find out whether the erratum applies.

For certain special errata, the code using this framework might have to
conduct further checks to make sure an erratum is really (not) present.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |   30 ++++++++++++++++++++++
 arch/x86/kernel/cpu/amd.c        |   51 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..09fb3a1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1025,4 +1025,34 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+/*
+ * AMD errata checking
+ */
+#ifdef CONFIG_CPU_SUP_AMD
+extern bool cpu_has_amd_erratum(const struct cpuinfo_x86 *, bool, ...);
+
+/*
+ * Errata are defined using the AMD_LEGACY_ERRATUM() or AMD_OSVW_ERRATUM()
+ * macros. The latter is intended for newer errata that have an OSVW id
+ * assigned, which it takes as first argument. Both take a variable number
+ * of family-specific model-stepping ranges created by AMD_MODEL_RANGE().
+ *
+ * Example:
+ *
+ * #define AMD_ERRATUM_319						\
+ *	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0x4, 0x2),	\
+ *			   AMD_MODEL_RANGE(0x10, 0x8, 0x0, 0x8, 0x0),	\
+ *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0))
+ */
+
+#define AMD_LEGACY_ERRATUM(...)		false, __VA_ARGS__, 0
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	true, osvw_id, __VA_ARGS__, 0
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+#endif /* CONFIG_CPU_SUP_AMD */
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 12b9cff..07bdfe9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -14,6 +14,8 @@
 # include <asm/cacheflush.h>
 #endif
 
+#include <stdarg.h>
+
 #include "cpu.h"
 
 #ifdef CONFIG_X86_32
@@ -609,3 +611,52 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 };
 
 cpu_dev_register(amd_cpu_dev);
+
+
+/*
+ * Check for the presence of an AMD erratum.
+ * Arguments are defined in processor.h for each known erratum.
+ */
+bool cpu_has_amd_erratum(const struct cpuinfo_x86 *cpu, bool osvw, ...)
+{
+	va_list ap;
+	u32 range;
+	u32 ms;
+
+	if (cpu->x86_vendor != X86_VENDOR_AMD)
+		return false;
+
+	va_start(ap, osvw);
+
+	if (osvw) {
+		u16 osvw_id = va_arg(ap, int);
+
+		if (cpu_has(cpu, X86_FEATURE_OSVW)) {
+			u64 osvw_len;
+			rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, osvw_len);
+
+			if (osvw_id < osvw_len) {
+				u64 osvw_bits;
+				rdmsrl(MSR_AMD64_OSVW_STATUS + (osvw_id >> 6),
+				       osvw_bits);
+
+				va_end(ap);
+				return osvw_bits & (1ULL << (osvw_id & 0x3f));
+			}
+		}
+	}
+
+	/* OSVW unavailable or ID unknown, match family-model-stepping range */
+	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	while ((range = va_arg(ap, int))) {
+		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
+		    (ms >= AMD_MODEL_RANGE_START(range)) &&
+		    (ms <= AMD_MODEL_RANGE_END(range))) {
+			va_end(ap);
+			return true;
+		}
+	}
+
+	va_end(ap);
+	return false;
+}
