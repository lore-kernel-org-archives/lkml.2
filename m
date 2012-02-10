Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab2BJUHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066Ab2BJUHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:07:10 -0500
Date: Fri, 10 Feb 2012 21:00:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] signal: cosmetic, s/from_ancestor_ns/force/ in
	prepare_signal() paths
Message-ID: <20120210200037.GB20898@redhat.com>
References: <20120210200004.GA20890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210200004.GA20890@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, rename the from_ancestor_ns argument in prepare_signal()
paths. After the previous change it doesn't match the reality.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bfb2b97..541905b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -58,21 +58,20 @@ static int sig_handler_ignored(void __user *handler, int sig)
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_task_ignored(struct task_struct *t, int sig,
-		int from_ancestor_ns)
+static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 {
 	void __user *handler;
 
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL && !from_ancestor_ns)
+			handler == SIG_DFL && !force)
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
 }
 
-static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
+static int sig_ignored(struct task_struct *t, int sig, bool force)
 {
 	/*
 	 * Blocked signals are never ignored, since the
@@ -82,7 +81,7 @@ static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig, from_ancestor_ns))
+	if (!sig_task_ignored(t, sig, force))
 		return 0;
 
 	/*
@@ -855,7 +854,7 @@ static void ptrace_trap_notify(struct task_struct *t)
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
+static int prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -915,7 +914,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		}
 	}
 
-	return !sig_ignored(p, sig, from_ancestor_ns);
+	return !sig_ignored(p, sig, force);
 }
 
 /*
@@ -1595,7 +1594,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
-	if (!prepare_signal(sig, t, 0))
+	if (!prepare_signal(sig, t, false))
 		goto out;
 
 	ret = 0;
-- 
1.5.5.1


