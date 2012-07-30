Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2G3Q64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:58:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54824 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab2G3Q6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:58:54 -0400
Date: Mon, 30 Jul 2012 09:58:49 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] Yama: access current->comm directly
Message-ID: <20120730165848.GA28288@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core ptrace access checking routine already holds the task lock,
so there is no need to use get_task_comm() which just tries to take the
lock again. Drop its use and access current->comm directly.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/yama/yama_lsm.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 83554ee..20a68ca 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -279,12 +279,10 @@ static int yama_ptrace_access_check(struct task_struct *child,
 	}
 
 	if (rc) {
-		char name[sizeof(current->comm)];
+		/* task_lock is held by the caller, so use comm directly. */
 		printk_ratelimited(KERN_NOTICE
 			"ptrace of pid %d was attempted by: %s (pid %d)\n",
-			child->pid,
-			get_task_comm(name, current),
-			current->pid);
+			child->pid, current->comm, current->pid);
 	}
 
 	return rc;
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
