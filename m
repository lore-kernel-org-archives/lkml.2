Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2AEWr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:47:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab2AEWrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:47:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:44:03 2012
Message-Id: <20120105224403.138492777@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:44:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [72/73] ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE race
In-Reply-To: <20120105224632.GA14659@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2354
Lines: 86

From: Oleg Nesterov <oleg@redhat.com>

commit 50b8d257486a45cba7b65ca978986ed216bbcc10 upstream.

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

		assert(ptrace(PTRACE_SETOPTIONS, pid, 0,
					PTRACE_O_TRACEFORK) == 0);

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

Reported-and-tested-by: Denys Vlasenko <vda.linux@googlemail.com>
Tested-by: Lukasz Michalik <lmi@ift.uni.wroc.pl>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1553,8 +1553,15 @@ static int wait_consider_task(struct wai
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


