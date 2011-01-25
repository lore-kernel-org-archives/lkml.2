Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1AYFn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:43:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab1AYFn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:43:27 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D3E63B8.4040701@np.css.fujitsu.com>
Date: Tue, 25 Jan 2011 14:46:32 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Fix unsuitable behavior for poisoned tail pages of THP.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a tail page of THP is poisoned, memory-failure will do
nothing except setting poison flag, while the expected behavior is
that the process, who is using the poisoned tail page, should be
killed.

The above problem is caused by lru checking of the poisoned tail page
of THP. Because PG_lru flag is only set on the head page of
THP, the check always consider the poisoned tail page as NON
lru page.

So avoid checking NON lru for THP, as like as hugetlb.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/memory-failure.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5396603..44a1bdf 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1046,19 +1046,22 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
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
+	if (!PageCompound(p)) {
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


