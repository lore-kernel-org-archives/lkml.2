Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0K3J45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:56:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58449 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0K3J4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jVUlaqBSc/cuB38VQ05r82BWSHdS71fCWQOCe8G5PpV+lThI9f8PT2QbKwdyE4qBSK
         uZMZAMonsaf5QDEf3T3qbkPb2Pf5bx9OqGnss2t62JlgVN5/CncK2lGZHggqvkLbBu01
         RO9eIEs6FSMRNehkDy6b+nYyEC9zTmm7aJQZ8=
Date: Tue, 30 Nov 2010 17:56:45 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2] APPARMOR: add sid to profile mapping and sid recycling
Message-ID: <20101130095645.GA2711@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sid to profile mapping and sid recycling.

A security identifier table (sidtab) is a hash table of aa_profile
structures indexed by sid value.

sid_bitmap is a bitmap array for sid allocing and recycling.

alloc_sid: find the first zero bit in the sid_bitmap array.
free_sid: clear the bit in the sid_bitmap array.

v2:
- fix some bugs pointed by john.johansen.
- use list_for_each_entry_* to clean up the code.
- combine the sid alloc and profile addition, and it called from
  aa_alloc_profile and aa_alloc_null_profile.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/include/policy.h |    2 +
 security/apparmor/include/sid.h    |   28 +++++-
 security/apparmor/lsm.c            |   11 ++
 security/apparmor/policy.c         |   77 +++++++++++---
 security/apparmor/sid.c            |  211 ++++++++++++++++++++++++++++++++----
 5 files changed, 292 insertions(+), 37 deletions(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index aeda5cf..14ebd7f 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -30,6 +30,8 @@
 #include "resource.h"
 
 extern const char *profile_mode_names[];
+extern struct aa_sidtab *aa_sid_hash_table;
+
 #define APPARMOR_NAMES_MAX_INDEX 3
 
 #define COMPLAIN_MODE(_profile)	\
diff --git a/security/apparmor/include/sid.h b/security/apparmor/include/sid.h
index 020db35..73c4bd6 100644
--- a/security/apparmor/include/sid.h
+++ b/security/apparmor/include/sid.h
@@ -16,9 +16,33 @@
 
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
 
-u32 aa_alloc_sid(void);
-void aa_free_sid(u32 sid);
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
+u32 aa_alloc_sid(struct aa_profile *new_profile);
+void aa_sidtab_init(struct aa_sidtab *sid_hash_table);
+void init_sid_bitmap(void);
+int replace_profile_by_sid(u32 sid, struct aa_profile *new_profile);
+void free_sidtab(struct aa_sidtab *sid_hash_table);
+int aa_free_sid(u32 sid);
 
 #endif /* __AA_SID_H */
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b7106f1..1758e8e 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -34,6 +34,7 @@
 #include "include/path.h"
 #include "include/policy.h"
 #include "include/procattr.h"
+#include "include/sid.h"
 
 /* Flag indicating whether initialization completed */
 int apparmor_initialized __initdata;
@@ -907,6 +908,15 @@ static int __init apparmor_init(void)
 		return 0;
 	}
 
+	aa_sid_hash_table = kmalloc(sizeof(struct aa_sidtab), GFP_KERNEL);
+	if (!aa_sid_hash_table) {
+		AA_ERROR("Unable to allocate sid hash table\n");
+		return -ENOMEM;
+	}
+
+	aa_sidtab_init(aa_sid_hash_table);
+	init_sid_bitmap();
+
 	error = aa_alloc_root_ns();
 	if (error) {
 		AA_ERROR("Unable to allocate default profile namespace\n");
@@ -943,6 +953,7 @@ register_security_out:
 	aa_free_root_ns();
 
 alloc_out:
+	kfree(aa_sid_hash_table);
 	aa_destroy_aafs();
 
 	apparmor_enabled = 0;
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 4f0eade..01a3025 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -292,7 +292,6 @@ static struct aa_namespace *alloc_namespace(const char *prefix,
 	if (!ns->unconfined)
 		goto fail_unconfined;
 
-	ns->unconfined->sid = aa_alloc_sid();
 	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
 	    PFLAG_IMMUTABLE;
 
@@ -510,6 +509,8 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 	/* released by free_profile */
 	old->replacedby = aa_get_profile(new);
 	__list_remove_profile(old);
+
+	replace_profile_by_sid(old->sid, new);
 }
 
 static void __profile_list_release(struct list_head *head);
@@ -644,6 +645,7 @@ void __init aa_free_root_ns(void)
 struct aa_profile *aa_alloc_profile(const char *hname)
 {
 	struct aa_profile *profile;
+	u32 sid;
 
 	/* freed by free_profile - usually through aa_put_profile */
 	profile = kzalloc(sizeof(*profile), GFP_KERNEL);
@@ -655,6 +657,59 @@ struct aa_profile *aa_alloc_profile(const char *hname)
 		return NULL;
 	}
 
+	sid = aa_alloc_sid(profile);
+	if (sid == -1) {
+		kfree(profile->base.hname);
+		kzfree(profile);
+		return NULL;
+	}
+	profile->sid = sid;
+
+	return profile;
+}
+
+
+/**
+ * aa_alloc_null_profile - allocate, initialize and return a new
+ * null-X learning profile
+ *
+ * Returns: refcount profile or NULL on failure
+ */
+struct aa_profile *aa_alloc_null_profile(struct aa_profile *parent)
+{
+	struct aa_profile *profile;
+	char *name;
+	u32 sid;
+
+	profile = kzalloc(sizeof(*profile), GFP_KERNEL);
+	if (!profile)
+		return NULL;
+
+	sid = aa_alloc_sid(profile);
+	if (sid == -1) {
+		kfree(profile);
+		return NULL;
+	}
+
+	/* freed below */
+	name = kmalloc(strlen(parent->base.hname) + 2 + 7 + 8, GFP_KERNEL);
+	if (!name) {
+		kfree(profile);
+		aa_free_sid(sid);
+		return NULL;
+	}
+
+	sprintf(name, "%s//null-%x", parent->base.hname, sid);
+
+	if (!policy_init(&profile->base, NULL, name)) {
+		aa_free_sid(sid);
+		kzfree(profile);
+		return NULL;
+	}
+
+	profile->sid = sid;
+	kfree(name);
+
 	/* refcount released by caller */
 	return profile;
 }
@@ -676,21 +731,11 @@ struct aa_profile *aa_alloc_profile(const char *hname)
 struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
 {
 	struct aa_profile *profile = NULL;
-	char *name;
-	u32 sid = aa_alloc_sid();
-
-	/* freed below */
-	name = kmalloc(strlen(parent->base.hname) + 2 + 7 + 8, GFP_KERNEL);
-	if (!name)
-		goto fail;
-	sprintf(name, "%s//null-%x", parent->base.hname, sid);
 
-	profile = aa_alloc_profile(name);
-	kfree(name);
+	profile = aa_alloc_null_profile(parent);
 	if (!profile)
 		goto fail;
 
-	profile->sid = sid;
 	profile->mode = APPARMOR_COMPLAIN;
 	profile->flags = PFLAG_NULL;
 	if (hat)
@@ -708,7 +753,6 @@ struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
 	return profile;
 
 fail:
-	aa_free_sid(sid);
 	return NULL;
 }
 
@@ -727,7 +771,7 @@ static void free_profile(struct aa_profile *profile)
 	AA_DEBUG("%s(%p)\n", __func__, profile);
 
 	if (!profile)
-		return;
+		return ;
 
 	if (!list_empty(&profile->base.list)) {
 		AA_ERROR("%s: internal error, "
@@ -736,6 +780,9 @@ static void free_profile(struct aa_profile *profile)
 		BUG();
 	}
 
+	if (aa_free_sid(profile->sid) == -1)
+		return ;
+
 	/* free children profiles */
 	policy_destroy(&profile->base);
 	aa_put_profile(profile->parent);
@@ -747,7 +794,6 @@ static void free_profile(struct aa_profile *profile)
 	aa_free_cap_rules(&profile->caps);
 	aa_free_rlimit_rules(&profile->rlimits);
 
-	aa_free_sid(profile->sid);
 	aa_put_dfa(profile->xmatch);
 
 	aa_put_profile(profile->replacedby);
@@ -945,7 +991,6 @@ static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
 		profile->parent = aa_get_profile((struct aa_profile *) policy);
 	__list_add_profile(&policy->profiles, profile);
 	/* released on free_profile */
-	profile->sid = aa_alloc_sid();
 	profile->ns = aa_get_namespace(ns);
 }
 
diff --git a/security/apparmor/sid.c b/security/apparmor/sid.c
index f0b34f7..4a4fcd4 100644
--- a/security/apparmor/sid.c
+++ b/security/apparmor/sid.c
@@ -14,42 +14,215 @@
  * AppArmor allocates a unique sid for every profile loaded.  If a profile
  * is replaced it receives the sid of the profile it is replacing.
  *
- * The sid value of 0 is invalid.
+ * The sid value of 0 and -1 is invalid.
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
+ */
+static void set_sid_bitmap(u32 sid)
+{
+	sid_bitmap[sid / 32] |= (1 << (sid % 32));
+}
 
 /**
- * aa_alloc_sid - allocate a new sid for a profile
+ * clear_sid_bitmap - clear bitmap with sid in the sid_bitmap array
+ * @sid: sid to clear in the sid_bitmap array
  */
-u32 aa_alloc_sid(void)
+static void clear_sid_bitmap(u32 sid)
 {
-	u32 sid;
+	sid_bitmap[sid / 32] ^= (1 << (sid % 32));
+}
+
+/**
+ * alloc_sid - allocte a unique sid in the sid_bitmap array and add
+ * new profile to sid hash table
+ *
+ * Returns: success return sid, failed return -1
+ */
+u32 aa_alloc_sid(struct aa_profile *new_profile)
+{
+	struct aa_sidtab_node *node = NULL;
+	int hash_value;
+	u32 sid = 0;
+	u32 i, j;
+
+	node = kmalloc(sizeof(struct aa_sidtab_node), GFP_KERNEL);
+	if (!node)
+		return -1;
+
+	node->profile = new_profile;
+	INIT_LIST_HEAD(&node->list);
+
+	/* find the first zero bit in the sid_bitmap array */
+	spin_lock(&aa_sid_hash_table->lock);
+	for (i = 0; i < AA_SID_BITMAP_SIZE; i++) {
+		for (j = 0; j < 32; j++) {
+			if (!(sid_bitmap[i] & (1 << j))) {
+				/* convert offset to sid */
+				sid = i * 32 + j;
+				goto alloc_ok;
+			}
+		}
+	}
+	spin_unlock(&aa_sid_hash_table->lock);
+	kfree(node);
+
+	return -1;
+
+alloc_ok:
+	node->sid = sid;
+	hash_value = AA_SIDTAB_HASH(sid);
+	list_add_tail(&(node->list), &aa_sid_hash_table->sid_list[hash_value]);
+	set_sid_bitmap(sid);
+	spin_unlock(&aa_sid_hash_table->lock);
 
-	/*
-	 * TODO FIXME: sid recycling - part of profile mapping table
-	 */
-	spin_lock(&sid_lock);
-	sid = (++global_sid);
-	spin_unlock(&sid_lock);
 	return sid;
 }
 
 /**
- * aa_free_sid - free a sid
- * @sid: sid to free
+ * aa_sidtab_init - init sid hash table
+ * @sid_hash_table: sid hash table to be created
+ *
+ */
+void aa_sidtab_init(struct aa_sidtab *sid_hash_table)
+{
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
+ * @list_head: list to be freed
+ *
+ * Requires: correct locks for the @list_head be held
+ *
+ */
+static void free_sidtab_list(struct list_head *list_head)
+{
+	struct aa_sidtab_node *p = NULL;
+	struct list_head *s = NULL, *q = NULL;
+
+	list_for_each_safe(s, q, list_head) {
+		p = list_entry(s, struct aa_sidtab_node, list);
+		if (p) {
+			list_del(s);
+			kfree(p);
+		}
+	}
+}
+
+/**
+ * free_sidtab - free memory of sid hash table
+ * @sid_hash_table: sid hash table to be freed
  */
-void aa_free_sid(u32 sid)
+void free_sidtab(struct aa_sidtab *sid_hash_table)
 {
-	;			/* NOP ATM */
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
+ * Requires: correct locks for the @list_head be held
+ * Returns: success a profile struct, failed NULL
+ */
+static struct aa_sidtab_node *search_profile_by_sid(u32 sid)
+{
+	struct aa_sidtab_node *s = NULL;
+	int hash_value = AA_SIDTAB_HASH(sid);
+
+	list_for_each_entry(s, &aa_sid_hash_table->sid_list[hash_value], list) {
+		if (s && s->sid == sid)
+			return s;
+	}
+
+	return NULL;
+}
+
+/**
+ * replace_profile_by_sid  - replace a profile by sid in the sid hash table
+ * @sid: sid to be deleted
+ *
+ * Returns: sccesss 0, failed -1
+ */
+int replace_profile_by_sid(u32 sid, struct aa_profile *new_profile)
+{
+	struct aa_sidtab_node *node;
+
+	spin_lock(&aa_sid_hash_table->lock);
+	node = search_profile_by_sid(sid);
+	if (!node) {
+		spin_unlock(&aa_sid_hash_table->lock);
+		return -1;
+	}
+
+	node->profile = new_profile;
+	spin_unlock(&aa_sid_hash_table->lock);
+
+	return 0;
+}
+
+/**
+ * aa_free_sid - delete a profile by sid in the sid hash table
+ * @sid: sid to be deleted
+ *
+ * Returns: sccesss 0, failed -1
+ */
+int aa_free_sid(u32 sid)
+{
+	struct aa_sidtab_node *node;
+
+	spin_lock(&aa_sid_hash_table->lock);
+	node = search_profile_by_sid(sid);
+	if (!node) {
+		spin_unlock(&aa_sid_hash_table->lock);
+		return -1;
+	}
+
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

