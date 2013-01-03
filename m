Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3ACRys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:54:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab3ACRyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:54:44 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 2/7] memcg: keep prev's css alive for the whole mem_cgroup_iter
Date: Thu,  3 Jan 2013 18:54:16 +0100
Message-Id: <1357235661-29564-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357235661-29564-1-git-send-email-mhocko@suse.cz>
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css reference counting keeps the cgroup alive even though it has been
already removed. mem_cgroup_iter relies on this fact and takes a
reference to the returned group. The reference is then released on the
next iteration or mem_cgroup_iter_break.
mem_cgroup_iter currently releases the reference right after it gets the
last css_id.
This is correct because neither prev's memcg nor cgroup are accessed
after then. This will change in the next patch so we need to hold the
group alive a bit longer so let's move the css_put at the end of the
function.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e71cfde..90a3b1d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1143,12 +1143,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (prev && !reclaim)
 		id = css_id(&prev->css);
 
-	if (prev && prev != root)
-		css_put(&prev->css);
-
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
-			return NULL;
+			goto out_css_put;
 		return root;
 	}
 
@@ -1166,7 +1163,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			spin_lock(&iter->iter_lock);
 			if (prev && reclaim->generation != iter->generation) {
 				spin_unlock(&iter->iter_lock);
-				return NULL;
+				goto out_css_put;
 			}
 			id = iter->position;
 		}
@@ -1190,8 +1187,12 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		}
 
 		if (prev && !css)
-			return NULL;
+			goto out_css_put;
 	}
+out_css_put:
+	if (prev && prev != root)
+		css_put(&prev->css);
+
 	return memcg;
 }
 
-- 
1.7.10.4

