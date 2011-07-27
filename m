Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1G0Qhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:37:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab1G0Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:37:30 -0400
Date: Wed, 27 Jul 2011 18:34:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] vfork: do not block SIG_DFL/SIG_IGN signals is
	single-threaded
Message-ID: <20110727163427.GH23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfork() blocks all signals except SIGKILL and SIGSTOP. This means
it doesn't react to ^Z or other fatal signals.

We can unblock all signals which doesn't have a handler and solve
this. Unfortunately, without the really ugly hacks we can not do
this in the multithreaded case, we can not trust sighand->action[]
otherwise.

Let's do this in the single-threaded case at least. Anyway, I do
not think that vfork() from the multithreaded application is sane.
And even in this case other threads can handle the blocked signals
unless they exit after clone_vfork_prepare().

Note: "sighand->count == 1" doesn't handle the dead-leader case,
this is easy to fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- 3.1/kernel/fork.c~8_more_signals	2011-07-27 17:48:53.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-27 17:51:54.000000000 +0200
@@ -1506,10 +1506,26 @@ static long clone_vfork_restart(struct r
 
 static void clone_vfork_prepare(void)
 {
+	struct sighand_struct *sigh = current->sighand;
 	sigset_t vfork_mask;
 
-	current->saved_sigmask = current->blocked;
 	siginitsetinv(&vfork_mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+	if (atomic_read(&sigh->count) == 1) {
+		__sighandler_t h;
+		int signr;
+		/*
+		 * Nobody can play with ->action[], we can unblock all
+		 * signals which do not have a handler, they can not
+		 * trigger return-to-user-mode.
+		 */
+		for (signr = 1; signr <= _NSIG; ++signr) {
+			h = sigh->action[signr-1].sa.sa_handler;
+			if (h == SIG_DFL || h == SIG_IGN)
+				sigdelset(&vfork_mask, signr);
+		}
+	}
+
+	current->saved_sigmask = current->blocked;
 	set_current_blocked(&vfork_mask);
 }
 

