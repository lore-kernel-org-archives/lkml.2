Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2F1M53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab2F1M5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:57:21 -0400
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
Subject: [PATCH 27/40] autonuma: call autonuma_split_huge_page()
Date: Thu, 28 Jun 2012 14:56:07 +0200
Message-Id: <1340888180-15355-28-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to make sure the tail pages are also queued into the
migration queues of knuma_migrated across a transparent hugepage
split.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1598708..55fc72d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -17,6 +17,7 @@
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
+#include <linux/autonuma.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -1316,6 +1317,7 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(!PageSwapBacked(page_tail));
 
 		lru_add_page_tail(page, page_tail, lruvec);
+		autonuma_migrate_split_huge_page(page, page_tail);
 	}
 	atomic_sub(tail_count, &page->_count);
 	BUG_ON(__page_count(page) <= 0);
