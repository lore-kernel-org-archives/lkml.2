Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352Ab2CFExb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:53:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62270 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030281Ab2CFExa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:53:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.125.195 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Mon, 5 Mar 2012 20:52:55 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bob Liu <lliubbo@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] page_cgroup: fix horrid swap accounting regression
Message-ID: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is memcg's swap accounting so broken?  Insane counts, wrong ownership,
unfreeable structures, which later get freed and then accessed after free.

Turns out to be a tiny a little 3.3-rc1 regression in 9fb4b7cc0724
"page_cgroup: add helper function to get swap_cgroup": the helper
function (actually named lookup_swap_cgroup()) returns an address
using void* arithmetic, but the structure in question is a short.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/page_cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 3.3-rc6/mm/page_cgroup.c	2012-01-20 08:42:35.320020840 -0800
+++ linux/mm/page_cgroup.c	2012-03-05 19:51:13.535372098 -0800
@@ -379,13 +379,15 @@ static struct swap_cgroup *lookup_swap_c
 	pgoff_t offset = swp_offset(ent);
 	struct swap_cgroup_ctrl *ctrl;
 	struct page *mappage;
+	struct swap_cgroup *sc;
 
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
 	if (ctrlp)
 		*ctrlp = ctrl;
 
 	mappage = ctrl->map[offset / SC_PER_PAGE];
-	return page_address(mappage) + offset % SC_PER_PAGE;
+	sc = page_address(mappage);
+	return sc + offset % SC_PER_PAGE;
 }
 
 /**
