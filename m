Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0LPANB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:13:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38908 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0LPANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:13:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Dec 2010 09:06:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Korb <ingo@akana.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mel@csn.ul.ie,
        cl@linux-foundation.org, yinghai@kernel.org, andi.kleen@intel.com,
        linux-kernel@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: PROBLEM: __offline_isolated_pages may offline too many pages
Message-Id: <20101216090657.9d3aaa4c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D08899F.4050502@akana.de>
References: <4D0786D3.7070007@akana.de>
	<20101215092134.e2c8849f.kamezawa.hiroyu@jp.fujitsu.com>
	<4D08899F.4050502@akana.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:25:51 +0100
Ingo Korb <ingo@akana.de> wrote:

> On 15.12.2010 01:21, KAMEZAWA Hiroyuki wrote:
> 
> > It's designed for offline memory section>  MAX_ORDER. pageblock_nr_pages
> > is tend to be smaller than that.
> >
> > Do you see the problem with _exsisting_ user interface of memory hotplug ?
> > I think we have no control other than memory section.
> 
> The existing, exported interface (remove_memory() - the check itself is 
> in offline_pages()) only checks if both start and end of the 
> to-be-removed block are aligned to pageblock_nr_pages. As you noted the 
> actual size and alignment requirements in __offline_isolated_pages can 
> be larger that that, so I think the checks in offline_pages() should be 
> changed (if 1<<MAX_ORDER is always >= pageblock_nr_pages) or extended 
> (if there can be any relation between the two).
> 

Ok, maybe my mistake. This is a fix. Thank you for reporting.
==

offline_pages()'s sanity check of given range is wrong. It should
be aligned to MAX_ORDER. Current exsiting caller uses SECTION_SIZE
alignment, so this change has no influence to exsisting callers.

Reported-by: Ingo Korb <ingo@akana.de>
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
+	 * Considering buddy allocator which joins nearby pages, the range
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

