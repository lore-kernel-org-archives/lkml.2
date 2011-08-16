Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1HPTrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1HPTrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:47:45 -0400
Date: Tue, 16 Aug 2011 21:44:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
Message-ID: <20110816194450.GB6602@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-42-git-send-email-matt@console-pimps.org> <20110816180644.GJ29190@redhat.com> <20110816194427.GA6602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816194427.GA6602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow_signal(sig) unblocks the signal. This was only needed because
we had the daemonize()'ed kthreads playing with signals. And daemonize()
can't use ignore_signals() but does sigprocmask(SIG_BLOCK) because it
was used after kernel_thread(CLONE_SIGHAND).

Nobody does this any longer, we can remove this hack. And hopefully
we can deprecate daemonize() soon, all current users do not actually
need it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- 3.1/kernel/exit.c~4_allow_signal_dont_unblock	2011-08-16 20:14:20.000000000 +0200
+++ 3.1/kernel/exit.c	2011-08-16 21:20:11.000000000 +0200
@@ -365,7 +365,8 @@ static void set_special_pids(struct pid 
 
 /*
  * Let kernel threads use this to say that they allow a certain signal.
- * Must not be used if kthread was cloned with CLONE_SIGHAND.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND or daemonize()
+ * was called.
  */
 int allow_signal(int sig)
 {
@@ -373,8 +374,6 @@ int allow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
-	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
 	/*
 	 * Kernel threads handle their own signals. Let the signal code
 	 * know it'll be handled, so that they don't get converted to

