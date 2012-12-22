Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2LVE5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:57:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57315 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2LVE5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:57:41 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
References: <87d2y2elbi.fsf@xmission.com>
Date: Fri, 21 Dec 2012 20:57:34 -0800
In-Reply-To: <87d2y2elbi.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 21 Dec 2012 20:56:49 -0800")
Message-ID: <877goaela9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19uJzgLWBaSkgoMb73DCNCGkV+6wC9xF7s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH review 1/3] pidns: Outlaw thread creation after unshare(CLONE_NEWPID)
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sequence:
unshare(CLONE_NEWPID)
clone(CLONE_THREAD|CLONE_SIGHAND|CLONE_VM)

Creates a new process in the new pid namespace without setting
pid_ns->child_reaper.  After forking this results in a NULL
pointer dereference.

Avoid this and other nonsense scenarios that can show up after
creating a new pid namespace with unshare by adding a new
check in copy_prodcess.

Pointed-out-by:  Oleg Nesterov <oleg@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/fork.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index a31b823..65ca6d2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1166,6 +1166,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 				current->signal->flags & SIGNAL_UNKILLABLE)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * If the new process will be in a different pid namespace
+	 * don't allow the creation of threads.
+	 */
+	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
+	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
-- 
1.7.5.4

