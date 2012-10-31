Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935453Ab2JaLRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:17:04 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44834 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab2JaLRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:17:00 -0400
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: anish kumar <anish198519851985@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <1351622752.4004.21.camel@gandalf.local.home>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	 <1351622024.1504.13.camel@anish-Inspiron-N5050>
	 <1351622752.4004.21.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 20:06:26 +0900
Message-ID: <1351681586.1504.22.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 14:45 -0400, Steven Rostedt wrote:
> On Wed, 2012-10-31 at 03:33 +0900, anish kumar wrote:
> 
> > > CPU 0                                 CPU 1
> > > 
> > > data = something                     flags = IRQ_WORK_BUSY
> > > smp_mb() (implicit with cmpxchg      smp_mb()
> > >           on flags in claim)         execute_work (sees data from CPU
> > > 0)
> > > try to claim
> > > 
> > As I understand without the memory barrier proposed by you the situation
> > would be as below:
> > CPU 0                                 CPU 1
> >  
> > data = something                     flags = IRQ_WORK_BUSY
> > smp_mb() (implicit with cmpxchg      execute_work (sees data from CPU 0)
> >            on flags in claim)        
> > _success_ in claiming and goes
> 
> Correct, because it would see the stale value of flags.
> 
> > ahead and execute the work(wrong?)
> > 		                     cmpxchg cause flag to IRQ_WORK_BUSY
> > 
> > Now knows the flag==IRQ_WORK_BUSY
> >                                 
> > Am I right?
> 
> right.
> 
> > 
> > Probably a stupid question.Why do we return the bool from irq_work_queue
> > when no one bothers to check the return value?Wouldn't it be better if
> > this function is void as used by the users of this function or am I
> > looking at the wrong code.
> 
> Not a stupid question, as I was asking that to myself just earlier
> today. But forgot to mention it as well. Especially, because it makes it
> look like there's a bug in the code. Maybe someday someone will care if
> their work was finished by itself, or some other CPU.
> 
> Probably should just nix the return value.
Can I send a patch to fix this?
> 
> -- Steve
> 
> 


