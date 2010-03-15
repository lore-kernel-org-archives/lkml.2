Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756Ab0COTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936593Ab0COTsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:48:47 -0400
Date: Mon, 15 Mar 2010 20:46:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/6] umh: creds: convert call_usermodehelper_keys() to use
	subprocess_info->init()
Message-ID: <20100315194648.GB10896@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_usermodehelper_keys() uses call_usermodehelper_setkeys() to change
subprocess_info->cred in advance. Now that we have info->init() we can
change this code to set tgcred->session_keyring in context of execing
kernel thread.

Note: since currently call_usermodehelper_keys() is never called with
UMH_NO_WAIT, call_usermodehelper_keys()->key_get() and umh_keys_cleanup()
are not really needed, we could rely on install_session_keyring_to_cred()
which does key_get() on success.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David Howells <dhowells@redhat.com>
---

 include/linux/kmod.h         |   17 -----------------
 kernel/kmod.c                |   18 ------------------
 security/keys/internal.h     |    1 +
 security/keys/process_keys.c |    3 +--
 security/keys/request_key.c  |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 34 insertions(+), 37 deletions(-)

--- 34-rc1/include/linux/kmod.h~1_CONVERT_KEYS	2010-03-15 20:00:42.000000000 +0100
+++ 34-rc1/include/linux/kmod.h	2010-03-15 20:04:34.000000000 +0100
@@ -71,8 +71,6 @@ struct subprocess_info *call_usermodehel
 						  char **envp, gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -111,21 +109,6 @@ call_usermodehelper(char *path, char **a
 				       NULL, NULL, NULL);
 }
 
-static inline int
-call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
-{
-	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
-	if (info == NULL)
-		return -ENOMEM;
-
-	call_usermodehelper_setkeys(info, session_keyring);
-	return call_usermodehelper_exec(info, wait);
-}
-
 extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
--- 34-rc1/kernel/kmod.c~1_CONVERT_KEYS	2010-03-15 20:00:42.000000000 +0100
+++ 34-rc1/kernel/kmod.c	2010-03-15 20:04:34.000000000 +0100
@@ -367,24 +367,6 @@ struct subprocess_info *call_usermodehel
 EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
- * call_usermodehelper_setkeys - set the session keys for usermode helper
- * @info: a subprocess_info returned by call_usermodehelper_setup
- * @session_keyring: the session keyring for the process
- */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring)
-{
-#ifdef CONFIG_KEYS
-	struct thread_group_cred *tgcred = info->cred->tgcred;
-	key_put(tgcred->session_keyring);
-	tgcred->session_keyring = key_get(session_keyring);
-#else
-	BUG();
-#endif
-}
-EXPORT_SYMBOL(call_usermodehelper_setkeys);
-
-/**
  * call_usermodehelper_setfns - set a cleanup/init function
  * @info: a subprocess_info returned by call_usermodehelper_setup
  * @cleanup: a cleanup function
--- 34-rc1/security/keys/internal.h~1_CONVERT_KEYS	2009-09-11 19:07:59.000000000 +0200
+++ 34-rc1/security/keys/internal.h	2010-03-15 20:04:34.000000000 +0100
@@ -115,6 +115,7 @@ extern struct key *find_keyring_by_name(
 extern int install_user_keyrings(void);
 extern int install_thread_keyring_to_cred(struct cred *);
 extern int install_process_keyring_to_cred(struct cred *);
+extern int install_session_keyring_to_cred(struct cred *, struct key *);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
--- 34-rc1/security/keys/process_keys.c~1_CONVERT_KEYS	2009-09-11 19:07:59.000000000 +0200
+++ 34-rc1/security/keys/process_keys.c	2010-03-15 20:04:34.000000000 +0100
@@ -217,8 +217,7 @@ static int install_process_keyring(void)
 /*
  * install a session keyring directly to a credentials struct
  */
-static int install_session_keyring_to_cred(struct cred *cred,
-					   struct key *keyring)
+int install_session_keyring_to_cred(struct cred *cred, struct key *keyring)
 {
 	unsigned long flags;
 	struct key *old;
--- 34-rc1/security/keys/request_key.c~1_CONVERT_KEYS	2009-04-13 17:05:52.000000000 +0200
+++ 34-rc1/security/keys/request_key.c	2010-03-15 20:04:34.000000000 +0100
@@ -58,6 +58,38 @@ void complete_request_key(struct key_con
 }
 EXPORT_SYMBOL(complete_request_key);
 
+static int umh_keys_init(struct subprocess_info *info)
+{
+	struct cred *cred = (struct cred*)current_cred();
+	struct key *keyring = info->data;
+	/*
+	 * This is called in context of freshly forked kthread before
+	 * kernel_execve(), we can just change our ->session_keyring.
+	 */
+	return install_session_keyring_to_cred(cred, keyring);
+}
+
+static void umh_keys_cleanup(struct subprocess_info *info)
+{
+	struct key *keyring = info->data;
+	key_put(keyring);
+}
+
+static int call_usermodehelper_keys(char *path, char **argv, char **envp,
+			 struct key *session_keyring, enum umh_wait wait)
+{
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	struct subprocess_info *info =
+		call_usermodehelper_setup(path, argv, envp, gfp_mask);
+
+	if (!info)
+		return -ENOMEM;
+
+	call_usermodehelper_setfns(info, umh_keys_init, umh_keys_cleanup,
+					key_get(session_keyring));
+	return call_usermodehelper_exec(info, wait);
+}
+
 /*
  * request userspace finish the construction of a key
  * - execute "/sbin/request-key <op> <key> <uid> <gid> <keyring> <keyring> <keyring>"

