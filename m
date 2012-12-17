Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2LQPCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:02:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17775 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2LQPCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:02:08 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 01/15] userns: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:21 -0500
Message-Id: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using the new hashtable implementation to store user structs.
This reduces the amount of generic unrelated code in kernel/user.c.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/user.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 33acb5e..5333a16 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 #include <linux/proc_fs.h>
+#include <linux/hashtable.h>
 
 /*
  * userns count is 1 for root user, 1 for init_uts_ns,
@@ -62,13 +63,9 @@ EXPORT_SYMBOL_GPL(init_user_ns);
  */
 
 #define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
-#define UIDHASH_SZ	(1 << UIDHASH_BITS)
-#define UIDHASH_MASK		(UIDHASH_SZ - 1)
-#define __uidhashfn(uid)	(((uid >> UIDHASH_BITS) + uid) & UIDHASH_MASK)
-#define uidhashentry(uid)	(uidhash_table + __uidhashfn((__kuid_val(uid))))
 
 static struct kmem_cache *uid_cachep;
-struct hlist_head uidhash_table[UIDHASH_SZ];
+static DEFINE_HASHTABLE(uidhash_table, UIDHASH_BITS);
 
 /*
  * The uidhash_lock is mostly taken from process context, but it is
@@ -94,22 +91,22 @@ struct user_struct root_user = {
 /*
  * These routines must be called with the uidhash spinlock held!
  */
-static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
+static void uid_hash_insert(struct user_struct *up)
 {
-	hlist_add_head(&up->uidhash_node, hashent);
+	hash_add(uidhash_table, &up->uidhash_node, __kuid_val(up->uid));
 }
 
 static void uid_hash_remove(struct user_struct *up)
 {
-	hlist_del_init(&up->uidhash_node);
+	hash_del(&up->uidhash_node);
 }
 
-static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
+static struct user_struct *uid_hash_find(kuid_t uid)
 {
 	struct user_struct *user;
 	struct hlist_node *h;
 
-	hlist_for_each_entry(user, h, hashent, uidhash_node) {
+	hash_for_each_possible(uidhash_table, user, h, uidhash_node, __kuid_val(uid)) {
 		if (uid_eq(user->uid, uid)) {
 			atomic_inc(&user->__count);
 			return user;
@@ -145,7 +142,7 @@ struct user_struct *find_user(kuid_t uid)
 	unsigned long flags;
 
 	spin_lock_irqsave(&uidhash_lock, flags);
-	ret = uid_hash_find(uid, uidhashentry(uid));
+	ret = uid_hash_find(uid);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 	return ret;
 }
@@ -166,11 +163,10 @@ void free_uid(struct user_struct *up)
 
 struct user_struct *alloc_uid(kuid_t uid)
 {
-	struct hlist_head *hashent = uidhashentry(uid);
 	struct user_struct *up, *new;
 
 	spin_lock_irq(&uidhash_lock);
-	up = uid_hash_find(uid, hashent);
+	up = uid_hash_find(uid);
 	spin_unlock_irq(&uidhash_lock);
 
 	if (!up) {
@@ -186,13 +182,13 @@ struct user_struct *alloc_uid(kuid_t uid)
 		 * on adding the same user already..
 		 */
 		spin_lock_irq(&uidhash_lock);
-		up = uid_hash_find(uid, hashent);
+		up = uid_hash_find(uid);
 		if (up) {
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
 		} else {
-			uid_hash_insert(new, hashent);
+			uid_hash_insert(new);
 			up = new;
 		}
 		spin_unlock_irq(&uidhash_lock);
@@ -206,17 +202,12 @@ out_unlock:
 
 static int __init uid_cache_init(void)
 {
-	int n;
-
 	uid_cachep = kmem_cache_create("uid_cache", sizeof(struct user_struct),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	for(n = 0; n < UIDHASH_SZ; ++n)
-		INIT_HLIST_HEAD(uidhash_table + n);
-
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
-	uid_hash_insert(&root_user, uidhashentry(GLOBAL_ROOT_UID));
+	uid_hash_insert(&root_user);
 	spin_unlock_irq(&uidhash_lock);
 
 	return 0;
-- 
1.8.0

