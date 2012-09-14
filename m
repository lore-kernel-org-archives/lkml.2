Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2INGKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:10:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2INGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:10:42 -0400
Date: Thu, 13 Sep 2012 23:10:26 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-b3f68f16dbcde6fcdf0fd27695391ff7e9d41233@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        davej@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        davej@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120826191214.GA4231@redhat.com>
References: <20120826191214.GA4231@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] task_work: Revert "
 hold task_lock around checks in keyctl"
Git-Commit-ID: b3f68f16dbcde6fcdf0fd27695391ff7e9d41233
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:10:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3f68f16dbcde6fcdf0fd27695391ff7e9d41233
Gitweb:     http://git.kernel.org/tip/b3f68f16dbcde6fcdf0fd27695391ff7e9d41233
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 26 Aug 2012 21:12:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:47:36 +0200

task_work: Revert "hold task_lock around checks in keyctl"

This reverts commit d35abdb28824cf74f0a106a0f9c6f3ff700a35bf.

task_lock() was added to ensure exit_mm() and thus exit_task_work() is
not possible before task_work_add().

This is wrong, task_lock() must not be nested with write_lock(tasklist).
And this is no longer needed, task_work_add() now fails if it is called
after exit_task_work().

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120826191214.GA4231@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 security/keys/keyctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3364fbf..6cfc647 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1486,7 +1486,6 @@ long keyctl_session_to_parent(void)
 	oldwork = NULL;
 	parent = me->real_parent;
 
-	task_lock(parent);
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
 		goto unlock;
@@ -1530,7 +1529,6 @@ long keyctl_session_to_parent(void)
 	if (!ret)
 		newwork = NULL;
 unlock:
-	task_unlock(parent);
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
 	if (oldwork)
