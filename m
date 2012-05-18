Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2ERS3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:29:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52879 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2ERS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:29:00 -0400
Date: Fri, 18 May 2012 11:28:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] memcg,thp: fix res_counter:96 regression
Message-ID: <alpine.LSU.2.00.1205181116160.2082@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occasionally, testing memcg's move_charge_at_immigrate on rc7 shows
a flurry of hundreds of warnings at kernel/res_counter.c:96, where
res_counter_uncharge_locked() does WARN_ON(counter->usage < val).

The first trace of each flurry implicates __mem_cgroup_cancel_charge()
of mc.precharge, and an audit of mc.precharge handling points to
mem_cgroup_move_charge_pte_range()'s THP handling in 12724850e806
"memcg: avoid THP split in task migration".

Checking !mc.precharge is good everywhere else, when a single page is
to be charged; but here the "mc.precharge -= HPAGE_PMD_NR" likely to
follow, is liable to result in underflow (a lot can change since the
precharge was estimated).

Simply check against HPAGE_PMD_NR: there's probably a better alternative,
trying precharge for more, splitting if unsuccessful; but this one-liner
is safer for now - no kernel/res_counter.c:96 warnings seen in 26 hours.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.4-rc7/mm/memcontrol.c	2012-05-12 22:56:05.340002552 -0700
+++ linux/mm/memcontrol.c	2012-05-17 09:39:45.944034396 -0700
@@ -5481,7 +5481,7 @@ static int mem_cgroup_move_charge_pte_ra
 	 *    part of thp split is not executed yet.
 	 */
 	if (pmd_trans_huge_lock(pmd, vma) == 1) {
-		if (!mc.precharge) {
+		if (mc.precharge < HPAGE_PMD_NR) {
 			spin_unlock(&vma->vm_mm->page_table_lock);
 			return 0;
 		}
