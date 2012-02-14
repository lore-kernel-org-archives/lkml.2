Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2BNQzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:55:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab2BNQzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:55:05 -0500
Date: Tue, 14 Feb 2012 17:48:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] usermodehelper: kill umh_wait, renumber UMH_* constants
Message-ID: <20120214164821.GC21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. It is not sane to use UMH_KILLABLE with
enum umh_wait, but obviously we do not want another argument in
call_usermodehelper_* helpers. Kill this enum, use the plain int.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/kmod.h        |   18 +++++++-----------
 kernel/kmod.c               |    8 ++------
 security/keys/request_key.c |    2 +-
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 1b59858..9efeae6 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -48,12 +48,9 @@ static inline int request_module_nowait(const char *name, ...) { return -ENOSYS;
 struct cred;
 struct file;
 
-enum umh_wait {
-	UMH_NO_WAIT = -1,	/* don't wait at all */
-	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
-	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
-};
-
+#define UMH_NO_WAIT	0	/* don't wait at all */
+#define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
+#define UMH_WAIT_PROC	2	/* wait for the process to complete */
 #define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
 
 struct subprocess_info {
@@ -62,7 +59,7 @@ struct subprocess_info {
 	char *path;
 	char **argv;
 	char **envp;
-	enum umh_wait wait;
+	int wait;
 	int retval;
 	int (*init)(struct subprocess_info *info, struct cred *new);
 	void (*cleanup)(struct subprocess_info *info);
@@ -80,15 +77,14 @@ void call_usermodehelper_setfns(struct subprocess_info *info,
 		    void *data);
 
 /* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
+int call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
 /* Free the subprocess_info. This is only needed if you're not going
    to call call_usermodehelper_exec */
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper_fns(char *path, char **argv, char **envp,
-			enum umh_wait wait,
+call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
 			void (*cleanup)(struct subprocess_info *), void *data)
 {
@@ -106,7 +102,7 @@ call_usermodehelper_fns(char *path, char **argv, char **envp,
 }
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
 	return call_usermodehelper_fns(path, argv, envp, wait,
 				       NULL, NULL, NULL);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index f92f917..8341de9 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -257,12 +257,9 @@ static void __call_usermodehelper(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	enum umh_wait wait = sub_info->wait;
+	int wait = sub_info->wait & ~UMH_KILLABLE;
 	pid_t pid;
 
-	if (wait != UMH_NO_WAIT)
-		wait &= ~UMH_KILLABLE;
-
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -451,8 +448,7 @@ EXPORT_SYMBOL(call_usermodehelper_setfns);
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
-int call_usermodehelper_exec(struct subprocess_info *sub_info,
-			     enum umh_wait wait)
+int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 8246532..fc7c8cc 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -91,7 +91,7 @@ static void umh_keys_cleanup(struct subprocess_info *info)
  * Call a usermode helper with a specific session keyring.
  */
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
+			 		struct key *session_keyring, int wait)
 {
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 	struct subprocess_info *info =
-- 
1.5.5.1


