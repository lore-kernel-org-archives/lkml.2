Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2JQNcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:32:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab2JQNbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:31:17 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 2/6] memcg: root_cgroup cannot reach mem_cgroup_move_parent
Date: Wed, 17 Oct 2012 15:30:44 +0200
Message-Id: <1350480648-10905-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The root cgroup cannot be destroyed so we never hit it idown the
mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
even try to do anything if called for the root.

This means that mem_cgroup_move_parent doesn't have to bother with the
root cgroup and it can assume it can always move charges upwards.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f25e9c0..9ce24b7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2709,9 +2709,7 @@ static int mem_cgroup_move_parent(struct page *page,
 	unsigned long uninitialized_var(flags);
 	int ret;
 
-	/* Is ROOT ? */
-	if (mem_cgroup_is_root(child))
-		return -EINVAL;
+	VM_BUG_ON(mem_cgroup_is_root(child));
 
 	ret = -EBUSY;
 	if (!get_page_unless_zero(page))
@@ -3817,6 +3815,8 @@ static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	int ret;
 
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
 	css_get(&memcg->css);
 	ret = mem_cgroup_force_empty(memcg);
 	css_put(&memcg->css);
-- 
1.7.10.4

