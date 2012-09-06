Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2IFRsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:48:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:49642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab2IFRsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:48:24 -0400
Message-ID: <1346953576.18408.52.camel@twins>
Subject: Re: [PATCH tip/core/rcu 07/23] rcu: Provide OOM handler to motivate
 lazy RCU callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 19:46:16 +0200
In-Reply-To: <20120906174112.GL2448@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346939197.18408.10.camel@twins>
	 <1346939573.1680.18.camel@gandalf.local.home>
	 <20120906174112.GL2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 10:41 -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 09:52:53AM -0400, Steven Rostedt wrote:
> > On Thu, 2012-09-06 at 15:46 +0200, Peter Zijlstra wrote:
> > > On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > > > +       get_online_cpus();
> > > > +       for_each_online_cpu(cpu)
> > > > +               for_each_rcu_flavor(rsp)
> > > > +                       smp_call_function_single(cpu, rcu_oom_notify_cpu,
> > > > +                                                rsp, 1);
> > > > +       put_online_cpus(); 
> > > 
> > > I guess blasting IPIs around is better than OOM but still.. do you
> > > really need to wait for each cpu individually, or would a construct
> > > using on_each_cpu() be possible, or better yet, on_each_cpu_cond()?
> 
> I rejected on_each_cpu_cond() because it disables preemption across
> a scan of all CPUs.  Probably need to fix that at some point...

It would be rather straight fwd to make a variant that does
get_online_cpus() though.. but even then there's smp_call_function()
that does a broadcast, avoiding the need to spray individual IPIs and
wait for each CPU individually.
