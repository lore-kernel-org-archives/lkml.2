Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0KSGKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 01:10:03 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:42029 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0KSGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 01:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o6nzm/B5uVKu9FRQ6EnX48H/VyqaVeAbIPDTXflWQfDiUM9iT2Ujv14xiDcK04hbjH
         JNzTi3g5H93z1NnF6fXVn4G8QaubWXyPlBbWppk6XzTB2ZddBbCtibkR7EO7By9APRta
         lejCrKgzAU2kbuzne/oqZDadog9wJT3Eg0bLg=
Date: Fri, 19 Nov 2010 14:09:54 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [RFC][PATCH] APPARMOR: add sid to profile mapping and sid recycling
Message-ID: <20101119060954.GA2775@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AppArmor: add sid to profile mapping and sid recycling.

A security identifier table (sidtab) is a hash table of aa_profile
structures indexed by sid value.

sid_bitmap is a bitmap array for sid allocing and recycling.

alloc_sid: find the first zero bit in the sid_bitmap array.
free_sid: clear the bit in the sid_bitmap array.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/include/policy.h |    1 +
 security/apparmor/include/sid.h    |   27 ++++-
 security/apparmor/lsm.c            |    9 ++
 security/apparmor/policy.c         |   36 +++++-
 security/apparmor/sid.c            |  225 +++++++++++++++++++++++++++++++++---
 5 files changed, 274 insertions(+), 24 deletions(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index aeda5cf..dbb3614 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -30,6 +30,7 @@
 #include "resource.h"
 
 extern const char *profile_mode_names[];
+extern struct aa_sidtab *aa_sid_hash_table;
 #define APPARMOR_NAMES_MAX_INDEX 3
 
 #define COMPLAIN_MODE(_profile)	\
diff --git a/security/apparmor/include/sid.h b/security/apparmor/include/sid.h
index 020db35..7759931 100644
--- a/security/apparmor/include/sid.h
+++ b/security/apparmor/include/sid.h
@@ -16,9 +16,34 @@
 
 #include <linux/types.h>
 
+#define AA_SIDTAB_HASH_BITS        7
+#define AA_SIDTAB_HASH_BUCKETS     (1 << AA_SIDTAB_HASH_BITS)
+#define AA_SIDTAB_HASH_MASK        (AA_SIDTAB_HASH_BUCKETS - 1)
+
+#define AA_SIDTAB_SIZE             AA_SIDTAB_HASH_BUCKETS
+#define AA_SIDTAB_HASH(sid)        (sid & AA_SIDTAB_HASH_MASK)
+
+#define AA_SID_BITMAP_SIZE         1024
+
 struct aa_profile;
 
+struct aa_sidtab_node {
+	u32 sid;
+	struct aa_profile *profile;
+	struct list_head list;
+};
+
+struct aa_sidtab {
+	struct list_head sid_list[AA_SIDTAB_SIZE];
+	spinlock_t lock;
+};
+
 u32 aa_alloc_sid(void);
-void aa_free_sid(u32 sid);
+void aa_sidtab_init(struct aa_sidtab *sid_hash_table);
+void init_sid_bitmap(void);
+void clear_sid_bitmap(u32 sid);
+void free_sidtab(struct aa_sidtab *sid_hash_table);
+int add_profile(u32 sid, struct aa_profile *new_profile);
+int aa_free_sid(u32 sid);
 
 #endif /* __AA_SID_H */
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index cf1de44..7e1f7b7 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -34,6 +34,7 @@
 #include "include/path.h"
 #include "include/policy.h"
 #include "include/procattr.h"
+#include "include/sid.h"
 
 /* Flag indicating whether initialization completed */
 int apparmor_initialized __initdata;
@@ -907,6 +908,13 @@ static int __init apparmor_init(void)
 		return 0;
 	}
 
+	aa_sid_hash_table = kmalloc(sizeof(struct aa_sidtab), GFP_KERNEL);
+	if (!aa_sid_hash_table)
+		return -ENOMEM;
+
+	aa_sidtab_init(aa_sid_hash_table);
+	init_sid_bitmap();
+
 	error = aa_alloc_root_ns();
 	if (error) {
 		AA_ERROR("Unable to allocate default profile namespace\n");
@@ -940,6 +948,7 @@ register_security_out:
 	aa_free_root_ns();
 
 alloc_out:
+	kfree(aa_sid_hash_table);
 	aa_destroy_aafs();
 
 	apparmor_enabled = 0;
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 52cc865..dd2191c 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -276,6 +276,7 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 					    const char *name)
 {
 	struct aa_namespace *ns;
+	u32 sid;
 
 	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
 	AA_DEBUG("%s(%p)\n", __func__, ns);
@@ -292,7 +293,11 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 	if (!ns->unconfined)
 		goto fail_unconfined;
 
-	ns->unconfined->sid = aa_alloc_sid();
+	sid = aa_alloc_sid();
+	if (sid == -1)
+		goto fail_unconfined;
+
+	ns->unconfined->sid = sid;
 	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
 	    PFLAG_IMMUTABLE;
 
@@ -303,6 +308,9 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 	 */
 	ns->unconfined->ns = aa_get_namespace(ns);
 
+	if (add_profile(sid, ns->unconfined) != 0)
+		goto fail_unconfined;
+
 	return ns;
 
 fail_unconfined:
@@ -510,6 +518,9 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 	/* released by free_profile */
 	old->replacedby = aa_get_profile(new);
 	__list_remove_profile(old);
+
+	/* free old sid in the sid hash table */
+	aa_free_sid(old->sid);
 }
 
 static void __profile_list_release(struct list_head *head);
@@ -677,7 +688,11 @@ struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
 {
 	struct aa_profile *profile = NULL;
 	char *name;
-	u32 sid = aa_alloc_sid();
+	u32 sid;
+
+	sid = aa_alloc_sid();
+	if (sid == -1)
+		return NULL;
 
 	/* freed below */
 	name = kmalloc(strlen(parent->base.hname) + 2 + 7 + 8, GFP_KERNEL);
@@ -704,11 +719,16 @@ struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
 	__list_add_profile(&parent->base.profiles, profile);
 	write_unlock(&profile->ns->lock);
 
+	if (add_profile(sid, profile) != 0) {
+		kfree(profile->base.hname);
+		kfree(profile);
+		goto fail;
+	}
+
 	/* refcount released by caller */
 	return profile;
 
 fail:
-	aa_free_sid(sid);
 	return NULL;
 }
 
@@ -736,6 +756,9 @@ static void free_profile(struct aa_profile *profile)
 		BUG();
 	}
 
+	if (aa_free_sid(profile->sid) == -1)
+		return ;
+
 	/* free children profiles */
 	policy_destroy(&profile->base);
 	aa_put_profile(profile->parent);
@@ -747,7 +770,6 @@ static void free_profile(struct aa_profile *profile)
 	aa_free_cap_rules(&profile->caps);
 	aa_free_rlimit_rules(&profile->rlimits);
 
-	aa_free_sid(profile->sid);
 	aa_put_dfa(profile->xmatch);
 
 	aa_put_profile(profile->replacedby);
@@ -940,12 +962,16 @@ static int replacement_allowed(struct aa_profile *profile, int noreplace,
 static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
 			      struct aa_profile *profile)
 {
+	profile->sid = aa_alloc_sid();
+	if (profile->sid == -1)
+		return ;
+	if (add_profile(profile->sid, profile) == -1)
+		return ;
 	if (policy != &ns->base)
 		/* released on profile replacement or free_profile */
 		profile->parent = aa_get_profile((struct aa_profile *) policy);
 	__list_add_profile(&policy->profiles, profile);
 	/* released on free_profile */
-	profile->sid = aa_alloc_sid();
 	profile->ns = aa_get_namespace(ns);
 }
 
diff --git a/security/apparmor/sid.c b/security/apparmor/sid.c
index f0b34f7..d3b30cc 100644
--- a/security/apparmor/sid.c
+++ b/security/apparmor/sid.c
@@ -15,41 +15,230 @@
  * is replaced it receives the sid of the profile it is replacing.
  *
  * The sid value of 0 is invalid.
+ *
+ * A security identifier table (sidtab) is a hash table of aa_profile
+ * structures indexed by sid value.
  */
 
+#include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/list.h>
 #include <linux/errno.h>
-#include <linux/err.h>
 
 #include "include/sid.h"
 
-/* global counter from which sids are allocated */
-static u32 global_sid;
-static DEFINE_SPINLOCK(sid_lock);
+struct aa_sidtab *aa_sid_hash_table;
+u32 sid_bitmap[AA_SID_BITMAP_SIZE] = {0};
 
-/* TODO FIXME: add sid to profile mapping, and sid recycling */
+/**
+ * set_sid_bitmap - set bitmap with sid in the sid_bitmap array
+ * @sid: sid to set in the sid_bitmap array
+ * Returns: NULL
+ */
+void set_sid_bitmap(u32 sid)
+{
+	sid_bitmap[sid / 32] |= (1 << (sid % 32));
+}
 
 /**
- * aa_alloc_sid - allocate a new sid for a profile
+ * clear_sid_bitmap - clear bitmap with sid in the sid_bitmap array
+ * @sid: sid to clear in the sid_bitmap array
+ *
+ * Returns: NULL
+ */
+void clear_sid_bitmap(u32 sid)
+{
+	sid_bitmap[sid / 32] ^= (1 << (sid % 32));
+}
+
+/**
+ * alloc_sid - allocte a unique sid in the sid_bitmap array
+ *
+ * Returns: success return sid, failed return -1
  */
 u32 aa_alloc_sid(void)
 {
-	u32 sid;
+	u32 i, j;
+	u32 sid = 0;
+
+	/* find the first zero bit in the sid_bitmap array */
+	spin_lock(&aa_sid_hash_table->lock);
+	for (i = 0; i < AA_SID_BITMAP_SIZE; i++) {
+		for (j = 0; j < 32; j++) {
+			if (!(sid_bitmap[i] & (1 << j))) {
+				/* convert offset to sid */
+				sid = i * 32 + j;
+				spin_unlock(&aa_sid_hash_table->lock);
+				return sid;
+			}
+		}
+	}
+	spin_unlock(&aa_sid_hash_table->lock);
 
-	/*
-	 * TODO FIXME: sid recycling - part of profile mapping table
-	 */
-	spin_lock(&sid_lock);
-	sid = (++global_sid);
-	spin_unlock(&sid_lock);
-	return sid;
+	return -1;
 }
 
 /**
- * aa_free_sid - free a sid
- * @sid: sid to free
+ * aa_sidtab_init - init sid hash table
+ * @sid_hash_table: sid hash table to be created
+ *
  */
-void aa_free_sid(u32 sid)
+void aa_sidtab_init(struct aa_sidtab *sid_hash_table)
 {
-	;			/* NOP ATM */
+	int i;
+
+	for (i = 0; i < AA_SIDTAB_SIZE; i++)
+		INIT_LIST_HEAD(&sid_hash_table->sid_list[i]);
+
+	spin_lock_init(&sid_hash_table->lock);
+}
+
+/**
+ * init_sid_bitmap - init sid_bitmap array
+ */
+void init_sid_bitmap(void)
+{
+	/* The sid value of 0 is invalid */
+	sid_bitmap[0] = 1;
+}
+
+/**
+ * free_sidtab_list - free memory of a aa_profile list
+ * @list_head: list to be free
+ *
+ * Requires: correct locks for the @list_head be held
+ *
+ */
+static void free_sidtab_list(struct list_head *list_head)
+{
+	struct aa_sidtab_node *p = NULL;
+	struct list_head *s = NULL, *q = NULL;
+
+	for (s = list_head->next; s != list_head; s = q) {
+		if (!s)
+			return ;
+		q = s->next;
+		p = list_entry(s, struct aa_sidtab_node, list);
+		if (p) {
+			list_del(s);
+			kfree(p);
+			p = NULL;
+		}
+	}
+}
+
+/**
+ * free_sidtab - free memory of sid hash table
+ * @sid_hash_table: sid hash table to be free
+ *
+ */
+void free_sidtab(struct aa_sidtab *sid_hash_table)
+{
+	int i;
+
+	spin_lock(&sid_hash_table->lock);
+	for (i = 0; i < AA_SIDTAB_SIZE; i++) {
+		if (list_empty(&sid_hash_table->sid_list[i]))
+			continue;
+		free_sidtab_list(&sid_hash_table->sid_list[i]);
+	}
+	spin_unlock(&sid_hash_table->lock);
+
+	kfree(sid_hash_table);
+}
+
+/**
+ * search_profile_by_sid - search a profile by sid
+ * @sid: sid to be searched
+ *
+ * Returns: success a profile struct, failed NULL
+ */
+static struct aa_sidtab_node *search_profile_by_sid(u32 sid)
+{
+	struct aa_sidtab_node *s = NULL;
+	struct list_head *p = NULL;
+	int hash_value = AA_SIDTAB_HASH(sid);
+
+	spin_lock(&aa_sid_hash_table->lock);
+	list_for_each(p, &aa_sid_hash_table->sid_list[hash_value]) {
+		s = list_entry(p, struct aa_sidtab_node, list);
+		if (s && s->sid == sid) {
+			spin_unlock(&aa_sid_hash_table->lock);
+			return s;
+		}
+	}
+	spin_unlock(&aa_sid_hash_table->lock);
+
+	return NULL;
+}
+
+/**
+ * insert_profile_by_sid - insert a profile into sid hash table
+ * @sid: sid to be add
+ * @node: sidtab_node to be add
+ *
+ * Returns: success 0, failed -1
+ */
+static int insert_profile_by_sid(u32 sid, struct aa_sidtab_node *node)
+{
+	int hash_value = AA_SIDTAB_HASH(sid);
+
+	if (search_profile_by_sid(sid))
+		return -1;
+
+	spin_lock(&aa_sid_hash_table->lock);
+	list_add_tail(&(node->list), &aa_sid_hash_table->sid_list[hash_value]);
+	set_sid_bitmap(sid);
+	spin_unlock(&aa_sid_hash_table->lock);
+
+	return 0;
+}
+
+/**
+ * add_profile - add a profile to sid hash table
+ * @new_profile: profile to be add
+ *
+ * Returns: success 0, failed an error value
+ */
+int add_profile(u32 sid, struct aa_profile *new_profile)
+{
+	struct aa_sidtab_node *node = NULL;
+
+	node = kmalloc(sizeof(struct aa_sidtab_node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->sid = sid;
+	node->profile = new_profile;
+	INIT_LIST_HEAD(&node->list);
+
+	if (insert_profile_by_sid(node->sid, node) == -1) {
+		kfree(node);
+		return -1;
+	}
+	return 0;
+}
+
+/**
+ * aa_free_sid - delete a profile by sid in the sid hash table
+ * @sid: sid to be delete
+ *
+ * Returns: sccesss 0, failed -1
+ */
+int aa_free_sid(u32 sid)
+{
+	struct aa_sidtab_node *node;
+
+	node = search_profile_by_sid(sid);
+	if (!node)
+		return -1;
+
+	spin_lock(&aa_sid_hash_table->lock);
+	list_del(&(node->list));
+	clear_sid_bitmap(sid);
+	spin_unlock(&aa_sid_hash_table->lock);
+
+	kfree(node);
+
+	return 0;
 }
-- 
1.6.5.3

