Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2DHFMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:12:52 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44058 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535Ab2DHFMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:24 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:20 -0700
Message-Id: <1333862139-31737-24-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18vu75OCTIrWZipatStfVNhFqWAwadoNec=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 24/43] userns: Convert ptrace, kill, set_priority permission checks to work with kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Update the permission checks to use the new uid_eq and gid_eq helpers
and remove the now unnecessary user_ns equality comparison.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/ptrace.c |   13 ++++++-------
 kernel/signal.c |   15 ++++++---------
 kernel/sys.c    |   18 ++++++++----------
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 24e0a5a..a232bb5 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -198,13 +198,12 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		return 0;
 	rcu_read_lock();
 	tcred = __task_cred(task);
-	if (cred->user_ns == tcred->user_ns &&
-	    (cred->uid == tcred->euid &&
-	     cred->uid == tcred->suid &&
-	     cred->uid == tcred->uid  &&
-	     cred->gid == tcred->egid &&
-	     cred->gid == tcred->sgid &&
-	     cred->gid == tcred->gid))
+	if (uid_eq(cred->uid, tcred->euid) &&
+	    uid_eq(cred->uid, tcred->suid) &&
+	    uid_eq(cred->uid, tcred->uid)  &&
+	    gid_eq(cred->gid, tcred->egid) &&
+	    gid_eq(cred->gid, tcred->sgid) &&
+	    gid_eq(cred->gid, tcred->gid))
 		goto ok;
 	if (ptrace_has_cap(tcred->user_ns, mode))
 		goto ok;
diff --git a/kernel/signal.c b/kernel/signal.c
index d630327..9797939 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -767,11 +767,10 @@ static int kill_ok_by_cred(struct task_struct *t)
 	const struct cred *cred = current_cred();
 	const struct cred *tcred = __task_cred(t);
 
-	if (cred->user_ns == tcred->user_ns &&
-	    (cred->euid == tcred->suid ||
-	     cred->euid == tcred->uid ||
-	     cred->uid  == tcred->suid ||
-	     cred->uid  == tcred->uid))
+	if (uid_eq(cred->euid, tcred->suid) ||
+	    uid_eq(cred->euid, tcred->uid)  ||
+	    uid_eq(cred->uid,  tcred->suid) ||
+	    uid_eq(cred->uid,  tcred->uid))
 		return 1;
 
 	if (ns_capable(tcred->user_ns, CAP_KILL))
@@ -1389,10 +1388,8 @@ static int kill_as_cred_perm(const struct cred *cred,
 			     struct task_struct *target)
 {
 	const struct cred *pcred = __task_cred(target);
-	if (cred->user_ns != pcred->user_ns)
-		return 0;
-	if (cred->euid != pcred->suid && cred->euid != pcred->uid &&
-	    cred->uid  != pcred->suid && cred->uid  != pcred->uid)
+	if (uid_eq(cred->euid, pcred->suid) && uid_eq(cred->euid, pcred->uid) &&
+	    uid_eq(cred->uid,  pcred->suid) && uid_eq(cred->uid,  pcred->uid))
 		return 0;
 	return 1;
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index aff09f2..f484077 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -131,9 +131,8 @@ static bool set_one_prio_perm(struct task_struct *p)
 {
 	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
 
-	if (pcred->user_ns == cred->user_ns &&
-	    (pcred->uid  == cred->euid ||
-	     pcred->euid == cred->euid))
+	if (uid_eq(pcred->uid,  cred->euid) ||
+	    uid_eq(pcred->euid, cred->euid))
 		return true;
 	if (ns_capable(pcred->user_ns, CAP_SYS_NICE))
 		return true;
@@ -1582,13 +1581,12 @@ static int check_prlimit_permission(struct task_struct *task)
 		return 0;
 
 	tcred = __task_cred(task);
-	if (cred->user_ns == tcred->user_ns &&
-	    (cred->uid == tcred->euid &&
-	     cred->uid == tcred->suid &&
-	     cred->uid == tcred->uid &&
-	     cred->gid == tcred->egid &&
-	     cred->gid == tcred->sgid &&
-		    cred->gid == tcred->gid))
+	if (uid_eq(cred->uid, tcred->euid) &&
+	    uid_eq(cred->uid, tcred->suid) &&
+	    uid_eq(cred->uid, tcred->uid)  &&
+	    gid_eq(cred->gid, tcred->egid) &&
+	    gid_eq(cred->gid, tcred->sgid) &&
+	    gid_eq(cred->gid, tcred->gid))
 		return 0;
 	if (ns_capable(tcred->user_ns, CAP_SYS_RESOURCE))
 		return 0;
-- 
1.7.2.5

