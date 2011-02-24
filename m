Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1BXPCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:02:24 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:40138
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756252Ab1BXPCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:02:21 -0500
Date: Thu, 24 Feb 2011 15:02:36 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, dhowells@redhat.com,
        oleg@mail.hallyn.com, dlezcano@mail.hallyn.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: [PATCH 04/10] allow killing tasks in your own or child userns
Message-ID: <20110224150236.GD8262@mail.hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224150150.GA8262@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog:
	Dec  8: Fixed bug in my check_kill_permission pointed out by
	        Eric Biederman.
	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
	        for clarity
	Dec 31: address comment by Eric Biederman:
		don't need cred/tcred in check_kill_permission.
	Jan  1: use const cred struct.
	Jan 11: Per Bastian Blank's advice, clean up kill_ok_by_cred().
	Feb 16: kill_ok_by_cred: fix bad parentheses
	Feb 23: per akpm, let compiler inline kill_ok_by_cred

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 kernel/signal.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..12702b4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -636,13 +636,33 @@ static inline bool si_fromuser(const struct siginfo *info)
 }
 
 /*
+ * called with RCU read lock from check_kill_permission()
+ */
+static int kill_ok_by_cred(struct task_struct *t)
+{
+	const struct cred *cred = current_cred();
+	const struct cred *tcred = __task_cred(t);
+
+	if (cred->user->user_ns == tcred->user->user_ns &&
+	    (cred->euid == tcred->suid ||
+	     cred->euid == tcred->uid ||
+	     cred->uid  == tcred->suid ||
+	     cred->uid  == tcred->uid))
+		return 1;
+
+	if (ns_capable(tcred->user->user_ns, CAP_KILL))
+		return 1;
+
+	return 0;
+}
+
+/*
  * Bad permissions for sending the signal
  * - the caller must hold the RCU read lock
  */
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	const struct cred *cred, *tcred;
 	struct pid *sid;
 	int error;
 
@@ -656,14 +676,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	if (error)
 		return error;
 
-	cred = current_cred();
-	tcred = __task_cred(t);
 	if (!same_thread_group(current, t) &&
-	    (cred->euid ^ tcred->suid) &&
-	    (cred->euid ^ tcred->uid) &&
-	    (cred->uid  ^ tcred->suid) &&
-	    (cred->uid  ^ tcred->uid) &&
-	    !capable(CAP_KILL)) {
+	    !kill_ok_by_cred(t)) {
 		switch (sig) {
 		case SIGCONT:
 			sid = task_session(t);
-- 
1.7.0.4

