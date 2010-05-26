Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0EZRJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:09:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab0EZRJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:09:11 -0400
Date: Wed, 26 May 2010 10:08:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rostedt@goodmis.org
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       arnd@arndb.de, john.williams@petalogix.com, tglx@linutronix.de,
       peter.fritzsche@gmx.de, anton@samba.org, mingo@elte.hu
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead
 local_irq_save/restore
Message-Id: <20100526100805.171b3c48.akpm@linux-foundation.org>
In-Reply-To: <1274884963.22648.245.camel@gandalf.stny.rr.com>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>
	<1274863724-14906-2-git-send-email-monstr@monstr.eu>
	<1274884963.22648.245.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 10:42:43 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-05-26 at 10:48 +0200, monstr@monstr.eu wrote:
> > From: Michal Simek <monstr@monstr.eu>
> > 
> > start/stop_critical_timing function for preemptirqsoff, preemptoff
> > and irqsoff tracers contains atomic_inc and atomic_dec operations.
> > 
> > Atomic operations used local_irq_save/restore macros to ensure
> > atomic access but they are traced by the same function which is causing
> > recursion problem.
> > 
> > The reason is when these tracers are turn ON then local_irq_save/restore
> > macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
> > which call start/stop_critical_timing.
> > 
> > Microblaze was affected because use generic atomic implementation.
> > 
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 

Sighed-at-by: me.

> > diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> > index 058129e..6c190fd 100644
> > --- a/include/asm-generic/atomic.h
> > +++ b/include/asm-generic/atomic.h
> > @@ -57,11 +57,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
> >  	unsigned long flags;
> >  	int temp;
> >  
> > -	local_irq_save(flags);
> > +	raw_local_irq_save(flags);
> >  	temp = v->counter;
> >  	temp += i;
> >  	v->counter = temp;
> > -	local_irq_restore(flags);
> > +	raw_local_irq_restore(flags);
> >  
> >  	return temp;
> >  }

If a developer looks at atomic_add_return() and asks himself "why did
this use raw_local_irq_save()", the only way of answering that question
is to go groveling through the git logs, which is a right PITA if
you're trying to get some coding work done.

Guys, any time you add code which is non-obvious at the raw C level, it
*needs* a comment!
