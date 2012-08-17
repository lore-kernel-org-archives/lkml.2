Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030318Ab2HQKwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:52:20 -0400
Received: from tundra.namei.org ([65.99.196.166]:43326 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161008Ab2HQKwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:52:09 -0400
Date: Fri, 17 Aug 2012 20:51:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [GIT] Bug fix for Yama
Message-ID: <alpine.LRH.2.02.1208172050100.8396@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this fix for a deadlock in the Yama LSM.

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:
  Linus Torvalds (1):
        Linux 3.6-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Kees Cook (1):
      Yama: access task_struct->comm directly

 security/yama/yama_lsm.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

commit 7612bfeecc197bbb6629842b5c6ff1967f0a9b70
Author: Kees Cook <keescook@chromium.org>
Date:   Wed Aug 15 11:41:55 2012 -0700

    Yama: access task_struct->comm directly
    
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
    Signed-off-by: James Morris <james.l.morris@oracle.com>

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
