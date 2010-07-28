Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0G1X2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:28:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:48359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab0G1X17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:27:59 -0400
Date: Wed, 28 Jul 2010 23:27:41 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
References: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: AMD errata checking framework
Message-ID: <tip-d78d671db478eb8b14c78501c0cee1cc7baf6967@git.kernel.org>
Git-Commit-ID: d78d671db478eb8b14c78501c0cee1cc7baf6967
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 23:27:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d78d671db478eb8b14c78501c0cee1cc7baf6967
Gitweb:     http://git.kernel.org/tip/d78d671db478eb8b14c78501c0cee1cc7baf6967
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 28 Jul 2010 19:09:30 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 28 Jul 2010 13:12:04 -0700

x86, cpu: AMD errata checking framework

Errata are defined using the AMD_LEGACY_ERRATUM() or AMD_OSVW_ERRATUM()
macros. The latter is intended for newer errata that have an OSVW id
assigned, which it takes as first argument. Both take a variable number
of family-specific model-stepping ranges created by AMD_MODEL_RANGE().

Iff an erratum has an OSVW id, OSVW is available on the CPU, and the
OSVW id is known to the hardware, it is used to determine whether an
erratum is present. Otherwise, the model-stepping ranges are matched
against the current CPU to find out whether the erratum applies.

For certain special errata, the code using this framework might have to
conduct further checks to make sure an erratum is really (not) present.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h |   18 +++++++++++
 arch/x86/kernel/cpu/amd.c        |   60 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..5084c2f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1025,4 +1025,22 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+/*
+ * AMD errata checking
+ */
+#ifdef CONFIG_CPU_SUP_AMD
+extern bool cpu_has_amd_erratum(const int *);
+
+#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+#else
+#define cpu_has_amd_erratum(x)	(false)
+#endif /* CONFIG_CPU_SUP_AMD */
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 12b9cff..8066541 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -609,3 +609,63 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 };
 
 cpu_dev_register(amd_cpu_dev);
+
+/*
+ * AMD errata checking
+ *
+ * Errata are defined as arrays of ints using the AMD_LEGACY_ERRATUM() or
+ * AMD_OSVW_ERRATUM() macros. The latter is intended for newer errata that
+ * have an OSVW id assigned, which it takes as first argument. Both take a
+ * variable number of family-specific model-stepping ranges created by
+ * AMD_MODEL_RANGE(). Each erratum also has to be declared as extern const
+ * int[] in arch/x86/include/asm/processor.h.
+ *
+ * Example:
+ *
+ * const int amd_erratum_319[] =
+ *	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0x4, 0x2),
+ *			   AMD_MODEL_RANGE(0x10, 0x8, 0x0, 0x8, 0x0),
+ *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
+ */
+
+bool cpu_has_amd_erratum(const int *erratum)
+{
+	struct cpuinfo_x86 *cpu = &current_cpu_data;
+	int osvw_id = *erratum++;
+	u32 range;
+	u32 ms;
+
+	/*
+	 * If called early enough that current_cpu_data hasn't been initialized
+	 * yet, fall back to boot_cpu_data.
+	 */
+	if (cpu->x86 == 0)
+		cpu = &boot_cpu_data;
+
+	if (cpu->x86_vendor != X86_VENDOR_AMD)
+		return false;
+
+	if (osvw_id >= 0 && osvw_id < 65536 &&
+	    cpu_has(cpu, X86_FEATURE_OSVW)) {
+		u64 osvw_len;
+
+		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, osvw_len);
+		if (osvw_id < osvw_len) {
+			u64 osvw_bits;
+
+			rdmsrl(MSR_AMD64_OSVW_STATUS + (osvw_id >> 6),
+			    osvw_bits);
+			return osvw_bits & (1ULL << (osvw_id & 0x3f));
+		}
+	}
+
+	/* OSVW unavailable or ID unknown, match family-model-stepping range */
+	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	while ((range = *erratum++))
+		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
+		    (ms >= AMD_MODEL_RANGE_START(range)) &&
+		    (ms <= AMD_MODEL_RANGE_END(range)))
+			return true;
+
+	return false;
+}
