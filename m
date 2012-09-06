Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2IFWIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:08:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48818 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2IFWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:08:49 -0400
Date: Thu, 6 Sep 2012 15:08:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep WARNING on check_critical_timing()
Message-ID: <20120906220821.GO2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120905015937.GA20175@localhost>
 <1346965229.1680.48.camel@gandalf.local.home>
 <20120906212914.GE2448@linux.vnet.ibm.com>
 <1346968599.1680.55.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346968599.1680.55.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090622-7408-0000-0000-00000844901D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:56:39PM -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 14:29 -0700, Paul E. McKenney wrote:
> >  
> > > Didn't we talk about having the rcu_dereference_raw() not do the check?
> > > The function tracer is just too invasive to add work arounds to prevent
> > > lockdep from screaming about it.
> > 
> > Actually, rcu_dereference_raw() is already supposed to bypass the
> > lockdep checks.  And the code looks to me like it does the bypass,
> > OR-ing "1" into the asssertion condition.
> > 
> > So what am I missing here?
> 
> >From my tree, I see:
> 
> #define rcu_dereference_raw(p) rcu_dereference_check(p, 1)
> 
> #define rcu_dereference_check(p, c) \
> 	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
> 
> Note the 'c' comes after rcu_read_lock_held()
> 
> static inline int rcu_read_lock_held(void)
> {
> 	if (!debug_lockdep_rcu_enabled())
> 		return 1;
> 	if (rcu_is_cpu_idle())
> 		return 0;
> 	if (!rcu_lockdep_current_cpu_online())
> 		return 0;
> 	return lock_is_held(&rcu_lock_map);
> }
> 
> Then when lock_is_held() is called, we get the false warning message.

OK, I can easily do:

	__rcu_dereference_check((p), (c) || rcu_read_lock_held(), __rcu)

But I am still missing why the order matters.  Are you saying that
lock_is_held() itself is doing the splat?

							Thanx, Paul

