Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0EFVJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:09:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0EFVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:09:09 -0400
Date: Thu, 6 May 2010 23:08:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] RCU fixes
Message-ID: <20100506210836.GA26196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

This addresses all known CONFIG_PROVE_RCU warnings (modulo 3 fixes pending in 
maintainer trees).

 Thanks,

	Ingo

------------------>
David Howells (2):
      KEYS: Fix an RCU warning
      KEYS: Fix an RCU warning in the reading of user keys

Li Zefan (4):
      cgroup: Fix an RCU warning in cgroup_path()
      cgroup: Fix an RCU warning in alloc_css_id()
      sched: Fix an RCU warning in print_task()
      cgroup: Check task_lock in task_subsys_state()

Paul E. McKenney (2):
      memcg: css_id() must be called under rcu_read_lock()
      rcu: create rcu_my_thread_group_empty() wrapper


 include/linux/cgroup.h       |    1 +
 include/linux/rcupdate.h     |    2 ++
 kernel/cgroup.c              |   16 +++++++++++-----
 kernel/rcupdate.c            |   11 +++++++++++
 kernel/sched_debug.c         |    2 ++
 mm/memcontrol.c              |   21 ++++++++++++++++-----
 security/keys/request_key.c  |   13 ++++++++-----
 security/keys/user_defined.c |    3 ++-
 8 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b8ad1ea..8f78073 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -530,6 +530,7 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
+				     lockdep_is_held(&task->alloc_lock) ||
 				     cgroup_lock_is_held());
 }
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 07db2fe..db266bb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+extern int rcu_my_thread_group_empty(void);
+
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2769e1..3a53c77 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1646,7 +1646,9 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
 	char *start;
-	struct dentry *dentry = rcu_dereference(cgrp->dentry);
+	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
+						      rcu_read_lock_held() ||
+						      cgroup_lock_is_held());
 
 	if (!dentry || cgrp == dummytop) {
 		/*
@@ -1662,13 +1664,17 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	*--start = '\0';
 	for (;;) {
 		int len = dentry->d_name.len;
+
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
-		memcpy(start, cgrp->dentry->d_name.name, len);
+		memcpy(start, dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
-		dentry = rcu_dereference(cgrp->dentry);
+
+		dentry = rcu_dereference_check(cgrp->dentry,
+					       rcu_read_lock_held() ||
+					       cgroup_lock_is_held());
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
@@ -4555,13 +4561,13 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
 {
 	int subsys_id, i, depth = 0;
 	struct cgroup_subsys_state *parent_css, *child_css;
-	struct css_id *child_id, *parent_id = NULL;
+	struct css_id *child_id, *parent_id;
 
 	subsys_id = ss->subsys_id;
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
-	depth = css_depth(parent_css) + 1;
 	parent_id = parent_css->id;
+	depth = parent_id->depth;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 03a7ea1..49d808e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -122,3 +122,14 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
+
+#ifdef CONFIG_PROVE_RCU
+/*
+ * wrapper function to avoid #include problems.
+ */
+int rcu_my_thread_group_empty(void)
+{
+	return thread_group_empty(current);
+}
+EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
+#endif /* #ifdef CONFIG_PROVE_RCU */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9b49db1..19be00b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -114,7 +114,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	{
 		char path[64];
 
+		rcu_read_lock();
 		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4ede99..e06490d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -811,10 +811,12 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
 	 * hierarchy(even if use_hierarchy is disabled in "mem").
 	 */
+	rcu_read_lock();
 	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
+	rcu_read_unlock();
 	css_put(&curr->css);
 	return ret;
 }
@@ -2312,7 +2314,9 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 
 	/* record memcg information */
 	if (do_swap_account && swapout && memcg) {
+		rcu_read_lock();
 		swap_cgroup_record(ent, css_id(&memcg->css));
+		rcu_read_unlock();
 		mem_cgroup_get(memcg);
 	}
 	if (swapout && memcg)
@@ -2369,8 +2373,10 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 {
 	unsigned short old_id, new_id;
 
+	rcu_read_lock();
 	old_id = css_id(&from->css);
 	new_id = css_id(&to->css);
+	rcu_read_unlock();
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -4038,11 +4044,16 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
 			put_page(page);
 	}
 	/* throught */
-	if (ent.val && do_swap_account && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
-		ret = MC_TARGET_SWAP;
-		if (target)
-			target->ent = ent;
+	if (ent.val && do_swap_account && !ret) {
+		unsigned short id;
+		rcu_read_lock();
+		id = css_id(&mc.from->css);
+		rcu_read_unlock();
+		if (id == lookup_swap_cgroup(ent)) {
+			ret = MC_TARGET_SWAP;
+			if (target)
+				target->ent = ent;
+		}
 	}
 	return ret;
 }
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..ea97c31 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -68,7 +68,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 {
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
-	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
+	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
+		*session;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
 	char key_str[12], keyring_str[3][12];
 	char desc[20];
@@ -112,10 +113,12 @@ static int call_sbin_request_key(struct key_construction *cons,
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
 
-	if (cred->tgcred->session_keyring)
-		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
-	else
-		sskey = cred->user->session_keyring->serial;
+	rcu_read_lock();
+	session = rcu_dereference(cred->tgcred->session_keyring);
+	if (!session)
+		session = cred->user->session_keyring;
+	sskey = session->serial;
+	rcu_read_unlock();
 
 	sprintf(keyring_str[2], "%d", sskey);
 
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 7c687d5..e9aa079 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -199,7 +199,8 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 	struct user_key_payload *upayload;
 	long ret;
 
-	upayload = rcu_dereference(key->payload.data);
+	upayload = rcu_dereference_protected(
+		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
 	ret = upayload->datalen;
 
 	/* we can return the data as is */
