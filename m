Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905Ab2JaNv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:51:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628Ab2JaNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:51:57 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPGaiRUHczgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=Zb1TR0gF99nHc721YnAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351691516.4004.80.camel@gandalf.local.home>
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
Date: Wed, 31 Oct 2012 09:51:56 -0400
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

> > This now does:
> > 
> > 	CPU 1					CPU 2
> > 	-----					-----
> > 	(flags = 0)
> > 	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
> > 	(flags = 3)
> > 	[...]

We can still add here:

						(fetch flags)

> > 	xchg(&flags, IRQ_WORK_BUSY)
> > 	(flags = 2)
> > 	func()
> > 						oflags = cmpxchg(&flags, flags, nflags);

Then the cmpxchg() would fail, and oflags would be 2

> > 						(sees flags = 2)
> > 						if (flags & IRQ_WORK_PENDING)

This should be:
						  if (oflags & IRQ_WORK_PENDING)


> > 							(not true)
> > 						(loop)						
> > 	cmpxchg(flags, 2, 0);
> > 	(flags = 2)

This should be:
	  (flags = 0)
as we described the previous cmpxchg() as failing, flags would still be
2 before this cmpxchg(), and this one would succeed.

-- Steve

> > 						flags = 3
> > 
> > 
> > 


