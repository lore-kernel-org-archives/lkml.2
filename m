Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2ILXoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:44:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab2ILXoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Valentin Avram <aval13@gmail.com>, Peter Moody <pmoody@google.com>,
        Eric Paris <eparis@redhat.com>
Subject: [ 19/46] audit: fix refcounting in audit-tree
Date: Wed, 12 Sep 2012 16:39:09 -0700
Message-Id: <20120912233819.675862459@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit a2140fc0cb0325bb6384e788edd27b9a568714e2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -256,7 +256,6 @@ static void untag_chunk(struct node *p)
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
 		fsnotify_destroy_mark(entry);
-		fsnotify_put_mark(entry);
 		goto out;
 	}
 
@@ -299,7 +298,6 @@ static void untag_chunk(struct node *p)
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
 	fsnotify_destroy_mark(entry);
-	fsnotify_put_mark(entry);
 	goto out;
 
 Fallback:
@@ -338,6 +336,7 @@ static int create_chunk(struct inode *in
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
+		fsnotify_get_mark(entry);
 		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 		return 0;
@@ -418,6 +417,7 @@ static int tag_chunk(struct inode *inode
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
+		fsnotify_get_mark(chunk_entry);
 		fsnotify_destroy_mark(chunk_entry);
 
 		fsnotify_put_mark(chunk_entry);
@@ -451,7 +451,6 @@ static int tag_chunk(struct inode *inode
 	spin_unlock(&old_entry->lock);
 	fsnotify_destroy_mark(old_entry);
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
-	fsnotify_put_mark(old_entry); /* and kill it */
 	return 0;
 }
 


