Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2DZOcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:32:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58096 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2DZOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:32:15 -0400
Date: Thu, 26 Apr 2012 07:12:13 -0700
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
Message-ID: <20120426141213.GB2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444707.13683.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335444707.13683.14.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042614-7408-0000-0000-000004858383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:51:47PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Commit #0209f649 (rcu: limit rcu_node leaf-level fanout) set an upper
> > limit of 16 on the leaf-level fanout for the rcu_node tree.  This was
> > needed to reduce lock contention that was induced by the synchronization
> > of scheduling-clock interrupts, which was in turn needed to improve
> > energy efficiency for moderate-sized lightly loaded servers.
> > 
> > However, reducing the leaf-level fanout means that there are more
> > leaf-level rcu_node structures in the tree, which in turn means that
> > RCU's grace-period initialization incurs more cache misses.  This is
> > not a problem on moderate-sized servers with only a few tens of CPUs,
> > but becomes a major source of real-time latency spikes on systems with
> > many hundreds of CPUs.  In addition, the workloads running on these large
> > systems tend to be CPU-bound, which eliminates the energy-efficiency
> > advantages of synchronizing scheduling-clock interrupts.  Therefore,
> > these systems need maximal values for the rcu_node leaf-level fanout.
> > 
> > This commit addresses this problem by introducing a new kernel parameter
> > named RCU_FANOUT_LEAF that directly controls the leaf-level fanout.
> > This parameter defaults to 16 to handle the common case of a moderate
> > sized lightly loaded servers, but may be set higher on larger systems.
> 
> Wouldn't it be much better to match the rcu fanout tree to the physical
> topology of the machine?

>From what I am hearing, doing so requires me to morph the rcu_node tree
at run time.  I might eventually become courageous/inspired/senile
enough to try this, but not yet.  ;-)

Actually, some of this topology shifting seems to me like a firmware
bug.  Why not arrange the Linux-visible numbering in a way to promote
locality for code sequencing through the CPUs?

							Thanx, Paul

