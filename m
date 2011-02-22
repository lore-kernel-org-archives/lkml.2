Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1BVWct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:32:49 -0500
Received: from kroah.org ([198.145.64.141]:46694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1BVWVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.669765656@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>
Subject: [26/70] CRED: Fix BUG() upon security_cred_alloc_blank() failure
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cred.c            |   12 ++++++++----
 security/selinux/hooks.c |    6 +++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

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
@@ -748,7 +748,11 @@ bool creds_are_invalid(const struct cred
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
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3198,7 +3198,11 @@ static void selinux_cred_free(struct cre
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


