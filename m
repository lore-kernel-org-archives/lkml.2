Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3AHCJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:09:31 -0500
Received: from nm3-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.108]:30698
	"EHLO nm3-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035Ab3AHCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:27 -0500
X-Yahoo-Newman-Id: 67860.34153.bm@smtp109.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: S.1g7Z0VM1kDENCsL3i7c_KhRzGcG1vzKTGF3_jgUMoYUg0
 nUwvoRR.AJeon5ld9r1dKge0CbK6H1aclSq0bqtbhR5RNV5Sj6OjL.JnYJ2P
 yuOpPP.U2zpMmL8uWeQUQKUe5cK9sum6d9KSgT8mwh4AGwdxS2FGUXjSKuD8
 c5t51kfRUI7BGglOrbrRLWVlROSiDP6VZYG0UdGVopSF6C8FmE44TuBOfmqg
 O8kj9sZOBKZ.Fuk15uqEZbhUS2ZBuW0PP8GTG3Z7IXG1BPBCxJtMZyKKQwy7
 yvmWsPzAAAgH.2_Oc_bkYzwGmloqP2Lx2qY1A9WlpnT2rYIlUU_laFjry.By
 6qhhWPDHEUhVZbnCa2GoNWitIi.Y8BkC1iNA.CgvyNUHIBpNYklGJYNvGlRq
 SDQCj6gU_Cfc26sb3ktnrmnwp0u3jIQaYCRhQbi5MWZsxS7k2qiBv1Ti5CHD
 _VMEYzS_KCeKk6EvU8p7zk1lL77HAZteq0EftnMamwRjtM0f0LmD5QgqV7.B
 fgw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FE5.5070105@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:41 -0800
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
Subject: [PATCH v12 8/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 8/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Abstract access to security blobs.
Remove commoncap calls.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/tomoyo/common.h        |    6 +++--
 security/tomoyo/domain.c        |    2 +-
 security/tomoyo/securityfs_if.c |    9 +++++---
 security/tomoyo/tomoyo.c        |   47 ++++++++++++++++++++++-----------------
 4 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index d4f166b..ef0cdcc 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -28,6 +28,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/un.h>
+#include <linux/lsm.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
 #include <net/ip.h>
@@ -1079,6 +1080,7 @@ extern struct list_head tomoyo_domain_list;
 extern struct list_head tomoyo_name_list[TOMOYO_MAX_HASH];
 extern struct list_head tomoyo_namespace_list;
 extern struct mutex tomoyo_policy_lock;
+extern struct security_operations tomoyo_security_ops;
 extern struct srcu_struct tomoyo_ss;
 extern struct tomoyo_domain_info tomoyo_kernel_domain;
 extern struct tomoyo_policy_namespace tomoyo_kernel_namespace;
@@ -1202,7 +1204,7 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	return current_cred()->security;
+	return lsm_get_cred(current_cred(), &tomoyo_security_ops);
 }
 
 /**
@@ -1215,7 +1217,7 @@ static inline struct tomoyo_domain_info *tomoyo_domain(void)
 static inline struct tomoyo_domain_info *tomoyo_real_domain(struct task_struct
 							    *task)
 {
-	return task_cred_xxx(task, security);
+	return lsm_get_cred(__task_cred(task), &tomoyo_security_ops);
 }
 
 /**
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 3865145..15042e7 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -840,7 +840,7 @@ force_jump_domain:
 		domain = old_domain;
 	/* Update reference count on "struct tomoyo_domain_info". */
 	atomic_inc(&domain->users);
-	bprm->cred->security = domain;
+	lsm_set_cred(bprm->cred, domain, &tomoyo_security_ops);
 	kfree(exename.name);
 	if (!retval) {
 		ee->r.domain = domain;
diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index 8592f2fc..37feaf5 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -75,8 +75,10 @@ static ssize_t tomoyo_write_self(struct file *file, const char __user *buf,
 					error = -ENOMEM;
 				} else {
 					struct tomoyo_domain_info *old_domain =
-						cred->security;
-					cred->security = new_domain;
+						lsm_get_cred(cred,
+							&tomoyo_security_ops);
+					lsm_set_cred(cred, new_domain,
+							&tomoyo_security_ops);
 					atomic_inc(&new_domain->users);
 					atomic_dec(&old_domain->users);
 					commit_creds(cred);
@@ -242,7 +244,8 @@ static int __init tomoyo_initerface_init(void)
 	struct dentry *tomoyo_dir;
 
 	/* Don't create securityfs entries unless registered. */
-	if (current_cred()->security != &tomoyo_kernel_domain)
+	if (lsm_get_cred(current_cred(), &tomoyo_security_ops) !=
+			&tomoyo_kernel_domain)
 		return 0;
 
 	tomoyo_dir = securityfs_create_dir("tomoyo", NULL);
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index a2ee362..b2a58ae 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -17,7 +17,7 @@
  */
 static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 {
-	new->security = NULL;
+	lsm_set_cred(new, NULL, &tomoyo_security_ops);
 	return 0;
 }
 
@@ -33,8 +33,10 @@ static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 			       gfp_t gfp)
 {
-	struct tomoyo_domain_info *domain = old->security;
-	new->security = domain;
+	struct tomoyo_domain_info *domain;
+
+	domain = lsm_get_cred(old, &tomoyo_security_ops);
+	lsm_set_cred(new, domain, &tomoyo_security_ops);
 	if (domain)
 		atomic_inc(&domain->users);
 	return 0;
@@ -58,9 +60,13 @@ static void tomoyo_cred_transfer(struct cred *new, const struct cred *old)
  */
 static void tomoyo_cred_free(struct cred *cred)
 {
-	struct tomoyo_domain_info *domain = cred->security;
-	if (domain)
+	struct tomoyo_domain_info *domain;
+
+	domain = lsm_get_cred(cred, &tomoyo_security_ops);
+	if (domain) {
 		atomic_dec(&domain->users);
+		lsm_set_cred(cred, NULL, &tomoyo_security_ops);
+	}
 }
 
 /**
@@ -72,12 +78,6 @@ static void tomoyo_cred_free(struct cred *cred)
  */
 static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 {
-	int rc;
-
-	rc = cap_bprm_set_creds(bprm);
-	if (rc)
-		return rc;
-
 	/*
 	 * Do only if this function is called for the first time of an execve
 	 * operation.
@@ -98,13 +98,13 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 	 * stored inside "bprm->cred->security" will be acquired later inside
 	 * tomoyo_find_next_domain().
 	 */
-	atomic_dec(&((struct tomoyo_domain_info *)
-		     bprm->cred->security)->users);
+	atomic_dec(&((struct tomoyo_domain_info *)lsm_get_cred(bprm->cred,
+						&tomoyo_security_ops))->users);
 	/*
 	 * Tell tomoyo_bprm_check_security() is called for the first time of an
 	 * execve operation.
 	 */
-	bprm->cred->security = NULL;
+	lsm_set_cred(bprm->cred, NULL, &tomoyo_security_ops);
 	return 0;
 }
 
@@ -117,8 +117,9 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
  */
 static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 {
-	struct tomoyo_domain_info *domain = bprm->cred->security;
+	struct tomoyo_domain_info *domain;
 
+	domain = lsm_get_cred(bprm->cred, &tomoyo_security_ops);
 	/*
 	 * Execute permission is checked against pathname passed to do_execve()
 	 * using current domain.
@@ -503,7 +504,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
  */
-static struct security_operations tomoyo_security_ops = {
+struct security_operations tomoyo_security_ops = {
 	.name                = "tomoyo",
 	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
@@ -545,16 +546,22 @@ struct srcu_struct tomoyo_ss;
  */
 static int __init tomoyo_init(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *) current_cred();
 
+	/* register ourselves with the security framework */
 	if (!security_module_enable(&tomoyo_security_ops))
 		return 0;
-	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_security_ops) ||
-	    init_srcu_struct(&tomoyo_ss))
+
+	if (init_srcu_struct(&tomoyo_ss))
 		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
-	cred->security = &tomoyo_kernel_domain;
+
+	rc = lsm_set_init_cred(cred, &tomoyo_kernel_domain,
+				&tomoyo_security_ops);
+	if (rc)
+		panic("Failure allocating credential for TOMOYO Linux");
+
 	tomoyo_mm_init();
 	return 0;
 }

