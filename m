Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0LaIdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 03:33:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42473 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751374Ab0LaIdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 03:33:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1855uZPEtc5SrRRX5aaq3MJs4crxdWvLhA/reLPYO
	4//m1LkvgPbUfP
Subject: [PATCH] Re: [PATCH] sched, cgroup: Use exit hook to avoid
 use-after-free crash
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Miklos Vajna <vmiklos@frugalware.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20101229152522.GA23825@elte.hu>
References: <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop> <1293107624.2170.642.camel@laptop>
	 <1293128670.2170.748.camel@laptop>
	 <1293132304.6798.6.camel@marge.simson.net>
	 <1293132862.25981.22.camel@laptop>
	 <1293187425.7138.2.camel@marge.simson.net>
	 <1293188091.25981.200.camel@laptop>
	 <1293192999.18035.4.camel@marge.simson.net>
	 <1293206353.29444.205.camel@laptop>  <20101229152522.GA23825@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 09:32:30 +0100
Message-ID: <1293784350.6839.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 16:25 +0100, Ingo Molnar wrote:

> I tried this patch, but it causes a boot crash:

The below should fix it.

sched: fix autogroup reference leak and cpu_cgroup_exit() explosion

In the event of a fork failure, the new cpu_cgroup_exit() method tries to
move an unhashed task.  Since PF_EXITING isn't set in that case, autogroup
will dig aground in a freed signal_struct.  Neither cgroups nor autogroup
has anything it needs to do with this shade, so don't go there.

This also uncovered a struct autogroup reference leak. copy_process() was
simply freeing vs putting the signal_struct, stranding a reference.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/fork.c  |    2 +-
 kernel/sched.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.37.git/kernel/fork.c
===================================================================
--- linux-2.6.37.git.orig/kernel/fork.c
+++ linux-2.6.37.git/kernel/fork.c
@@ -1318,7 +1318,7 @@ bad_fork_cleanup_mm:
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		free_signal_struct(p->signal);
+		put_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
Index: linux-2.6.37.git/kernel/sched.c
===================================================================
--- linux-2.6.37.git.orig/kernel/sched.c
+++ linux-2.6.37.git/kernel/sched.c
@@ -9193,6 +9193,16 @@ cpu_cgroup_attach(struct cgroup_subsys *
 static void
 cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
 {
+	/*
+	 * cgroup_exit() is called in the copy_process failure path.
+	 * The task isn't hashed, and we don't want to make autogroup
+	 * dig into a freed signal_struct, so just go away.
+	 *
+	 * XXX: why are cgroup methods diddling unattached tasks?
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
 	sched_move_task(task);
 }
 


