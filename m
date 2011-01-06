Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1AFAbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:45 -0500
Received: from kroah.org ([198.145.64.141]:36084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1AFAbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:42 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.335150008@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: [134/152] memcg: fix wrong VM_BUG_ON() in try_charge()s mm->owner check
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit ebb76ce16daf6908dc030dec1c00827d37129fe5 upstream.

At __mem_cgroup_try_charge(), VM_BUG_ON(!mm->owner) is checked.
But as commented in mem_cgroup_from_task(), mm->owner can be NULL
in some racy case. This check of VM_BUG_ON() is bad.

A possible story to hit this is at swapoff()->try_to_unuse(). It passes
mm_struct to mem_cgroup_try_charge_swapin() while mm->owner is NULL. If we
can't get proper mem_cgroup from swap_cgroup information, mm->owner is used
as charge target and we see NULL.

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1730,19 +1730,18 @@ again:
 
 		rcu_read_lock();
 		p = rcu_dereference(mm->owner);
-		VM_BUG_ON(!p);
 		/*
-		 * because we don't have task_lock(), "p" can exit while
-		 * we're here. In that case, "mem" can point to root
-		 * cgroup but never be NULL. (and task_struct itself is freed
-		 * by RCU, cgroup itself is RCU safe.) Then, we have small
-		 * risk here to get wrong cgroup. But such kind of mis-account
-		 * by race always happens because we don't have cgroup_mutex().
-		 * It's overkill and we allow that small race, here.
+		 * Because we don't have task_lock(), "p" can exit.
+		 * In that case, "mem" can point to root or p can be NULL with
+		 * race with swapoff. Then, we have small risk of mis-accouning.
+		 * But such kind of mis-account by race always happens because
+		 * we don't have cgroup_mutex(). It's overkill and we allo that
+		 * small race, here.
+		 * (*) swapoff at el will charge against mm-struct not against
+		 * task-struct. So, mm->owner can be NULL.
 		 */
 		mem = mem_cgroup_from_task(p);
-		VM_BUG_ON(!mem);
-		if (mem_cgroup_is_root(mem)) {
+		if (!mem || mem_cgroup_is_root(mem)) {
 			rcu_read_unlock();
 			goto done;
 		}


