Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2GSJtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:49:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46067 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GSJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:48:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] audit: fix refcounting in audit-tree
References: <87eho8rsjs.fsf@tucsk.pomaz.szeredi.hu>
Date: Thu, 19 Jul 2012 11:48:52 +0200
In-Reply-To: <87eho8rsjs.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 19 Jul 2012 11:47:35 +0200")
Message-ID: <87a9ywrshn.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
after calling destroy_mark or adds a get_mark before.

The additional get_mark is necessary where there's no other put_mark after
fsnotify_destroy_mark() since it assumes that the caller is holding a reference
(or the inode is keeping the mark pinned, not the case here AFAICS).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reported-by: Valentin Avram <aval13@gmail.com>
Reported-by: Peter Moody <pmoody@google.com>
Acked-by: Eric Paris <eparis@redhat.com>
CC: stable@vger.kernel.org
---
 kernel/audit_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/audit_tree.c
===================================================================
--- linux-2.6.orig/kernel/audit_tree.c	2012-06-25 17:55:41.000000000 +0200
+++ linux-2.6/kernel/audit_tree.c	2012-06-25 18:08:03.000000000 +0200
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
@@ -332,6 +330,7 @@ static int create_chunk(struct inode *in
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
+		fsnotify_get_mark(entry);
 		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 		return 0;
@@ -412,6 +411,7 @@ static int tag_chunk(struct inode *inode
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
+		fsnotify_get_mark(chunk_entry);
 		fsnotify_destroy_mark(chunk_entry);
 
 		fsnotify_put_mark(chunk_entry);
@@ -445,7 +445,6 @@ static int tag_chunk(struct inode *inode
 	spin_unlock(&old_entry->lock);
 	fsnotify_destroy_mark(old_entry);
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
-	fsnotify_put_mark(old_entry); /* and kill it */
 	return 0;
 }
 
