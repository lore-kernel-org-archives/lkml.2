Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2DHFV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:21:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51474 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2DHFMT (ORCPT
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
Date: Sat,  7 Apr 2012 22:15:06 -0700
Message-Id: <1333862139-31737-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196khP2o8WimZWXOLyEz2X+uMXYI6+lfmI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 10/43] userns: Deprecate and rename the user_namespace reference in the user_struct
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With a user_ns reference in struct cred the only user of the user namespace
reference in struct user_struct is to keep the uid hash table alive.

The user_namespace reference in struct user_struct will be going away soon, and
I have removed all of the references.  Rename the field from user_ns to _user_ns
so that the compiler can verify nothing follows the user struct to the user
namespace anymore.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sched.h |    2 +-
 kernel/user.c         |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 720ce8d..6867ae9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -729,7 +729,7 @@ struct user_struct {
 	/* Hash table maintenance information */
 	struct hlist_node uidhash_node;
 	uid_t uid;
-	struct user_namespace *user_ns;
+	struct user_namespace *_user_ns; /* Don't use will be removed soon */
 
 #ifdef CONFIG_PERF_EVENTS
 	atomic_long_t locked_vm;
diff --git a/kernel/user.c b/kernel/user.c
index 71dd236..d65fec0 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -58,7 +58,7 @@ struct user_struct root_user = {
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
-	.user_ns	= &init_user_ns,
+	._user_ns	= &init_user_ns,
 };
 
 /*
@@ -72,7 +72,7 @@ static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
-	put_user_ns(up->user_ns);
+	put_user_ns(up->_user_ns); /* It is safe to free the uid hash table now */
 }
 
 static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
@@ -153,7 +153,7 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 
-		new->user_ns = get_user_ns(ns);
+		new->_user_ns = get_user_ns(ns);
 
 		/*
 		 * Before adding this, check whether we raced
-- 
1.7.2.5

