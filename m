Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab0GOAqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:46:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56943 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0GOAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:05 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 04/13] AppArmor: core policy routines
Date: Wed, 14 Jul 2010 17:43:32 -0700
Message-Id: <1279154621-25868-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic routines and defines for AppArmor policy.  AppArmor policy
is defined by a few basic components.
      profiles - the basic unit of confinement contain all the information
                 to enforce policy on a task

                 Profiles tend to be named after an executable that they
                 will attach to but this is not required.
      namespaces - a container for a set of profiles that will be used
                 during attachment and transitions between profiles.
      sids - which provide a unique id for each profile

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/policy.h |  312 ++++++++++
 security/apparmor/include/sid.h    |   24 +
 security/apparmor/policy.c         | 1177 ++++++++++++++++++++++++++++++++++++
 security/apparmor/sid.c            |   55 ++
 4 files changed, 1568 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/policy.h
 create mode 100644 security/apparmor/include/sid.h
 create mode 100644 security/apparmor/policy.c
 create mode 100644 security/apparmor/sid.c

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
new file mode 100644
index 0000000..9125076
--- /dev/null
+++ b/security/apparmor/include/policy.h
@@ -0,0 +1,312 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor policy definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_POLICY_H
+#define __AA_POLICY_H
+
+#include <linux/capability.h>
+#include <linux/cred.h>
+#include <linux/kref.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
+
+#include "apparmor.h"
+#include "audit.h"
+#include "capability.h"
+#include "domain.h"
+#include "file.h"
+#include "resource.h"
+
+extern const char *profile_mode_names[];
+#define APPARMOR_NAMES_MAX_INDEX 3
+
+#define COMPLAIN_MODE(_profile)				\
+	((aa_g_profile_mode == APPARMOR_COMPLAIN) || ((_profile) &&	\
+					(_profile)->mode == APPARMOR_COMPLAIN))
+
+#define DO_KILL(_profile)					\
+	((aa_g_profile_mode == APPARMOR_KILL) || ((_profile) &&	\
+					(_profile)->mode == APPARMOR_KILL))
+
+#define PROFILE_IS_HAT(_profile) \
+	((_profile) && (_profile)->flags & PFLAG_HAT)
+
+/*
+ * FIXME: currently need a clean way to replace and remove profiles as a
+ * set.  It should be done at the namespace level.
+ * Either, with a set of profiles loaded at the namespace level or via
+ * a mark and remove marked interface.
+ */
+enum profile_mode {
+	APPARMOR_ENFORCE,	/* enforce access rules */
+	APPARMOR_COMPLAIN,	/* allow and log access violations */
+	APPARMOR_KILL,		/* kill task on access violation */
+};
+
+enum profile_flags {
+	PFLAG_HAT = 1,			/* profile is a hat */
+	PFLAG_UNCONFINED = 2,		/* profile is the unconfined profile */
+	PFLAG_NULL = 4,			/* profile is null learning profile */
+	PFLAG_IX_ON_NAME_ERROR = 8,	/* fallback to ix on name lookup fail */
+	PFLAG_IMMUTABLE = 0x10,		/* don't allow changes/replacement */
+	PFLAG_USER_DEFINED = 0x20,	/* user based profile */
+	PFLAG_NO_LIST_REF = 0x40,	/* list doesn't keep profile ref */
+	PFLAG_MMAP_MIN_ADDR = 0x80,	/* profile controls mmap_min_addr */
+	PFLAG_OLD_NULL_TRANS = 0x100,	/* use // as the null transition */
+
+	/* These flags must coorespond with PATH_flags */
+	PFLAG_MEDIATE_DELETED = 0x10000, /* mediate instead delegate deleted */
+};
+
+#define AA_NEW_SID 0
+
+struct aa_profile;
+
+/* struct aa_policy - common part of both namespaces and profiles
+ * @name: name of the object
+ * @hname - The hierarchical name
+ * @count: reference count of the obj
+ * @list: list policy object is on
+ * @profiles: head of the profiles list contained in the object
+ */
+struct aa_policy {
+	char *name;
+	char *hname;
+	struct kref count;
+	struct list_head list;
+	struct list_head profiles;
+};
+
+/* struct aa_ns_acct - accounting of profiles in namespace
+ * @max_size: maximum space allowed for all profiles in namespace
+ * @max_count: maximum number of profiles that can be in this namespace
+ * @size: current size of profiles
+ * @count: current count of profiles (includes null profiles)
+ */
+struct aa_ns_acct {
+	int max_size;
+	int max_count;
+	int size;
+	int count;
+};
+
+/* struct aa_namespace - namespace for a set of profiles
+ * @base: common policy
+ * @parent: parent of namespace
+ * @lock: lock for modifying the object
+ * @acct: accounting for the namespace
+ * @unconfined: special unconfined profile for the namespace
+ * @sub_ns: list of namespaces under the current namespace.
+ *
+ * An aa_namespace defines the set profiles that are searched to determine
+ * which profile to attach to a task.  Profiles can not be shared between
+ * aa_namespaces and profile names within a namespace are guarenteed to be
+ * unique.  When profiles in seperate namespaces have the same name they
+ * are NOT considered to be equivalent.
+ *
+ * Namespaces are hierarchical and only namespaces and profiles below the
+ * current namespace are visible.
+ *
+ * Namespace names must be unique and can not contain the characters :/\0
+ *
+ * FIXME TODO: add vserver support so a vserer (can it all be done in userspace)
+ */
+struct aa_namespace {
+	struct aa_policy base;
+	struct aa_namespace *parent;
+	rwlock_t lock;
+	struct aa_ns_acct acct;
+	struct aa_profile *unconfined;
+	struct list_head sub_ns;
+};
+
+/* struct aa_profile - basic confinement data
+ * @base - base componets of the profile (name, refcount, lists, lock ...)
+ * @parent: parent of profile
+ * @ns: namespace the profile is in
+ * @replacedby: is set profile that replaced this profile
+ * @rename: optional profile name that this profile renamed
+ * @xmatch: optional extended matching for unconfined executables names
+ * @xmatch_len: xmatch prefix len, used to determine xmatch priority
+ * @sid: the unique security id number of this profile
+ * @audit: the auditing mode of the profile
+ * @mode: the enforcement mode of the profile
+ * @flags: flags controlling profile behavior
+ * @path_flags: flags controlling path generation behavior
+ * @size: the memory consumed by this profiles rules
+ * @file: The set of rules governing basic file access and domain transitions
+ * @caps: capabilities for the profile
+ * @rlimits: rlimits for the profile
+ *
+ * The AppArmor profile contains the basic confinement data.  Each profile
+ * has a name, and exists in a namespace.  The @name and @exec_match are
+ * used to determine profile attachment against unconfined tasks.  All other
+ * attachments are determined by profile X transition rules.
+ *
+ * The @replacedby field is write protected by the profile lock.  Reads
+ * are assumed to be atomic, and are done without locking.
+ *
+ * Profiles have a hierachy where hats and children profiles keep
+ * a reference to their parent.
+ *
+ * Profile names can not begin with a : and can not contain the \0
+ * character.  If a profile name begins with / it will be considered when
+ * determining profile attachment on "unconfined" tasks.
+ */
+struct aa_profile {
+	struct aa_policy base;
+	struct aa_profile *parent;
+
+	struct aa_namespace *ns;
+	struct aa_profile *replacedby;
+	const char *rename;
+
+	struct aa_dfa *xmatch;
+	int xmatch_len;
+	u32 sid;
+	enum audit_mode audit;
+	enum profile_mode mode;
+	u32 flags;
+	u32 path_flags;
+	int size;
+
+	unsigned long mmap_min_addr;
+
+	struct aa_file_rules file;
+	struct aa_caps caps;
+	struct aa_rlimit rlimits;
+};
+
+extern struct aa_namespace *root_ns;
+extern enum profile_mode aa_g_profile_mode;
+
+void aa_add_profile(struct aa_policy *common, struct aa_profile *profile);
+
+bool aa_ns_visible(struct aa_namespace *parent, struct aa_namespace *child);
+const char *aa_ns_name(struct aa_namespace *parent, struct aa_namespace *child);
+int aa_alloc_root_ns(void);
+void aa_free_root_ns(void);
+void aa_free_namespace_kref(struct kref *kref);
+
+struct aa_namespace *aa_find_namespace(struct aa_namespace *root,
+				       const char *name);
+
+static inline struct aa_policy *aa_get_common(struct aa_policy *c)
+{
+	if (c)
+		kref_get(&c->count);
+
+	return c;
+}
+
+/**
+ * aa_get_namespace - increment references count on @ns
+ * @ns: namespace to increment reference count of (MAYBE NULL)
+ *
+ * Returns: pointer to @ns if @ns is NULL returns NULL
+ * Requires: @ns must be held with valid refcount when called
+ */
+static inline struct aa_namespace *aa_get_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		kref_get(&(ns->base.count));
+
+	return ns;
+}
+
+/**
+ * aa_put_namespace - decrement refcount on @ns
+ * @ns: namespace to put reference to
+ *
+ * Decrement reference count to @ns and if no longer in use free it
+ */
+static inline void aa_put_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		kref_put(&ns->base.count, aa_free_namespace_kref);
+}
+
+struct aa_profile *aa_alloc_profile(const char *name);
+struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat);
+void aa_free_profile_kref(struct kref *kref);
+struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name);
+struct aa_profile *aa_lookup_profile(struct aa_namespace *ns, const char *name);
+struct aa_profile *aa_match_profile(struct aa_namespace *ns, const char *name);
+
+ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace);
+ssize_t aa_remove_profiles(char *name, size_t size);
+
+#define PROF_ADD 1
+#define PROF_REPLACE 0
+
+#define unconfined(X) ((X)->flags & PFLAG_UNCONFINED)
+
+/**
+ * aa_newest_version - find the newest version of @profile
+ * @profile: the profile to check for newer versions of (NOT NULL)
+ *
+ * Returns: newest version of @profile, if @profile is the newest version
+ *          return @profile.
+ *
+ * NOTE: the profile returned is not refcounted, The refcount on @profile
+ * must be held until the caller decides what to do with the returned newest
+ * version.
+ */
+static inline struct aa_profile *aa_newest_version(struct aa_profile *profile)
+{
+	if (unlikely(profile && profile->replacedby))
+		for (; profile->replacedby; profile = profile->replacedby)
+			;
+
+	return profile;
+}
+
+/**
+ * aa_get_profile - increment refcount on profile @p
+ * @p: profile  (MAYBE NULL)
+ *
+ * Returns: pointer to @p if @p is NULL will return NULL
+ * Requires: @p must be held with valid refcount when called
+ */
+static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
+{
+	if (p)
+		kref_get(&(p->base.count));
+
+	return p;
+}
+
+/**
+ * aa_put_profile - decrement refcount on profile @p
+ * @p: profile  (MAYBE NULL)
+ */
+static inline void aa_put_profile(struct aa_profile *p)
+{
+	if (p)
+		kref_put(&p->base.count, aa_free_profile_kref);
+}
+
+static inline int AUDIT_MODE(struct aa_profile *profile)
+{
+	if (aa_g_audit != AUDIT_NORMAL)
+		return aa_g_audit;
+	if (profile)
+		return profile->audit;
+	return AUDIT_NORMAL;
+}
+
+bool aa_may_manage_policy(int op);
+
+#endif /* __AA_POLICY_H */
diff --git a/security/apparmor/include/sid.h b/security/apparmor/include/sid.h
new file mode 100644
index 0000000..020db35
--- /dev/null
+++ b/security/apparmor/include/sid.h
@@ -0,0 +1,24 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor security identifier (sid) definitions
+ *
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_SID_H
+#define __AA_SID_H
+
+#include <linux/types.h>
+
+struct aa_profile;
+
+u32 aa_alloc_sid(void);
+void aa_free_sid(u32 sid);
+
+#endif /* __AA_SID_H */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
new file mode 100644
index 0000000..de659cc
--- /dev/null
+++ b/security/apparmor/policy.c
@@ -0,0 +1,1177 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor policy manipulation functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ * AppArmor policy is based around profiles, which contain the rules a
+ * task is confined by.  Every task in the sytem has a profile attached
+ * to it determined either by matching "unconfined" tasks against the
+ * visible set of profiles or by following a profiles attachment rules.
+ *
+ * Each profile exists in a profile namespace which is a container of
+ * visible profiles.  Each namespace contains a special "unconfined" profile,
+ * which doesn't enforce any confinement on a task beyond DAC.
+ *
+ * Namespace and profile names can be written together in either
+ * of two syntaxes.
+ *	:namespace:profile - used by kernel interfaces for easy detection
+ *	namespace://profile - used by policy
+ *
+ * Profile names can not start with : or @ or ^ and may not contain \0
+ *
+ * Reserved profile names
+ *	unconfined - special automatically generated unconfined profile
+ *	inherit - special name to indicate profile inheritance
+ *	null-XXXX-YYYY - special automically generated learning profiles
+ *
+ * Namespace names may not start with / or @ and may not contain \0 or :
+ * Reserved namespace namespace
+ *	user-XXXX - user defined profiles
+ *
+ * a // in a profile or namespace name indicates a hierarcical name with the
+ * name before the // being the parent and the name after the child.
+ *
+ * Profile and namespace hierachies serve two different but similar purposes.
+ * The namespace contains the set of visible profiles that are considered
+ * for attachment.  The hierarchy of namespaces allows for virtualizing
+ * the namespace so that for example a chroot can have its own set of profiles
+ * which may define some local user namespaces.
+ * The profile hierachy severs two distinct purposes,
+ * -  it allows for sub profiles or hats, which allows an application to run
+ *    subprograms under its own profile with different restriction than it
+ *    self, and not have it use the system profile.
+ *    eg. if a mail program starts an editor, the policy might make the
+ *        restrictions tighter on the editor tighter than the mail program,
+ *        and definitely different than general editor restrictions
+ * - it allows for binary hierarchy of profiles, so that execution history
+ *   is preserved.  This feature isn't exploited by AppArmor reference policy
+ *   but is allowed.  NOTE: this is currently suboptimal because profile
+ *   aliasing is not currently implemented so that a profile for each
+ *   level must be defined.
+ *   eg. /bin/bash///bin/ls as a name would indicate /bin/ls was started
+ *       from /bin/bash
+ *
+ *   A profile or namespace name that can contain one or more // seperators
+ *   is refered to as an hname (hierarchical).
+ *   eg.  /bin/bash//bin/ls
+ *
+ *   An fqname is a name that may contain both namespace and profile hnames.
+ *   eg. :ns:/bin/bash//bin/ls
+ *
+ * NOTES:
+ *   - locking of profile lists is currently fairly coarse.  All profile
+ *     lists within a namespace use the namespace lock.
+ * FIXME: move profile lists to using rcu_lists
+ */
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+#include "include/apparmor.h"
+#include "include/capability.h"
+#include "include/context.h"
+#include "include/file.h"
+#include "include/ipc.h"
+#include "include/match.h"
+#include "include/path.h"
+#include "include/policy.h"
+#include "include/policy_unpack.h"
+#include "include/resource.h"
+#include "include/sid.h"
+
+
+/* root profile namespace */
+struct aa_namespace *root_ns;
+
+const char *profile_mode_names[] = {
+	"enforce",
+	"complain",
+	"kill",
+};
+
+/**
+ * hname_tail - find the last component of an hname
+ * @name: hname to find the base profile name component of  (NOT NULL)
+ *
+ * Returns: the tail (base profile name) name component of an hname
+ */
+static const char *hname_tail(const char *hname)
+{
+	char *split;
+	hname = strim((char *)hname);
+	for (split = strstr(hname, "//"); split; split = strstr(hname, "//"))
+		hname = split + 2;
+
+	return hname;
+}
+
+/**
+ * policy_init - initialize a policy structure
+ * @policy: policy to initialize  (NOT NULL)
+ * @prefix: prefix name if any is required.  (MAYBE NULL)
+ * @name: name of the policy, init will make a copy of it  (NOT NULL)
+ *
+ * Note: this fn creates a copy of strings passed in
+ *
+ * Returns: true if policy init successful
+ */
+static bool policy_init(struct aa_policy *policy, const char *prefix,
+			const char *name)
+{
+	/* freed by policy_free */
+	if (prefix) {
+		policy->hname = kmalloc(strlen(prefix) + strlen(name) + 3,
+					GFP_KERNEL);
+		if (policy->hname)
+			sprintf(policy->hname, "%s//%s", prefix, name);
+	} else
+		policy->hname = kstrdup(name, GFP_KERNEL);
+	if (!policy->hname)
+		return 0;
+	/* base.name is a substring of fqname */
+	policy->name = (char *)hname_tail(policy->hname);
+	INIT_LIST_HEAD(&policy->list);
+	INIT_LIST_HEAD(&policy->profiles);
+	kref_init(&policy->count);
+
+	return 1;
+}
+
+/**
+ * policy_destroy - free the elements referenced by @policy
+ * @policy: policy that is to have its elements freed  (NOT NULL)
+ */
+static void policy_destroy(struct aa_policy *policy)
+{
+	/* still contains profiles -- invalid */
+	if (!list_empty(&policy->profiles)) {
+		AA_ERROR("%s: internal error, "
+			 "policy '%s' still contains profiles\n",
+			 __func__, policy->name);
+		BUG();
+	}
+	if (!list_empty(&policy->list)) {
+		AA_ERROR("%s: internal error, policy '%s' still on list\n",
+			 __func__, policy->name);
+		BUG();
+	}
+
+	/* don't free name as its a subset of hname */
+	kzfree(policy->hname);
+}
+
+/**
+ * __policy_find - find a policy by @name on a policy list
+ * @head: list to search  (NOT NULL)
+ * @name: name to search for  (NOT NULL)
+ *
+ * Requires: correct locks for the @head list be held
+ *
+ * Returns: unrefcounted policy that match @name or NULL if not found
+ */
+static struct aa_policy *__policy_find(struct list_head *head, const char *name)
+{
+	struct aa_policy *policy;
+
+	list_for_each_entry(policy, head, list) {
+		if (!strcmp(policy->name, name))
+			return policy;
+	}
+	return NULL;
+}
+
+/**
+ * __policy_strn_find - find a policy thats name matches @len chars of @str
+ * @head: list to search  (NOT NULL)
+ * @str: string to search for  (NOT NULL)
+ * @len: length of match required
+ *
+ * Requires: correct locks for the @head list be held
+ *
+ * Returns: unrefcounted policy that match @str or NULL if not found
+ *
+ * if @len == strlen(@strlen) then this is equiv to __policy_find
+ * other wise it allows searching for policy by a partial match of name
+ */
+static struct aa_policy *__policy_strn_find(struct list_head *head,
+					    const char *str, int len)
+{
+	struct aa_policy *policy;
+
+	list_for_each_entry(policy, head, list) {
+		if (aa_strneq(policy->name, str, len))
+			return policy;
+	}
+
+	return NULL;
+}
+
+/*
+ * Routines for AppArmor namespaces
+ */
+
+static const char *hidden_ns_name = "---";
+/**
+ * aa_ns_visible - test if @child is visible from @parent
+ * @parent: namespace to treat as the parent
+ * @child:  namespace to test if visible from @parent
+ *
+ * Returns: true if @child is visible from @parent else false
+ */
+bool aa_ns_visible(struct aa_namespace *parent, struct aa_namespace *child)
+{
+	if (parent == child)
+		return true;
+
+	for ( ; child; child = child->parent) {
+		if (child->parent == parent)
+			return true;
+	}
+	return false;
+}
+
+const char *aa_ns_name(struct aa_namespace *parent, struct aa_namespace *child)
+{
+	/* if child == parent then the namespace name isn't displayed */
+	if (parent == child)
+		return "";
+
+	if (aa_ns_visible(parent, child)) {
+		/* at this point if a ns is visible it is in a child ns
+		 * thus the parent ns.hname is a prefix of its name.
+		 * Only output the virtualized portion of the name
+		 * Add + 2 to skip over // seperating parent hname prefix
+		 * from the visible tail of the childs hname
+		 */
+		return child->base.hname + strlen(parent->base.hname) + 2;
+	} else
+		return hidden_ns_name;
+}
+
+/**
+ * alloc_namespace - allocate, initialize and return a new namespace
+ * @prefix: parent namespace name (MAYBE NULL)
+ * @name: a preallocated name  (NOT NULL)
+ *
+ * Returns: refcounted namespace or NULL on failure.
+ */
+static struct aa_namespace *alloc_namespace(const char *prefix,
+					    const char *name)
+{
+	struct aa_namespace *ns;
+
+	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
+	AA_DEBUG("%s(%p)\n", __func__, ns);
+	if (!ns)
+		return NULL;
+	if (!policy_init(&ns->base, prefix, name))
+		goto fail_ns;
+
+	INIT_LIST_HEAD(&ns->sub_ns);
+	rwlock_init(&ns->lock);
+
+	/* released by free_namespace */
+	ns->unconfined = aa_alloc_profile("unconfined");
+	if (!ns->unconfined)
+		goto fail_unconfined;
+
+	ns->unconfined->sid = aa_alloc_sid();
+	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
+	    PFLAG_IMMUTABLE;
+
+	/*
+	 * released by free_namespace, however __remove_namespace breaks
+	 * the cyclic references (ns->unconfined, and unconfined->ns) and
+	 * replaces with refs to parent namespace unconfined
+	 */
+	ns->unconfined->ns = aa_get_namespace(ns);
+
+	return ns;
+
+fail_unconfined:
+	kzfree(ns->base.name);
+fail_ns:
+	kzfree(ns);
+	return NULL;
+}
+
+/**
+ * free_namespace - free a profile namespace
+ * @ns: the namespace to free  (MAYBE NULL)
+ *
+ * Requires: All references to the namespace must have been put, if the
+ *           namespace was referenced by a profile confining a task,
+ */
+static void free_namespace(struct aa_namespace *ns)
+{
+	if (!ns)
+		return;
+
+	policy_destroy(&ns->base);
+	aa_put_namespace(ns->parent);
+
+	if (ns->unconfined && ns->unconfined->ns == ns)
+		ns->unconfined->ns = NULL;
+
+	aa_put_profile(ns->unconfined);
+	kzfree(ns);
+}
+
+/**
+ * aa_free_namespace_kref - free aa_namespace by kref (see aa_put_namespace)
+ * @kr: kref callback for freeing of a namespace  (NOT NULL)
+ */
+void aa_free_namespace_kref(struct kref *kref)
+{
+	free_namespace(container_of(kref, struct aa_namespace, base.count));
+}
+
+/**
+ * __aa_find_namespace - find a namespace on a list by @name
+ * @head: list to search for namespace on  (NOT NULL)
+ * @name: name of namespace to look for  (NOT NULL)
+ *
+ * Returns: unrefcounted namespace
+ *
+ * Requires: ns lock be held
+ */
+static struct aa_namespace *__aa_find_namespace(struct list_head *head,
+						const char *name)
+{
+	return (struct aa_namespace *)__policy_find(head, name);
+}
+
+/**
+ * aa_find_namespace  -  look up a profile namespace on the namespace list
+ * @root: namespace to search in  (NOT NULL)
+ * @name: name of namespace to find  (NOT NULL)
+ *
+ * Returns: a refcounted namespace on the list, or NULL if no namespace
+ *          called @name exists.
+ *
+ * refcount released by caller
+ */
+struct aa_namespace *aa_find_namespace(struct aa_namespace *root,
+				       const char *name)
+{
+	struct aa_namespace *ns = NULL;
+
+	read_lock(&root->lock);
+	ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
+	read_unlock(&root->lock);
+
+	return ns;
+}
+
+/**
+ * aa_prepare_namespace - find an existing or create a new namespace of @name
+ * @name: the namespace to find or add  (NOT NULL)
+ *
+ * Returns: refcounted namespace or NULL if failed to create one
+ */
+static struct aa_namespace *aa_prepare_namespace(const char *name)
+{
+	struct aa_namespace *ns, *root;
+
+	root = aa_current_profile()->ns;
+
+	write_lock(&root->lock);
+
+	/* if name isn't specified the profile is loaded to the current ns */
+	if (!name) {
+		/* released by caller */
+		ns = aa_get_namespace(root);
+		goto out;
+	}
+
+	/* try and find the specified ns and if it doesn't exist create it */
+	/* released by caller */
+	ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
+	if (!ns) {
+		/* namespace not found */
+		struct aa_namespace *new_ns;
+		write_unlock(&root->lock);
+		new_ns = alloc_namespace(root->base.hname, name);
+		if (!new_ns)
+			return NULL;
+		write_lock(&root->lock);
+		/* test for race when new_ns was allocated */
+		ns = __aa_find_namespace(&root->sub_ns, name);
+		if (!ns) {
+			/* add parent ref */
+			new_ns->parent = aa_get_namespace(root);
+
+			list_add(&new_ns->base.list, &root->sub_ns);
+			/* add list ref */
+			ns = aa_get_namespace(new_ns);
+		} else {
+			/* raced so free the new one */
+			free_namespace(new_ns);
+			/* get reference on namespace */
+			aa_get_namespace(ns);
+		}
+	}
+out:
+	write_unlock(&root->lock);
+
+	/* return ref */
+	return ns;
+}
+
+/**
+ * __list_add_profile - add a profile to a list
+ * @list: list to add it to  (NOT NULL)
+ * @profile: the profile to add  (NOT NULL)
+ *
+ * refcount @profile, should be put by __list_remove_profile
+ *
+ * Requires: namespace lock be held, or list not be shared
+ */
+static void __list_add_profile(struct list_head *list,
+			       struct aa_profile *profile)
+{
+	list_add(&profile->base.list, list);
+	/* get list reference */
+	aa_get_profile(profile);
+}
+
+/**
+ * __list_remove_profile - remove a profile from the list it is on
+ * @profile: the profile to remove  (NOT NULL)
+ *
+ * remove a profile from the list, warning generally removal should
+ * be done with __replace_profile as most profile removals are
+ * replacements to the unconfined profile.
+ *
+ * put @profile list refcount
+ *
+ * Requires: namespace lock be held, or list not have been live
+ */
+static void __list_remove_profile(struct aa_profile *profile)
+{
+	list_del_init(&profile->base.list);
+	if (!(profile->flags & PFLAG_NO_LIST_REF))
+		/* release list reference */
+		aa_put_profile(profile);
+}
+
+/**
+ * __replace_profile - replace @old with @new on a list
+ * @old: profile to be replaced  (NOT NULL)
+ * @new: profile to replace @old with  (NOT NULL)
+ *
+ * Will duplicaticate and refcount elements that @new inherits from @old
+ * and will inherit @old children.
+ *
+ * refcount @new for list, put @old list refcount
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
+{
+	struct aa_policy *policy;
+	struct aa_profile *child, *tmp;
+
+	if (old->parent)
+		policy = &old->parent->base;
+	else
+		policy = &old->ns->base;
+
+	/* released when @new is freed */
+	new->parent = aa_get_profile(old->parent);
+	new->ns = aa_get_namespace(old->ns);
+	new->sid = old->sid;
+	__list_add_profile(&policy->profiles, new);
+	/* inherit children */
+	list_for_each_entry_safe(child, tmp, &old->base.profiles, base.list) {
+		aa_put_profile(child->parent);
+		child->parent = aa_get_profile(new);
+		/* list refcount transfered to @new*/
+		list_move(&child->base.list, &new->base.profiles);
+	}
+
+	/* released by free_profile */
+	old->replacedby = aa_get_profile(new);
+	__list_remove_profile(old);
+}
+
+static void __profile_list_release(struct list_head *head);
+
+/**
+ * __remove_profile - remove old profile, and children
+ * @profile: profile to be replaced  (NOT NULL)
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+static void __remove_profile(struct aa_profile *profile)
+{
+	/* release any children lists first */
+	__profile_list_release(&profile->base.profiles);
+	/* released by free_profile */
+	profile->replacedby = aa_get_profile(profile->ns->unconfined);
+	__list_remove_profile(profile);
+}
+
+/**
+ * __profile_list_release - remove all profiles on the list and put refs
+ * @head: list of profiles  (NOT NULL)
+ *
+ * Requires: namespace lock be held
+ */
+static void __profile_list_release(struct list_head *head)
+{
+	struct aa_profile *profile, *tmp;
+	list_for_each_entry_safe(profile, tmp, head, base.list)
+		__remove_profile(profile);
+}
+
+static void __ns_list_release(struct list_head *head);
+
+/**
+ * destroy_namespace - remove everything contained by @ns
+ * @ns: namespace to have it contents removed  (NOT NULL)
+ */
+static void destroy_namespace(struct aa_namespace *ns)
+{
+	if (!ns)
+		return;
+
+	write_lock(&ns->lock);
+	/* release all profiles in this namespace */
+	__profile_list_release(&ns->base.profiles);
+
+	/* release all sub namespaces */
+	__ns_list_release(&ns->sub_ns);
+
+	write_unlock(&ns->lock);
+}
+
+/**
+ * __remove_namespace - remove a namespace and all its children
+ * @ns: namespace to be removed  (NOT NULL)
+ *
+ * Requires: ns->parent->lock be held and ns removed from parent.
+ */
+static void __remove_namespace(struct aa_namespace *ns)
+{
+	struct aa_profile *unconfined = ns->unconfined;
+
+	/* remove ns from namespace list */
+	list_del_init(&ns->base.list);
+
+	/*
+	 * break the ns, unconfined profile cyclic reference and forward
+	 * all new unconfined profiles requests to the parent namespace
+	 * This will result in all confined tasks that have a profile
+	 * being removed, inheriting the parent->unconfined profile.
+	 */
+	if (ns->parent)
+		ns->unconfined = aa_get_profile(ns->parent->unconfined);
+
+	destroy_namespace(ns);
+
+	/* release original ns->unconfined ref */
+	aa_put_profile(unconfined);
+	/* release ns->base.list ref, from removal above */
+	aa_put_namespace(ns);
+}
+
+/**
+ * __ns_list_release - remove all profile namespaces on the list put refs
+ * @head: list of profile namespaces  (NOT NULL)
+ *
+ * Requires: namespace lock be held
+ */
+static void __ns_list_release(struct list_head *head)
+{
+	struct aa_namespace *ns, *tmp;
+	list_for_each_entry_safe(ns, tmp, head, base.list)
+		__remove_namespace(ns);
+
+}
+
+/**
+ * aa_alloc_root_ns - allocate the root profile namespace
+ *
+ * Returns: %0 on success else error
+ *
+ */
+int __init aa_alloc_root_ns(void)
+{
+	/* released by aa_free_root_ns - used as list ref*/
+	root_ns = alloc_namespace(NULL, "root");
+	if (!root_ns)
+		return -ENOMEM;
+
+	return 0;
+}
+
+ /**
+  * aa_free_root_ns - free the root profile namespace
+  */
+void aa_free_root_ns(void)
+ {
+	 struct aa_namespace *ns = root_ns;
+	 root_ns = NULL;
+
+	 destroy_namespace(ns);
+	 aa_put_namespace(ns);
+}
+
+/**
+ * aa_alloc_profile - allocate, initialize and return a new profile
+ * @hname: name of the profile  (NOT NULL)
+ *
+ * Returns: refcount profile or NULL on failure
+ */
+struct aa_profile *aa_alloc_profile(const char *hname)
+{
+	struct aa_profile *profile;
+
+	/* freed by free_profile - usually through aa_put_profile */
+	profile = kzalloc(sizeof(*profile), GFP_KERNEL);
+	if (!profile)
+		return NULL;
+
+	if (!policy_init(&profile->base, NULL, hname)) {
+		kzfree(profile);
+		return NULL;
+	}
+
+	/* refcount released by caller */
+	return profile;
+}
+
+/**
+ * aa_new_null_profile - create a new null-X learning profile
+ * @parent: profile that caused this profile to be created (NOT NULL)
+ * @hat: true if the null- learning profile is a hat
+ *
+ * Create a null- complain mode profile used in learning mode.  The name of
+ * the profile is unique and follows the format of parent//null-sid.
+ *
+ * null profiles are added to the profile list but the list does not
+ * hold a count on them so that they are automatically released when
+ * not in use.
+ *
+ * Returns: new refcounted profile else NULL on failure
+ */
+struct aa_profile *aa_new_null_profile(struct aa_profile *parent, int hat)
+{
+	struct aa_profile *profile = NULL;
+	char *name;
+	u32 sid = aa_alloc_sid();
+
+	/* freed below */
+	name = kmalloc(strlen(parent->base.hname) + 2 + 7 + 8, GFP_KERNEL);
+	if (!name)
+		goto fail;
+	sprintf(name, "%s//null-%x", parent->base.hname, sid);
+
+	profile = aa_alloc_profile(name);
+	kfree(name);
+	if (!profile)
+		goto fail;
+
+	profile->sid = sid;
+	profile->mode = APPARMOR_COMPLAIN;
+	profile->flags = PFLAG_NULL;
+	if (hat)
+		profile->flags |= PFLAG_HAT;
+
+	/* released on free_profile */
+	profile->parent = aa_get_profile(parent);
+	profile->ns = aa_get_namespace(parent->ns);
+
+	write_lock(&profile->ns->lock);
+	__list_add_profile(&parent->base.profiles, profile);
+	write_unlock(&profile->ns->lock);
+
+	/* refcount released by caller */
+	return profile;
+
+fail:
+	aa_free_sid(sid);
+	return NULL;
+}
+
+/**
+ * free_profile - free a profile
+ * @profile: the profile to free  (MAYBE NULL)
+ *
+ * Free a profile, its hats and null_profile. All references to the profile,
+ * its hats and null_profile must have been put.
+ *
+ * If the profile was referenced from a task context, free_profile() will
+ * be called from an rcu callback routine, so we must not sleep here.
+ */
+static void free_profile(struct aa_profile *profile)
+{
+	AA_DEBUG("%s(%p)\n", __func__, profile);
+
+	if (!profile)
+		return;
+
+	if (!list_empty(&profile->base.list)) {
+		AA_ERROR("%s: internal error, "
+			 "profile '%s' still on ns list\n",
+			 __func__, profile->base.name);
+		BUG();
+	}
+
+	/* free children profiles */
+	policy_destroy(&profile->base);
+	aa_put_profile(profile->parent);
+
+	aa_put_namespace(profile->ns);
+	kzfree(profile->rename);
+
+	aa_free_file_rules(&profile->file);
+	aa_free_cap_rules(&profile->caps);
+	aa_free_rlimit_rules(&profile->rlimits);
+
+	aa_free_sid(profile->sid);
+	aa_put_dfa(profile->xmatch);
+
+	aa_put_profile(profile->replacedby);
+
+	kzfree(profile);
+}
+
+/**
+ * aa_free_profile_kref - free aa_profile by kref (called by aa_put_profile)
+ * @kr: kref callback for freeing of a profile  (NOT NULL)
+ */
+void aa_free_profile_kref(struct kref *kref)
+{
+	struct aa_profile *p = container_of(kref, struct aa_profile,
+					    base.count);
+
+	free_profile(p);
+}
+
+/* TODO: profile count accounting - setup in remove */
+
+/**
+ * __find_child - find a profile on @head list with a name matching @name
+ * @head: list to search  (NOT NULL)
+ * @name: name of profile (NOT NULL)
+ *
+ * Requires: ns lock protecting list be held
+ *
+ * Returns: unrefcounted profile ptr, or NULL if not found
+ */
+static struct aa_profile *__find_child(struct list_head *head, const char *name)
+{
+	return (struct aa_profile *)__policy_find(head, name);
+}
+
+/**
+ * __strn_find_child - find a profile on @head list using substring of @name
+ * @head: list to search  (NOT NULL)
+ * @name: name of profile (NOT NULL)
+ * @len: length of @name substring to match
+ *
+ * Requires: ns lock protecting list be held
+ *
+ * Returns: unrefcounted profile ptr, or NULL if not found
+ */
+static struct aa_profile *__strn_find_child(struct list_head *head,
+					    const char *name, int len)
+{
+	return (struct aa_profile *)__policy_strn_find(head, name, len);
+}
+
+/**
+ * aa_find_child - find a profile by @name in @parent
+ * @parent: profile to search  (NOT NULL)
+ * @name: profile name to search for  (NOT NULL)
+ *
+ * Returns: a refcounted profile or NULL if not found
+ */
+struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name)
+{
+	struct aa_profile *profile;
+
+	read_lock(&parent->ns->lock);
+	profile = aa_get_profile(__find_child(&parent->base.profiles, name));
+	read_unlock(&parent->ns->lock);
+
+	/* refcount released by caller */
+	return profile;
+}
+
+/**
+ * __lookup_parent - lookup the parent of a profile of name @hname
+ * @ns: namespace to lookup profile in  (NOT NULL)
+ * @hname: hierarchical profile name to find parent of  (NOT NULL)
+ *
+ * Lookups up the parent of a fully qualified profile name, the profile
+ * that matches hname does not need to exist, in general this
+ * is used to load a new profile.
+ *
+ * Requires: ns->lock be held
+ *
+ * Returns: unrefcounted policy or NULL if not found
+ */
+static struct aa_policy *__lookup_parent(struct aa_namespace *ns,
+					 const char *hname)
+{
+	struct aa_policy *policy;
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	policy = &ns->base;
+
+	for (split = strstr(hname, "//"); split;) {
+		profile = __strn_find_child(&policy->profiles, hname,
+					    split - hname);
+		if (!profile)
+			return NULL;
+		policy = &profile->base;
+		hname = split + 2;
+		split = strstr(hname, "//");
+	}
+	if (!profile)
+		return &ns->base;
+	return &profile->base;
+}
+
+/**
+ * __lookup_profile - lookup the profile matching @hname
+ * @base: base list to start looking up profile name from  (NOT NULL)
+ * @hname: hierarchical profile name  (NOT NULL)
+ *
+ * Requires: ns->lock be held
+ *
+ * Returns: unrefcounted profile pointer or NULL if not found
+ *
+ * Do a relative name lookup, recursing through profile tree.
+ */
+static struct aa_profile *__lookup_profile(struct aa_policy *base,
+					   const char *hname)
+{
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	for (split = strstr(hname, "//"); split;) {
+		profile = __strn_find_child(&base->profiles, hname,
+					    split - hname);
+		if (!profile)
+			return NULL;
+
+		base = &profile->base;
+		hname = split + 2;
+		split = strstr(hname, "//");
+	}
+
+	profile = __find_child(&base->profiles, hname);
+
+	return profile;
+}
+
+/**
+ * aa_lookup_profile - find a profile by its full or partial name
+ * @ns: the namespace to start from
+ * @hname: name to do lookup on.  Does not contain namespace prefix
+ *
+ * Returns: refcounted profile or NULL if not found
+ */
+struct aa_profile *aa_lookup_profile(struct aa_namespace *ns, const char *hname)
+{
+	struct aa_profile *profile;
+
+	read_lock(&ns->lock);
+	profile = aa_get_profile(__lookup_profile(&ns->base, hname));
+	read_unlock(&ns->lock);
+
+	/* refcount released by caller */
+	return profile;
+}
+
+/**
+ * replacement_allowed - test to see if replacement is allowed
+ * @profile: profile to test if it can be replaced  (MAYBE NULL)
+ * @noreplace: true if replacement shouldn't be allowed but addition is okay
+ * @info: return pointer to info about why replacement failed
+ *
+ * Returns: %0 if replacement allowed else error code
+ */
+static int replacement_allowed(struct aa_profile *profile, int noreplace,
+			       const char **info)
+{
+	if (profile) {
+		if (profile->flags & PFLAG_IMMUTABLE) {
+			*info = "cannot replace immutible profile";
+			return -EPERM;
+		} else if (noreplace) {
+			*info = "profile already exists";
+			return -EEXIST;
+		}
+	}
+	return 0;
+}
+
+/**
+ * __add_new_profile - simple wrapper around __list_add_profile
+ * @ns: namespace that profile is being added to  (NOT NULL)
+ * @policy: the policy container to add the profile to  (NOT NULL)
+ * @profile: profile to add  (NOT NULL)
+ *
+ * add a profile to a list and do other required basic allocations
+ */
+static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
+			      struct aa_profile *profile)
+{
+	if (policy != &ns->base)
+		/* released on profile replacement or free_profile */
+		profile->parent = aa_get_profile((struct aa_profile *) policy);
+	__list_add_profile(&policy->profiles, profile);
+	/* released on free_profile */
+	profile->sid = aa_alloc_sid();
+	profile->ns = aa_get_namespace(ns);
+}
+
+/**
+ * aa_audit_policy - Do auditing of policy changes
+ * @op: policy operation being performed
+ * @gfp: memory allocation flags
+ * @name: name of profile being manipulated
+ * @info: any extra information to be audited
+ * @error: error code
+ *
+ * Returns: the error to be returned after audit is done
+ */
+static int audit_policy(int op, gfp_t gfp, const char *name, const char *info,
+			int error)
+{
+	struct common_audit_data sa;
+	COMMON_AUDIT_DATA_INIT_NONE(&sa);
+	sa.aad.op = op;
+	sa.aad.name = name;
+	sa.aad.info = info;
+	sa.aad.error = error;
+
+	return aa_audit(AUDIT_APPARMOR_STATUS, __aa_current_profile(), gfp,
+			&sa, NULL);
+}
+
+/**
+ * aa_may_manage_policy - can the current task manage policy
+ * @op: the policy manipulation operation being done
+ *
+ * Returns: true if the task is allowed to manipulate policy
+ */
+bool aa_may_manage_policy(int op)
+{
+	/* check if loading policy is locked out */
+	if (aa_g_lock_policy) {
+		audit_policy(op, GFP_KERNEL, NULL, "policy_locked", -EACCES);
+		return 0;
+	}
+
+	if (!capable(CAP_MAC_ADMIN)) {
+		audit_policy(op, GFP_KERNEL, NULL, "not policy admin", -EACCES);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * aa_replace_profiles - replace profile(s) on the profile list
+ * @udata: serialized data stream  (NOT NULL)
+ * @size: size of the serialized data stream
+ * @noreplace: true if only doing addition, no replacement allowed
+ *
+ * unpack and replace a profile on the profile list and uses of that profile
+ * by any aa_task_cxt.  If the profile does not exist on the profile list
+ * it is added.
+ *
+ * Returns: size of data consumed else error code on failure.
+ */
+ssize_t aa_replace_profiles(void *udata, size_t size, bool noreplace)
+{
+	struct aa_policy *policy;
+	struct aa_profile *old_profile = NULL, *new_profile = NULL;
+	struct aa_profile *rename_profile = NULL;
+	struct aa_namespace *ns = NULL;
+	const char *ns_name, *name = NULL, *info = NULL;
+	int op = OP_PROF_REPL;
+	ssize_t error;
+
+	/* released below */
+	new_profile = aa_unpack(udata, size, &ns_name);
+	if (IS_ERR(new_profile)) {
+		error = PTR_ERR(new_profile);
+		new_profile = NULL;
+		goto fail;
+	}
+
+	/* released below */
+	ns = aa_prepare_namespace(ns_name);
+	if (!ns) {
+		info = "failed to prepare namespace";
+		error = -ENOMEM;
+		name = ns_name;
+		goto fail;
+	}
+
+	name = new_profile->base.hname;
+
+	write_lock(&ns->lock);
+	/* no ref on policy only use inside lock */
+	policy = __lookup_parent(ns, new_profile->base.hname);
+
+	if (!policy) {
+		info = "parent does not exist";
+		error = -ENOENT;
+		goto audit;
+	}
+
+	old_profile = __find_child(&policy->profiles, new_profile->base.name);
+	/* released below */
+	aa_get_profile(old_profile);
+
+	if (new_profile->rename) {
+		rename_profile = __lookup_profile(&ns->base,
+						  new_profile->rename);
+		/* released below */
+		aa_get_profile(rename_profile);
+
+		if (!rename_profile) {
+			info = "profile to rename does not exist";
+			name = new_profile->rename;
+			error = -ENOENT;
+			goto audit;
+		}
+	}
+
+	error = replacement_allowed(old_profile, noreplace, &info);
+	if (error)
+		goto audit;
+
+	error = replacement_allowed(rename_profile, noreplace, &info);
+	if (error)
+		goto audit;
+
+audit:
+	if (!old_profile && !rename_profile)
+		op = OP_PROF_LOAD;
+
+	error = audit_policy(op, GFP_ATOMIC, name, info, error);
+
+	if (!error) {
+		if (rename_profile)
+			__replace_profile(rename_profile, new_profile);
+		if (old_profile) {
+			/* when there are both rename and old profiles
+			 * inherit old profiles sid
+			 */
+			if (rename_profile)
+				aa_free_sid(new_profile->sid);
+			__replace_profile(old_profile, new_profile);
+		}
+		if (!(old_profile || rename_profile))
+			__add_new_profile(ns, policy, new_profile);
+	}
+	write_unlock(&ns->lock);
+
+out:
+	aa_put_namespace(ns);
+	aa_put_profile(rename_profile);
+	aa_put_profile(old_profile);
+	aa_put_profile(new_profile);
+	if (error)
+		return error;
+	return size;
+
+fail:
+	error = audit_policy(op, GFP_KERNEL, name, info, error);
+	goto out;
+}
+
+/**
+ * aa_remove_profiles - remove profile(s) from the system
+ * @fqname: name of the profile or namespace to remove  (NOT NULL)
+ * @size: size of the name
+ *
+ * Remove a profile or sub namespace from the current namespace, so that
+ * they can not be found anymore and mark them as replaced by unconfined
+ *
+ * NOTE: removing confinement does not restore rlimits to preconfinemnet values
+ *
+ * Returns: size of data consume else error code if fails
+ */
+ssize_t aa_remove_profiles(char *fqname, size_t size)
+{
+	struct aa_namespace *root, *ns = NULL;
+	struct aa_profile *profile = NULL;
+	const char *name = fqname, *info = NULL;
+	ssize_t error = 0;
+
+	if (*fqname == 0) {
+		info = "no profile specified";
+		error = -ENOENT;
+		goto fail;
+	}
+
+	root = aa_current_profile()->ns;
+
+	if (fqname[0] == ':') {
+		char *ns_name;
+		name = aa_split_fqname(fqname, &ns_name);
+		if (ns_name) {
+			/* released below */
+			ns = aa_find_namespace(root, ns_name);
+			if (!ns) {
+				info = "namespace does not exist";
+				error = -ENOENT;
+				goto fail;
+			}
+		}
+	} else
+		/* released below */
+		ns = aa_get_namespace(root);
+
+	write_lock(&ns->lock);
+	if (!name) {
+		/* remove namespace - can only happen if fqname[0] == ':' */
+		__remove_namespace(ns);
+	} else {
+		/* remove profile */
+		profile = aa_get_profile(__lookup_profile(&ns->base, name));
+		if (!profile) {
+			error = -ENOENT;
+			info = "profile does not exist";
+			goto fail_ns_lock;
+		}
+		name = profile->base.hname;
+		__remove_profile(profile);
+	}
+	write_unlock(&ns->lock);
+
+	/* don't fail removal if audit fails */
+	(void) audit_policy(OP_PROF_RM, GFP_KERNEL, name, info, error);
+	aa_put_namespace(ns);
+	aa_put_profile(profile);
+	return size;
+
+fail_ns_lock:
+	write_unlock(&ns->lock);
+	aa_put_namespace(ns);
+
+fail:
+	(void) audit_policy(OP_PROF_RM, GFP_KERNEL, name, info, error);
+	return error;
+}
diff --git a/security/apparmor/sid.c b/security/apparmor/sid.c
new file mode 100644
index 0000000..f0b34f7
--- /dev/null
+++ b/security/apparmor/sid.c
@@ -0,0 +1,55 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor security identifier (sid) manipulation fns
+ *
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ * AppArmor allocates a unique sid for every profile loaded.  If a profile
+ * is replaced it receives the sid of the profile it is replacing.
+ *
+ * The sid value of 0 is invalid.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+
+#include "include/sid.h"
+
+/* global counter from which sids are allocated */
+static u32 global_sid;
+static DEFINE_SPINLOCK(sid_lock);
+
+/* TODO FIXME: add sid to profile mapping, and sid recycling */
+
+/**
+ * aa_alloc_sid - allocate a new sid for a profile
+ */
+u32 aa_alloc_sid(void)
+{
+	u32 sid;
+
+	/*
+	 * TODO FIXME: sid recycling - part of profile mapping table
+	 */
+	spin_lock(&sid_lock);
+	sid = (++global_sid);
+	spin_unlock(&sid_lock);
+	return sid;
+}
+
+/**
+ * aa_free_sid - free a sid
+ * @sid: sid to free
+ */
+void aa_free_sid(u32 sid)
+{
+	;			/* NOP ATM */
+}
-- 
1.7.0.4

