Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2ASUtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:49:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35551 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab2ASUtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:49:02 -0500
Date: Thu, 19 Jan 2012 12:48:48 -0800 (PST)
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
Subject: [PATCH 1/3] idr: make idr_get_next() good for rcu_read_lock()
In-Reply-To: <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1201191247210.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make one small adjustment to idr_get_next(): take the height from the
top layer (stable under RCU) instead of from the root (unprotected by
RCU), as idr_find() does: so that it can be used with RCU locking.
Copied comment on RCU locking from idr_find().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/idr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- 3.2.0+.orig/lib/idr.c	2012-01-04 15:55:44.000000000 -0800
+++ 3.2.0+/lib/idr.c	2012-01-19 11:55:28.780206713 -0800
@@ -595,8 +595,10 @@ EXPORT_SYMBOL(idr_for_each);
  * Returns pointer to registered object with id, which is next number to
  * given id. After being looked up, *@nextidp will be updated for the next
  * iteration.
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
-
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
 	struct idr_layer *p, *pa[MAX_LEVEL];
@@ -605,11 +607,11 @@ void *idr_get_next(struct idr *idp, int
 	int n, max;
 
 	/* find first ent */
-	n = idp->layers * IDR_BITS;
-	max = 1 << n;
 	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
+	n = (p->layer + 1) * IDR_BITS;
+	max = 1 << n;
 
 	while (id < max) {
 		while (n > 0 && p) {
