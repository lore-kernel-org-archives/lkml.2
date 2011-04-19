Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1DSUsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:48:32 -0400
Received: from kroah.org ([198.145.64.141]:58948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1DSUmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:17 2011
Message-Id: <20110419204117.882676010@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [11/28] x86, cpu: AMD errata checking framework
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Rosenfeld <hans.rosenfeld@amd.com>

commit d78d671db478eb8b14c78501c0cee1cc7baf6967 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/processor.h |   18 +++++++++++
 arch/x86/kernel/cpu/amd.c        |   60 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1029,4 +1029,22 @@ unsigned long calc_aperfmperf_ratio(stru
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
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -610,3 +610,63 @@ static const struct cpu_dev __cpuinitcon
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


