Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2JEUxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:53:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2JEUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:53:38 -0400
Date: Fri, 5 Oct 2012 13:53:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcg: clean up mm_match_cgroup() signature
Message-Id: <20121005135336.1ee7082f.akpm@linux-foundation.org>
In-Reply-To: <1349374157-20604-3-git-send-email-hannes@cmpxchg.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
	<1349374157-20604-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Oct 2012 14:09:17 -0400
Johannes Weiner <hannes@cmpxchg.org> wrote:

> It really should return a boolean for match/no match.  And since it
> takes a memcg, not a cgroup, fix that parameter name as well.
> 
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -84,14 +84,14 @@ extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
>  extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
>  
>  static inline
> -int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> +bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
>  {
> -	struct mem_cgroup *memcg;
> -	int match;
> +	struct mem_cgroup *task_memcg;
> +	bool match;
>  
>  	rcu_read_lock();
> -	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> -	match = memcg && __mem_cgroup_same_or_subtree(cgroup, memcg);
> +	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> +	match = task_memcg && __mem_cgroup_same_or_subtree(memcg, task_memcg);
>  	rcu_read_unlock();
>  	return match;
>  }

This needed massaging after droppage of your [1/2]:



From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: clean up mm_match_cgroup() signature

It really should return a boolean for match/no match.  And since it
takes a memcg, not a cgroup, fix that parameter name as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 1 file changed, 7 insertions(+), 7 deletions(-)

index 8686294..7698182 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature
+++ a/include/linux/memcontrol.h
@@ -84,13 +84,13 @@ extern struct mem_cgroup *parent_mem_cgr
 extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
 
 static inline
-int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
-	int match;
+	struct mem_cgroup *task_memcg;
+	bool match;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
 	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
 	rcu_read_unlock();
 	return match;
@@ -258,10 +258,10 @@ static inline struct mem_cgroup *try_get
 	return NULL;
 }
 
-static inline int mm_match_cgroup(struct mm_struct *mm,
+static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
 {
-	return 1;
+	return true;
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
_


Also,


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-clean-up-mm_match_cgroup-signature-fix

mm_match_cgroup is not a macro

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix
+++ a/include/linux/memcontrol.h
@@ -90,7 +90,7 @@ bool mm_match_cgroup(const struct mm_str
 	bool match;
 
 	rcu_read_lock();
-	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
 	rcu_read_unlock();
 	return match;
_

