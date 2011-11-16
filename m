Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1KPNrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:47:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37351 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1KPNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:47:18 -0500
Subject: [PATCH] mm: account reaped page cache on inode cache pruning
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 Nov 2011 17:47:13 +0300
Message-ID: <20111116134713.8933.34389.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inode cache pruning indirectly reclaims page-cache by invalidating mapping pages.
Let's account them into reclaim-state to notice this progress in memory reclaimer.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ee4e66b..1f6c48d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -692,6 +692,8 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&sb->s_inode_lru_lock);
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += reap;
 
 	dispose_list(&freeable);
 }

