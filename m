Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1BGX47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:56:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab1BGX45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:56:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110207133610.18389.5602.stgit@warthog.procyon.org.uk>
References: <20110207133610.18389.5602.stgit@warthog.procyon.org.uk>
To: stable@kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 1/2] CRED: Fix BUG() upon security_cred_alloc_blank() failure
Date: Mon, 07 Feb 2011 23:56:32 +0000
Message-ID: <13689.1297122992@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

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
---

 kernel/cred.c            |   12 ++++++++----
 security/selinux/hooks.c |    6 +++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 6a1aa00..fcf104b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -252,13 +252,13 @@ struct cred *cred_alloc_blank(void)
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
@@ -748,7 +748,11 @@ bool creds_are_invalid(const struct cred *cred)
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
index e276eb4..c8d6992 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3198,7 +3198,11 @@ static void selinux_cred_free(struct cred *cred)
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

