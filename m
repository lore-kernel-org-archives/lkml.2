Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2KPQgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:36:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33561 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2KPQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:36:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:45 -0800
Message-Id: <1353083750-3621-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18hapzv41FhTZje2x4V4HydR00/KnpVoiE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0137]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 06/11] pidns: Don't allow new processes in a dead pid namespace.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Set nr_hashed to -1 just before we schedule the work to cleanup proc.
Test nr_hashed just before we hash a new pid and if nr_hashed is < 0
fail.

This guaranteees that processes never enter a pid namespaces after we
have cleaned up the state to support processes in a pid namespace.

Currently sending SIGKILL to all of the process in a pid namespace as
init exists gives us this guarantee but we need something a little
stronger to support unsharing and joining a pid namespace.

Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/pid.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index e957f8b..9c21911 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -274,8 +274,10 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
 		hlist_del_rcu(&upid->pid_chain);
-		if (--upid->ns->nr_hashed == 0)
+		if (--upid->ns->nr_hashed == 0) {
+			upid->ns->nr_hashed = -1;
 			schedule_work(&upid->ns->proc_work);
+		}
 	}
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
@@ -321,6 +323,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
+	if (ns->nr_hashed < 0)
+		goto out_unlock;
 	for ( ; upid >= pid->numbers; --upid) {
 		hlist_add_head_rcu(&upid->pid_chain,
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
@@ -331,6 +335,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 out:
 	return pid;
 
+out_unlock:
+	spin_unlock(&pidmap_lock);
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
-- 
1.7.5.4

