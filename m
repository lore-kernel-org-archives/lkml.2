Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2HTMTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:19:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HTMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:19:04 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=y0_T5Fz-FGAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=994DCJuXJMUA:10 a=meVymXHHAAAA:8 a=dwFNnNmXbK1BhcQX3tUA:9 a=PUjeQqilurYA:10 a=cqGl5H8raEjWh4QT:21 a=IXpSASqRhuCE2s0g:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345465141.5069.0.camel@gandalf.local.home>
Subject: Re: lockdep trace from posix timers
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, dhowells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 08:19:01 -0400
In-Reply-To: <1345463458.23018.37.camel@twins>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <1345463458.23018.37.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 13:50 +0200, Peter Zijlstra wrote:
> On Mon, 2012-08-20 at 13:44 +0200, Peter Zijlstra wrote:
> >  int
> > +task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
> >  {
> > +       struct callback_head **head = &task->task_works;
> > +       struct callback_head *entry, *old_entry;
> > +
> > +       entry = &head;
> 
> My compiler just alerted me that: 
> 
> 	entry = *head; 
> 
> works a lot better..
> 
> > +       for (;;) {
> > +               if (entry == &dead)

But your compiler likes "entry == &dead"? ;-)

-- Steve

> > +                       return -ESRCH;
> > +
> > +               old_entry = entry;
> > +               work->next = entry;
> > +               entry = cmpxchg(head, old_entry, work);
> > +               if (entry == old_entry)
> > +                       break;
> > +       }
> >  
> >         /* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
> >         if (notify)
> >                 set_notify_resume(task);
> > +
> >         return 0;
> >  } 


