Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab2J3Spz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:45:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab2J3Spy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:45:54 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPGaiRUHczgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=lC5Bz_El-uJzycyYwPkA:9 a=PUjeQqilurYA:10 a=7PVchbkP683bnDCq:21 a=y5vyED47RSmQPJ6s:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351622752.4004.21.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Steven Rostedt <rostedt@goodmis.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 14:45:52 -0400
In-Reply-To: <1351622024.1504.13.camel@anish-Inspiron-N5050>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	 <1351622024.1504.13.camel@anish-Inspiron-N5050>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 03:33 +0900, anish kumar wrote:

> > CPU 0                                 CPU 1
> > 
> > data = something                     flags = IRQ_WORK_BUSY
> > smp_mb() (implicit with cmpxchg      smp_mb()
> >           on flags in claim)         execute_work (sees data from CPU
> > 0)
> > try to claim
> > 
> As I understand without the memory barrier proposed by you the situation
> would be as below:
> CPU 0                                 CPU 1
>  
> data = something                     flags = IRQ_WORK_BUSY
> smp_mb() (implicit with cmpxchg      execute_work (sees data from CPU 0)
>            on flags in claim)        
> _success_ in claiming and goes

Correct, because it would see the stale value of flags.

> ahead and execute the work(wrong?)
> 		                     cmpxchg cause flag to IRQ_WORK_BUSY
> 
> Now knows the flag==IRQ_WORK_BUSY
>                                 
> Am I right?

right.

> 
> Probably a stupid question.Why do we return the bool from irq_work_queue
> when no one bothers to check the return value?Wouldn't it be better if
> this function is void as used by the users of this function or am I
> looking at the wrong code.

Not a stupid question, as I was asking that to myself just earlier
today. But forgot to mention it as well. Especially, because it makes it
look like there's a bug in the code. Maybe someday someone will care if
their work was finished by itself, or some other CPU.

Probably should just nix the return value.

-- Steve


