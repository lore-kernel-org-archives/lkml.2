Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2IFFZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:25:35 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62745 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IFFZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:25:34 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 13:25:33 +0800
Message-ID: <CAPgLHd_JoWyH1CQkr+b4E8rsFas09qV4U09ELHa6Rn8RpxSU-Q@mail.gmail.com>
Subject: [PATCH] audit: use list_move instead of list_del/list_add in audit-tree
From: Wei Yongjun <weiyj.lk@gmail.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/audit_tree.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ed206fd..56c4a9e 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -585,8 +585,7 @@ void audit_trim_trees(void)
 
 		tree = container_of(cursor.next, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&cursor);
-		list_add(&cursor, &tree->list);
+		list_move(&cursor, &tree->list);
 		mutex_unlock(&audit_filter_mutex);
 
 		err = kern_path(tree->pathname, 0, &path);
@@ -738,8 +737,7 @@ int audit_tag_tree(char *old, char *new)
 
 		tree = container_of(cursor.next, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&cursor);
-		list_add(&cursor, &tree->list);
+		list_move(&cursor, &tree->list);
 		mutex_unlock(&audit_filter_mutex);
 
 		err = kern_path(tree->pathname, 0, &path2);
@@ -764,8 +762,7 @@ int audit_tag_tree(char *old, char *new)
 		mutex_lock(&audit_filter_mutex);
 		spin_lock(&hash_lock);
 		if (!tree->goner) {
-			list_del(&tree->list);
-			list_add(&tree->list, &tree_list);
+			list_move(&tree->list, &tree_list);
 		}
 		spin_unlock(&hash_lock);
 		put_tree(tree);
@@ -776,8 +773,7 @@ int audit_tag_tree(char *old, char *new)
 
 		tree = container_of(barrier.prev, struct audit_tree, list);
 		get_tree(tree);
-		list_del(&tree->list);
-		list_add(&tree->list, &barrier);
+		list_move(&tree->list, &barrier);
 		mutex_unlock(&audit_filter_mutex);
 
 		if (!failed) {


