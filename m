Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2KSPNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:33 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50562 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2KSPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:13:29 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:35 -0800
Message-Id: <1353337961-12962-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX180fV5MuC/hjfER5BJvdMwL4BOuTVlI6Ac=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 10/16] userns: Implement unshare of the user namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Add CLONE_THREAD to the unshare flags if CLONE_NEWUSER is selected
  As changing user namespaces is only valid if all there is only
  a single thread.
- Restore the code to add CLONE_VM if CLONE_THREAD is selected and
  the code to addCLONE_SIGHAND if CLONE_VM is selected.
  Making the constraints in the code clear.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/nsproxy.h        |    2 +-
 include/linux/user_namespace.h |    9 +++++++++
 kernel/fork.c                  |   25 ++++++++++++++++++++++---
 kernel/nsproxy.c               |    8 ++++----
 kernel/user_namespace.c        |   15 +++++++++++++++
 5 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cc37a55..10e5947 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -67,7 +67,7 @@ void exit_task_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 void free_nsproxy(struct nsproxy *ns);
 int unshare_nsproxy_namespaces(unsigned long, struct nsproxy **,
-	struct fs_struct *);
+	struct cred *, struct fs_struct *);
 int __init nsproxy_cache_init(void);
 
 static inline void put_nsproxy(struct nsproxy *ns)
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 95142ca..17651f0 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -39,6 +39,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void free_user_ns(struct kref *kref);
 
 static inline void put_user_ns(struct user_namespace *ns)
@@ -66,6 +67,14 @@ static inline int create_user_ns(struct cred *new)
 	return -EINVAL;
 }
 
+static inline int unshare_userns(unsigned long unshare_flags,
+				 struct cred **new_cred)
+{
+	if (unshare_flags & CLONE_NEWUSER)
+		return -EINVAL;
+	return 0;
+}
+
 static inline void put_user_ns(struct user_namespace *ns)
 {
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 8c29abb..38e53b8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1687,7 +1687,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing to
@@ -1754,11 +1754,17 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 {
 	struct fs_struct *fs, *new_fs = NULL;
 	struct files_struct *fd, *new_fd = NULL;
+	struct cred *new_cred = NULL;
 	struct nsproxy *new_nsproxy = NULL;
 	int do_sysvsem = 0;
 	int err;
 
 	/*
+	 * If unsharing a user namespace must also unshare the thread.
+	 */
+	if (unshare_flags & CLONE_NEWUSER)
+		unshare_flags |= CLONE_THREAD;
+	/*
 	 * If unsharing a pid namespace must also unshare the thread.
 	 */
 	if (unshare_flags & CLONE_NEWPID)
@@ -1795,11 +1801,15 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	err = unshare_fd(unshare_flags, &new_fd);
 	if (err)
 		goto bad_unshare_cleanup_fs;
-	err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy, new_fs);
+	err = unshare_userns(unshare_flags, &new_cred);
 	if (err)
 		goto bad_unshare_cleanup_fd;
+	err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
+					 new_cred, new_fs);
+	if (err)
+		goto bad_unshare_cleanup_cred;
 
-	if (new_fs || new_fd || do_sysvsem || new_nsproxy) {
+	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
 			/*
 			 * CLONE_SYSVSEM is equivalent to sys_exit().
@@ -1832,11 +1842,20 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 		}
 
 		task_unlock(current);
+
+		if (new_cred) {
+			/* Install the new user namespace */
+			commit_creds(new_cred);
+			new_cred = NULL;
+		}
 	}
 
 	if (new_nsproxy)
 		put_nsproxy(new_nsproxy);
 
+bad_unshare_cleanup_cred:
+	if (new_cred)
+		put_cred(new_cred);
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 2ddd816..78e2ecb 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -186,7 +186,7 @@ void free_nsproxy(struct nsproxy *ns)
  * On success, returns the new nsproxy.
  */
 int unshare_nsproxy_namespaces(unsigned long unshare_flags,
-		struct nsproxy **new_nsp, struct fs_struct *new_fs)
+	struct nsproxy **new_nsp, struct cred *new_cred, struct fs_struct *new_fs)
 {
 	struct user_namespace *user_ns;
 	int err = 0;
@@ -195,12 +195,12 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 			       CLONE_NEWNET | CLONE_NEWPID)))
 		return 0;
 
-	if (!nsown_capable(CAP_SYS_ADMIN))
+	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	user_ns = current_user_ns();
 	*new_nsp = create_new_namespaces(unshare_flags, current, user_ns,
-				new_fs ? new_fs : current->fs);
+					 new_fs ? new_fs : current->fs);
 	if (IS_ERR(*new_nsp)) {
 		err = PTR_ERR(*new_nsp);
 		goto out;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a946077..ce92f7e 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -82,6 +82,21 @@ int create_user_ns(struct cred *new)
 	return 0;
 }
 
+int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
+{
+	struct cred *cred;
+
+	if (!(unshare_flags & CLONE_NEWUSER))
+		return 0;
+
+	cred = prepare_creds();
+	if (!cred)
+		return -ENOMEM;
+
+	*new_cred = cred;
+	return create_user_ns(cred);
+}
+
 void free_user_ns(struct kref *kref)
 {
 	struct user_namespace *parent, *ns =
-- 
1.7.5.4

