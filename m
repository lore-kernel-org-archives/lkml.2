Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2HONsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:48:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55039 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2HONr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:47:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: eparis@redhat.com
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        stable@vger.kernel.org
Subject: [PATCH 1/3] audit: don't free_chunk() after fsnotify_add_mark()
Date: Wed, 15 Aug 2012 15:49:09 +0200
Message-Id: <1345038551-5729-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345038551-5729-1-git-send-email-miklos@szeredi.hu>
References: <1345038551-5729-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't do free_chunk() after fsnotify_add_mark().  That one does a delayed unref
via the destroy list and this results in use-after-free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Eric Paris <eparis@redhat.com>
CC: stable@vger.kernel.org
---
 kernel/audit_tree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 3a5ca58..69a5851 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -259,7 +259,7 @@ static void untag_chunk(struct node *p)
 
 	fsnotify_duplicate_mark(&new->mark, entry);
 	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, NULL, 1)) {
-		free_chunk(new);
+		fsnotify_put_mark(&new->mark);
 		goto Fallback;
 	}
 
@@ -322,7 +322,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 
 	entry = &chunk->mark;
 	if (fsnotify_add_mark(entry, audit_tree_group, inode, NULL, 0)) {
-		free_chunk(chunk);
+		fsnotify_put_mark(entry);
 		return -ENOSPC;
 	}
 
@@ -396,7 +396,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	fsnotify_duplicate_mark(chunk_entry, old_entry);
 	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, NULL, 1)) {
 		spin_unlock(&old_entry->lock);
-		free_chunk(chunk);
+		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
 		return -ENOSPC;
 	}
-- 
1.7.7

