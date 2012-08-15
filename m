Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2HOSmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:42:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54750 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2HOSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:42:08 -0400
Date: Wed, 15 Aug 2012 11:41:55 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2] Yama: access task_struct->comm directly
Message-ID: <20120815184155.GA3666@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core ptrace access checking routine holds a task lock, and when
reporting a failure, Yama takes a separate task lock. To avoid a
potential deadlock with two ptracers taking the opposite locks, do not
use get_task_comm() and just use ->comm directly since accuracy is not
important for the report.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: John Johansen <john.johansen@canonical.com>

---
v2: update with newly added traceme report.
---
 security/yama/yama_lsm.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index d51b7c7..0cc99a3 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -279,12 +279,9 @@ static int yama_ptrace_access_check(struct task_struct *child,
 	}
 
 	if (rc) {
-		char name[sizeof(current->comm)];
 		printk_ratelimited(KERN_NOTICE
 			"ptrace of pid %d was attempted by: %s (pid %d)\n",
-			child->pid,
-			get_task_comm(name, current),
-			current->pid);
+			child->pid, current->comm, current->pid);
 	}
 
 	return rc;
@@ -319,12 +316,9 @@ static int yama_ptrace_traceme(struct task_struct *parent)
 	}
 
 	if (rc) {
-		char name[sizeof(current->comm)];
 		printk_ratelimited(KERN_NOTICE
 			"ptraceme of pid %d was attempted by: %s (pid %d)\n",
-			current->pid,
-			get_task_comm(name, parent),
-			parent->pid);
+			current->pid, parent->comm, parent->pid);
 	}
 
 	return rc;
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
