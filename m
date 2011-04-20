Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1DTGpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:45:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58499 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab1DTGpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:45:04 -0400
Message-ID: <4DAE811D.6080506@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 14:45:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] Btrfs: fix unsafe usage of merge_state
References: <4DAE80E9.2010102@cn.fujitsu.com>
In-Reply-To: <4DAE80E9.2010102@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 14:45:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 14:45:35,
	Serialize complete at 2011-04-20 14:45:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge_state can free the current state if it can be merged with the next node,
but in set_extent_bit(), after merge_state, we still use the current extent to
get the next node and cache it into cached_state

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f36e284..129601e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -780,20 +780,18 @@ hit_next:
 		if (err)
 			goto out;
 
+		next_node = rb_next(node);
 		cache_state(state, cached_state);
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
 			goto out;
 
 		start = last_end + 1;
-		if (start < end && prealloc && !need_resched()) {
-			next_node = rb_next(node);
-			if (next_node) {
-				state = rb_entry(next_node, struct extent_state,
-						 rb_node);
-				if (state->start == start)
-					goto hit_next;
-			}
+		if (next_node && start < end && prealloc && !need_resched()) {
+			state = rb_entry(next_node, struct extent_state,
+					 rb_node);
+			if (state->start == start)
+				goto hit_next;
 		}
 		goto search_again;
 	}
@@ -856,14 +854,22 @@ hit_next:
 
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
+
+		/*
+		 * Avoid to free 'prealloc' if it can be merged with
+		 * the later extent.
+		 */
+		atomic_inc(&prealloc->refs);
 		err = insert_state(tree, prealloc, start, this_end,
 				   &bits);
 		BUG_ON(err == -EEXIST);
 		if (err) {
+			free_extent_state(prealloc);
 			prealloc = NULL;
 			goto out;
 		}
 		cache_state(prealloc, cached_state);
+		free_extent_state(prealloc);
 		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
-- 
1.7.4.2

