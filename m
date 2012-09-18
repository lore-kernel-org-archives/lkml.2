Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2IRJNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2IRJNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:13:05 -0400
Date: Tue, 18 Sep 2012 11:13:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, glommer@parallels.com, sachin.kamat@linaro.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] memcg: move mem_cgroup_is_root upwards (was Re: +
 memcg-cleanup-kmem-tcp-ifdefs.patch added to -mm tree)
Message-ID: <20120918091304.GA13936@dhcp22.suse.cz>
References: <20120917222052.240CC200057@hpza10.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120917222052.240CC200057@hpza10.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
could you add the patch bellow on top of memcg-cleanup-kmem-tcp-ifdefs.patch?
They are not directly related (that's why I didn't post it as a series)
but this one depend on the changed context (and it makes my old compiler much
happier).
---
>From 3c18a5330f37a3bb2a622d63b1755dd4d8682fd3 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 14 Sep 2012 13:56:32 +0200
Subject: [PATCH] memcg: move mem_cgroup_is_root upwards
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kmem code uses this function and it is better to not use forward
declarations for static inline functions as some (older) compilers don't
like it:

gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux)

mm/memcontrol.c:421: warning: ‘mem_cgroup_is_root’ declared inline after being called
mm/memcontrol.c:421: warning: previous declaration of ‘mem_cgroup_is_root’ was here

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf5cb0b..6005049 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -412,10 +412,14 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
 	return container_of(s, struct mem_cgroup, css);
 }
 
+static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+{
+	return (memcg == root_mem_cgroup);
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
-static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
 void sock_update_memcg(struct sock *sk)
 {
 	if (mem_cgroup_sockets_enabled) {
@@ -1011,11 +1015,6 @@ void mem_cgroup_iter_break(struct mem_cgroup *root,
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
-{
-	return (memcg == root_mem_cgroup);
-}
-
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
