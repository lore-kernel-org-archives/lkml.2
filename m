Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab1DASN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab1DASN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:13:26 -0400
Date: Fri, 1 Apr 2011 20:13:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 4/4] ptrace: ptrace_check_attach() should not do
	s/STOPPED/TRACED/
Message-ID: <20110401181301.GE9010@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org> <20110331172946.GA14934@redhat.com> <20110401181123.GA9010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401181123.GA9010@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After "ptrace: Clean transitions between TASK_STOPPED and TRACED"
d79fdd6d96f46fabb779d86332e3677c6f5c2a4f, ptrace_check_attach()
should never see a TASK_STOPPED tracee and s/STOPPED/TRACED/ is
no longer legal. Add the warning.

Note: ptrace_check_attach() can be greatly simplified, in particular
it doesn't need tasklist. But I'd prefer another patch for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- ptrace/kernel/ptrace.c~4_ck_attach_cant_be_stopped	2011-04-01 16:36:29.000000000 +0200
+++ ptrace/kernel/ptrace.c	2011-04-01 19:54:05.000000000 +0200
@@ -112,16 +112,14 @@ int ptrace_check_attach(struct task_stru
 	 */
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
-		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
 		 * does ptrace_unlink() before __exit_signal().
 		 */
 		spin_lock_irq(&child->sighand->siglock);
-		if (task_is_stopped(child))
-			child->state = TASK_TRACED;
-		else if (!task_is_traced(child) && !kill)
-			ret = -ESRCH;
+		WARN_ON_ONCE(task_is_stopped(child));
+		if (task_is_traced(child) || kill)
+			ret = 0;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);

