Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0LIRco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:32:44 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:57745
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754332Ab0LIRcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:32:43 -0500
Date: Thu, 9 Dec 2010 17:32:45 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: LSM <linux-security-module@vger.kernel.org>
Cc: containers@lists.linux-foundation.org, Kees Cook <kees.cook@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 4/4] allow killing tasks in your own or child userns
Message-ID: <20101209173245.GB10206@mail.hallyn.com>
References: <20101209172027.GA10085@mail.hallyn.com>
 <20101209172843.GA10155@mail.hallyn.com>
 <20101209173050.GA10206@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209173050.GA10206@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
	Dec 8: Fixed bug in my check_kill_permission pointed out by
	       Eric Biederman.

To test:
	1. Test killing tasks as usual.  No change.
	2. Clone a new user namespace without a new pidns.
	   a. You CAN kill -CONT tasks in your thread group but outside
	      your user ns.
	   b. You can NOT otherwise kill tasks outside your user_ns.
	   c. Inside your new userns, signal semantics are as normal
	      with respect to userids, CAP_KILL, and thread groups.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 kernel/signal.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..677025c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -635,6 +635,27 @@ static inline bool si_fromuser(const struct siginfo *info)
 		(!is_si_special(info) && SI_FROMUSER(info));
 }
 
+static inline int kill_ok_by_cred(struct cred *cred, struct cred *tcred)
+{
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
 /*
  * Bad permissions for sending the signal
  * - the caller must hold the RCU read lock
@@ -659,11 +680,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	cred = current_cred();
 	tcred = __task_cred(t);
 	if (!same_thread_group(current, t) &&
-	    (cred->euid ^ tcred->suid) &&
-	    (cred->euid ^ tcred->uid) &&
-	    (cred->uid  ^ tcred->suid) &&
-	    (cred->uid  ^ tcred->uid) &&
-	    !capable(CAP_KILL)) {
+	    !kill_ok_by_cred(cred, tcred)) {
 		switch (sig) {
 		case SIGCONT:
 			sid = task_session(t);
-- 
1.7.2.3

