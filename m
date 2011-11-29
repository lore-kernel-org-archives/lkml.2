Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1K2Nen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:34:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1K2Nem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:34:42 -0500
Message-ID: <1322573615.2921.235.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Tue, 29 Nov 2011 14:33:35 +0100
In-Reply-To: <1322505327.2921.156.camel@twins>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1322484071.2921.115.camel@twins>
	 <20111128171513.GF2346@linux.vnet.ibm.com>
	 <1322504279.2921.154.camel@twins>
	 <20111128183124.GH2346@linux.vnet.ibm.com>
	 <1322505327.2921.156.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 19:35 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 10:31 -0800, Paul E. McKenney wrote:
> > >   local_irq_save(flags);
> > >   srcu_read_lock(&my_srcu_domain);
> > >   local_irq_restore(flags);
> > > 
> > > and
> > > 
> > >   local_irq_save(flags);
> > >   srcu_read_unlock(&my_srcu_domain);
> > >   local_irq_restore(flags)
> > > 
> > > Doesn't look to be too hard, or confusing.
> > 
> > Ah, OK, I was under the mistaken impression that lockdep would splat
> > if you did (for example) srcu_read_lock() in an exception handler and
> > srcu_read_unlock() in the context of the task that took the exception. 
> 
> I don't think it will, lockdep does very little actual validation on the
> RCU locks other than recording they're held. But if they do, the planned
> TODO item will get inversed.
> 
> Should be easy enough to test I guess.

OK, so I had me a little peek at lockdep and you're right, it will
complain.

Still uprobes can do:

  local_irq_save(flags);
  __srcu_read_lock(&mr_srcu_domain);
  local_irq_restore(flags);

However if you object to exposing the __srcu functions (which I can
understand) you could expose these two functions as
srcu_read_{,un}lock_raw() or so, to mirror the non-validation also found
in rcu_dereference_raw()


