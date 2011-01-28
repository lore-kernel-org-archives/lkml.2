Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1A1FuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:50:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39094 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1A1FuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:50:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D4259D2.9090206@np.css.fujitsu.com>
Date: Fri, 28 Jan 2011 14:53:22 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 3/3] Fix unsuitable behavior for poisoned tail pages of
 THP.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a tail page of THP is poisoned, memory-failure will do
nothing except setting PG_hwpoison, while the expected behavior is
that the process, who is using the poisoned tail page, should be
killed.

The above problem is caused by lru check of the poisoned tail page
of THP. Because PG_lru flag is only set on the head page of
THP, the check always consider the poisoned tail page as NON
lru page.

So the lru check for the tail page of THP should be avoided,
as like as hugetlb.

This patch adds !PageTransCompound() before lru check for THP,
because of the check (!PageHuge() && !PageTransCompound())
the whole branch could be optimized away at build time when both
hugetlbfs and THP are set with "N" (or in archs not supporting
either of those).

-v2
   Use PageTransCompound() that could be optimized away.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/memory-failure.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c526469..685a1d9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1065,19 +1065,22 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageLRU(p) && !PageHuge(p))
-		shake_page(p, 0);
-	if (!PageLRU(p) && !PageHuge(p)) {
-		/*
-		 * shake_page could have turned it free.
-		 */
-		if (is_free_buddy_page(p)) {
-			action_result(pfn, "free buddy, 2nd try", DELAYED);
-			return 0;
+	if (!PageHuge(p) && !PageTransCompound(p)) {
+		if (!PageLRU(p))
+			shake_page(p, 0);
+		if (!PageLRU(p)) {
+			/*
+			 * shake_page could have turned it free.
+			 */
+			if (is_free_buddy_page(p)) {
+				action_result(pfn, "free buddy, 2nd try",
+						DELAYED);
+				return 0;
+			}
+			action_result(pfn, "non LRU", IGNORED);
+			put_page(p);
+			return -EBUSY;
 		}
-		action_result(pfn, "non LRU", IGNORED);
-		put_page(p);
-		return -EBUSY;
 	}
 
 	/*
-- 
1.7.2.2


