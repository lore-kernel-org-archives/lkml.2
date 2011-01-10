Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1AJVMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:12:19 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:34287
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754793Ab1AJVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:12:16 -0500
Date: Mon, 10 Jan 2011 21:13:34 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110110211334.GD22564@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110211135.GA22446@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
	Dec 8: Fixed bug in my check_kill_permission pointed out by
	       Eric Biederman.
	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
	        for clarity
	Dec 31: address comment by Eric Biederman:
		don't need cred/tcred in check_kill_permission.
	Jan 1: use const cred struct.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..6a12eae 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -636,13 +636,39 @@ static inline bool si_fromuser(const struct siginfo *info)
 }
 
 /*
+ * called with RCU read lock from check_kill_permission()
+ */
+static inline int kill_ok_by_cred(struct task_struct *t)
+{
+	const struct cred *cred = current_cred();
+	const struct cred *tcred = __task_cred(t);
+
+	if (cred->user->user_ns != tcred->user->user_ns) {
+		/* userids are not equivalent - either you have the
+		   capability to the target user ns or you don't */
+		if (ns_capable(tcred->user->user_ns, CAP_KILL))
+			return 1;
+		return 0;
+	}
+
+	/* same user namespace - usual credentials checks apply */
+	if ((cred->euid ^ tcred->suid) &&
+	    (cred->euid ^ tcred->uid) &&
+	    (cred->uid  ^ tcred->suid) &&
+	    (cred->uid  ^ tcred->uid) &&
+	    !ns_capable(tcred->user->user_ns, CAP_KILL))
+		return 0;
+
+	return 1;
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
 
@@ -656,14 +682,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
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

