Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2BQVph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:45:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2BQVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:45:36 -0500
Date: Fri, 17 Feb 2012 13:45:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 0/6] page cgroup diet v5
Message-Id: <20120217134535.020b7254.akpm@linux-foundation.org>
In-Reply-To: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 18:24:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> This patch set is for removing 2 flags PCG_FILE_MAPPED and PCG_MOVE_LOCK on
> page_cgroup->flags. After this, page_cgroup has only 3bits of flags.
> And, this set introduces a new method to update page status accounting per memcg.
> With it, we don't have to add new flags onto page_cgroup if 'struct page' has
> information. This will be good for avoiding a new flag for page_cgroup.
> 
> Fixed pointed out parts.
>  - added more comments
>  - fixed texts
>  - removed redundant arguments.
> 

I tweaked a few things here.  Renamed "bool lock;" to "bool locked" in
several places.  Also the void-returning
mem_cgroup_begin_update_page_stat() was doing an explicit return which
is OK C but pointless and misleading.


Also, this has been bugging me for a while ;)

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: s/stealed/stolen/

A grammatical fix.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~a mm/memcontrol.c
--- a/mm/memcontrol.c~a
+++ a/mm/memcontrol.c
@@ -1299,8 +1299,8 @@ static void mem_cgroup_end_move(struct m
 /*
  * 2 routines for checking "mem" is under move_account() or not.
  *
- * mem_cgroup_stealed() - checking a cgroup is mc.from or not. This is used
- *			  for avoiding race in accounting. If true,
+ * mem_cgroup_stolen() -  checking whether a cgroup is mc.from or not. This
+ *			  is used for avoiding races in accounting.  If true,
  *			  pc->mem_cgroup may be overwritten.
  *
  * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
@@ -1308,7 +1308,7 @@ static void mem_cgroup_end_move(struct m
  *			  waiting at hith-memory prressure caused by "move".
  */
 
-static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
+static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
 	return atomic_read(&memcg->moving_account) > 0;
@@ -1356,7 +1356,7 @@ static bool mem_cgroup_wait_acct_move(st
  * Take this lock when
  * - a code tries to modify page's memcg while it's USED.
  * - a code tries to modify page state accounting in a memcg.
- * see mem_cgroup_stealed(), too.
+ * see mem_cgroup_stolen(), too.
  */
 static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
 				  unsigned long *flags)
@@ -1899,9 +1899,9 @@ again:
 	 * If this memory cgroup is not under account moving, we don't
 	 * need to take move_lock_page_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock() if mem_cgroup_stealed() == true.
+	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
 	 */
-	if (!mem_cgroup_stealed(memcg))
+	if (!mem_cgroup_stolen(memcg))
 		return;
 
 	move_lock_mem_cgroup(memcg, flags);
_

