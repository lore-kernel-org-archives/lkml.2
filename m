Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0IWROb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:14:31 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:55357 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0IWROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:14:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD4nm0xGGN6i/2dsb2JhbACiMXLHG4VBBA
Date: Thu, 23 Sep 2010 13:09:28 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100923170928.GB20365@Krystal>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal> <20100923153902.GD2825@redhat.com> <1285260731.26872.1436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1285260731.26872.1436.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:08:17 up 169 days,  2:59,  3 users,  load average: 0.49, 0.27,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-09-23 at 11:39 -0400, Jason Baron wrote:
> > On Thu, Sep 23, 2010 at 10:37:58AM -0400, Mathieu Desnoyers wrote:
> 
> > I was thinking about the rcu_read_lock/synchronize_rcu() for this race.
> > We can hold the rcu_read_lock() across the is_module_text_address()
> > check in the jump label code, and then we can do in module.c:
> > 
> > mod->module_init = NULL;
> > synchronize_rcu();
> > module_free(mod, mod->module_init);
> 
> Um, isn't that last call the same as:
> 
> 	module_free(mod, NULL); ?

Yes, this is incorrect (as I pointed out in my reply). We should do,
instead:

module_init = mod->module_init;
mod->module_init = NULL;
synchronize_rcu();
module_free(mod, module_init);

Thanks,

Mathieu

> 
> I'll spend some time looking at this too.
> 
> -- Steve
> 
> > .
> > .
> > .
> > 
> > or we could push the rcu_read_lock() further down into
> > is_module_address()?
> > 
> > thanks,
> > 
> > -Jason
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
