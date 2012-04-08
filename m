Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2DHFVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:21:09 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56911 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609Ab2DHFMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:19 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:03 -0700
Message-Id: <1333862139-31737-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX190gwjdoOA0P/Gjsb8cJu+CgZmYkoeWln0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1529]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 07/43] cred: Refcount the user_ns pointed to by the cred.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

struct user_struct will shortly loose it's user_ns reference
so make the cred user_ns reference a proper reference complete
with reference counting.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/cred.h         |    2 +-
 kernel/cred.c                |    8 +++-----
 kernel/user_namespace.c      |    8 +++++---
 security/keys/process_keys.c |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index d12c4e4..2c60ec8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -146,7 +146,7 @@ struct cred {
 	void		*security;	/* subjective LSM security */
 #endif
 	struct user_struct *user;	/* real user ID subscription */
-	struct user_namespace *user_ns; /* cached user->user_ns */
+	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	struct rcu_head	rcu;		/* RCU deletion hook */
 };
diff --git a/kernel/cred.c b/kernel/cred.c
index 97b36ee..7a0d806 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -148,6 +148,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
+	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
 
@@ -303,6 +304,7 @@ struct cred *prepare_creds(void)
 	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
 	get_uid(new->user);
+	get_user_ns(new->user_ns);
 
 #ifdef CONFIG_KEYS
 	key_get(new->thread_keyring);
@@ -412,11 +414,6 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 			goto error_put;
 	}
 
-	/* cache user_ns in cred.  Doesn't need a refcount because it will
-	 * stay pinned by cred->user
-	 */
-	new->user_ns = new->user->user_ns;
-
 #ifdef CONFIG_KEYS
 	/* new threads get their own thread keyrings if their parent already
 	 * had one */
@@ -676,6 +673,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	atomic_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_uid(new->user);
+	get_user_ns(new->user_ns);
 	get_group_info(new->group_info);
 
 #ifdef CONFIG_KEYS
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index f084083..58bb878 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,7 +24,7 @@ static struct kmem_cache *user_ns_cachep __read_mostly;
  */
 int create_user_ns(struct cred *new)
 {
-	struct user_namespace *ns;
+	struct user_namespace *ns, *parent_ns = new->user_ns;
 	struct user_struct *root_user;
 	int n;
 
@@ -57,8 +57,10 @@ int create_user_ns(struct cred *new)
 #endif
 	/* tgcred will be cleared in our caller bc CLONE_THREAD won't be set */
 
-	/* root_user holds a reference to ns, our reference can be dropped */
-	put_user_ns(ns);
+	/* Leave the reference to our user_ns with the new cred */
+	new->user_ns = ns;
+
+	put_user_ns(parent_ns);
 
 	return 0;
 }
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 70febff..447fb76 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -858,7 +858,7 @@ void key_replace_session_keyring(void)
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
-	new->user_ns	= new->user_ns;
+	new->user_ns	= get_user_ns(new->user_ns);
 	new->group_info	= get_group_info(old->group_info);
 
 	new->securebits	= old->securebits;
-- 
1.7.2.5

