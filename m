Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1COWyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:23 -0400
Received: from shutemov.name ([188.40.19.243]:49809 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 09/13] audit: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:21 +0200
Message-Id: <1300229605-14499-9-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
---
 kernel/audit_tree.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 37b2bea..6fe56d2 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -591,8 +591,7 @@ void audit_trim_trees(void)
 
 		tree = container_of(cursor.next, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&cursor);
-		list_add(&cursor, &tree->list);
+		list_move(&cursor, &tree->list);
 		mutex_unlock(&audit_filter_mutex);
 
 		err = kern_path(tree->pathname, 0, &path);
@@ -744,8 +743,7 @@ int audit_tag_tree(char *old, char *new)
 
 		tree = container_of(cursor.next, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&cursor);
-		list_add(&cursor, &tree->list);
+		list_move(&cursor, &tree->list);
 		mutex_unlock(&audit_filter_mutex);
 
 		err = kern_path(tree->pathname, 0, &path2);
@@ -769,10 +767,8 @@ int audit_tag_tree(char *old, char *new)
 
 		mutex_lock(&audit_filter_mutex);
 		spin_lock(&hash_lock);
-		if (!tree->goner) {
-			list_del(&tree->list);
-			list_add(&tree->list, &tree_list);
-		}
+		if (!tree->goner)
+			list_move(&tree->list, &tree_list);
 		spin_unlock(&hash_lock);
 		put_tree(tree);
 	}
@@ -782,8 +778,7 @@ int audit_tag_tree(char *old, char *new)
 
 		tree = container_of(barrier.prev, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&tree->list);
-		list_add(&tree->list, &barrier);
+		list_move(&tree->list, &barrier);
 		mutex_unlock(&audit_filter_mutex);
 
 		if (!failed) {
-- 
1.7.4.1

