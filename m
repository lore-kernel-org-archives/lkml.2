Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0EGI4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:56:22 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46446 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0EGI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 09/11] rlimits: switch getrlimit to do_prlimit
Date: Fri,  7 May 2010 10:55:40 +0200
Message-Id: <1273222543-17083-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

After we added more generic do_prlimit, switch sys_getrlimit to that.
We now have all non-compat rlimit handling at one place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/sys.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 7a453d2..0f8034f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1236,15 +1236,14 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 
 SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 {
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	else {
-		struct rlimit value;
-		task_lock(current->group_leader);
-		value = current->signal->rlim[resource];
-		task_unlock(current->group_leader);
-		return copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
-	}
+	struct rlimit value;
+	int ret;
+
+	ret = do_prlimit(current, resource, NULL, &value);
+	if (!ret)
+		ret = copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
+
+	return ret;
 }
 
 #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT
-- 
1.7.1


