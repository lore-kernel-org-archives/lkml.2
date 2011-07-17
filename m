Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1GQTGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 15:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1GQTGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 15:06:49 -0400
Date: Sun, 17 Jul 2011 21:03:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
	interaction
Message-ID: <20110717190337.GA18465@redhat.com>
References: <20110707190301.GA25332@redhat.com> <20110707190324.GB25332@redhat.com> <20110713100404.GG2872@htj.dyndns.org> <20110713183322.GA12535@redhat.com> <20110714064457.GA3455@htj.dyndns.org> <20110714191233.GA20177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714191233.GA20177@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Oleg Nesterov wrote:
>
> On 07/14, Tejun Heo wrote:
> >
> > Never mind.  I for some reason thought flipping the flag would make
> > the extra step in ptrace_signal() unnecessary.  We need to clear it
> > all the same so it doesn't really improve anything.  I think the
> > current version should be fine
>
> Good.
>
> > (maybe the comment can be beefed up a
> > bit?).
>
> I agree, this is not the best comment... OK, I'll try to make a
> better one. Damn this is not easy ;) and I hate the really fat
> comments.

OK, how about v2? The patch is the same, only the comment was updated.
Not sure it is really better though.

Oleg.

------------------------------------------------------------------------------
[PATCH v2] ptrace: fix ptrace_signal() && STOP_DEQUEUED interaction

Simple test-case,

	int main(void)
	{
		int pid, status;

		pid = fork();
		if (!pid) {
			pause();
			assert(0);
			return 0x23;
		}

		assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);

		kill(pid, SIGCONT);	// <--- also clears STOP_DEQUEUD

		assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGCONT);

		assert(ptrace(PTRACE_CONT, pid, 0, SIGSTOP) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);

		kill(pid, SIGKILL);
		return 0;
	}

Without the patch it hangs. After the patch SIGSTOP "injected" by the
tracer is not ignored and stops the tracee.

Note also that if this test-case uses, say, SIGWINCH instead of SIGCONT,
everything works without the patch. This can't be right, and this is
confusing.

The problem is that SIGSTOP (or any other sig_kernel_stop() signal) has
no effect without JOBCTL_STOP_DEQUEUED. This means it is simply ignored
after PTRACE_CONT unless JOBCTL_STOP_DEQUEUED was set "by accident", say
it wasn't cleared after initial SIGSTOP sent by PTRACE_ATTACH.

At first glance we could change ptrace_signal() to add STOP_DEQUEUED
after return from ptrace_stop(), but this is not right in case when the
tracer does not change the reported SIGSTOP and SIGCONT comes in between.
This is even more wrong with PT_SEIZED, SIGCONT adds JOBCTL_TRAP_NOTIFY
which will be "lost" during the TRAP_STOP | TRAP_NOTIFY report.

So lets add STOP_DEQUEUED _before_ we report the signal. It has no effect
unless sig_kernel_stop() == T after the tracer resumes us, and in the
latter case the pending STOP_DEQUEUED means no SIGCONT in between, we
should stop.

Note also that if SIGCONT was sent, PT_SEIZED tracee will correctly
report PTRACE_EVENT_STOP/SIGTRAP and thus the tracer can notice the fact
SIGSTOP was cancelled.

Also, move the current->ptrace check from ptrace_signal() to its caller,
get_signal_to_deliver(), this looks more natural.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- ptrace/kernel/signal.c~1_ptrace_signal_stop_dequeued	2011-07-17 20:16:36.000000000 +0200
+++ ptrace/kernel/signal.c	2011-07-17 20:57:30.000000000 +0200
@@ -2084,12 +2084,17 @@ static void do_jobctl_trap(void)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!current->ptrace)
-		return signr;
-
 	ptrace_signal_deliver(regs, cookie);
-
-	/* Let the debugger run.  */
+	/*
+	 * We do not check sig_kernel_stop(signr) but set this marker
+	 * unconditionally because we do not know whether debugger will
+	 * change signr. This flag has no meaning unless we are going
+	 * to stop after return from ptrace_stop(). In this case it will
+	 * be checked in do_signal_stop(), we should only stop if it was
+	 * not cleared by SIGCONT while we were sleeping. See also the
+	 * comment in dequeue_signal().
+	 */
+	current->jobctl |= JOBCTL_STOP_DEQUEUED;
 	ptrace_stop(signr, CLD_TRAPPED, 0, info);
 
 	/* We're back.  Did the debugger cancel the sig?  */
@@ -2193,7 +2198,7 @@ relock:
 		if (!signr)
 			break; /* will return 0 */
 
-		if (signr != SIGKILL) {
+		if (unlikely(current->ptrace) && signr != SIGKILL) {
 			signr = ptrace_signal(signr, info,
 					      regs, cookie);
 			if (!signr)

