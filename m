Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2EGAfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:35:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58217 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2EGAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:35:53 -0400
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
Date: Sun, 06 May 2012 17:35:46 -0700
In-Reply-To: <87havs7rvv.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 06 May 2012 17:32:20 -0700")
Message-ID: <87zk9k6d5p.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+i/KJe327sna6n/Rcgib/C64Q8idHBp7U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: XX
Subject: [PATCH 3/3] pidns: Make killed children autoreap
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Force SIGCHLD handling to SIG_IGN so that signals are not generated
and so that the children autoreap.  This increases the parallelize
and in general the speed of network namespace shutdown.

Note self reaping childrean can exist past zap_pid_ns_processess but
they will all be reaped before we allow the pid namespace init task
with pid == 1 to be reaped.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/pid_namespace.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 57bc1fd..b98b0ed 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -149,7 +149,12 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 {
 	int nr;
 	int rc;
-	struct task_struct *task;
+	struct task_struct *task, *me = current;
+
+	/* Ignore SIGCHLD causing any terminated children to autoreap */
+	spin_lock_irq(&me->sighand->siglock);
+	me->sighand->action[SIGCHLD -1].sa.sa_handler = SIG_IGN;
+	spin_unlock_irq(&me->sighand->siglock);
 
 	/*
 	 * The last thread in the cgroup-init thread group is terminating.
-- 
1.7.5.4

