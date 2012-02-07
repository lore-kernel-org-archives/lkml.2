Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2BGSvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:51:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2BGSvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:51:01 -0500
Date: Tue, 7 Feb 2012 19:44:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rusty@rustcorp.com.au, arjan@linux.intel.com, akpm@linux-foundation.org,
        tj@kernel.org, fhrbata@redhat.com, rientjes@google.com,
        apw@canonical.com, john.johansen@canonical.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1-5] make request_module() killable
Message-ID: <20120207184423.GA17924@redhat.com>
References: <20120202173504.GA25528@redhat.com> <201202032254.GCJ30240.SLMOVFFHtJOFOQ@I-love.SAKURA.ne.jp> <20120203151534.GB32503@redhat.com> <201202041426.ICI23458.FFFtOMLOJOVSQH@I-love.SAKURA.ne.jp> <201202051415.JEB43260.SFMJOHLtOFVQOF@I-love.SAKURA.ne.jp> <201202072055.GEC05251.FFMSVHOLOFOQJt@I-love.SAKURA.ne.jp> <20120207171031.GA11215@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20120207171031.GA11215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 02/07, Oleg Nesterov wrote:
>
> OK. I am convinced we need this ;) Thanks Tetsuo.

So. Please see the attachments. COMPLETELY UNTESTED, only for
review/discussion.

For those who were not CC'ed. As Tetsuo pointed out, request_module()
is very much unfriendly wrt OOM. It needs "a lot" of time/memory to
finish while the caller is blocked in TASK_UNINTERRUPTIBLE.

	0001-usermodehelper-kill-umh_wait-renumber-UMH_-consta.patch
	0002-usermodehelper-introduce-umh_complete-sub_info.patch
	0003-usermodehelper-implement-UMH_KILLABLE.patch

this adds UMH_KILLABLE,

	0004-kmod-introduce-call_modprobe-helper.patch
	0005-kmod-make-__request_module-killable.patch

this changes __request_module() to use UMH_KILLABLE.

Perhaps we should also mark the modprobe process as OOM_ADJUST_MAX.

What do you all think?

Oleg.

 include/linux/kmod.h        |   18 ++++-----
 kernel/kmod.c               |   81 +++++++++++++++++++++++++++++++++++--------
 security/keys/request_key.c |    2 +-
 3 files changed, 75 insertions(+), 26 deletions(-)


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-usermodehelper-kill-umh_wait-renumber-UMH_-consta.patch"

>From 03940f43d03efc0354c2e591f93cfaf12cc38c71 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 7 Feb 2012 16:25:34 +0100
Subject: [PATCH 1/5] usermodehelper: kill umh_wait, renumber UMH_* constants

No functional changes, preparation.

umh_wait doesn't can't be used as a bitmask, and we do not want
to add another argument call_usermodehelper_* helpers.

Kill this enum and redefine the UMH_* constants.
---
 include/linux/kmod.h        |   17 +++++++----------
 kernel/kmod.c               |    5 ++---
 security/keys/request_key.c |    2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 722f477..26187f2 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -48,11 +48,9 @@ static inline int request_module_nowait(const char *name, ...) { return -ENOSYS;
 struct cred;
 struct file;
 
-enum umh_wait {
-	UMH_NO_WAIT = -1,	/* don't wait at all */
-	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
-	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
-};
+#define UMH_NO_WAIT	0	/* don't wait at all */
+#define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
+#define UMH_WAIT_PROC	2	/* wait for the process to complete */
 
 struct subprocess_info {
 	struct work_struct work;
@@ -60,7 +58,7 @@ struct subprocess_info {
 	char *path;
 	char **argv;
 	char **envp;
-	enum umh_wait wait;
+	int wait;
 	int retval;
 	int (*init)(struct subprocess_info *info, struct cred *new);
 	void (*cleanup)(struct subprocess_info *info);
@@ -78,15 +76,14 @@ void call_usermodehelper_setfns(struct subprocess_info *info,
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
@@ -104,7 +101,7 @@ call_usermodehelper_fns(char *path, char **argv, char **envp,
 }
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
 	return call_usermodehelper_fns(path, argv, envp, wait,
 				       NULL, NULL, NULL);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index a0a8854..ad68fc7 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -244,7 +244,7 @@ static void __call_usermodehelper(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	enum umh_wait wait = sub_info->wait;
+	int wait = sub_info->wait;
 	pid_t pid;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
@@ -435,8 +435,7 @@ EXPORT_SYMBOL(call_usermodehelper_setfns);
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


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-usermodehelper-introduce-umh_complete-sub_info.patch"

>From 0ef1c578505d765e1a3fd07c1676027c5b205cfb Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 7 Feb 2012 17:09:07 +0100
Subject: [PATCH 2/5] usermodehelper: introduce umh_complete(sub_info)

Preparation. Add the new trivial helper, umh_complete(). Currently
it simply does complete(sub_info->complete).
---
 kernel/kmod.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index ad68fc7..2443213 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -199,6 +199,11 @@ void call_usermodehelper_freeinfo(struct subprocess_info *info)
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	complete(sub_info->complete);
+}
+
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -235,7 +240,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	complete(sub_info->complete);
+	umh_complete(sub_info);
 	return 0;
 }
 
@@ -269,7 +274,7 @@ static void __call_usermodehelper(struct work_struct *work)
 	case UMH_WAIT_EXEC:
 		if (pid < 0)
 			sub_info->retval = pid;
-		complete(sub_info->complete);
+		umh_complete(sub_info);
 	}
 }
 
-- 
1.5.5.1


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-usermodehelper-implement-UMH_KILLABLE.patch"

>From 4ab2af61fc601b550b4e59dc6fa2bd01375920f0 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 7 Feb 2012 17:40:32 +0100
Subject: [PATCH 3/5] usermodehelper: implement UMH_KILLABLE

Implement UMH_KILLABLE, should be used along with UMH_WAIT_EXEC/PROC.
The caller must ensure that subprocess_info->path/etc can not go away
until call_usermodehelper_freeinfo().

call_usermodehelper_exec(UMH_KILLABLE) does wait_for_completion_killable.
If it fails, it uses xchg(&sub_info->complete, NULL) to serialize with
umh_complete() which does the same xhcg() to access sub_info->complete.

If call_usermodehelper_exec wins, it can safely return. umh_complete()
should get NULL and call call_usermodehelper_freeinfo().

Otherwise we know that umh_complete() was already called, in this case
call_usermodehelper_exec() falls back to wait_for_completion() which
should succeed "very soon".
---
 include/linux/kmod.h |    1 +
 kernel/kmod.c        |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 26187f2..9efeae6 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -51,6 +51,7 @@ struct file;
 #define UMH_NO_WAIT	0	/* don't wait at all */
 #define UMH_WAIT_EXEC	1	/* wait for the exec, but not the process */
 #define UMH_WAIT_PROC	2	/* wait for the process to complete */
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
 
 struct subprocess_info {
 	struct work_struct work;
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2443213..7452b4e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -201,7 +201,12 @@ EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
 static void umh_complete(struct subprocess_info *sub_info)
 {
-	complete(sub_info->complete);
+	struct completion *done = xchg(&sub_info->complete, NULL);
+
+	if (done)
+		complete(done);
+	else	/* see call_usermodehelper_exec(), we own sub_info */
+		call_usermodehelper_freeinfo(sub_info);
 }
 
 /* Keventd can't block, but this (a child) can. */
@@ -455,14 +460,26 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	}
 
 	sub_info->complete = &done;
-	sub_info->wait = wait;
+	sub_info->wait = (wait & ~UMH_KILLABLE);
 
 	queue_work(khelper_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
+
+	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_killable(&done);
+		if (!retval)
+			goto wait_done;
+
+		/* see umh_complete()->call_usermodehelper_freeinfo() */
+		if (xchg(&sub_info->complete, NULL))
+			goto unlock;
+		/* wait for umh_complete()->complete() in progress... */
+	}
+
 	wait_for_completion(&done);
+wait_done:
 	retval = sub_info->retval;
-
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
-- 
1.5.5.1


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0004-kmod-introduce-call_modprobe-helper.patch"

>From 4e2347777f969bc4e8ba960d31fcff34b38ad318 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 7 Feb 2012 18:35:33 +0100
Subject: [PATCH 4/5] kmod: introduce call_modprobe() helper

No functional changes. Move the call_usermodehelper code from
__request_module() into the new simple helper, call_modprobe().
---
 kernel/kmod.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 7452b4e..cc119d1 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -60,6 +60,21 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static int call_modprobe(char *module_name, int wait)
+{
+	static char *envp[] = {
+		"HOME=/",
+		"TERM=linux",
+		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+		NULL
+	};
+
+	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+
+	return call_usermodehelper_fns(modprobe_path, argv, envp,
+					wait, NULL, NULL, NULL);
+}
+
 /**
  * __request_module - try to load a kernel module
  * @wait: wait (or not) for the operation to complete
@@ -81,11 +96,6 @@ int __request_module(bool wait, const char *fmt, ...)
 	char module_name[MODULE_NAME_LEN];
 	unsigned int max_modprobes;
 	int ret;
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
-	static char *envp[] = { "HOME=/",
-				"TERM=linux",
-				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
-				NULL };
 	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
@@ -128,9 +138,7 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
-			NULL, NULL, NULL);
+	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 
 	atomic_dec(&kmod_concurrent);
 	return ret;
-- 
1.5.5.1


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0005-kmod-make-__request_module-killable.patch"

>From cae641ffc528461798fe3698d0d327bb7048f274 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 7 Feb 2012 19:24:49 +0100
Subject: [PATCH 5/5] kmod: make __request_module() killable

Make __request_module() killable. The only necessary change is
that call_modprobe() should kmalloc argv and module_name, they
can't live in the stack if we use UMH_KILLABLE.

This memory is freed via call_usermodehelper_freeinfo()->cleanup.
---
 kernel/kmod.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index cc119d1..8eebec4 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -60,6 +60,12 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static void free_modprobe_argv(struct subprocess_info *info)
+{
+	kfree(info->argv[3]); /* check call_modprobe() */
+	kfree(info->argv);
+}
+
 static int call_modprobe(char *module_name, int wait)
 {
 	static char *envp[] = {
@@ -69,10 +75,26 @@ static int call_modprobe(char *module_name, int wait)
 		NULL
 	};
 
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	if (!argv)
+		goto out;
+
+	module_name = kstrdup(module_name, GFP_KERNEL);
+	if (!module_name)
+		goto free_argv;
+
+	argv[0] = modprobe_path;
+	argv[1] = "-q";
+	argv[2] = "--";
+	argv[3] = module_name;	/* check free_modprobe_argv() */
+	argv[4] = NULL;
 
 	return call_usermodehelper_fns(modprobe_path, argv, envp,
-					wait, NULL, NULL, NULL);
+		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+free_argv:
+	kfree(argv);
+out:
+	return -ENOMEM;
 }
 
 /**
-- 
1.5.5.1


--FL5UXtIhxfXey3p5--

