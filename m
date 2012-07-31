Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2GaPpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:45:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2GaPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:45:04 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=I5RZEMmPgckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=y2bZKhvoUKbeMOoiDqMA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343749502.27983.57.camel@gandalf.stny.rr.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Jul 2012 11:45:02 -0400
In-Reply-To: <20120731151808.GF2422@linux.vnet.ibm.com>
References: <20120724090330.GA9830@localhost>
	 <1343662752.3847.2.camel@fedora> <20120731120556.GB17252@localhost>
	 <1343741625.27983.39.camel@gandalf.stny.rr.com>
	 <20120731144453.GB2422@linux.vnet.ibm.com>
	 <1343746311.27983.52.camel@gandalf.stny.rr.com>
	 <1343746583.27983.55.camel@gandalf.stny.rr.com>
	 <20120731151808.GF2422@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 08:18 -0700, Paul E. McKenney wrote:
> On Tue, Jul 31, 2012 at 10:56:23AM -0400, Steven Rostedt wrote:
> > On Tue, 2012-07-31 at 10:51 -0400, Steven Rostedt wrote:
> > 
> > > > OK, I will bite.  How about using something like RCU_NONIDLE(), either
> > > > directly or open-coded, to make it a legal call site?
> > > 
> > > OK, then something like:
> > > 
> > > 	RCU_NONIDLE(max_data = task_uid(tsk));
> > > 
> > > would work when called normally or with idle?
> > > 
> > 
> > The comment above RCU_NONIDLE() says:
> > 
> > 	This macro may be used from process-level code only.
> > 
> > Although I'm not sure what a 'level' is. Do you mean process-context? If
> > so, then this will not work because it can be called from non process
> > level code (return from interrupt), or any interrupt that enables
> > interrupts.
> 
> Yep, process context.  It seems that I was naively expecting the
> calls in interrupt context to be covered by rcu_irq_enter() and
> rcu_irq_exit().  I take it that these calls are happening outside of
> the rcu_irq_enter()-protected region?

Yep, it is called by the same hooks that lockdep uses. TRACE_IRQS_ON
inside the irq handler in assembly.

-- Steve


