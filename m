Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1KWPoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:44:13 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44819 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750Ab1KWPnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:43:01 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 5/8] mm: memcg: remove unneeded checks from newpage_charge()
Date: Wed, 23 Nov 2011 16:42:28 +0100
Message-Id: <1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

All callsites pass in freshly allocated pages and a valid mm.  As a
result, all checks pertaining the page's mapcount, page->mapping or
the fallback to init_mm are unneeded.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/memcontrol.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4d139a..0d10be4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2679,19 +2679,8 @@ int mem_cgroup_newpage_charge(struct page *page,
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	/*
-	 * If already mapped, we don't have to account.
-	 * If page cache, page->mapping has address_space.
-	 * But page->mapping may have out-of-use anon_vma pointer,
-	 * detecit it by PageAnon() check. newly-mapped-anon's page->mapping
-	 * is NULL.
-  	 */
-	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
-		return 0;
-	if (unlikely(!mm))
-		mm = &init_mm;
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
 static void
-- 
1.7.6.4

