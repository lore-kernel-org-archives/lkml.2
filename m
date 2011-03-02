Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1CBKEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:04:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab1CBKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:04:22 -0500
Date: Wed, 2 Mar 2011 11:04:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] page_cgroup array is never stored on reserved pages
Message-ID: <20110302100418.GC19651@tiehlicka.suse.cz>
References: <20110228101129.GE4648@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228101129.GE4648@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
here is the updated follow up patch refreshed on top of the current
mmotm (2011-02-10-16-26) with a checkpatch cleanup:
--- 
>From b458b849767e41038adce81e59ff30d7d42d7321 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 28 Feb 2011 10:43:12 +0100
Subject: [PATCH 2/2] page_cgroup array is never stored on reserved pages

KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
PageReserved because we never store the array on reserved pages
(neither alloc_pages_exact nor vmalloc use those pages).

So we can replace the check by a BUG_ON.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.38-rc4/mm/page_cgroup.c
===================================================================
--- linux-2.6.38-rc4.orig/mm/page_cgroup.c	2011-03-02 10:58:01.000000000 +0100
+++ linux-2.6.38-rc4/mm/page_cgroup.c	2011-03-02 10:58:41.000000000 +0100
@@ -152,11 +152,11 @@ static void free_page_cgroup(void *addr)
 		vfree(addr);
 	} else {
 		struct page *page = virt_to_page(addr);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			size_t table_size =
-				sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-			free_pages_exact(addr, table_size);
-		}
+		size_t table_size =
+			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+
+		BUG_ON(PageReserved(page));
+		free_pages_exact(addr, table_size);
 	}
 }
 
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
