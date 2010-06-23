Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0FWVww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:52:52 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37296 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751617Ab0FWVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:52:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v4 07/12] rlimits: do security check under task_lock
Date: Wed, 23 Jun 2010 23:52:08 +0200
Message-Id: <1277329933-8139-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do security_task_setrlimit under task_lock. Other tasks may change
limits under our hands while we are checking limits inside the
function. From now on, they can't.

Note that all the security work is done under a spinlock here now.
Security hooks count with that, they are called from interrupt context
(like security_task_kill) and with spinlocks already held (e.g.
capable->security_capable).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sys.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 9dbcbbc..c762eeb 100644
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
@@ -1293,9 +1293,14 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		goto out;
 	}
 
-	retval = security_task_setrlimit(tsk->group_leader, resource, new_rlim);
-	if (retval)
-		goto out;
+	old_rlim = tsk->signal->rlim + resource;
+	task_lock(tsk->group_leader);
+	if (new_rlim->rlim_max > old_rlim->rlim_max &&
+			!capable(CAP_SYS_RESOURCE))
+		retval = -EPERM;
+	if (!retval)
+		retval = security_task_setrlimit(tsk->group_leader, resource,
+				new_rlim);
 
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
@@ -1307,12 +1312,7 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		new_rlim->rlim_cur = 1;
 	}
 
-	old_rlim = tsk->signal->rlim + resource;
-	task_lock(tsk->group_leader);
-	if (new_rlim->rlim_max > old_rlim->rlim_max &&
-			!capable(CAP_SYS_RESOURCE))
-		retval = -EPERM;
-	else
+	if (!retval)
 		*old_rlim = *new_rlim;
 	task_unlock(tsk->group_leader);
 
-- 
1.7.1


