Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1A0OHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:07:55 -0500
Received: from moat.camk.edu.pl ([148.81.175.50]:40011 "EHLO moat.camk.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab1A0OHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:07:54 -0500
X-Greylist: delayed 1235 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 09:07:54 EST
Date: Thu, 27 Jan 2011 14:47:10 +0100
From: Kacper Kornet <kornet@camk.edu.pl>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix prlimit64 for suid/sgid processes
Message-ID: <20110127134710.GB519@camk.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since check_prlimit_permission always fails in the case of SUID/GUID
processes, such processes are not able to read or set their own limits.
This commit changes this by assuming that process can always read/change
its own limits.

Signed-off-by: Kacper Kornet <kornet@camk.edu.pl>
---
 kernel/sys.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e9ad444..0aaafde 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1409,10 +1409,12 @@ SYSCALL_DEFINE4(prlimit64, pid_t, pid, unsigned int, resource,
 		rcu_read_unlock();
 		return -ESRCH;
 	}
-	ret = check_prlimit_permission(tsk);
-	if (ret) {
-		rcu_read_unlock();
-		return ret;
+	if (tsk != current) {
+		ret = check_prlimit_permission(tsk);
+		if (ret) {
+			rcu_read_unlock();
+			return ret;
+		}
 	}
 	get_task_struct(tsk);
 	rcu_read_unlock();
-- 
  Kacper Kornet
