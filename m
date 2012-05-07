Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2EGAd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:33:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57969 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2EGAd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:33:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com>
Date: Sun, 06 May 2012 17:33:20 -0700
In-Reply-To: <87havs7rvv.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 06 May 2012 17:32:20 -0700")
Message-ID: <87aa1k7ru7.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+0xWA19X50LGYxAfEll59F+82wInX/AMs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  0.0 SUBJ_OBFU_PUNCT_FEW Possible punctuation-obfuscated Subject: header
	*  0.3 SUBJ_OBFU_PUNCT_MANY Punctuation-obfuscated Subject: header
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: XX
Subject: [PATCH 1/3] pidns: Use task_active_pid_ns in do_notify_parent.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using task_active_pid_ns is more robust because it works even after we
have called exit_namespaces.  This change allows us to have parent
processes that are zombies.  Normally a zombie parent processes is crazy
and the last thing you would want to have but in the case of not letting
the init process of a pid namespace be reaped until all of it's children
are dead and reaped a zombie parent process is exactly what we want.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/signal.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 17afcaf..0e4ef99 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1665,19 +1665,18 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_signo = sig;
 	info.si_errno = 0;
 	/*
-	 * we are under tasklist_lock here so our parent is tied to
-	 * us and cannot exit and release its namespace.
+	 * We are under tasklist_lock here so our parent is tied to
+	 * us and cannot change.
 	 *
-	 * the only it can is to switch its nsproxy with sys_unshare,
-	 * bu uncharing pid namespaces is not allowed, so we'll always
-	 * see relevant namespace
+	 * task_active_pid_ns will always return the same pid namespace
+	 * until a task passes through release_task.
 	 *
 	 * write_lock() currently calls preempt_disable() which is the
 	 * same as rcu_read_lock(), but according to Oleg, this is not
 	 * correct to rely on this
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, task_active_pid_ns(tsk->parent));
 	info.si_uid = map_cred_ns(__task_cred(tsk),
 			task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
-- 
1.7.5.4

