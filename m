Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2ASUwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:52:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47759 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2ASUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:52:01 -0500
Date: Thu, 19 Jan 2012 12:51:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] memcg: let css_get_next() rely upon rcu_read_lock()
In-Reply-To: <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1201191250210.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove lock and unlock around css_get_next()'s call to idr_get_next().
memcg iterators (only users of css_get_next) already did rcu_read_lock(),
and its comment demands that; but add a WARN_ON_ONCE to make sure of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- 3.2.0+.orig/kernel/cgroup.c	2012-01-19 12:16:04.000000000 -0800
+++ 3.2.0+/kernel/cgroup.c	2012-01-19 12:22:55.188244820 -0800
@@ -5087,6 +5087,8 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -5094,10 +5096,7 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		spin_unlock(&ss->id_lock);
-
 		if (!tmp)
 			break;
 		if (tmp->depth >= depth && tmp->stack[depth] == rootid) {
