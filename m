Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1JPUlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab1JPUk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:40:57 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: [PATCH 3/4] powerpc: gup_hugepte() avoid to free the head page too many times
Date: Sun, 16 Oct 2011 22:40:38 +0200
Message-Id: <1318797639-26962-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1316793432.9084.47.camel@twins>
References: <1316793432.9084.47.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only taken "refs" pins on the head page not "*nr" pins.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index b649c28..78b14ab 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -428,10 +428,9 @@ static noinline int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long add
 
 	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 		/* Could be optimized better */
-		while (*nr) {
+		*nr -= refs;
+		while (refs--)
 			put_page(head);
-			(*nr)--;
-		}
 	}
 
 	return 1;
-- 
1.7.3.4

