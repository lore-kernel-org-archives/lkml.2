Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2DHFUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:20:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51485 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2DHFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:20 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:11 -0700
Message-Id: <1333862139-31737-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+M1RAkW1R86+xzihs0WlrPiuwnD5/6ws=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3281]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 15/43] userns: Disassociate user_struct from the user_namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Modify alloc_uid to take a kuid and make the user hash table global.
Stop holding a reference to the user namespace in struct user_struct.

This simplifies the code and makes the per user accounting not
care about which user namespace a uid happens to appear in.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ioprio.c                    |   18 ++++++++++++++----
 include/linux/sched.h          |    8 ++++----
 include/linux/user_namespace.h |    4 ----
 kernel/sys.c                   |   34 +++++++++++++++++++++++-----------
 kernel/user.c                  |   28 +++++++++++++---------------
 kernel/user_namespace.c        |    6 +-----
 6 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/fs/ioprio.c b/fs/ioprio.c
index 0f1b951..8e35e96 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -65,6 +65,7 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 	struct task_struct *p, *g;
 	struct user_struct *user;
 	struct pid *pgrp;
+	kuid_t uid;
 	int ret;
 
 	switch (class) {
@@ -110,16 +111,21 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
+			uid = make_kuid(current_user_ns(), who);
+			if (!uid_valid(uid))
+				break;
 			if (!who)
 				user = current_user();
 			else
-				user = find_user(who);
+				user = find_user(uid);
 
 			if (!user)
 				break;
 
 			do_each_thread(g, p) {
-				if (__task_cred(p)->uid != who)
+				const struct cred *tcred = __task_cred(p);
+				kuid_t tcred_uid = make_kuid(tcred->user_ns, tcred->uid);
+				if (!uid_eq(tcred_uid, uid))
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
@@ -174,6 +180,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	struct pid *pgrp;
+	kuid_t uid;
 	int ret = -ESRCH;
 	int tmpio;
 
@@ -203,16 +210,19 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
+			uid = make_kuid(current_user_ns(), who);
 			if (!who)
 				user = current_user();
 			else
-				user = find_user(who);
+				user = find_user(uid);
 
 			if (!user)
 				break;
 
 			do_each_thread(g, p) {
-				if (__task_cred(p)->uid != user->uid)
+				const struct cred *tcred = __task_cred(p);
+				kuid_t tcred_uid = make_kuid(tcred->user_ns, tcred->uid);
+				if (!uid_eq(tcred_uid, user->uid))
 					continue;
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6867ae9..5fdc1eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -90,6 +90,7 @@ struct sched_param {
 #include <linux/latencytop.h>
 #include <linux/cred.h>
 #include <linux/llist.h>
+#include <linux/uidgid.h>
 
 #include <asm/processor.h>
 
@@ -728,8 +729,7 @@ struct user_struct {
 
 	/* Hash table maintenance information */
 	struct hlist_node uidhash_node;
-	uid_t uid;
-	struct user_namespace *_user_ns; /* Don't use will be removed soon */
+	kuid_t uid;
 
 #ifdef CONFIG_PERF_EVENTS
 	atomic_long_t locked_vm;
@@ -738,7 +738,7 @@ struct user_struct {
 
 extern int uids_sysfs_init(void);
 
-extern struct user_struct *find_user(uid_t);
+extern struct user_struct *find_user(kuid_t);
 
 extern struct user_struct root_user;
 #define INIT_USER (&root_user)
@@ -2177,7 +2177,7 @@ extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 extern void __set_special_pids(struct pid *pid);
 
 /* per-UID process charging. */
-extern struct user_struct * alloc_uid(struct user_namespace *, uid_t);
+extern struct user_struct * alloc_uid(kuid_t);
 static inline struct user_struct *get_uid(struct user_struct *u)
 {
 	atomic_inc(&u->__count);
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index dc2d85a..d767508 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -6,12 +6,8 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-#define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
-#define UIDHASH_SZ	(1 << UIDHASH_BITS)
-
 struct user_namespace {
 	struct kref		kref;
-	struct hlist_head	uidhash_table[UIDHASH_SZ];
 	struct user_namespace	*parent;
 	struct user_struct	*creator;
 	struct work_struct	destroyer;
diff --git a/kernel/sys.c b/kernel/sys.c
index 7185241..f0c43b4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -175,6 +175,8 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	const struct cred *cred = current_cred();
 	int error = -EINVAL;
 	struct pid *pgrp;
+	kuid_t cred_uid;
+	kuid_t uid;
 
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		goto out;
@@ -207,18 +209,22 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
+			cred_uid = make_kuid(cred->user_ns, cred->uid);
+			uid = make_kuid(cred->user_ns, who);
 			user = cred->user;
 			if (!who)
-				who = cred->uid;
-			else if ((who != cred->uid) &&
-				 !(user = find_user(who)))
+				uid = cred_uid;
+			else if (!uid_eq(uid, cred_uid) &&
+				 !(user = find_user(uid)))
 				goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p) {
-				if (__task_cred(p)->uid == who)
+				const struct cred *tcred = __task_cred(p);
+				kuid_t tcred_uid = make_kuid(tcred->user_ns, tcred->uid);
+				if (uid_eq(tcred_uid, uid))
 					error = set_one_prio(p, niceval, error);
 			} while_each_thread(g, p);
-			if (who != cred->uid)
+			if (!uid_eq(uid, cred_uid))
 				free_uid(user);		/* For find_user() */
 			break;
 	}
@@ -242,6 +248,8 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 	const struct cred *cred = current_cred();
 	long niceval, retval = -ESRCH;
 	struct pid *pgrp;
+	kuid_t cred_uid;
+	kuid_t uid;
 
 	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
@@ -272,21 +280,25 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
+			cred_uid = make_kuid(cred->user_ns, cred->uid);
+			uid = make_kuid(cred->user_ns, who);
 			user = cred->user;
 			if (!who)
-				who = cred->uid;
-			else if ((who != cred->uid) &&
-				 !(user = find_user(who)))
+				uid = cred_uid;
+			else if (!uid_eq(uid, cred_uid) &&
+				 !(user = find_user(uid)))
 				goto out_unlock;	/* No processes for this user */
 
 			do_each_thread(g, p) {
-				if (__task_cred(p)->uid == who) {
+				const struct cred *tcred = __task_cred(p);
+				kuid_t tcred_uid = make_kuid(tcred->user_ns, tcred->uid);
+				if (uid_eq(tcred_uid, uid)) {
 					niceval = 20 - task_nice(p);
 					if (niceval > retval)
 						retval = niceval;
 				}
 			} while_each_thread(g, p);
-			if (who != cred->uid)
+			if (!uid_eq(uid, cred_uid))
 				free_uid(user);		/* for find_user() */
 			break;
 	}
@@ -629,7 +641,7 @@ static int set_user(struct cred *new)
 {
 	struct user_struct *new_user;
 
-	new_user = alloc_uid(current_user_ns(), new->uid);
+	new_user = alloc_uid(make_kuid(new->user_ns, new->uid));
 	if (!new_user)
 		return -EAGAIN;
 
diff --git a/kernel/user.c b/kernel/user.c
index d65fec0..025077e 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -34,11 +34,14 @@ EXPORT_SYMBOL_GPL(init_user_ns);
  * when changing user ID's (ie setuid() and friends).
  */
 
+#define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
+#define UIDHASH_SZ	(1 << UIDHASH_BITS)
 #define UIDHASH_MASK		(UIDHASH_SZ - 1)
 #define __uidhashfn(uid)	(((uid >> UIDHASH_BITS) + uid) & UIDHASH_MASK)
-#define uidhashentry(ns, uid)	((ns)->uidhash_table + __uidhashfn((uid)))
+#define uidhashentry(uid)	(uidhash_table + __uidhashfn((__kuid_val(uid))))
 
 static struct kmem_cache *uid_cachep;
+struct hlist_head uidhash_table[UIDHASH_SZ];
 
 /*
  * The uidhash_lock is mostly taken from process context, but it is
@@ -58,7 +61,7 @@ struct user_struct root_user = {
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
-	._user_ns	= &init_user_ns,
+	.uid		= GLOBAL_ROOT_UID,
 };
 
 /*
@@ -72,16 +75,15 @@ static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
-	put_user_ns(up->_user_ns); /* It is safe to free the uid hash table now */
 }
 
-static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
 	struct hlist_node *h;
 
 	hlist_for_each_entry(user, h, hashent, uidhash_node) {
-		if (user->uid == uid) {
+		if (uid_eq(user->uid, uid)) {
 			atomic_inc(&user->__count);
 			return user;
 		}
@@ -110,14 +112,13 @@ static void free_user(struct user_struct *up, unsigned long flags)
  *
  * If the user_struct could not be found, return NULL.
  */
-struct user_struct *find_user(uid_t uid)
+struct user_struct *find_user(kuid_t uid)
 {
 	struct user_struct *ret;
 	unsigned long flags;
-	struct user_namespace *ns = current_user_ns();
 
 	spin_lock_irqsave(&uidhash_lock, flags);
-	ret = uid_hash_find(uid, uidhashentry(ns, uid));
+	ret = uid_hash_find(uid, uidhashentry(uid));
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 	return ret;
 }
@@ -136,9 +137,9 @@ void free_uid(struct user_struct *up)
 		local_irq_restore(flags);
 }
 
-struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
+struct user_struct *alloc_uid(kuid_t uid)
 {
-	struct hlist_head *hashent = uidhashentry(ns, uid);
+	struct hlist_head *hashent = uidhashentry(uid);
 	struct user_struct *up, *new;
 
 	spin_lock_irq(&uidhash_lock);
@@ -153,8 +154,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 
-		new->_user_ns = get_user_ns(ns);
-
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..
@@ -162,7 +161,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
@@ -187,11 +185,11 @@ static int __init uid_cache_init(void)
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
 	for(n = 0; n < UIDHASH_SZ; ++n)
-		INIT_HLIST_HEAD(init_user_ns.uidhash_table + n);
+		INIT_HLIST_HEAD(uidhash_table + n);
 
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
-	uid_hash_insert(&root_user, uidhashentry(&init_user_ns, 0));
+	uid_hash_insert(&root_user, uidhashentry(GLOBAL_ROOT_UID));
 	spin_unlock_irq(&uidhash_lock);
 
 	return 0;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index e216e1e..898e973 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -27,7 +27,6 @@ int create_user_ns(struct cred *new)
 {
 	struct user_namespace *ns, *parent_ns = new->user_ns;
 	struct user_struct *root_user;
-	int n;
 
 	ns = kmem_cache_alloc(user_ns_cachep, GFP_KERNEL);
 	if (!ns)
@@ -35,11 +34,8 @@ int create_user_ns(struct cred *new)
 
 	kref_init(&ns->kref);
 
-	for (n = 0; n < UIDHASH_SZ; ++n)
-		INIT_HLIST_HEAD(ns->uidhash_table + n);
-
 	/* Alloc new root user.  */
-	root_user = alloc_uid(ns, 0);
+	root_user = alloc_uid(make_kuid(ns, 0));
 	if (!root_user) {
 		kmem_cache_free(user_ns_cachep, ns);
 		return -ENOMEM;
-- 
1.7.2.5

