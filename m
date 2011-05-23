Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1EWOMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:12:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1EWOMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:12:06 -0400
Date: Mon, 23 May 2011 16:10:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: ptrace_resume->wake_up_process (Was: Ptrace documentation, draft
	#1)
Message-ID: <20110523141034.GA11866@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523121011.GA5799@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Oleg Nesterov wrote:
>
> "does nothing" is not 100% true, it does wake_up_process() but this shouldn't
> be documented, this should be fixed.

In fact ptrace_resume()->wake_up_process() is obviously wrong anyway,
I think the patch below makes sense even for 2.6.40.

But it is much worse in PTRACE_KILL case. Just for example,

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

leaks -ERESTARTNOHAND. Yes, we should probably fix sys_pause() as well,
it should check signal_pending(). But we shouldn't allow to wake up the
tracee in unknown state/path.

Can't understand why this wasn't fixed before... I always knew this looks
wrong, but I never sent the patch. Probably because I never understood
the original reason for wake_up_process...

Oleg.

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -706,7 +706,7 @@ static int ptrace_resume(struct task_str
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	wake_up_state(child, TASK_TRACED);
 
 	return 0;
 }

