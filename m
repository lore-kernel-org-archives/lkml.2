Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2F1NE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab2F1M57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:57:59 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 29/40] autonuma: retain page last_nid information in khugepaged
Date: Thu, 28 Jun 2012 14:56:09 +0200
Message-Id: <1340888180-15355-30-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pages are collapsed try to keep the last_nid information from one
of the original pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 094f82b..ae20409 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1814,7 +1814,18 @@ static bool __collapse_huge_page_copy(pte_t *pte, struct page *page,
 			clear_user_highpage(page, address);
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
 		} else {
+#ifdef CONFIG_AUTONUMA
+			int autonuma_last_nid;
+#endif
 			src_page = pte_page(pteval);
+#ifdef CONFIG_AUTONUMA
+			/* pick the last one, better than nothing */
+			autonuma_last_nid =
+				ACCESS_ONCE(src_page->autonuma_last_nid);
+			if (autonuma_last_nid >= 0)
+				ACCESS_ONCE(page->autonuma_last_nid) =
+					autonuma_last_nid;
+#endif
 			copy_user_highpage(page, src_page, address, vma);
 			VM_BUG_ON(page_mapcount(src_page) != 1);
 			VM_BUG_ON(page_count(src_page) != 2);
