Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0IJXoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:44:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:56914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab0IJXoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:44:12 -0400
Date: Fri, 10 Sep 2010 23:43:53 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mark.langsdorf@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mark.langsdorf@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
In-Reply-To: <1284159350-19841-3-git-send-email-venki@google.com>
References: <1284159350-19841-3-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] x86, mtrr: Support mtrr lookup for range spanning across MTRR range
Message-ID: <tip-351e5a703ad994405bd900da330823d3b4a372e0@git.kernel.org>
Git-Commit-ID: 351e5a703ad994405bd900da330823d3b4a372e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 23:43:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  351e5a703ad994405bd900da330823d3b4a372e0
Gitweb:     http://git.kernel.org/tip/351e5a703ad994405bd900da330823d3b4a372e0
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Fri, 10 Sep 2010 15:55:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 10 Sep 2010 16:11:20 -0700

x86, mtrr: Support mtrr lookup for range spanning across MTRR range

mtrr_type_lookup [start:end] looked up the resultant MTRR type for that
range, based on fixed and all variable MTRR ranges. It did check for multiple
MTRR var ranges overlapping [start:end] and returned the net type.

However, if the [start:end] range spanned across any var MTRR range,
mtrr_type_lookup would return an error return of 0xFE. This was based on
typical usage of mtrr_type_lookup in PAT mapping, where region being
mapped would not normally span across MTRR ranges and also trying
to keep the code simple.

Mark recently reported the problem with this limitation. When there are
two continguous MTRR's of type "writeback" and if there is a memory mapping
over a region starting in one MTRR range and ending in another MTRR range,
such mapping will fallback to "uncached" due to the above limitation.

Change below adds support for such lookups spanning multiple MTRR ranges.
We now have a wrapper mtrr_type_lookup that dynamically splits such a region
into smaller chunks that fit within one MTRR range and does a
__mtrr_type_lookup on it and combine the results later.

Reported-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <1284159350-19841-3-git-send-email-venki@google.com>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |   84 +++++++++++++++++++++++++++++++++---
 1 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 14f4f0c..9f27228 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -64,6 +64,18 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	}
 }
 
+/* Get the size of contiguous MTRR range */
+static u64 get_mtrr_size(u64 mask)
+{
+	u64 size;
+
+	mask >>= PAGE_SHIFT;
+	mask |= size_or_mask;
+	size = -mask;
+	size <<= PAGE_SHIFT;
+	return size;
+}
+
 /*
  * Check and return the effective type for MTRR-MTRR type overlap.
  * Returns 1 if the effective type is UNCACHEABLE, else returns 0
@@ -92,17 +104,19 @@ static int check_type_overlap(u8 *prev, u8 *curr)
 }
 
 /*
- * Returns the effective MTRR type for the region
- * Error returns:
- * - 0xFE - when the range is "not entirely covered" by _any_ var range MTRR
- * - 0xFF - when MTRR is not enabled
+ * Error/Semi-error returns:
+ * 0xFF - when MTRR is not enabled
+ * *repeat == 1 implies [start:end] spanned across MTRR range and type returned
+ *		corresponds only to [start:*partial_end].
+ *		Caller has to lookup again for [*partial_end:end].
  */
-u8 mtrr_type_lookup(u64 start, u64 end)
+static u8 __mtrr_type_lookup(u64 start, u64 end, u64 *partial_end, int *repeat)
 {
 	int i;
 	u64 base, mask;
 	u8 prev_match, curr_match;
 
+	*repeat = 0;
 	if (!mtrr_state_set)
 		return 0xFF;
 
@@ -153,8 +167,34 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 
 		start_state = ((start & mask) == (base & mask));
 		end_state = ((end & mask) == (base & mask));
-		if (start_state != end_state)
-			return 0xFE;
+
+		if (start_state != end_state) {
+			/*
+			 * We have start:end spanning across an MTRR.
+			 * We split the region into
+			 * either
+			 * (start:mtrr_end) (mtrr_end:end)
+			 * or
+			 * (start:mtrr_start) (mtrr_start:end)
+			 * depending on kind of overlap.
+			 * Return the type for first region and a pointer to
+			 * the start of second region so that caller will
+			 * lookup again on the second region.
+			 * Note: This way we handle multiple overlaps as well.
+			 */
+			if (start_state)
+				*partial_end = base + get_mtrr_size(mask);
+			else
+				*partial_end = base;
+
+			if (unlikely(*partial_end <= start)) {
+				WARN_ON(1);
+				*partial_end = start + PAGE_SIZE;
+			}
+
+			end = *partial_end - 1; /* end is inclusive */
+			*repeat = 1;
+		}
 
 		if ((start & mask) != (base & mask))
 			continue;
@@ -180,6 +220,36 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	return mtrr_state.def_type;
 }
 
+/*
+ * Returns the effective MTRR type for the region
+ * Error return:
+ * 0xFF - when MTRR is not enabled
+ */
+u8 mtrr_type_lookup(u64 start, u64 end)
+{
+	u8 type, prev_type;
+	int repeat;
+	u64 partial_end;
+
+	type = __mtrr_type_lookup(start, end, &partial_end, &repeat);
+
+	/*
+	 * Common path is with repeat = 0.
+	 * However, we can have cases where [start:end] spans across some
+	 * MTRR range. Do repeated lookups for that case here.
+	 */
+	while (repeat) {
+		prev_type = type;
+		start = partial_end;
+		type = __mtrr_type_lookup(start, end, &partial_end, &repeat);
+
+		if (check_type_overlap(&prev_type, &type))
+			return type;
+	}
+
+	return type;
+}
+
 /* Get the MSR pair relating to a var range */
 static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
