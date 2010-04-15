Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0DOX1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:27:47 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:46750 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0DOX1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c/YorBra4DSSSLc7f44wQefhESC+eH+a9/svcFgTYle5DUxc3QcuQz+zK9JGI2ztZa
         9M4JiHdccZhWzgygJduyWXpSGt2xUeS+66EeRk75Q5I5wxQuA3hITxElmFb9dooFwyP3
         lLeYssziY4RGQCzmWMg0Ct2wQ8zYXzObxeEtQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
Date: Thu, 15 Apr 2010 16:27:45 -0700
X-Google-Sender-Auth: e26f655578a14811
Message-ID: <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 4:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 15 Apr 2010, Chase Douglas wrote:
>> On Thu, Apr 15, 2010 at 2:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Wed, Apr 14, 2010 at 12:20:16PM -0400, Chase Douglas wrote:
>> >> This change adds a tracing_off_event() call to stop tracing on schedule
>> >> bugs unless tracing_off=none was specified on the commandline.
>> >>
>> >> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> >> ---
>> >>  kernel/sched.c |    2 ++
>> >>  1 files changed, 2 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/kernel/sched.c b/kernel/sched.c
>> >> index 6af210a..439f036 100644
>> >> --- a/kernel/sched.c
>> >> +++ b/kernel/sched.c
>> >> @@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
>> >>  {
>> >>       struct pt_regs *regs = get_irq_regs();
>> >>
>> >> +     tracing_off_event(TRACE_EVENT_BUG);
>> >> +
>> >>       printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
>> >>               prev->comm, prev->pid, preempt_count());
>> >
>> >
>> >
>> > I would rather call that a TRACE_EVENT_WARN as this is what happens: we
>> > warn but we continue.
>>
>> I tend to think of the TRACE_EVENT_* as an indication of severity and
>> whether we want to stop the trace by default. From a distro
>> standpoint, the likelihood that we want to continue tracing after a
>> __schedule_bug is pretty low. It's easiest if we don't have to tell
>
> Well, scheduling while atomic is a BUG, but one of the category which
> allows the kernel to continue. So in fact it's treated like a WARN_ON.
> So the tracing_off_event() qualifier should be *_WARN.
>
> That's independent of the question whether you want to stop tracing in
> that very case. Though I agree that the tracer should stop here.

We seem to be agreeing on the functionality. The disagreement seems to
be in the macro name/functionality mapping. However, the name of the
function itself is *_bug. I don't see how things are clearer or more
useful by inserting a *_WARN level macro in a *_bug named function.

Essentially, it makes more sense to me for the macro to represent the
severity of the case, and not be coupled somehow to what the kernel
decides to do outside of the tracing.

Is it the case that you really feel it should be *_WARN, or that the
macro name/functionality should be different?

-- Chase
