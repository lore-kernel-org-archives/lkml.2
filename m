Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1GUQGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:06:30 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:46844 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1GUQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:06:29 -0400
Date: Thu, 21 Jul 2011 20:06:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86, perf: P4 PMU - Fix typos in comments and style
 cleanup
Message-ID: <20110721160625.GX7492@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes typos in comments, renames obscure
p4_event_alias::original and ::alter members to
::original and ::alternative as appropriate, and
finally drops parenthesis from the return of
p4_get_alias_event to fit coding style.

No functional changes.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

 arch/x86/include/asm/perf_event_p4.h |    2 -
 arch/x86/kernel/cpu/perf_event_p4.c  |   66 +++++++++++++++--------------------
 2 files changed, 31 insertions(+), 37 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -133,7 +133,7 @@
 
 /*
  * In case of event aliasing we need to preserve some
- * caller bits otherwise the mapping won't be complete.
+ * caller bits, otherwise the mapping won't be complete.
  */
 #define P4_CONFIG_EVENT_ALIAS_MASK			  \
 	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR)	| \
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -571,35 +571,34 @@ static __initconst const u64 p4_hw_cache
 };
 
 /*
- * Because of Netburst being quite restricted in now
- * many same events can run simultaneously, we use
- * event aliases, ie different events which have the
- * same functionallity but use non-intersected resources
- * (ESCR/CCCR/couter registers). This allow us to run
- * two or more semi-same events together. It is done
- * transparently to a user space.
+ * Because of Netburst being quite restricted in how many
+ * identical events may run simultaneously, we introduce event aliases,
+ * ie the different events which have the same functionality but
+ * utilize non-intersected resources (ESCR/CCCR/counter registers).
  *
- * Never set any cusom internal bits such as P4_CONFIG_HT,
- * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
- * either up-to-dated automatically either not appliable
- * at all.
+ * This allow us to relax restrictions a bit and run two or more
+ * identical events together.
  *
- * And be really carefull choosing aliases!
+ * Never set any custom internal bits such as P4_CONFIG_HT,
+ * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
+ * either up to date automatically or not applicable at all.
  */
 struct p4_event_alias {
-	u64 orig;
-	u64 alter;
+	u64 original;
+	u64 alternative;
 } p4_event_aliases[] = {
 	{
 		/*
-		 * Non-halted cycles can be substituted with
-		 * non-sleeping cycles (see Intel SDM Vol3b for
-		 * details).
+		 * Non-halted cycles can be substituted with non-sleeping cycles (see
+		 * Intel SDM Vol3b for details). We need this alias to be able
+		 * to run nmi-watchdog and 'perf top' (or any other user space tool
+		 * which is interested in running PERF_COUNT_HW_CPU_CYCLES)
+		 * simultaneously.
 		 */
-	.orig	=
+	.original	=
 		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
-	.alter	=
+	.alternative	=
 		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)|
 				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)|
@@ -620,25 +619,21 @@ static u64 p4_get_alias_event(u64 config
 	int i;
 
 	/*
-	 * Probably we're lucky and don't have to do
-	 * matching over all config bits.
+	 * Only event with special mark is allowed,
+	 * we're to be sure it didn't come as malformed
+	 * RAW event.
 	 */
 	if (!(config & P4_CONFIG_ALIASABLE))
 		return 0;
 
 	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
 
-	/*
-	 * If an event was previously swapped to the alter config
-	 * we should swap it back otherwise contnention on registers
-	 * will return back.
-	 */
 	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
-		if (config_match == p4_event_aliases[i].orig) {
-			config_match = p4_event_aliases[i].alter;
+		if (config_match == p4_event_aliases[i].original) {
+			config_match = p4_event_aliases[i].alternative;
 			break;
-		} else if (config_match == p4_event_aliases[i].alter) {
-			config_match = p4_event_aliases[i].orig;
+		} else if (config_match == p4_event_aliases[i].alternative) {
+			config_match = p4_event_aliases[i].original;
 			break;
 		}
 	}
@@ -646,8 +641,7 @@ static u64 p4_get_alias_event(u64 config
 	if (i >= ARRAY_SIZE(p4_event_aliases))
 		return 0;
 
-	return config_match |
-		(config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
+	return config_match | (config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
 }
 
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
@@ -1229,9 +1223,9 @@ static int p4_pmu_schedule_events(struct
 
 again:
 		/*
-		 * Aliases are swappable so we may hit circular
-		 * lock if both original config and alias need
-		 * resources (MSR registers) which already busy.
+		 * It's possible to hit a circular lock
+		 * between original and alternative events
+		 * if both are scheduled already.
 		 */
 		if (pass > 2)
 			goto done;
@@ -1251,7 +1245,7 @@ again:
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
 		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
 			/*
-			 * Probably an event alias is still available.
+			 * Check whether an event alias is still available.
 			 */
 			config_alias = p4_get_alias_event(hwc->config);
 			if (!config_alias)
