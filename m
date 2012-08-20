Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2HTEAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:00:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2HTEAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 21/46] Yama: access task_struct->comm directly
Date: Sun, 19 Aug 2012 20:58:57 -0700
Message-Id: <20120820035835.212441157@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 7612bfeecc197bbb6629842b5c6ff1967f0a9b70 upstream.

The core ptrace access checking routine holds a task lock, and when
reporting a failure, Yama takes a separate task lock. To avoid a
potential deadlock with two ptracers taking the opposite locks, do not
use get_task_comm() and just use ->comm directly since accuracy is not
important for the report.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/yama/yama_lsm.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -279,12 +279,9 @@ static int yama_ptrace_access_check(stru
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
@@ -319,12 +316,9 @@ static int yama_ptrace_traceme(struct ta
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


