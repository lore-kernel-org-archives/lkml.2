Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0DVBUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:20:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46657 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754594Ab0DVBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:20:52 -0400
Date: Wed, 21 Apr 2010 21:20:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       davem@davemloft.net
Subject: Re: [patch 0/5] rcu head debugobjects
Message-ID: <20100422012049.GA32400@Krystal>
References: <20100417124837.536020244@efficios.com> <20100418004849.GD2876@linux.vnet.ibm.com> <20100421173145.GA6966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421173145.GA6966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:10:33 up 89 days,  3:47,  9 users,  load average: 0.01, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Apr 17, 2010 at 05:48:49PM -0700, Paul E. McKenney wrote:
> > On Sat, Apr 17, 2010 at 08:48:37AM -0400, Mathieu Desnoyers wrote:
> > > Here is a repost of the rcu head debugobjects patchset, with updated changelogs.
> > > 
> > > Paul, this would be ready to be integrated with the RCU patches.
> > 
> > Thank you, Mathieu, queued up for 2.6.35!
> 
> And testing got me the following debugobjects splat, which baffles me.
> My first thought was that one of the synchronize_rcu() variants was
> missing the init_rcu_head_on_stack(), but not so.  Then I started
> looking through the debugobjects code, and found the following:
> 
> 	static void debug_object_is_on_stack(void *addr, int onstack)
> 	{
> 		int is_on_stack;
> 		static int limit;
> 
> 		if (limit > 4)
> 			return;
> 
> This really confuses me.  We are using a static variable, but as
> near as I can tell, it is being guarded by a per-bucket lock:
> 
> 	raw_spin_lock_irqsave(&db->lock, flags);
> 
> If I understand correctly, this means that multiple CPUs might be
> concurrently updating the static variable "limit", which might in
> turn be causing the splat below.
> 
> Or am I missing something?

This "limit" static variable is really only a printk suppressor: it stops the
printk warning output after approximately 5 occurences (modulo racy increments).
But normally, it should not _cause_ a splat if there ain't any in the first
place.

Will send the fix in a following email.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
