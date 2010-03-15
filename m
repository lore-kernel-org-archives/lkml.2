Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936660Ab0COTu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936612Ab0COTuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:50:23 -0400
Date: Mon, 15 Mar 2010 20:48:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 4/6] wait_for_helper: SIGCHLD from user-space can lead to
	use-after-free
Message-ID: <20100315194824.GE10896@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. wait_for_helper() calls allow_signal(SIGCHLD) to ensure the child
   can't autoreap itself.

   However, this means that a spurious SIGCHILD from user-space can
   set TIF_SIGPENDING and:

   	- kernel_thread() or sys_wait4() can fail due to signal_pending()

   	- worse, wait4() can fail before ____call_usermodehelper() execs
   	  or exits. In this case the caller may kfree(subprocess_info)
   	  while the child still uses this memory.

   Change the code to use SIG_DFL instead of magic "(void __user *)2"
   set by allow_signal(). This means that SIGCHLD won't be delivered,
   yet the child won't autoreap itsefl.

   The problem is minor, only root can send a signal to this kthread.

2. If sys_wait4(&ret) fails it doesn't populate "ret", in this case
   wait_for_helper() reports a random value from uninitialized var.

   With this patch sys_wait4() should never fail, but still it makes
   sense to initialize ret = -ECHILD so that the caller can notice
   the problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---

 kernel/kmod.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- 34-rc1/kernel/kmod.c~4_SIGCHLD_RACE	2010-03-15 20:17:47.000000000 +0100
+++ 34-rc1/kernel/kmod.c	2010-03-15 20:28:31.000000000 +0100
@@ -175,16 +175,16 @@ static int wait_for_helper(void *data)
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
-	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
-	 * populate the status, but will return -ECHILD. */
-	allow_signal(SIGCHLD);
+	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
+	spin_lock_irq(&current->sighand->siglock);
+	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
+	spin_unlock_irq(&current->sighand->siglock);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
 	} else {
-		int ret;
-
+		int ret = -ECHILD;
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.

