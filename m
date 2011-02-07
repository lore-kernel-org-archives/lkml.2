Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1BGEo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:44:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48082 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BGEo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:44:28 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D4F7979.9040205@np.css.fujitsu.com>
Date: Mon, 07 Feb 2011 13:47:53 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Huang Ying <ying.huang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [Resend][PATCH -v2 2/3 -next] Fix poison failure for unmapped hugetlb
 page without MF_COUNT_INCREASED.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unmapped hugetlb page could not be poisoned when the tail
page is poisoned.

The reason is because the PG_hwpoison of head page is checked
before setting PG_hwpoison on other pages of the hugetlb page.
  - If the head page is not poisoned, the rest pages of
    hugetlb page will not be set with PG_hwpoison;
  - If the head page is poisoned, poisoning for the hugetlb page
    has been finished by other context running simultaneously.

Usually the head page here is not poisoned yet, so __memory_failure()
will return without poisoning the rest pages of hugetlb page.

As it is described in the comment(in __memory_failure()):
 994               /*
 995                * Check "just unpoisoned", "filter hit", and
 996                * "race with other subpage."
 997                */

I think the real checking expected here is "just unpoisoned",
whether the tail page just poisoned by this context is still
poisoned or not. It should be realized by checking agaist
the poisoned tail page, not against the head page.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d2c2a7b..0317cb3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1039,7 +1039,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 			 * "race with other subpage."
 			 */
 			lock_page_nosync(hpage);
-			if (!PageHWPoison(hpage)
+			if (!PageHWPoison(p)
 			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
 			    || (p != hpage && TestSetPageHWPoison(hpage))) {
 				atomic_long_sub(nr_pages, &mce_bad_pages);
-- 
1.7.2.2


