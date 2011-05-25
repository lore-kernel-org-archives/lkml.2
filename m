Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1EYUKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1EYUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:10:09 -0400
Date: Wed, 25 May 2011 22:08:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [GIT PULL] PTRACE_KILL/wakeup fix for v2.6.40
Message-ID: <20110525200804.GA22117@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com> <20110523141034.GA11866@redhat.com> <BANLkTimaN8U8_sWT_q_ZDZkA51jqWPHkiQ@mail.gmail.com> <20110523172352.GA30226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523172352.GA30226@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Oleg Nesterov wrote:
>
> On 05/23, Linus Torvalds wrote:
> >
> > Or a pull request ..
>
> Whatever is more convenient for you. If everyone agree with this change,
> I'll add it to ptrace branch and send [GIT PULL] tomorrow.

OK, nobody replied, I assume there are no objections...

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git for-2.6.40

Oleg Nesterov (2):
      ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED thread
      signal: sys_pause() should check signal_pending()

 kernel/ptrace.c |    2 +-
 kernel/signal.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7a81fc0..2df1157 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -562,7 +562,7 @@ static int ptrace_resume(struct task_struct *child, long request,
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	wake_up_state(child, __TASK_TRACED);
 
 	return 0;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index ad5e818..86c32b8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3023,8 +3023,10 @@ SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
 
 SYSCALL_DEFINE0(pause)
 {
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
+	while (!signal_pending(current)) {
+		current->state = TASK_INTERRUPTIBLE;
+		schedule();
+	}
 	return -ERESTARTNOHAND;
 }
 

