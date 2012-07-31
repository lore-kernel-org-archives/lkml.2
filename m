Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2GaSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:06:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2GaSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:06:42 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=I5RZEMmPgckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=mkhFjgIERGt2ff7qgW8A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343758001.27983.66.camel@gandalf.stny.rr.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Jul 2012 14:06:41 -0400
In-Reply-To: <20120731174440.GM2422@linux.vnet.ibm.com>
References: <1343662752.3847.2.camel@fedora>
	 <20120731120556.GB17252@localhost>
	 <1343741625.27983.39.camel@gandalf.stny.rr.com>
	 <20120731144453.GB2422@linux.vnet.ibm.com>
	 <1343746311.27983.52.camel@gandalf.stny.rr.com>
	 <1343746583.27983.55.camel@gandalf.stny.rr.com>
	 <20120731151808.GF2422@linux.vnet.ibm.com>
	 <1343749502.27983.57.camel@gandalf.stny.rr.com>
	 <20120731171733.GK2422@linux.vnet.ibm.com>
	 <1343755497.27983.59.camel@gandalf.stny.rr.com>
	 <20120731174440.GM2422@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 10:44 -0700, Paul E. McKenney wrote:

> OK, I interpret this as excluding NMI handlers, but please let me
> know if I am still being naive.  ;-)
> 

You are correct. This is only called where lockdep is called (to trace
enabling of IRQS). Note, that its called before normal irqs are actually
enabled (interrupts are still disabled), this is why it's called outside
of the in_irq() sections, because it is called just before returning
back to process context.

That said, because NMIs are so difficult, lockdep doesn't record the
disabling (and then enabling) of interrupts when an NMI triggers. Thus,
the irqsoff tracer also does not record NMIs. Which is fine, because
NMIs should not take long to run (we can add other mechanisms to time
NMI length if that is needed), and NMIs should not be enabling
interrupts nor taking any locks.

>From arch/x86/kernel/entry_64.S:

	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */

-- Steve


