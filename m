Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0LQP0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:26:40 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:47048
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751700Ab0LQP0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:26:39 -0500
Date: Fri, 17 Dec 2010 15:26:59 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: [RFC 4/5] user namespaces: allow killing tasks in your own or
 child userns
Message-ID: <20101217152659.GD11162@mail.hallyn.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217152547.GB11162@mail.hallyn.com>
 <20101217152625.GC11162@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217152625.GC11162@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
	Dec 8: Fixed bug in my check_kill_permission pointed out by
	       Eric Biederman.
	Dec 13: Apply Eric's suggestion to pass target task into kill_ok_by_cred()
	        for clarity

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 kernel/signal.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..499bd36 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -636,6 +636,33 @@ static inline bool si_fromuser(const struct siginfo *info)
 }
 
 /*
+ * called with RCU read lock from check_kill_permission()
+ */
+static inline int kill_ok_by_cred(struct task_struct *t)
+{
+	struct cred *cred = current_cred();
+	struct cred *tcred = __task_cred(t);
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
@@ -659,11 +686,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	cred = current_cred();
 	tcred = __task_cred(t);
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

