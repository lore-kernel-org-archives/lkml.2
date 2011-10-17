Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1JQVdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1JQVdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:33:22 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2] s390: gup_huge_pmd() return 0 if pte changes
Date: Mon, 17 Oct 2011 23:32:51 +0200
Message-Id: <1318887172-5854-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1318887172-5854-1-git-send-email-aarcange@redhat.com>
References: <1316793432.9084.47.camel@twins>
 <1318887172-5854-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 didn't return 0 in that case, if it's rolling back the *nr
pointer it should also return zero to avoid adding pages to the array
at the wrong offset.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/s390/mm/gup.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 668dda9..da33a02 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -93,16 +93,17 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		*nr -= refs;
 		while (refs--)
 			put_page(head);
-	} else {
-		/*
-		 * Any tail page need their mapcount reference taken
-		 * before we return.
-		 */
-		while (refs--) {
-			if (PageTail(tail))
-				get_huge_page_tail(tail);
-			tail++;
-		}
+		return 0;
+	}
+
+	/*
+	 * Any tail page need their mapcount reference taken before we
+	 * return.
+	 */
+	while (refs--) {
+		if (PageTail(tail))
+			get_huge_page_tail(tail);
+		tail++;
 	}
 
 	return 1;
