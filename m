Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab2CIAdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:33:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:44578 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2CIAdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:33:11 -0500
Date: Fri, 9 Mar 2012 01:33:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
In-Reply-To: <1331241940.25686.502.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203090124160.2742@ionos>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>  <1331230991.25686.452.camel@gandalf.stny.rr.com>  <1331231287.11248.396.camel@twins>  <1331232159.25686.456.camel@gandalf.stny.rr.com>  <1331235579.11248.402.camel@twins>  <1331237441.25686.469.camel@gandalf.stny.rr.com>
  <1331238369.11248.426.camel@twins>  <1331240882.25686.499.camel@gandalf.stny.rr.com>  <1331241627.11248.430.camel@twins> <1331241940.25686.502.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Steven Rostedt wrote:

> On Thu, 2012-03-08 at 22:20 +0100, Peter Zijlstra wrote:
> 
> > Now put the thing on 2 cpus and both tasks can endlessly chase each
> > other's tail, no? 
> 
> How would this be different than what mainline does? When the lock is
> released, it will wake up the other task.

Nonsense. That code is not causing any headache in mainline simply
because the lock holder cannot be preempted. So the contention case
runs on different cpus. On RT the failure case is when the trylocker
preempts the lock holder, which cannot be moved to a different cpu due
to the implicit migrate disable. Aside of that cpu_relax() and ticket
locks are there for a reason. They allow the other cpu to make
progress instead of allowing the trylocking cpu to monopolize the
cache line forever.

The only case where mainline can fail is when a high prio task does a
mutex_trylock() loop and the mutex owner and the trylocker are pinned
on the same core. Though I have not yet found code like that, but I
have not looked too hard either :)

It's a simple RT problem, which has been there forever, but obviously
nobody did stress tests such code pathes on UP systems or if someone
did he was not able to trigger it. On SMP this was not a big issue
when task migration was almost always enabled. Due to the implicit
migrate disable withing spinlocked regions we just made it more likely
to happen.

Thanks,

	tglx
