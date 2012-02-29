Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2B2Fas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:30:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37961 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2B2Far (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:30:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.130.7 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 28 Feb 2012 21:30:17 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH next] memcg: remove PCG_CACHE page_cgroup flag fix
In-Reply-To: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202282128500.4875@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swapping tmpfs loads show absurd wrapped rss and wrong cache in memcg's
memory.stat statistics: __mem_cgroup_uncharge_common() is failing to
distinguish the anon and tmpfs cases.

Mostly we can decide between them by PageAnon, which is reliable once
it has been set; but there are several callers who need to uncharge a
MEM_CGROUP_CHARGE_TYPE_MAPPED page before it was fully initialized,
so allow that case to override the PageAnon decision.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- 3.3-rc5-next/mm/memcontrol.c	2012-02-25 10:06:52.496035568 -0800
+++ linux/mm/memcontrol.c	2012-02-26 10:44:32.146365398 -0800
@@ -2944,13 +2944,16 @@ __mem_cgroup_uncharge_common(struct page
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
 
+	anon = PageAnon(page);
+
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		anon = true;
+		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
 			goto unlock_out;
-		anon = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
 		if (!PageAnon(page)) {	/* Shared memory */
@@ -2958,10 +2961,8 @@ __mem_cgroup_uncharge_common(struct page
 				goto unlock_out;
 		} else if (page_mapped(page)) /* Anon */
 				goto unlock_out;
-		anon = true;
 		break;
 	default:
-		anon = false;
 		break;
 	}
 
