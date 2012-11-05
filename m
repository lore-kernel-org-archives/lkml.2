Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2KENbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:31:36 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33571 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248Ab2KENbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:31:33 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 1/4] drm: Make hashtab rcu-safe
Date: Mon,  5 Nov 2012 14:31:15 +0100
Message-Id: <1352122278-12896-2-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352122278-12896-1-git-send-email-thellstrom@vmware.com>
References: <1352122278-12896-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM base objects will be the first consumer.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/drm_hashtab.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_hashtab.c b/drivers/gpu/drm/drm_hashtab.c
index c3745c4..5729e39 100644
--- a/drivers/gpu/drm/drm_hashtab.c
+++ b/drivers/gpu/drm/drm_hashtab.c
@@ -67,10 +67,8 @@ void drm_ht_verbose_list(struct drm_open_hash *ht, unsigned long key)
 	hashed_key = hash_long(key, ht->order);
 	DRM_DEBUG("Key is 0x%08lx, Hashed key is 0x%08x\n", key, hashed_key);
 	h_list = &ht->table[hashed_key];
-	hlist_for_each(list, h_list) {
-		entry = hlist_entry(list, struct drm_hash_item, head);
+	hlist_for_each_entry_rcu(entry, list, h_list, head)
 		DRM_DEBUG("count %d, key: 0x%08lx\n", count++, entry->key);
-	}
 }
 
 static struct hlist_node *drm_ht_find_key(struct drm_open_hash *ht,
@@ -83,8 +81,7 @@ static struct hlist_node *drm_ht_find_key(struct drm_open_hash *ht,
 
 	hashed_key = hash_long(key, ht->order);
 	h_list = &ht->table[hashed_key];
-	hlist_for_each(list, h_list) {
-		entry = hlist_entry(list, struct drm_hash_item, head);
+	hlist_for_each_entry_rcu(entry, list, h_list, head) {
 		if (entry->key == key)
 			return list;
 		if (entry->key > key)
@@ -105,8 +102,7 @@ int drm_ht_insert_item(struct drm_open_hash *ht, struct drm_hash_item *item)
 	hashed_key = hash_long(key, ht->order);
 	h_list = &ht->table[hashed_key];
 	parent = NULL;
-	hlist_for_each(list, h_list) {
-		entry = hlist_entry(list, struct drm_hash_item, head);
+	hlist_for_each_entry_rcu(entry, list, h_list, head) {
 		if (entry->key == key)
 			return -EINVAL;
 		if (entry->key > key)
@@ -114,9 +110,9 @@ int drm_ht_insert_item(struct drm_open_hash *ht, struct drm_hash_item *item)
 		parent = list;
 	}
 	if (parent) {
-		hlist_add_after(parent, &item->head);
+		hlist_add_after_rcu(parent, &item->head);
 	} else {
-		hlist_add_head(&item->head, h_list);
+		hlist_add_head_rcu(&item->head, h_list);
 	}
 	return 0;
 }
@@ -171,7 +167,7 @@ int drm_ht_remove_key(struct drm_open_hash *ht, unsigned long key)
 
 	list = drm_ht_find_key(ht, key);
 	if (list) {
-		hlist_del_init(list);
+		hlist_del_init_rcu(list);
 		return 0;
 	}
 	return -EINVAL;
@@ -179,7 +175,7 @@ int drm_ht_remove_key(struct drm_open_hash *ht, unsigned long key)
 
 int drm_ht_remove_item(struct drm_open_hash *ht, struct drm_hash_item *item)
 {
-	hlist_del_init(&item->head);
+	hlist_del_init_rcu(&item->head);
 	return 0;
 }
 EXPORT_SYMBOL(drm_ht_remove_item);
-- 
1.7.4.4

