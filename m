Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab2FJSzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 14:55:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57616 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2FJSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 14:55:16 -0400
Date: Sun, 10 Jun 2012 11:54:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] memcg: fix use_hierarchy css_is_ancestor oops regression
Message-ID: <alpine.LSU.2.00.1206101150230.4239@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If use_hierarchy is set, reclaim testing soon oopses in css_is_ancestor()
called from __mem_cgroup_same_or_subtree() called from page_referenced():
when processes are exiting, it's easy for mm_match_cgroup() to pass along
a NULL memcg coming from a NULL mm->owner.

Check for that in __mem_cgroup_same_or_subtree().  Return true or false?
False because we cannot know if it was in the hierarchy, but also false
because it's better not to count a reference from an exiting process.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
This a 3.5-rc issue: not needed for stable.

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.5-rc2/mm/memcontrol.c	2012-05-30 08:17:19.400008280 -0700
+++ linux/mm/memcontrol.c	2012-06-10 08:39:39.618182396 -0700
@@ -1148,7 +1148,7 @@ bool __mem_cgroup_same_or_subtree(const
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy)
+	if (!root_memcg->use_hierarchy || !memcg)
 		return false;
 	return css_is_ancestor(&memcg->css, &root_memcg->css);
 }
