Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1EWRGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:06:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab1EWRGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:06:51 -0400
Date: Mon, 23 May 2011 19:05:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH 1/2] ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED
	thread
Message-ID: <20110523170528.GB29328@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com> <20110523141034.GA11866@redhat.com> <20110523170508.GA29328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523170508.GA29328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not clear why ptrace_resume() does wake_up_process(). Unless the
caller is PTRACE_KILL the tracee should be TASK_TRACED so we can use
wake_up_state(__TASK_TRACED). If sys_ptrace() races with SIGKILL we do
not need the extra and potentionally spurious wakeup.

If the caller is PTRACE_KILL, wake_up_process() is even more wrong.
The tracee can sleep in any state in any place, and if we have a buggy
code which doesn't handle a spurious wakeup correctly PTRACE_KILL can
be used to exploit it. For example:

	int main(void)
	{
		int child, status;

		child = fork();
		if (!child) {
			int ret;

			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);

			ret = pause();
			printf("pause: %d %m\n", ret);

			return 0x23;
		}

		sleep(1);
		assert(ptrace(PTRACE_KILL, child, 0,0) == 0);

		assert(child == wait(&status));
		printf("wait: %x\n", status);

		return 0;
	}

prints "pause: -1 Unknown error 514", -ERESTARTNOHAND leaks to the
userland. In this case sys_pause() is buggy as well and should be
fixed.

I do not know what was the original rationality behind PTRACE_KILL.
The man page is simply wrong and afaics it was always wrong. Imho
it should be deprecated, or may be it should do send_sig(SIGKILL)
as Denys suggests, but in any case I do not think that the current
behaviour was intentional.

Note: there is another problem, ptrace_resume() changes ->exit_code
and this can race with SIGKILL too. Eventually we should change to
not use ->exit_code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- sigprocmask/kernel/ptrace.c~ptrace_resume_wakeup	2011-05-23 18:09:48.000000000 +0200
+++ sigprocmask/kernel/ptrace.c	2011-05-23 18:20:18.000000000 +0200
@@ -561,7 +561,7 @@ static int ptrace_resume(struct task_str
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	wake_up_state(child, __TASK_TRACED);
 
 	return 0;
 }

