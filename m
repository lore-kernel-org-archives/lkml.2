Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2A3QSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:18:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab2A3QSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:18:39 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 2/4] Fix apparmor for PR_{GET,SET}_NO_NEW_PRIVS
Date: Mon, 30 Jan 2012 08:17:27 -0800
Message-Id: <fb49711a1ec532c2f2bc7a5f4c1f70df60e27973.1327858005.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 security/apparmor/domain.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index fcfb610..7316d77 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -360,10 +360,6 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	/* XXX: no_new_privs is not usable with AppArmor yet */
-	if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
-		return -EPERM;
-
 	cxt = bprm->cred->security;
 	BUG_ON(!cxt);
 
@@ -399,6 +395,11 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 			new_profile = find_attach(ns, &ns->base.profiles, name);
 		if (!new_profile)
 			goto cleanup;
+		/*
+		 * NOTE: Domain transitions from unconfined are allowed
+		 * even when no_new_privs is set because this aways results
+		 * in a further reduction of permissions.
+		 */
 		goto apply;
 	}
 
@@ -459,6 +460,16 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 		/* fail exec */
 		error = -EACCES;
 
+	/*
+	 * Policy has specified a domain transition, if no_new_privs then
+	 * fail the exec.
+	 */
+	if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS) {
+		aa_put_profile(new_profile);
+		error = -EPERM;
+		goto cleanup;
+	}
+
 	if (!new_profile)
 		goto audit;
 
@@ -613,6 +624,14 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 	const char *target = NULL, *info = NULL;
 	int error = 0;
 
+	/*
+	 * Fail explicitly requested domain transitions if no_new_privs.
+	 * There is no exception for unconfined as change_hat is not
+	 * available.
+	 */
+	if (current->no_new_privs)
+		return -EPERM;
+
 	/* released below */
 	cred = get_current_cred();
 	cxt = cred->security;
@@ -754,6 +773,18 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 	cxt = cred->security;
 	profile = aa_cred_profile(cred);
 
+	/*
+	 * Fail explicitly requested domain transitions if no_new_privs
+	 * and not unconfined.
+	 * Domain transitions from unconfined are allowed even when
+	 * no_new_privs is set because this aways results in a reduction
+	 * of permissions.
+	 */
+	if (current->no_new_privs && !unconfined(profile)) {
+		put_cred(cred);
+		return -EPERM;
+	}
+
 	if (ns_name) {
 		/* released below */
 		ns = aa_find_namespace(profile->ns, ns_name);
-- 
1.7.7.6

