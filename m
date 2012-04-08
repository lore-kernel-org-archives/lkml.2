Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2DHFSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:18:44 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44075 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889Ab2DHFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:26 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:14 -0700
Message-Id: <1333862139-31737-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX180GuUykQ9kNG6ccLnGghSHqaMqnJ9Yjm0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2686]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 18/43] userns: Convert group_info values from gid_t to kgid_t.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

As a first step to converting struct cred to be all kuid_t and kgid_t
values convert the group values stored in group_info to always be
kgid_t values.   Unless user namespaces are used this change should
have no effect.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/s390/kernel/compat_linux.c   |   13 ++++++++-
 fs/nfsd/auth.c                    |    5 ++-
 fs/proc/array.c                   |    5 +++-
 include/linux/cred.h              |    9 ++++---
 kernel/groups.c                   |   48 +++++++++++++++++++-----------------
 kernel/uid16.c                    |   14 +++++++++-
 net/ipv4/ping.c                   |   11 ++++++--
 net/sunrpc/auth_generic.c         |    4 +-
 net/sunrpc/auth_gss/svcauth_gss.c |    7 ++++-
 net/sunrpc/auth_unix.c            |   15 ++++++++---
 net/sunrpc/svcauth_unix.c         |   18 ++++++++++---
 security/keys/permission.c        |    3 +-
 12 files changed, 103 insertions(+), 49 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index ab64bdb..5baac18 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -173,11 +173,14 @@ asmlinkage long sys32_setfsgid16(u16 gid)
 
 static int groups16_to_user(u16 __user *grouplist, struct group_info *group_info)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	u16 group;
+	kgid_t kgid;
 
 	for (i = 0; i < group_info->ngroups; i++) {
-		group = (u16)GROUP_AT(group_info, i);
+		kgid = GROUP_AT(group_info, i);
+		group = (u16)from_kgid_munged(user_ns, kgid);
 		if (put_user(group, grouplist+i))
 			return -EFAULT;
 	}
@@ -187,13 +190,19 @@ static int groups16_to_user(u16 __user *grouplist, struct group_info *group_info
 
 static int groups16_from_user(struct group_info *group_info, u16 __user *grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	u16 group;
 
 	for (i = 0; i < group_info->ngroups; i++) {
 		if (get_user(group, grouplist+i))
 			return  -EFAULT;
-		GROUP_AT(group_info, i) = (gid_t)group;
+
+		kgid = make_kgid(user_ns, (gid_t)group);
+		if (!gid_valid(kgid))
+			return -EINVAL;
+
+		GROUP_AT(group_info, i) = kgid;
 	}
 
 	return 0;
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 79717a4..204438c 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 1995, 1996 Olaf Kirch <okir@monad.swb.de> */
 
 #include <linux/sched.h>
+#include <linux/user_namespace.h>
 #include "nfsd.h"
 #include "auth.h"
 
@@ -56,8 +57,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 			goto oom;
 
 		for (i = 0; i < rqgi->ngroups; i++) {
-			if (!GROUP_AT(rqgi, i))
-				GROUP_AT(gi, i) = exp->ex_anon_gid;
+			if (gid_eq(GLOBAL_ROOT_GID, GROUP_AT(rqgi, i)))
+				GROUP_AT(gi, i) = make_kgid(&init_user_ns, exp->ex_anon_gid);
 			else
 				GROUP_AT(gi, i) = GROUP_AT(rqgi, i);
 		}
diff --git a/fs/proc/array.c b/fs/proc/array.c
index f9bd395..36a0a91 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -81,6 +81,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/user_namespace.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -161,6 +162,7 @@ static inline const char *get_task_state(struct task_struct *tsk)
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct group_info *group_info;
 	int g;
 	struct fdtable *fdt = NULL;
@@ -205,7 +207,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
-		seq_printf(m, "%d ", GROUP_AT(group_info, g));
+		seq_printf(m, "%d ",
+			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 
 	seq_putc(m, '\n');
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 2c60ec8..0ab3cda 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -17,6 +17,7 @@
 #include <linux/key.h>
 #include <linux/selinux.h>
 #include <linux/atomic.h>
+#include <linux/uidgid.h>
 
 struct user_struct;
 struct cred;
@@ -26,14 +27,14 @@ struct inode;
  * COW Supplementary groups list
  */
 #define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
+#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(kgid_t)))
 
 struct group_info {
 	atomic_t	usage;
 	int		ngroups;
 	int		nblocks;
-	gid_t		small_block[NGROUPS_SMALL];
-	gid_t		*blocks[0];
+	kgid_t		small_block[NGROUPS_SMALL];
+	kgid_t		*blocks[0];
 };
 
 /**
@@ -66,7 +67,7 @@ extern struct group_info init_groups;
 extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern int set_groups(struct cred *, struct group_info *);
-extern int groups_search(const struct group_info *, gid_t);
+extern int groups_search(const struct group_info *, kgid_t);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
diff --git a/kernel/groups.c b/kernel/groups.c
index 99b53d1..84156f2 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -31,7 +31,7 @@ struct group_info *groups_alloc(int gidsetsize)
 		group_info->blocks[0] = group_info->small_block;
 	else {
 		for (i = 0; i < nblocks; i++) {
-			gid_t *b;
+			kgid_t *b;
 			b = (void *)__get_free_page(GFP_USER);
 			if (!b)
 				goto out_undo_partial_alloc;
@@ -66,18 +66,15 @@ EXPORT_SYMBOL(groups_free);
 static int groups_to_user(gid_t __user *grouplist,
 			  const struct group_info *group_info)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	unsigned int count = group_info->ngroups;
 
-	for (i = 0; i < group_info->nblocks; i++) {
-		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
-		unsigned int len = cp_count * sizeof(*grouplist);
-
-		if (copy_to_user(grouplist, group_info->blocks[i], len))
+	for (i = 0; i < count; i++) {
+		gid_t gid;
+		gid = from_kgid_munged(user_ns, GROUP_AT(group_info, i));
+		if (put_user(gid, grouplist+i))
 			return -EFAULT;
-
-		grouplist += NGROUPS_PER_BLOCK;
-		count -= cp_count;
 	}
 	return 0;
 }
@@ -86,18 +83,21 @@ static int groups_to_user(gid_t __user *grouplist,
 static int groups_from_user(struct group_info *group_info,
     gid_t __user *grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	unsigned int count = group_info->ngroups;
 
-	for (i = 0; i < group_info->nblocks; i++) {
-		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
-		unsigned int len = cp_count * sizeof(*grouplist);
-
-		if (copy_from_user(group_info->blocks[i], grouplist, len))
+	for (i = 0; i < count; i++) {
+		gid_t gid;
+		kgid_t kgid;
+		if (get_user(gid, grouplist+i))
 			return -EFAULT;
 
-		grouplist += NGROUPS_PER_BLOCK;
-		count -= cp_count;
+		kgid = make_kgid(user_ns, gid);
+		if (!gid_valid(kgid))
+			return -EINVAL;
+
+		GROUP_AT(group_info, i) = kgid;
 	}
 	return 0;
 }
@@ -117,9 +117,9 @@ static void groups_sort(struct group_info *group_info)
 		for (base = 0; base < max; base++) {
 			int left = base;
 			int right = left + stride;
-			gid_t tmp = GROUP_AT(group_info, right);
+			kgid_t tmp = GROUP_AT(group_info, right);
 
-			while (left >= 0 && GROUP_AT(group_info, left) > tmp) {
+			while (left >= 0 && gid_gt(GROUP_AT(group_info, left), tmp)) {
 				GROUP_AT(group_info, right) =
 				    GROUP_AT(group_info, left);
 				right = left;
@@ -132,7 +132,7 @@ static void groups_sort(struct group_info *group_info)
 }
 
 /* a simple bsearch */
-int groups_search(const struct group_info *group_info, gid_t grp)
+int groups_search(const struct group_info *group_info, kgid_t grp)
 {
 	unsigned int left, right;
 
@@ -143,9 +143,9 @@ int groups_search(const struct group_info *group_info, gid_t grp)
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		if (grp > GROUP_AT(group_info, mid))
+		if (gid_gt(grp, GROUP_AT(group_info, mid)))
 			left = mid + 1;
-		else if (grp < GROUP_AT(group_info, mid))
+		else if (gid_lt(grp, GROUP_AT(group_info, mid)))
 			right = mid;
 		else
 			return 1;
@@ -262,7 +262,8 @@ int in_group_p(gid_t grp)
 	int retval = 1;
 
 	if (grp != cred->fsgid)
-		retval = groups_search(cred->group_info, grp);
+		retval = groups_search(cred->group_info,
+				       make_kgid(cred->user_ns, grp));
 	return retval;
 }
 
@@ -274,7 +275,8 @@ int in_egroup_p(gid_t grp)
 	int retval = 1;
 
 	if (grp != cred->egid)
-		retval = groups_search(cred->group_info, grp);
+		retval = groups_search(cred->group_info,
+				       make_kgid(cred->user_ns, grp));
 	return retval;
 }
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 51c6e89..e530bc3 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -134,11 +134,14 @@ SYSCALL_DEFINE1(setfsgid16, old_gid_t, gid)
 static int groups16_to_user(old_gid_t __user *grouplist,
     struct group_info *group_info)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	old_gid_t group;
+	kgid_t kgid;
 
 	for (i = 0; i < group_info->ngroups; i++) {
-		group = high2lowgid(GROUP_AT(group_info, i));
+		kgid = GROUP_AT(group_info, i);
+		group = high2lowgid(from_kgid_munged(user_ns, kgid));
 		if (put_user(group, grouplist+i))
 			return -EFAULT;
 	}
@@ -149,13 +152,20 @@ static int groups16_to_user(old_gid_t __user *grouplist,
 static int groups16_from_user(struct group_info *group_info,
     old_gid_t __user *grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
 	old_gid_t group;
+	kgid_t kgid;
 
 	for (i = 0; i < group_info->ngroups; i++) {
 		if (get_user(group, grouplist+i))
 			return  -EFAULT;
-		GROUP_AT(group_info, i) = low2highgid(group);
+
+		kgid = make_kgid(user_ns, low2highgid(group));
+		if (!gid_valid(kgid))
+			return -EINVAL;
+
+		GROUP_AT(group_info, i) = kgid;
 	}
 
 	return 0;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 50009c7..9d3044f 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -205,17 +205,22 @@ static int ping_init_sock(struct sock *sk)
 	gid_t range[2];
 	struct group_info *group_info = get_current_groups();
 	int i, j, count = group_info->ngroups;
+	kgid_t low, high;
 
 	inet_get_ping_group_range_net(net, range, range+1);
+	low = make_kgid(&init_user_ns, range[0]);
+	high = make_kgid(&init_user_ns, range[1]);
+	if (!gid_valid(low) || !gid_valid(high) || gid_lt(high, low))
+		return -EACCES;
+
 	if (range[0] <= group && group <= range[1])
 		return 0;
 
 	for (i = 0; i < group_info->nblocks; i++) {
 		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
-
 		for (j = 0; j < cp_count; j++) {
-			group = group_info->blocks[i][j];
-			if (range[0] <= group && group <= range[1])
+			kgid_t gid = group_info->blocks[i][j];
+			if (gid_lte(low, gid) && gid_lte(gid, high))
 				return 0;
 		}
 
diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 75762f3..6ed6f20 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -160,8 +160,8 @@ generic_match(struct auth_cred *acred, struct rpc_cred *cred, int flags)
 	if (gcred->acred.group_info->ngroups != acred->group_info->ngroups)
 		goto out_nomatch;
 	for (i = 0; i < gcred->acred.group_info->ngroups; i++) {
-		if (GROUP_AT(gcred->acred.group_info, i) !=
-				GROUP_AT(acred->group_info, i))
+		if (!gid_eq(GROUP_AT(gcred->acred.group_info, i),
+				GROUP_AT(acred->group_info, i)))
 			goto out_nomatch;
 	}
 out_match:
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 1600cfb..28b62db 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -41,6 +41,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/user_namespace.h>
 
 #include <linux/sunrpc/auth_gss.h>
 #include <linux/sunrpc/gss_err.h>
@@ -470,9 +471,13 @@ static int rsc_parse(struct cache_detail *cd,
 		status = -EINVAL;
 		for (i=0; i<N; i++) {
 			gid_t gid;
+			kgid_t kgid;
 			if (get_int(&mesg, &gid))
 				goto out;
-			GROUP_AT(rsci.cred.cr_group_info, i) = gid;
+			kgid = make_kgid(&init_user_ns, gid);
+			if (!gid_valid(kgid))
+				goto out;
+			GROUP_AT(rsci.cred.cr_group_info, i) = kgid;
 		}
 
 		/* mech name */
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index e50502d..52c5abd 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/auth.h>
+#include <linux/user_namespace.h>
 
 #define NFS_NGROUPS	16
 
@@ -78,8 +79,11 @@ unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 		groups = NFS_NGROUPS;
 
 	cred->uc_gid = acred->gid;
-	for (i = 0; i < groups; i++)
-		cred->uc_gids[i] = GROUP_AT(acred->group_info, i);
+	for (i = 0; i < groups; i++) {
+		gid_t gid;
+		gid = from_kgid(&init_user_ns, GROUP_AT(acred->group_info, i));
+		cred->uc_gids[i] = gid;
+	}
 	if (i < NFS_NGROUPS)
 		cred->uc_gids[i] = NOGROUP;
 
@@ -126,9 +130,12 @@ unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
 		groups = acred->group_info->ngroups;
 	if (groups > NFS_NGROUPS)
 		groups = NFS_NGROUPS;
-	for (i = 0; i < groups ; i++)
-		if (cred->uc_gids[i] != GROUP_AT(acred->group_info, i))
+	for (i = 0; i < groups ; i++) {
+		gid_t gid;
+		gid = from_kgid(&init_user_ns, GROUP_AT(acred->group_info, i));
+		if (cred->uc_gids[i] != gid)
 			return 0;
+	}
 	if (groups < NFS_NGROUPS &&
 	    cred->uc_gids[groups] != NOGROUP)
 		return 0;
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 521d8f7..71ec853 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/ipv6.h>
 #include <linux/kernel.h>
+#include <linux/user_namespace.h>
 #define RPCDBG_FACILITY	RPCDBG_AUTH
 
 #include <linux/sunrpc/clnt.h>
@@ -530,11 +531,15 @@ static int unix_gid_parse(struct cache_detail *cd,
 
 	for (i = 0 ; i < gids ; i++) {
 		int gid;
+		kgid_t kgid;
 		rv = get_int(&mesg, &gid);
 		err = -EINVAL;
 		if (rv)
 			goto out;
-		GROUP_AT(ug.gi, i) = gid;
+		kgid = make_kgid(&init_user_ns, gid);
+		if (!gid_valid(kgid))
+			goto out;
+		GROUP_AT(ug.gi, i) = kgid;
 	}
 
 	ugp = unix_gid_lookup(cd, uid);
@@ -563,6 +568,7 @@ static int unix_gid_show(struct seq_file *m,
 			 struct cache_detail *cd,
 			 struct cache_head *h)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct unix_gid *ug;
 	int i;
 	int glen;
@@ -580,7 +586,7 @@ static int unix_gid_show(struct seq_file *m,
 
 	seq_printf(m, "%u %d:", ug->uid, glen);
 	for (i = 0; i < glen; i++)
-		seq_printf(m, " %d", GROUP_AT(ug->gi, i));
+		seq_printf(m, " %d", from_kgid_munged(user_ns, GROUP_AT(ug->gi, i)));
 	seq_printf(m, "\n");
 	return 0;
 }
@@ -831,8 +837,12 @@ svcauth_unix_accept(struct svc_rqst *rqstp, __be32 *authp)
 	cred->cr_group_info = groups_alloc(slen);
 	if (cred->cr_group_info == NULL)
 		return SVC_CLOSE;
-	for (i = 0; i < slen; i++)
-		GROUP_AT(cred->cr_group_info, i) = svc_getnl(argv);
+	for (i = 0; i < slen; i++) {
+		kgid_t kgid = make_kgid(&init_user_ns, svc_getnl(argv));
+		if (!gid_valid(kgid))
+			goto badcred;
+		GROUP_AT(cred->cr_group_info, i) = kgid;
+	}
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
 		*authp = rpc_autherr_badverf;
 		return SVC_DENIED;
diff --git a/security/keys/permission.c b/security/keys/permission.c
index e146cbd..5442900 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -53,7 +53,8 @@ int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 			goto use_these_perms;
 		}
 
-		ret = groups_search(cred->group_info, key->gid);
+		ret = groups_search(cred->group_info,
+				    make_kgid(current_user_ns(), key->gid));
 		if (ret) {
 			kperm = key->perm >> 8;
 			goto use_these_perms;
-- 
1.7.2.5

