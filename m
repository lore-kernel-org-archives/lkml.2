Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2HMLPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:15:22 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34496 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2HMLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:15:20 -0400
Message-ID: <5028E1BF.1020902@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:15:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 06/12] thp: remove some code depend on CONFIG_NUMA
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-5564-0000-0000-000003FF2587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NUMA is disabled, hpage is used as page pre-alloc, so there are
two cases for hpage:
- it is !NULL, means the page is not consumed otherwise,
- the page has been consumed

If NUMA is enabled, hpage is just used as alloc-fail indicator which
is not a real page, NULL means not fail triggered.

So, we can release the page only if !IS_ERR_OR_NULL

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 86f71af..5f620cf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2321,11 +2321,8 @@ static void khugepaged_wait_work(void)

 static void khugepaged_loop(void)
 {
-	struct page *hpage;
+	struct page *hpage = NULL;

-#ifdef CONFIG_NUMA
-	hpage = NULL;
-#endif
 	while (likely(khugepaged_enabled())) {
 #ifndef CONFIG_NUMA
 		hpage = khugepaged_alloc_hugepage();
@@ -2339,10 +2336,9 @@ static void khugepaged_loop(void)
 #endif

 		khugepaged_do_scan(&hpage);
-#ifndef CONFIG_NUMA
-		if (hpage)
+
+		if (!IS_ERR_OR_NULL(hpage))
 			put_page(hpage);
-#endif

 		khugepaged_wait_work();
 	}
-- 
1.7.7.6

