Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2DHFNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51542 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2DHFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:27 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:28 -0700
Message-Id: <1333862139-31737-32-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19TsXd+uqMjvVHIPNUKMP2n2H92yZ5yg98=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_FRT_SLUT BODY: ReplaceTags: Slut
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0427]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 32/43] userns: signal remove unnecessary map_cred_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

map_cred_ns is a light wrapper around from_kuid with the order of the arguments
reversed.  Replace map_cred_ns with from_kuid and remove map_cred_ns.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/signal.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 9797939..6aca310 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1019,15 +1019,6 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-/*
- * map the uid in struct cred into user namespace *ns
- */
-static inline uid_t map_cred_ns(const struct cred *cred,
-				struct user_namespace *ns)
-{
-	return from_kuid_munged(ns, cred->uid);
-}
-
 #ifdef CONFIG_USER_NS
 static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
 {
@@ -1677,8 +1668,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = map_cred_ns(__task_cred(tsk),
-			task_cred_xxx(tsk->parent, user_ns));
+	info.si_uid = from_kuid_munged(task_cred_xxx(tsk->parent, user_ns),
+				       task_uid(tsk));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
@@ -1761,8 +1752,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = map_cred_ns(__task_cred(tsk),
-			task_cred_xxx(parent, user_ns));
+	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2180,8 +2170,8 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_code = SI_USER;
 		rcu_read_lock();
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = map_cred_ns(__task_cred(current->parent),
-				current_user_ns());
+		info->si_uid = from_kuid_munged(current_user_ns(),
+						task_uid(current->parent));
 		rcu_read_unlock();
 	}
 
-- 
1.7.2.5

