Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2FYRpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:45:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52994 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2FYRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:45:41 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: eparis@redhat.com
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        stable@vger.kernel.org
Subject: [PATCH 2/3] audit: fix refcounting in audit-tree
Date: Mon, 25 Jun 2012 19:46:17 +0200
Message-Id: <1340646378-5169-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
References: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Refcounting of fsnotify_mark in audit tree is broken.  E.g:

                              refcount
create_chunk
  alloc_chunk                 1
  fsnotify_add_mark           2

untag_chunk
  fsnotify_get_mark           3
  fsnotify_destroy_mark
    audit_tree_freeing_mark   2
  fsnotify_put_mark           1
  fsnotify_put_mark           0
  via destroy_list
    fsnotify_mark_destroy    -1

This was reported by various people as triggering Oops when stopping auditd.

We could just remove the put_mark from audit_tree_freeing_mark() but that would
break freeing via inode destruction.  So this patch simply omits a put_mark
after calling destroy_mark (or adds a get_mark before).

Next patch will clean up the remaining mess.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 kernel/audit_tree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index d52d247..31fdc48 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -250,7 +250,6 @@ static void untag_chunk(struct node *p)
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
 		fsnotify_destroy_mark(entry);
-		fsnotify_put_mark(entry);
 		goto out;
 	}
 
@@ -293,7 +292,6 @@ static void untag_chunk(struct node *p)
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
 	fsnotify_destroy_mark(entry);
-	fsnotify_put_mark(entry);
 	goto out;
 
 Fallback:
@@ -332,6 +330,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
+		fsnotify_get_mark(entry);
 		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 		return 0;
@@ -412,6 +411,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
+		fsnotify_get_mark(chunk_entry);
 		fsnotify_destroy_mark(chunk_entry);
 
 		fsnotify_put_mark(chunk_entry);
@@ -445,7 +445,6 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&old_entry->lock);
 	fsnotify_destroy_mark(old_entry);
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
-	fsnotify_put_mark(old_entry); /* and kill it */
 	return 0;
 }
 
-- 
1.7.7

