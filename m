Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab1FWSRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:17:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:34400 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab1FWRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 098/247] CRED: Fix BUG() upon security_cred_alloc_blank() failure
Date: Thu, 23 Jun 2011 13:32:46 -0400
Message-Id: <1308850515-15242-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2edeaa34a6e3f2c43b667f6c4f7b27944b811695 upstream.

In cred_alloc_blank() since 2.6.32, abort_creds(new) is called with
new->security == NULL and new->magic == 0 when security_cred_alloc_blank()
returns an error.  As a result, BUG() will be triggered if SELinux is enabled
or CONFIG_DEBUG_CREDENTIALS=y.

If CONFIG_DEBUG_CREDENTIALS=y, BUG() is called from __invalid_creds() because
cred->magic == 0.  Failing that, BUG() is called from selinux_cred_free()
because selinux_cred_free() is not expecting cred->security == NULL.  This does
not affect smack_cred_free(), tomoyo_cred_free() or apparmor_cred_free().

Fix these bugs by

(1) Set new->magic before calling security_cred_alloc_blank().

(2) Handle null cred->security in creds_are_invalid() and selinux_cred_free().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/cred.c            |   12 ++++++++----
 security/selinux/hooks.c |    6 +++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 791c431..9a85aee 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -256,13 +256,13 @@ struct cred *cred_alloc_blank(void)
 #endif
 
 	atomic_set(&new->usage, 1);
+#ifdef CONFIG_DEBUG_CREDENTIALS
+	new->magic = CRED_MAGIC;
+#endif
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
 		goto error;
 
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	new->magic = CRED_MAGIC;
-#endif
 	return new;
 
 error:
@@ -816,7 +816,11 @@ bool creds_are_invalid(const struct cred *cred)
 	if (cred->magic != CRED_MAGIC)
 		return true;
 #ifdef CONFIG_SECURITY_SELINUX
-	if (selinux_is_enabled()) {
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	if (selinux_is_enabled() && cred->security) {
 		if ((unsigned long) cred->security < PAGE_SIZE)
 			return true;
 		if ((*(u32 *)cred->security & 0xffffff00) ==
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0b459c8..c59c83f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3256,7 +3256,11 @@ static void selinux_cred_free(struct cred *cred)
 {
 	struct task_security_struct *tsec = cred->security;
 
-	BUG_ON((unsigned long) cred->security < PAGE_SIZE);
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
 	cred->security = (void *) 0x7UL;
 	kfree(tsec);
 }
-- 
1.7.4.4

