Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2HUTEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:04:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60118 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2HUTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:04:05 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Cc: eparis@redhat.com, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, stable@vger.kernel.org
Subject: [PATCH 1/3] audit: don't free_chunk() after fsnotify_add_mark()
Date: Tue, 21 Aug 2012 21:03:57 +0200
Message-Id: <1345575839-9389-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345575839-9389-1-git-send-email-miklos@szeredi.hu>
References: <1345575839-9389-1-git-send-email-miklos@szeredi.hu>
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

