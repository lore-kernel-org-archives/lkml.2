Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2GaPKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:10:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51616 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab2GaPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:10:11 -0400
Date: Tue, 31 Jul 2012 08:00:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
Message-ID: <20120731150053.GE2422@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120724090330.GA9830@localhost>
 <1343662752.3847.2.camel@fedora>
 <20120731120556.GB17252@localhost>
 <1343741625.27983.39.camel@gandalf.stny.rr.com>
 <20120731144453.GB2422@linux.vnet.ibm.com>
 <1343746311.27983.52.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343746311.27983.52.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073115-7182-0000-0000-0000021D3C77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:51:51AM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 07:44 -0700, Paul E. McKenney wrote:
> 
> > > Found it (and Cc'd David).
> > > 
> > > In __update_max_tr() we have:
> > > 
> > > 	max_data = task_uid(tsk);
> > > 
> > > where task_uid() is:
> > > 
> > > #define task_uid(task)		(task_cred_xxx((task), uid))
> > > 
> > > #define task_cred_xxx(task, xxx)			\
> > > ({							\
> > > 	__typeof__(((struct cred *)NULL)->xxx) ___val;	\
> > > 	rcu_read_lock();				\
> > > 	___val = __task_cred((task))->xxx;		\
> > > 	rcu_read_unlock();				\
> > > 	___val;						\
> > > })
> > > 
> > > The __update_max_tr() is called at every location interrupts are enabled
> > > (and a max time is discovered). But now this can include places that
> > > rcu_read_lock can not be called, I'm not sure how to handle this. Is
> > > there a non rcu way to get a tasks uid?
> > 
> > OK, I will bite.  How about using something like RCU_NONIDLE(), either
> > directly or open-coded, to make it a legal call site?
> 
> OK, then something like:
> 
> 	RCU_NONIDLE(max_data = task_uid(tsk));
> 
> would work when called normally or with idle?

As long as you don't nest too deeply, both.  There are seven bits for
the count, so you would have to nest quite deeply for there to be
a problem.  And I can safely add several more bits if needed.

							Thanx, Paul

