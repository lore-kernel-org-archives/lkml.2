Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2DZQQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:16:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59850 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2DZQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:16:17 -0400
Date: Thu, 26 Apr 2012 09:15:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
Message-ID: <20120426161509.GE2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444707.13683.14.camel@twins>
 <20120426141213.GB2407@linux.vnet.ibm.com>
 <1335454137.13683.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335454137.13683.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042616-3352-0000-0000-0000044BFA37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 05:28:57PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 07:12 -0700, Paul E. McKenney wrote:
> > On Thu, Apr 26, 2012 at 02:51:47PM +0200, Peter Zijlstra wrote:
> 
> > > Wouldn't it be much better to match the rcu fanout tree to the physical
> > > topology of the machine?
> > 
> > From what I am hearing, doing so requires me to morph the rcu_node tree
> > at run time.  I might eventually become courageous/inspired/senile
> > enough to try this, but not yet.  ;-)
> 
> Yes, boot time with possibly some hotplug hooks.

Has anyone actually measured any slowdown due to the rcu_node structure
not matching the topology?  (But see also below.)

> > Actually, some of this topology shifting seems to me like a firmware
> > bug.  Why not arrange the Linux-visible numbering in a way to promote
> > locality for code sequencing through the CPUs?
> 
> I'm not sure.. but it seems well established on x86 to first enumerate
> the cores (thread 0) and then the sibling threads (thread 1) -- one
> 'advantage' is that if you boot with max_cpus=$half you get all cores
> instead of half the cores.
> 
> OTOH it does make linear iteration of the cpus 'funny' :-)

Like I said, firmware bug.  Seems like the fix should be there as well.
Perhaps there needs to be two CPU numberings, one for people wanting
whole cores and another for people who want cache locality.  Yes, this
could be confusing, but keep in mind that you are asking every kernel
subsystem to keep its own version of the cache-locality numbering,
and that will be even more confusing.

> Also, a fanout of 16 is nice when your machine doesn't have HT and has a
> 2^n core count, but some popular machines these days have 6/10 cores per
> socket, resulting in your fanout splitting caches.

That is easy.  Such systems can set CONFIG_RCU_FANOUT to 6, 12, 10,
or 20, depending on preference.  With a patch intended for 3.6, they
could set the smallest reasonable value at build time and adjust to
the hardware using the boot parameter.

http://www.gossamer-threads.com/lists/linux/kernel/1524864

I expect to make other similar changes over time, but will be proceeding
cautiously.

							Thanx, Paul

