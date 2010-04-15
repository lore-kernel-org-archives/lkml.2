Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0DOXvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:51:05 -0400
Received: from www.tglx.de ([62.245.132.106]:54076 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab0DOXu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:50:59 -0400
Date: Fri, 16 Apr 2010 01:50:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chase Douglas <chase.douglas@canonical.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
In-Reply-To: <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>  <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>  <20100415210357.GG5069@nowhere>  <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com> 
 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain> <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2004148899-1271375447=:3625"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2004148899-1271375447=:3625
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 15 Apr 2010, Chase Douglas wrote:
> On Thu, Apr 15, 2010 at 4:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 15 Apr 2010, Chase Douglas wrote:
> >> On Thu, Apr 15, 2010 at 2:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > On Wed, Apr 14, 2010 at 12:20:16PM -0400, Chase Douglas wrote:
> >> >> This change adds a tracing_off_event() call to stop tracing on schedule
> >> >> bugs unless tracing_off=none was specified on the commandline.
> >> >>
> >> >> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> >> >> ---
> >> >>  kernel/sched.c |    2 ++
> >> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >> >>
> >> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> >> index 6af210a..439f036 100644
> >> >> --- a/kernel/sched.c
> >> >> +++ b/kernel/sched.c
> >> >> @@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
> >> >>  {
> >> >>       struct pt_regs *regs = get_irq_regs();
> >> >>
> >> >> +     tracing_off_event(TRACE_EVENT_BUG);
> >> >> +
> >> >>       printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
> >> >>               prev->comm, prev->pid, preempt_count());
> >> >
> >> >
> >> >
> >> > I would rather call that a TRACE_EVENT_WARN as this is what happens: we
> >> > warn but we continue.
> >>
> >> I tend to think of the TRACE_EVENT_* as an indication of severity and
> >> whether we want to stop the trace by default. From a distro
> >> standpoint, the likelihood that we want to continue tracing after a
> >> __schedule_bug is pretty low. It's easiest if we don't have to tell
> >
> > Well, scheduling while atomic is a BUG, but one of the category which
> > allows the kernel to continue. So in fact it's treated like a WARN_ON.
> > So the tracing_off_event() qualifier should be *_WARN.
> >
> > That's independent of the question whether you want to stop tracing in
> > that very case. Though I agree that the tracer should stop here.
> 
> We seem to be agreeing on the functionality. The disagreement seems to
> be in the macro name/functionality mapping. However, the name of the
> function itself is *_bug. I don't see how things are clearer or more
> useful by inserting a *_WARN level macro in a *_bug named function.

Care to read what I wrote ? Again:

> > Well, scheduling while atomic is a BUG, but one of the category which
> > allows the kernel to continue. So in fact it's treated like a WARN_ON.
> > So the tracing_off_event() qualifier should be *_WARN.

It does not matter at all whether the function name has "bug" in it or
not. What matters is the semantics of the function. It does _NOT_
raise a BUG. It merily warns and tries to continue. So it follows the
WARN() semantics.

If you feel strong about that send a patch to
s/schedule_bug/schedule_warn/ and I'll ack it.

> Essentially, it makes more sense to me for the macro to represent the
> severity of the case, and not be coupled somehow to what the kernel
> decides to do outside of the tracing.

Essentially you are wrong. The semantic of schedule_bug() is clearly
WARN() and not BUG(). So the tracing off qualifier needs to be
WARN. And it does not matter what you consider as the severity. The
severity is given by the semantics of schedule_bug().

If your extra stupid grub hiding logic prevents an user to change the
trace off level then you need to fix that instead of anything else.

BTW, if interacting with grub is that hard: how does an user start the
tracer at all ?

Thanks,

	tglx
--8323328-2004148899-1271375447=:3625--
