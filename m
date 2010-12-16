Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab0LQADO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:03:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0LQADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:03:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Dec 2010 08:57:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Korb <ingo@akana.de>, linux-mm@kvack.org, akpm@linux-foundation.org,
        cl@linux-foundation.org, yinghai@kernel.org, andi.kleen@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] memory hotplug: fix alignment check (Was Re: PROBLEM:
 __offline_isolated_pages may offline too many pages
Message-Id: <20101217085714.5525793b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101216102641.GK13914@csn.ul.ie>
References: <4D0786D3.7070007@akana.de>
	<20101215092134.e2c8849f.kamezawa.hiroyu@jp.fujitsu.com>
	<4D08899F.4050502@akana.de>
	<20101216090657.9d3aaa4c.kamezawa.hiroyu@jp.fujitsu.com>
	<20101216102641.GK13914@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 10:26:41 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> Other than the spelling mistakes in the changelog and the lack of a
> subject;
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> 
Thank you. fixed one.
==

offline_pages()'s sanity check of given range is wrong. It should
be aligned to MAX_ORDER. Current existing caller uses SECTION_SIZE
alignment, so this change has no influence to existing callers.

Reported-by: Ingo Korb <ingo@akana.de>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memory_hotplug.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.37-rc5/mm/memory_hotplug.c
===================================================================
--- linux-2.6.37-rc5.orig/mm/memory_hotplug.c
+++ linux-2.6.37-rc5/mm/memory_hotplug.c
@@ -798,10 +798,14 @@ static int offline_pages(unsigned long s
 	struct memory_notify arg;
 
 	BUG_ON(start_pfn >= end_pfn);
-	/* at least, alignment against pageblock is necessary */
-	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
+	/*
+	 * Considering Buddy system which joins nearby pages, the range
+	 * in offline should be aligned to MAX_ORDER. If not, isolated
+	 * page will be joined to other (not isolated) pages.
+	 */
+	if (!IS_ALIGNED(start_pfn, MAX_ORDER_NR_PAGES))
 		return -EINVAL;
-	if (!IS_ALIGNED(end_pfn, pageblock_nr_pages))
+	if (!IS_ALIGNED(end_pfn, MAX_ORDER_NR_PAGES))
 		return -EINVAL;
 	/* This makes hotplug much easier...and readable.
 	   we assume this for now. .*/
 

