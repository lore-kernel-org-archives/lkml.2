Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2DSXRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2DSXRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:17:03 -0400
Date: Fri, 20 Apr 2012 01:16:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/6] keys: kill task_struct->replacement_session_keyring
Message-ID: <20120419231616.GF15828@redhat.com>
References: <20120419231431.GA15820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419231431.GA15820@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the no longer used task_struct->replacement_session_keyring,
update copy_creds() and exit_creds().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    2 --
 kernel/cred.c         |    9 ---------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e36edfb..ac04a02 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1402,8 +1402,6 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
-
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
diff --git a/kernel/cred.c b/kernel/cred.c
index e70683d..9570736 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -198,13 +198,6 @@ void exit_creds(struct task_struct *tsk)
 	validate_creds(cred);
 	alter_cred_subscribers(cred, -1);
 	put_cred(cred);
-
-	cred = (struct cred *) tsk->replacement_session_keyring;
-	if (cred) {
-		tsk->replacement_session_keyring = NULL;
-		validate_creds(cred);
-		put_cred(cred);
-	}
 }
 
 /**
@@ -386,8 +379,6 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	struct cred *new;
 	int ret;
 
-	p->replacement_session_keyring = NULL;
-
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
-- 
1.5.5.1


