Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0CPTlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab0CPTlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:41:13 -0400
Date: Tue, 16 Mar 2010 20:39:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 4/4] coredump: shift down_write(mmap_sem) into
	coredump_wait()
Message-ID: <20100316193941.GE31632@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com> <20100316193750.GA31632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316193750.GA31632@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- move the cprm.mm_flags checks up, before we take mmap_sem

- move down_write(mmap_sem) and ->core_state check from do_coredump()
  to coredump_wait()

This simplifies the code and makes the locking symmetrical.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- 34-rc1/fs/exec.c~4_MMAP_SEM	2010-03-16 19:09:50.000000000 +0100
+++ 34-rc1/fs/exec.c	2010-03-16 19:28:23.000000000 +0100
@@ -1659,12 +1659,15 @@ static int coredump_wait(int exit_code, 
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
 	struct completion *vfork_done;
-	int core_waiters;
+	int core_waiters = -EBUSY;
 
 	init_completion(&core_state->startup);
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
-	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
+
+	down_write(&mm->mmap_sem);
+	if (!mm->core_state)
+		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1857,20 +1860,12 @@ void do_coredump(long signr, int exit_co
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
+	if (!__get_dumpable(cprm.mm_flags))
+		goto fail;
 
 	cred = prepare_creds();
 	if (!cred)
 		goto fail;
-
-	down_write(&mm->mmap_sem);
-	/*
-	 * If another thread got here first, or we are not dumpable, bail out.
-	 */
-	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
-		up_write(&mm->mmap_sem);
-		goto fail_creds;
-	}
-
 	/*
 	 *	We cannot trust fsuid as being the "true" uid of the
 	 *	process nor do we know its entire history. We only know it

