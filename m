Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0EGI6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:58:15 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46447 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0EGI4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 06/11] rlimits: do security check under task_lock
Date: Fri,  7 May 2010 10:55:37 +0200
Message-Id: <1273222543-17083-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do security_task_setrlimit under task_lock. Other tasks may
change limits under our hands while we are checking limits
inside the function. From now on, they can't.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sys.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index eb21661..9e9a3a7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1277,7 +1277,7 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
 	struct rlimit *old_rlim;
-	int retval;
+	int retval = 0;
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
@@ -1293,10 +1293,6 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		goto out;
 	}
 
-	retval = security_task_setrlimit(tsk, resource, new_rlim);
-	if (retval)
-		goto out;
-
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
@@ -1309,11 +1305,13 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	old_rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
-	if ((new_rlim->rlim_max <= old_rlim->rlim_max) ||
-				capable(CAP_SYS_RESOURCE))
-		*old_rlim = *new_rlim;
-	else
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
+				!capable(CAP_SYS_RESOURCE))
 		retval = -EPERM;
+	if (!retval)
+		retval = security_task_setrlimit(tsk, resource, new_rlim);
+	if (!retval)
+		*old_rlim = *new_rlim;
 	task_unlock(tsk->group_leader);
 
 	if (retval || resource != RLIMIT_CPU)
-- 
1.7.1


