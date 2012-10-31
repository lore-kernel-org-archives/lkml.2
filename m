Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2JaM7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:59:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2JaM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:59:53 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPGaiRUHczgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=17K8tnSt_0aWmJMz494A:9 a=PUjeQqilurYA:10 a=gqFzjmDl287Zmvrk:21 a=VD62QCmyVRcDgKrC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351688390.4004.74.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Steven Rostedt <rostedt@goodmis.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 31 Oct 2012 08:59:50 -0400
In-Reply-To: <1351681467.1504.20.camel@anish-Inspiron-N5050>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	 <1351622024.1504.13.camel@anish-Inspiron-N5050>
	 <CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
	 <1351650181.4004.70.camel@gandalf.local.home>
	 <1351681467.1504.20.camel@anish-Inspiron-N5050>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 20:04 +0900, anish kumar wrote:

> > /*
> >  * Claim the entry so that no one else will poke at it.
> >  */
> > static bool irq_work_claim(struct irq_work *work)
> > {
> > 	unsigned long flags, nflags;
> > 
> > 	for (;;) {
> > 		flags = work->flags;
> > 		if (flags & IRQ_WORK_PENDING)
> > 			return false;
> > 		nflags = flags | IRQ_WORK_FLAGS;
> nflags = 1 | 3
> nflags = 2 | 3
> In both cases the result would be same.If I am right then wouldn't this
> operation be redundant?

Right. Actually we could change the new loop to:

	for (;;) {
		oflags = cmpxchg(&work->flags, flags, IRQ_WORK_FLAGS);
		if (oflags == flags)
			break;
		if (oflags & IRQ_WORK_PENDING)
			return false;
		flags = oflags;
		cpu_relax();
	}


> > 		if (cmpxchg(&work->flags, flags, nflags) == flags)
> > 			break;
> > 		cpu_relax();
> > 	}
> > 
> > 	return true;
> > }
> > 


> > 
> > This now does:
> > 
> > 	CPU 1					CPU 2
> > 	-----					-----
> > 	(flags = 0)
> > 	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
> > 	(flags = 3)
> > 	[...]
> > 	xchg(&flags, IRQ_WORK_BUSY)
> > 	(flags = 2)
> > 	func()
> > 						oflags = cmpxchg(&flags, flags, nflags);
> > 						(sees flags = 2)
> > 						if (flags & IRQ_WORK_PENDING)
> > 							(not true)
> > 						(loop)						
> > 	cmpxchg(flags, 2, 0);
> > 	(flags = 2)
> > 						flags = 3
> > 
> > 
> > 
> > With both patch 1 and 2 you fixed the bug.
> This is the best explanation anyone can put forward for this problem.

Frederic,

Would you like to add my explanation to your change log? You can add the
entire thing, which I think would explain a lot to people.

Thanks,

-- Steve


