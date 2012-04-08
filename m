Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2DHFVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:21:03 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56923 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507Ab2DHFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:20 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:04 -0700
Message-Id: <1333862139-31737-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19U8ttklWphs6RxMrzdQjb9ukXQN2+iayg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0058]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 08/43] userns: Add an explicit reference to the parent user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

I am about to remove the struct user_namespace reference from struct user_struct.
So keep an explicit track of the parent user namespace.

Take advantage of this new reference and replace instances of user_ns->creator->user_ns
with user_ns->parent.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/user_namespace.h |    1 +
 kernel/user_namespace.c        |   13 ++++++-------
 security/commoncap.c           |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index faf4679..dc2d85a 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -12,6 +12,7 @@
 struct user_namespace {
 	struct kref		kref;
 	struct hlist_head	uidhash_table[UIDHASH_SZ];
+	struct user_namespace	*parent;
 	struct user_struct	*creator;
 	struct work_struct	destroyer;
 };
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 58bb878..c15e533 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -45,6 +45,7 @@ int create_user_ns(struct cred *new)
 	}
 
 	/* set the new root user in the credentials under preparation */
+	ns->parent = parent_ns;
 	ns->creator = new->user;
 	new->user = root_user;
 	new->uid = new->euid = new->suid = new->fsuid = 0;
@@ -60,8 +61,6 @@ int create_user_ns(struct cred *new)
 	/* Leave the reference to our user_ns with the new cred */
 	new->user_ns = ns;
 
-	put_user_ns(parent_ns);
-
 	return 0;
 }
 
@@ -72,10 +71,12 @@ int create_user_ns(struct cred *new)
  */
 static void free_user_ns_work(struct work_struct *work)
 {
-	struct user_namespace *ns =
+	struct user_namespace *parent, *ns =
 		container_of(work, struct user_namespace, destroyer);
+	parent = ns->parent;
 	free_uid(ns->creator);
 	kmem_cache_free(user_ns_cachep, ns);
+	put_user_ns(parent);
 }
 
 void free_user_ns(struct kref *kref)
@@ -99,8 +100,7 @@ uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
+	for ( tmp = to; tmp != &init_user_ns; tmp = tmp->parent ) {
 		if (cred->user == tmp->creator) {
 			return (uid_t)0;
 		}
@@ -120,8 +120,7 @@ gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
+	for ( tmp = to; tmp != &init_user_ns; tmp = tmp->parent ) {
 		if (cred->user == tmp->creator) {
 			return (gid_t)0;
 		}
diff --git a/security/commoncap.c b/security/commoncap.c
index 8b3e10e..435d074 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -92,7 +92,7 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 		 *If you have a capability in a parent user ns, then you have
 		 * it over all children user namespaces as well.
 		 */
-		targ_ns = targ_ns->creator->user_ns;
+		targ_ns = targ_ns->parent;
 	}
 
 	/* We never get here */
-- 
1.7.2.5

