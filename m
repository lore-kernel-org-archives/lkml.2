Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2DHFMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:12:49 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56954 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840Ab2DHFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:25 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:16 -0700
Message-Id: <1333862139-31737-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18w+dcfzZezuYAkWDBZY5VleWtk7twaNWw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 20/43] userns: Replace user_ns_map_uid and user_ns_map_gid with from_kuid and from_kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

These function are no longer needed replace them with their more useful equivalents.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/user_namespace.h |   12 ------------
 ipc/mqueue.c                   |    3 +--
 kernel/signal.c                |    2 +-
 net/core/sock.c                |    4 ++--
 4 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a2c6145..4e72922 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -69,16 +69,4 @@ static inline void put_user_ns(struct user_namespace *ns)
 
 #endif
 
-static inline uid_t user_ns_map_uid(struct user_namespace *to,
-	const struct cred *cred, kuid_t uid)
-{
-	return from_kuid_munged(to, uid);
-}
-
-static inline gid_t user_ns_map_gid(struct user_namespace *to,
-	const struct cred *cred, kgid_t gid)
-{
-	return from_kgid_munged(to, gid);
-}
-
 #endif /* _LINUX_USER_H */
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index b53cf34..b6a0d46 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -538,8 +538,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			rcu_read_lock();
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = user_ns_map_uid(info->notify_user_ns,
-						current_cred(), current_uid());
+			sig_i.si_uid = from_kuid_munged(info->notify_user_ns, current_uid());
 			rcu_read_unlock();
 
 			kill_pid_info(info->notify.sigev_signo,
diff --git a/kernel/signal.c b/kernel/signal.c
index 2734dc9..d630327 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1026,7 +1026,7 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 static inline uid_t map_cred_ns(const struct cred *cred,
 				struct user_namespace *ns)
 {
-	return user_ns_map_uid(ns, cred, cred->uid);
+	return from_kuid_munged(ns, cred->uid);
 }
 
 #ifdef CONFIG_USER_NS
diff --git a/net/core/sock.c b/net/core/sock.c
index b2e14c0..e1ec8ba 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -821,8 +821,8 @@ void cred_to_ucred(struct pid *pid, const struct cred *cred,
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = user_ns_map_uid(current_ns, cred, cred->euid);
-		ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
+		ucred->uid = from_kuid(current_ns, cred->euid);
+		ucred->gid = from_kgid(current_ns, cred->egid);
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
-- 
1.7.2.5

