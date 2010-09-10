Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0IJKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:42:14 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:3609 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554Ab0IJKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:41:51 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ia64: unwind - optimise linked-list searches for modules
Date: Fri, 10 Sep 2010 13:40:45 +0300
Message-Id: <1284115245-23876-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's clear from the comment in the code about keeping the
kernel's unwind table at the front of the list that some
attention has been paid to access patterns. Tests on other
architectures have shown that a move-to-front optimisation
improves searches dramatically.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

---
This might not be a useful optimisation for the ia64
due to the caching that's already in place. If someone
can count the number of linked list operations with and
without this patch in a real-world scenario, I'd be
grateful.
---
 arch/ia64/kernel/unwind.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/unwind.c b/arch/ia64/kernel/unwind.c
index f47217b..fed6afa 100644
--- a/arch/ia64/kernel/unwind.c
+++ b/arch/ia64/kernel/unwind.c
@@ -1531,7 +1531,7 @@ build_script (struct unw_frame_info *info)
 	struct unw_labeled_state *ls, *next;
 	unsigned long ip = info->ip;
 	struct unw_state_record sr;
-	struct unw_table *table;
+	struct unw_table *table, *prev;
 	struct unw_reg_info *r;
 	struct unw_insn insn;
 	u8 *dp, *desc_end;
@@ -1560,11 +1560,26 @@ build_script (struct unw_frame_info *info)
 
 	STAT(parse_start = ia64_get_itc());
 
+	prev = NULL;
 	for (table = unw.tables; table; table = table->next) {
 		if (ip >= table->start && ip < table->end) {
+			/*
+			 * Leave the kernel unwind table at the very front,
+			 * lest moving it breaks some assumption elsewhere.
+			 * Otherwise, move the matching table to the second
+			 * position in the list so that traversals can benefit
+			 * from commonality in backtrace paths.
+			 */
+			if (prev && prev != unw.tables) {
+				/* unw is safe - we're already spinlocked */
+				prev->next = table->next;
+				table->next = unw.tables->next;
+				unw.tables->next = table;
+			}
 			e = lookup(table, ip - table->segment_base);
 			break;
 		}
+		prev = table;
 	}
 	if (!e) {
 		/* no info, return default unwinder (leaf proc, no mem stack, no saved regs)  */
-- 
1.7.2.rc1.37.gf8c40

