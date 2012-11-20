Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2KTUZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:25:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36533 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2KTUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:25:44 -0500
Message-ID: <50ABE741.2020604@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 12:25:37 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [3.7-rc6] capture_free_page() frees page without accounting for them??
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112020-7606-0000-0000-0000058AAE8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

I'm chasing an apparent memory leak introduced post-3.6.  The
interesting thing is that it appears that the pages are in the
allocator, but not being accounted for:

	http://www.spinics.net/lists/linux-mm/msg46187.html
	https://bugzilla.kernel.org/show_bug.cgi?id=50181

I started auditing anything that might be messing with NR_FREE_PAGES,
and came across commit 1fb3f8ca.  It does something curious with
capture_free_page() (previously known as split_free_page()).

int capture_free_page(struct page *page, int alloc_order,
...
        __mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));

-       /* Split into individual pages */
-       set_page_refcounted(page);
-       split_page(page, order);
+       if (alloc_order != order)
+               expand(zone, page, alloc_order, order,
+                       &zone->free_area[order], migratetype);

Note that expand() puts the pages _back_ in the allocator, but it does
not bump NR_FREE_PAGES.  We "return" alloc_order' worth of pages, but we
accounted for removing 'order'.

I _think_ the correct fix is to just:

-     __mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+     __mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << alloc_order));

I'm trying to confirm the theory my making this happen a bit more often,
but I'd appreciate a second pair of eyes on the code in case I'm reading
it wrong.

