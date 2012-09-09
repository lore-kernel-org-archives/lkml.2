Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2IIXPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:15:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805Ab2IIXPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:48 -0400
Message-Id: <20120909224154.830412469@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
        Eric Paris <eparis@redhat.com>
Subject: [ 29/95] audit: dont free_chunk() after fsnotify_add_mark()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 0fe33aae0e94b4097dd433c9399e16e17d638cd8 upstream.

Don't do free_chunk() after fsnotify_add_mark().  That one does a delayed unref
via the destroy list and this results in use-after-free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


