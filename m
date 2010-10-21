Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab0JUODD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:03:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0JUODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:03:01 -0400
Date: Thu, 21 Oct 2010 16:02:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mtrr changes for v2.6.37
Message-ID: <20101021140249.GA8226@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mtrr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mtrr-for-linus

 Thanks,

	Ingo

------------------>
Venkatesh Pallipadi (2):
      x86, mtrr: Refactor MTRR type overlap check code
      x86, mtrr: Support mtrr lookup for range spanning across MTRR range


 arch/x86/kernel/cpu/mtrr/generic.c |  128 +++++++++++++++++++++++++++++------
 1 files changed, 106 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 7d28d7d..9f27228 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -64,18 +64,59 @@ static inline void k8_check_syscfg_dram_mod_en(void)
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
- * Returns the effective MTRR type for the region
- * Error returns:
- * - 0xFE - when the range is "not entirely covered" by _any_ var range MTRR
- * - 0xFF - when MTRR is not enabled
+ * Check and return the effective type for MTRR-MTRR type overlap.
+ * Returns 1 if the effective type is UNCACHEABLE, else returns 0
  */
-u8 mtrr_type_lookup(u64 start, u64 end)
+static int check_type_overlap(u8 *prev, u8 *curr)
+{
+	if (*prev == MTRR_TYPE_UNCACHABLE || *curr == MTRR_TYPE_UNCACHABLE) {
+		*prev = MTRR_TYPE_UNCACHABLE;
+		*curr = MTRR_TYPE_UNCACHABLE;
+		return 1;
+	}
+
+	if ((*prev == MTRR_TYPE_WRBACK && *curr == MTRR_TYPE_WRTHROUGH) ||
+	    (*prev == MTRR_TYPE_WRTHROUGH && *curr == MTRR_TYPE_WRBACK)) {
+		*prev = MTRR_TYPE_WRTHROUGH;
+		*curr = MTRR_TYPE_WRTHROUGH;
+	}
+
+	if (*prev != *curr) {
+		*prev = MTRR_TYPE_UNCACHABLE;
+		*curr = MTRR_TYPE_UNCACHABLE;
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Error/Semi-error returns:
+ * 0xFF - when MTRR is not enabled
+ * *repeat == 1 implies [start:end] spanned across MTRR range and type returned
+ *		corresponds only to [start:*partial_end].
+ *		Caller has to lookup again for [*partial_end:end].
+ */
+static u8 __mtrr_type_lookup(u64 start, u64 end, u64 *partial_end, int *repeat)
 {
 	int i;
 	u64 base, mask;
 	u8 prev_match, curr_match;
 
+	*repeat = 0;
 	if (!mtrr_state_set)
 		return 0xFF;
 
@@ -126,8 +167,34 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 
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
@@ -138,21 +205,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 			continue;
 		}
 
-		if (prev_match == MTRR_TYPE_UNCACHABLE ||
-		    curr_match == MTRR_TYPE_UNCACHABLE) {
-			return MTRR_TYPE_UNCACHABLE;
-		}
-
-		if ((prev_match == MTRR_TYPE_WRBACK &&
-		     curr_match == MTRR_TYPE_WRTHROUGH) ||
-		    (prev_match == MTRR_TYPE_WRTHROUGH &&
-		     curr_match == MTRR_TYPE_WRBACK)) {
-			prev_match = MTRR_TYPE_WRTHROUGH;
-			curr_match = MTRR_TYPE_WRTHROUGH;
-		}
-
-		if (prev_match != curr_match)
-			return MTRR_TYPE_UNCACHABLE;
+		if (check_type_overlap(&prev_match, &curr_match))
+			return curr_match;
 	}
 
 	if (mtrr_tom2) {
@@ -166,6 +220,36 @@ u8 mtrr_type_lookup(u64 start, u64 end)
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
