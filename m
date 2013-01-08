Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3AHCTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:19:35 -0500
Received: from nm29.access.bullet.mail.sp2.yahoo.com ([98.139.44.156]:43953
	"EHLO nm29.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052Ab3AHCIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:08:50 -0500
X-Yahoo-Newman-Id: 374038.43918.bm@smtp103.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iDaq4GMVM1l_Vgaz1mITj0GOVwf2BhXKDanC71IXIAf1Dai
 sUTiGhrJC4LBihMffeQib338IYUsWYvw3Ak5prWIAS.E6p3g86y5cTIIoIkF
 5xtb6qGRFz0eDn48KHpM6sL4SjWXTOPMDk8cokZJ3rYpqDNa9ahUgdgSHVcU
 3qTLJ5xMzFCKRPMH0gZGaBPE.dSShbQC7ArWb2vsPMihYFNVl4w5ZWBA_oIb
 prt1UYd8DeWdmTi29fC.Fgf.MMSTTsJ8ZLewjUpAUNqNJPYW8hZfZWJcPapv
 xkXbtc0nB7S2nKoFVqE4gBjZGyYLcnGxNgAdH0njMuoLPg.MYG09VKLV1HPo
 tzThZTVbuQ5ulJqMNybiqZgmT6_4ReZ46kUVNHvl0rTcPiWQ0IlkWtxjoz09
 AGd.jetz4IUTC8t6MWoYctUOUKAeSI2cxGVBK8JZP4mumhO2lZGXmCqDFUfn
 wqF8D
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FBE.80309@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:02 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 1/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 1/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Changes for AppArmor. Abstract access to security blobs.
Remove commoncap calls.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/apparmor/context.c         |   10 +++---
 security/apparmor/domain.c          |   19 ++++------
 security/apparmor/include/context.h |   13 +++++--
 security/apparmor/lsm.c             |   66 +++++++++++++----------------------
 4 files changed, 45 insertions(+), 63 deletions(-)

diff --git a/security/apparmor/context.c b/security/apparmor/context.c
index 8a9b502..3d9e460 100644
--- a/security/apparmor/context.c
+++ b/security/apparmor/context.c
@@ -76,7 +76,7 @@ void aa_dup_task_context(struct aa_task_cxt *new, const struct aa_task_cxt *old)
  */
 int aa_replace_current_profile(struct aa_profile *profile)
 {
-	struct aa_task_cxt *cxt = current_cred()->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(current_cred(), &apparmor_ops);
 	struct cred *new;
 	BUG_ON(!profile);
 
@@ -87,7 +87,7 @@ int aa_replace_current_profile(struct aa_profile *profile)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (unconfined(profile) || (cxt->profile->ns != profile->ns)) {
 		/* if switching to unconfined or a different profile namespace
 		 * clear out context state
@@ -123,7 +123,7 @@ int aa_set_current_onexec(struct aa_profile *profile)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	aa_get_profile(profile);
 	aa_put_profile(cxt->onexec);
 	cxt->onexec = profile;
@@ -150,7 +150,7 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token)
 		return -ENOMEM;
 	BUG_ON(!profile);
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (!cxt->previous) {
 		/* transfer refcount */
 		cxt->previous = cxt->profile;
@@ -187,7 +187,7 @@ int aa_restore_previous_profile(u64 token)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (cxt->token != token) {
 		abort_creds(new);
 		return -EACCES;
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 60f0c76..7ad4e26 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -353,14 +353,12 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 		bprm->file->f_path.dentry->d_inode->i_mode
 	};
 	const char *name = NULL, *target = NULL, *info = NULL;
-	int error = cap_bprm_set_creds(bprm);
-	if (error)
-		return error;
+	int error = 0;
 
 	if (bprm->cred_prepared)
 		return 0;
 
-	cxt = bprm->cred->security;
+	cxt = lsm_get_cred(bprm->cred, &apparmor_ops);
 	BUG_ON(!cxt);
 
 	profile = aa_get_profile(aa_newest_version(cxt->profile));
@@ -539,15 +537,10 @@ cleanup:
  */
 int apparmor_bprm_secureexec(struct linux_binprm *bprm)
 {
-	int ret = cap_bprm_secureexec(bprm);
-
 	/* the decision to use secure exec is computed in set_creds
 	 * and stored in bprm->unsafe.
 	 */
-	if (!ret && (bprm->unsafe & AA_SECURE_X_NEEDED))
-		ret = 1;
-
-	return ret;
+	return bprm->unsafe & AA_SECURE_X_NEEDED;
 }
 
 /**
@@ -557,7 +550,7 @@ int apparmor_bprm_secureexec(struct linux_binprm *bprm)
 void apparmor_bprm_committing_creds(struct linux_binprm *bprm)
 {
 	struct aa_profile *profile = __aa_current_profile();
-	struct aa_task_cxt *new_cxt = bprm->cred->security;
+	struct aa_task_cxt *new_cxt = lsm_get_cred(bprm->cred, &apparmor_ops);
 
 	/* bail out if unconfined or not changing profile */
 	if ((new_cxt->profile == profile) ||
@@ -634,7 +627,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 
 	/* released below */
 	cred = get_current_cred();
-	cxt = cred->security;
+	cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 	previous_profile = cxt->previous;
 
@@ -770,7 +763,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 	}
 
 	cred = get_current_cred();
-	cxt = cred->security;
+	cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 
 	/*
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index a9cbee4..8484e55 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -18,6 +18,7 @@
 #include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/lsm.h>
 
 #include "policy.h"
 
@@ -81,6 +82,8 @@ int aa_set_current_onexec(struct aa_profile *profile);
 int aa_set_current_hat(struct aa_profile *profile, u64 token);
 int aa_restore_previous_profile(u64 cookie);
 
+extern struct security_operations apparmor_ops;
+
 /**
  * __aa_task_is_confined - determine if @task has any confinement
  * @task: task to check confinement of  (NOT NULL)
@@ -89,7 +92,9 @@ int aa_restore_previous_profile(u64 cookie);
  */
 static inline bool __aa_task_is_confined(struct task_struct *task)
 {
-	struct aa_task_cxt *cxt = __task_cred(task)->security;
+	struct aa_task_cxt *cxt;
+
+	cxt = lsm_get_cred(__task_cred(task), &apparmor_ops);
 
 	BUG_ON(!cxt || !cxt->profile);
 	if (unconfined(aa_newest_version(cxt->profile)))
@@ -108,7 +113,7 @@ static inline bool __aa_task_is_confined(struct task_struct *task)
  */
 static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
 {
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	BUG_ON(!cxt || !cxt->profile);
 	return aa_newest_version(cxt->profile);
 }
@@ -136,8 +141,10 @@ static inline struct aa_profile *__aa_current_profile(void)
  */
 static inline struct aa_profile *aa_current_profile(void)
 {
-	const struct aa_task_cxt *cxt = current_cred()->security;
+	const struct aa_task_cxt *cxt;
 	struct aa_profile *profile;
+
+	cxt = lsm_get_cred(current_cred(), &apparmor_ops);
 	BUG_ON(!cxt || !cxt->profile);
 
 	profile = aa_newest_version(cxt->profile);
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8c2a7f6..28d6fd4 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -48,8 +48,8 @@ int apparmor_initialized __initdata;
  */
 static void apparmor_cred_free(struct cred *cred)
 {
-	aa_free_task_context(cred->security);
-	cred->security = NULL;
+	aa_free_task_context(lsm_get_cred(cred, &apparmor_ops));
+	lsm_set_cred(cred, NULL, &apparmor_ops);
 }
 
 /*
@@ -62,7 +62,7 @@ static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (!cxt)
 		return -ENOMEM;
 
-	cred->security = cxt;
+	lsm_set_cred(cred, cxt, &apparmor_ops);
 	return 0;
 }
 
@@ -77,8 +77,8 @@ static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
 	if (!cxt)
 		return -ENOMEM;
 
-	aa_dup_task_context(cxt, old->security);
-	new->security = cxt;
+	aa_dup_task_context(cxt, lsm_get_cred(old, &apparmor_ops));
+	lsm_set_cred(new, cxt, &apparmor_ops);
 	return 0;
 }
 
@@ -87,8 +87,8 @@ static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 {
-	const struct aa_task_cxt *old_cxt = old->security;
-	struct aa_task_cxt *new_cxt = new->security;
+	const struct aa_task_cxt *old_cxt = lsm_get_cred(old, &apparmor_ops);
+	struct aa_task_cxt *new_cxt = lsm_get_cred(new, &apparmor_ops);
 
 	aa_dup_task_context(new_cxt, old_cxt);
 }
@@ -96,19 +96,11 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 static int apparmor_ptrace_access_check(struct task_struct *child,
 					unsigned int mode)
 {
-	int error = cap_ptrace_access_check(child, mode);
-	if (error)
-		return error;
-
 	return aa_ptrace(current, child, mode);
 }
 
 static int apparmor_ptrace_traceme(struct task_struct *parent)
 {
-	int error = cap_ptrace_traceme(parent);
-	if (error)
-		return error;
-
 	return aa_ptrace(parent, current, PTRACE_MODE_ATTACH);
 }
 
@@ -140,14 +132,11 @@ static int apparmor_capable(const struct cred *cred, struct user_namespace *ns,
 			    int cap, int audit)
 {
 	struct aa_profile *profile;
-	/* cap_capable returns 0 on success, else -EPERM */
-	int error = cap_capable(cred, ns, cap, audit);
-	if (!error) {
-		profile = aa_cred_profile(cred);
-		if (!unconfined(profile))
-			error = aa_capable(current, profile, cap, audit);
-	}
-	return error;
+
+	profile = aa_cred_profile(cred);
+	if (!unconfined(profile))
+		return aa_capable(current, profile, cap, audit);
+	return 0;
 }
 
 /**
@@ -375,7 +364,7 @@ static int apparmor_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 
 static int apparmor_file_open(struct file *file, const struct cred *cred)
 {
-	struct aa_file_cxt *fcxt = file->f_security;
+	struct aa_file_cxt *fcxt = lsm_get_file(file, &apparmor_ops);
 	struct aa_profile *profile;
 	int error = 0;
 
@@ -409,8 +398,8 @@ static int apparmor_file_open(struct file *file, const struct cred *cred)
 static int apparmor_file_alloc_security(struct file *file)
 {
 	/* freed by apparmor_file_free_security */
-	file->f_security = aa_alloc_file_context(GFP_KERNEL);
-	if (!file->f_security)
+	lsm_set_file(file, aa_alloc_file_context(GFP_KERNEL), &apparmor_ops);
+	if (!lsm_get_file(file, &apparmor_ops))
 		return -ENOMEM;
 	return 0;
 
@@ -418,14 +407,15 @@ static int apparmor_file_alloc_security(struct file *file)
 
 static void apparmor_file_free_security(struct file *file)
 {
-	struct aa_file_cxt *cxt = file->f_security;
+	struct aa_file_cxt *cxt = lsm_get_file(file, &apparmor_ops);
 
+	lsm_set_file(file, NULL, &apparmor_ops);
 	aa_free_file_context(cxt);
 }
 
 static int common_file_perm(int op, struct file *file, u32 mask)
 {
-	struct aa_file_cxt *fcxt = file->f_security;
+	struct aa_file_cxt *fcxt = lsm_get_file(file, &apparmor_ops);
 	struct aa_profile *profile, *fprofile = aa_cred_profile(file->f_cred);
 	int error = 0;
 
@@ -472,7 +462,7 @@ static int common_mmap(int op, struct file *file, unsigned long prot,
 	struct dentry *dentry;
 	int mask = 0;
 
-	if (!file || !file->f_security)
+	if (!file || !lsm_get_file(file, &apparmor_ops))
 		return 0;
 
 	if (prot & PROT_READ)
@@ -510,7 +500,7 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	struct aa_profile *profile;
 	/* released below */
 	const struct cred *cred = get_task_cred(task);
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 
 	if (strcmp(name, "current") == 0)
@@ -614,7 +604,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static struct security_operations apparmor_ops = {
+struct security_operations apparmor_ops = {
 	.name =				"apparmor",
 
 	.ptrace_access_check =		apparmor_ptrace_access_check,
@@ -878,6 +868,7 @@ static int param_set_mode(const char *val, struct kernel_param *kp)
  */
 static int __init set_init_cxt(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *)current->real_cred;
 	struct aa_task_cxt *cxt;
 
@@ -886,9 +877,9 @@ static int __init set_init_cxt(void)
 		return -ENOMEM;
 
 	cxt->profile = aa_get_profile(root_ns->unconfined);
-	cred->security = cxt;
+	rc = lsm_set_init_cred(cred, cxt, &apparmor_ops);
 
-	return 0;
+	return rc;
 }
 
 static int __init apparmor_init(void)
@@ -913,12 +904,6 @@ static int __init apparmor_init(void)
 		goto register_security_out;
 	}
 
-	error = register_security(&apparmor_ops);
-	if (error) {
-		AA_ERROR("Unable to register AppArmor\n");
-		goto set_init_cxt_out;
-	}
-
 	/* Report that AppArmor successfully initialized */
 	apparmor_initialized = 1;
 	if (aa_g_profile_mode == APPARMOR_COMPLAIN)
@@ -930,9 +915,6 @@ static int __init apparmor_init(void)
 
 	return error;
 
-set_init_cxt_out:
-	aa_free_task_context(current->real_cred->security);
-
 register_security_out:
 	aa_free_root_ns();
 

