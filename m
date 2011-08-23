Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1HWI52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:57:28 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43849 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab1HWI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:57:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDAN5pU055LIxDgWdsb2JhbABBqCcVAQEWJiWBQAEBBScvIxAIGBgZOQMbGb9JgzqDDgSkJQ
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, khlebnikov@openvz.org
Subject: [PATCH 12/13] dcache: remove dentries from LRU before putting on dispose list
Date: Tue, 23 Aug 2011 18:56:25 +1000
Message-Id: <1314089786-20535-13-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314089786-20535-1-git-send-email-david@fromorbit.com>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

One of the big problems with modifying the way the dcache shrinker
and LRU implementation works is that the LRU is abused in several
ways. One of these is shrinker_dentry_list().

Basically, we can move a dentry off the LRU onto a different list
without doing any accounting changes, and then use dentry_lru_del()
to remove it from what-ever list it is now on to do the LRU
accounting at that point.

This makes it -really hard- to change the LRU implementation. The
use of the per-sb LRU lock serialises movement of the dentries
between the different lists and the removal of them, and this is the
only reason that it works. If we want to break up the dentry LRU
lock and lists into, say, per-node lists, we remove the only
serialisation that allows this lru list/dispose list abuse to work.

To make this work effectively, the dispose list has to be isolated
from the LRU list - dentries have to be removed from the LRU
*before* being placed on the dispose list. This means that the LRU
accounting and isolation is completed before disposal is started,
and that means we can change the LRU implementation freely in
future..

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/dcache.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b931415..79bf47c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -269,10 +269,10 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
-		dentry->d_sb->s_nr_dentry_unused++;
-		this_cpu_inc(nr_dentry_unused);
 	} else {
 		list_move_tail(&dentry->d_lru, list);
+		dentry->d_sb->s_nr_dentry_unused--;
+		this_cpu_dec(nr_dentry_unused);
 	}
 	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
@@ -732,12 +732,17 @@ static void shrink_dentry_list(struct list_head *list)
 		}
 
 		/*
+		 * The dispose list is isolated and dentries are not accounted
+		 * to the LRU here, so we can simply remove it from the list
+		 * here regardless of whether it is referenced or not.
+		 */
+		list_del_init(&dentry->d_lru);
+
+		/*
 		 * We found an inuse dentry which was not removed from
-		 * the LRU because of laziness during lookup.  Do not free
-		 * it - just keep it off the LRU list.
+		 * the LRU because of laziness during lookup. Do not free it.
 		 */
 		if (dentry->d_count) {
-			dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -789,6 +794,8 @@ relock:
 			spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
+			this_cpu_dec(nr_dentry_unused);
+			sb->s_nr_dentry_unused--;
 			spin_unlock(&dentry->d_lock);
 			freed++;
 			if (!--nr_to_scan)
@@ -818,6 +825,14 @@ void shrink_dcache_sb(struct super_block *sb)
 	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
+
+		/*
+		 * account for removal here so we don't need to handle it later
+		 * even though the dentry is no longer on the lru list.
+		 */
+		this_cpu_sub(nr_dentry_unused, sb->s_nr_dentry_unused);
+		sb->s_nr_dentry_unused = 0;
+
 		spin_unlock(&sb->s_dentry_lru_lock);
 		shrink_dentry_list(&tmp);
 		spin_lock(&sb->s_dentry_lru_lock);
-- 
1.7.5.4

