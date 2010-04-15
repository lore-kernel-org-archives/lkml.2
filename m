Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0DOXCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:02:10 -0400
Received: from www.tglx.de ([62.245.132.106]:42913 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0DOXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:02:07 -0400
Date: Fri, 16 Apr 2010 01:01:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
In-Reply-To: <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>  <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>  <20100415210357.GG5069@nowhere> <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1543384268-1271372511=:3625"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1543384268-1271372511=:3625
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 15 Apr 2010, Chase Douglas wrote:
> On Thu, Apr 15, 2010 at 2:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Apr 14, 2010 at 12:20:16PM -0400, Chase Douglas wrote:
> >> This change adds a tracing_off_event() call to stop tracing on schedule
> >> bugs unless tracing_off=none was specified on the commandline.
> >>
> >> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> >> ---
> >>  kernel/sched.c |    2 ++
> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> index 6af210a..439f036 100644
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
> >>  {
> >>       struct pt_regs *regs = get_irq_regs();
> >>
> >> +     tracing_off_event(TRACE_EVENT_BUG);
> >> +
> >>       printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
> >>               prev->comm, prev->pid, preempt_count());
> >
> >
> >
> > I would rather call that a TRACE_EVENT_WARN as this is what happens: we
> > warn but we continue.
> 
> I tend to think of the TRACE_EVENT_* as an indication of severity and
> whether we want to stop the trace by default. From a distro
> standpoint, the likelihood that we want to continue tracing after a
> __schedule_bug is pretty low. It's easiest if we don't have to tell

Well, scheduling while atomic is a BUG, but one of the category which
allows the kernel to continue. So in fact it's treated like a WARN_ON.
So the tracing_off_event() qualifier should be *_WARN.

That's independent of the question whether you want to stop tracing in
that very case. Though I agree that the tracer should stop here.

> our users to add a kernel command line, especially since grub in
> Ubuntu 10.04 LTS is difficult to interact with for end users.

That's a serious PITA caused by the "let's mimic the other OS" crowd
and no excuse for creating a mess in the kernel.
 
Thanks,

	tglx
--8323328-1543384268-1271372511=:3625--
