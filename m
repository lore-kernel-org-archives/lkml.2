Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab0IFFtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:49:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49044 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0IFFtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:49:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Sep 2010 14:44:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 2/3] memory hotplug: fix set_migratetype_isolate wrong
 callback result check
Message-Id: <20100906144428.d6d4bfd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Even if notifier cannot find any pages, it doesn't mean
no pages are available...And, if there are no notifiers registered,
this condition will be always true and memory hotplug will show -EBUSY.

Clarification:This is a bug but not critical

In most case, a pageblock which will be offlined is MIGRATE_MOVABLE
This "notifier" is called only when the pageblock is _not_ MIGRATE_MOVABLE.
If not MIGRATE_MOVABLE, it's common case that memory hotplug will fail.
So, no one notice this bug.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: kametest/mm/page_alloc.c
===================================================================
--- kametest.orig/mm/page_alloc.c
+++ kametest/mm/page_alloc.c
@@ -5313,7 +5313,7 @@ int set_migratetype_isolate(struct page 
 	 */
 	notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
 	notifier_ret = notifier_to_errno(notifier_ret);
-	if (notifier_ret || !arg.pages_found)
+	if (notifier_ret)
 		goto out;
 
 	for (iter = pfn; iter < (pfn + pageblock_nr_pages); iter++) {

