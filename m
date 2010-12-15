Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab0LODoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:44:12 -0500
Received: from relais.videotron.ca ([24.201.245.36]:50068 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0LODoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:44:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 14 Dec 2010 22:44:09 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] clarify a usage constraint for cnt32_to_63()
Message-id: <alpine.LFD.2.00.1012142219240.10437@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cnt32_to_63 algorithm relies on proper counter data evaluation
ordering to work properly. This was missing from the provided
documentation.

Let's augment the documentation with the missing usage constraint and
fix the only instance that got it wrong.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: David Howells <dhowells@redhat.com>

diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 8f7f6d2..6090f46 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -51,18 +51,15 @@ unsigned long long sched_clock(void)
 		unsigned long long ll;
 		unsigned l[2];
 	} tsc64, result;
-	unsigned long tsc, tmp;
+	unsigned long tmp;
 	unsigned product[3]; /* 96-bit intermediate value */
 
-	/* read the TSC value
-	 */
-	tsc = 0 - get_cycles(); /* get_cycles() counts down */
-
-	/* expand to 64-bits.
+	/* expand the tsc value to 64-bits.
 	 * - sched_clock() must be called once a minute or better or the
 	 *   following will go horribly wrong - see cnt32_to_63()
+	 * - get_cycles() counts down
 	 */
-	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
+	tsc64.ll = cnt32_to_63(0 - get_cycles()) & 0x7fffffffffffffffULL;
 
 	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
 	 * intermediate
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index 7605fdd..e3d8bf2 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -61,13 +61,31 @@ union cnt32_to_63 {
  *
  * 2) this code must not be preempted for a duration longer than the
  *    32-bit counter half period minus the longest period between two
- *    calls to this code.
+ *    calls to this code;
  *
  * Those requirements ensure proper update to the state bit in memory.
  * This is usually not a problem in practice, but if it is then a kernel
  * timer should be scheduled to manage for this code to be executed often
  * enough.
  *
+ * And finally:
+ *
+ * 3) the cnt_lo argument must be seen as a globally incrementing value,
+ *    meaning that it should be a direct reference to the counter data which
+ *    can be evaluated according to a specific ordering within the macro,
+ *    and not the result of a previous evaluation stored in a variable.
+ *
+ * For example, this is wrong:
+ *
+ *	u32 partial = get_hw_count();
+ *	u64 full = cnt32_to_63(partial);
+ *	return full;
+ *
+ * This is fine:
+ *
+ *	u64 full = cnt32_to_63(get_hw_count());
+ *	return full;
+ *
  * Note that the top bit (bit 63) in the returned value should be considered
  * as garbage.  It is not cleared here because callers are likely to use a
  * multiplier on the returned value which can get rid of the top bit
