Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0L2WH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 17:07:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0L2WHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 17:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VPKei7aqi06DFMmtOHY76fu4FaxEcEDZAJuOKFTkrSzJapk44sebznPEpMCuRORZsK
         VnmH7zhGoPl8gae801dw==
Date: Wed, 29 Dec 2010 14:07:11 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan.kim@gmail.com>,
        Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] memcg: fix wrong VM_BUG_ON() in try_charge()'s mm->owner
 check
In-Reply-To: <20101222164151.GA2048@cmpxchg.org>
Message-ID: <alpine.LSU.2.00.1012291355080.22872@sister.anvils>
References: <1293020757.1998.2.camel@localhost.localdomain> <AANLkTin6GMiXHuoVzNWPcj0jXDqWyfWCwW9fd-v=pq=X@mail.gmail.com> <20101222164151.GA2048@cmpxchg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

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
Cc: stable@kernel.org
---
Sorry, I hit this on 2.6.36, and we lined up this patch early in
November, but never really pushed it: now Thomas hit it on 37-rc7.

 mm/memcontrol.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- 2.6.37-rc8/mm/memcontrol.c	2010-11-29 22:29:32.000000000 -0800
+++ linux/mm/memcontrol.c	2010-12-28 21:42:29.000000000 -0800
@@ -1925,19 +1925,18 @@ again:
 
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
