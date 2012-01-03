Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2ACPt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab2ACPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:49:54 -0500
Date: Tue, 3 Jan 2012 16:44:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: ptrace fixes for 3.2
Message-ID: <20120103154404.GA28930@redhat.com>
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com> <20111229120506.GA23653@redhat.com> <20120103142941.GA25488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103142941.GA25488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Oleg Nesterov wrote:
>
> I am going to send the hack^Wpatch below to Linus as a temporary
> workaround for 3.2.

The same patch with the changelog.

Denys, Tejun, any chance you can review it before I send it to Linus ?

Also, I am going to send this one:

	http://marc.info/?l=linux-kernel&m=131705871825598&w=2

could you please take a look?

Oleg.

------------------------------------------------------------------------------
[PATCH] ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE race

Test-case:

	int main(void)
	{
		int pid, status;

		pid = fork();
		if (!pid) {
			for (;;) {
				if (!fork())
					return 0;
				if (waitpid(-1, &status, 0) < 0) {
					printf("ERR!! wait: %m\n");
					return 0;
				}
			}
		}

		assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);
		assert(waitpid(-1, NULL, 0) == pid);

		assert(ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_TRACEFORK) == 0);

		do {
			ptrace(PTRACE_CONT, pid, 0, 0);
			pid = waitpid(-1, NULL, 0);
		} while (pid > 0);

		return 1;
	}

It fails because ->real_parent sees its child in EXIT_DEAD state
while the tracer is going to change the state back to EXIT_ZOMBIE
in wait_task_zombie().

The offending commit is 823b018e which moved the EXIT_DEAD check,
but in fact we should not blame it. The original code was not
correct as well because it didn't take ptrace_reparented() into
account and because we can't really trust ->ptrace.

This patch adds the additional check to close this particular
race but it doesn't solve the whole problem. We simply can't
rely on ->ptrace in this case, it can be cleared if the tracer
is multithreaded by the exiting ->parent.

I think we should kill EXIT_DEAD altogether, we should always
remove the soon-to-be-reaped child from ->children or at least
we should never do the DEAD->ZOMBIE transition. But this is too
complex for 3.2.

Also, I think wait_consider_task() needs more fixes. I do not
think we should clear ->notask_error without WEXITED in this
case, but this is what we do in the EXIT_ZOMBIE case.

Reported-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: v3.0.. <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d0b7d98..e6e01b9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1540,8 +1540,15 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	}
 
 	/* dead body doesn't have much to contribute */
-	if (p->exit_state == EXIT_DEAD)
+	if (unlikely(p->exit_state == EXIT_DEAD)) {
+		/*
+		 * But do not ignore this task until the tracer does
+		 * wait_task_zombie()->do_notify_parent().
+		 */
+		if (likely(!ptrace) && unlikely(ptrace_reparented(p)))
+			wo->notask_error = 0;
 		return 0;
+	}
 
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {
-- 
1.5.5.1


