Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2KPQhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:37:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48964 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2KPQhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:37:12 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:47 -0800
Message-Id: <1353083750-3621-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19XgK3LpsmA9LKv6gsNIhRdmpejrdYWhtg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/11] pidns: Deny strange cases when creating pid namespaces.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

task_active_pid_ns(current) != current->ns_proxy->pid_ns will
soon be allowed to support unshare and setns.

The definition of creating a child pid namespace when
task_active_pid_ns(current) != current->ns_proxy->pid_ns could be that
we create a child pid namespace of current->ns_proxy->pid_ns.  However
that leads to strange cases like trying to have a single process be
init in multiple pid namespaces, which is racy and hard to think
about.

The definition of creating a child pid namespace when
task_active_pid_ns(current) != current->ns_proxy->pid_ns could be that
we create a child pid namespace of task_active_pid_ns(current).  While
that seems less racy it does not provide any utility.

Therefore define the semantics of creating a child pid namespace when
task_active_pid_ns(current) != current->ns_proxy->pid_ns to be that the
pid namespace creation fails.  That is easy to implement and easy
to think about.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid_namespace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e106b18..066c058 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -145,6 +145,8 @@ struct pid_namespace *copy_pid_ns(unsigned long flags,
 		return get_pid_ns(old_ns);
 	if (flags & (CLONE_THREAD|CLONE_PARENT))
 		return ERR_PTR(-EINVAL);
+	if (task_active_pid_ns(current) != old_ns)
+		return ERR_PTR(-EINVAL);
 	return create_pid_namespace(user_ns, old_ns);
 }
 
-- 
1.7.5.4

