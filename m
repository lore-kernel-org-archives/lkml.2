Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1GUSDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1GUSDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:03:06 -0400
Date: Thu, 21 Jul 2011 20:00:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: do_wait(traced_leader_killed_by_mt_exec) can
	block forever
Message-ID: <20110721180043.GB1319@redhat.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com> <20110721165137.GA21345@redhat.com> <20110721180019.GA1319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721180019.GA1319@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test-case:

	void *tfunc(void *arg)
	{
		execvp("true", NULL);
		return NULL;
	}

	int main(void)
	{
		int pid;

		if (fork()) {
			pthread_t t;

			kill(getpid(), SIGSTOP);

			pthread_create(&t, NULL, tfunc, NULL);

			for (;;)
				pause();
		}

		pid = getppid();
		assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);

		while (wait(NULL) > 0)
			ptrace(PTRACE_CONT, pid, 0,0);

		return 0;
	}

It is racy, exit_notify() does __wake_up_parent() too. But in the
likely case it triggers the problem: de_thread() does release_task()
and the old leader goes away without the notification, the tracer
sleeps in do_wait() without children/tracees.

Change de_thread() to do __wake_up_parent(traced_leader->parent).
Since it is already EXIT_DEAD we can do this without ptrace_unlink(),
EXIT_DEAD threads do not exist from do_wait's pov.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- ptrace/fs/exec.c~ptrace_mt_exec_wait_hang	2011-07-17 20:16:36.000000000 +0200
+++ ptrace/fs/exec.c	2011-07-21 19:56:22.000000000 +0200
@@ -967,6 +967,14 @@ static int de_thread(struct task_struct 
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
+
+		/*
+		 * We are going to release_task()->ptrace_unlink() silently,
+		 * the tracer can sleep in do_wait(). EXIT_DEAD guarantees
+		 * the tracer wont't block again waiting for this thread.
+		 */
+		if (unlikely(leader->ptrace))
+			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
 
 		release_task(leader);

