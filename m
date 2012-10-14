Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2JNSe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab2JNSeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:34:24 -0400
Date: Sun, 14 Oct 2012 20:35:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] (Was: [regression] boot failure on alpha, bisected)
Message-ID: <20121014183539.GA16804@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121012160337.GA30881@redhat.com> <20121012221843.GJ2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012221843.GJ2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12, Al Viro wrote:
>
> On Fri, Oct 12, 2012 at 06:03:37PM +0200, Oleg Nesterov wrote:
> > On 10/06, Thorsten Kranzkowski wrote:
> > >
> > > After upgrading from v3.5-rc7 to current git my system oopses and locks up
> > > early in the boot sequence.
> >
> > OK, I am sending the patch which I already showed.
> >
> > Perhaps we should only add the warning and local_irq_enable()
> > should go into arch/alpha/kernel/signal.c:do_notify_resume().
> >
> > In any case arch/alpha/ should be fixed imho.
>
> Oleg, could you check current signal.git#for-next?  alpha patches in
> there ought to deal with the do_notify_resume() mess on alpha
> for good, AFAICS.

Yes, thanks Al!

6972d6f25d21e3da58ff1309256c787078405c7f makes my patch unnecessary.
Although, as you pointed out, other architectures can have the same
problem so perhaps at least WARN_ONCE() in task_wrok_run() makes
sense.

But I am just curious,

	+do_work_pending(struct pt_regs *regs, struct switch_stack *sw,
	+		 unsigned long thread_flags,
			 unsigned long r0, unsigned long r19)
	 {
	-	if (thread_info_flags & _TIF_SIGPENDING)
	-		do_signal(regs, sw, r0, r19);
	-
	-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
	-		clear_thread_flag(TIF_NOTIFY_RESUME);
	-		tracehook_notify_resume(regs);
	-	}
	+	do {
	+		if (thread_flags & _TIF_NEED_RESCHED) {
	+			schedule();
	+		} else {
	+			local_irq_enable();

I think this is fine, schedule() can be called with irqs disabled.
And since this is ret-to-user path we can't have the problems with
sched_submit_work().

Still, any particular reason why this patch doesn't do irq_enable()
at the start of the loop?

	+			if (thread_flags & _TIF_SIGPENDING) {
	+				do_signal(regs, sw, r0, r19);
	+				r0 = 0;
	+			} else {
	+				clear_thread_flag(TIF_NOTIFY_RESUME);
	+				tracehook_notify_resume(regs);

Again, this is fine. But why "else" ? It seems that

			if (thread_flags & _TIF_SIGPENDING) {
				do_signal(regs, r0, r19);
				r0 = 0;
			}

			if (thread_flags & _TIF_NOTIFY_RESUME) {
				clear_thread_flag(TIF_NOTIFY_RESUME);
				tracehook_notify_resume(regs);
			}

makes a bit more sense?

Oleg.

