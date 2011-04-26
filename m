Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1DZVLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:11:04 -0400
Received: from mea1b5e42.tmodns.net ([66.94.27.234]:42976 "EHLO mail.tmail.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758184Ab1DZVLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:11:02 -0400
X-Greylist: delayed 5151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 17:11:02 EDT
Date: Tue, 26 Apr 2011 12:44:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110426194428.GA8029@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
 <20110423210539.GI2628@linux.vnet.ibm.com>
 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
 <20110424062728.GM2628@linux.vnet.ibm.com>
 <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
 <20110424164331.GN2628@linux.vnet.ibm.com>
 <1303812417.20212.239.camel@twins>
 <20110426113113.GH4308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426113113.GH4308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 04:31:13AM -0700, Paul E. McKenney wrote:
> On Tue, Apr 26, 2011 at 12:06:57PM +0200, Peter Zijlstra wrote:
> > On Sun, 2011-04-24 at 09:43 -0700, Paul E. McKenney wrote:
> > > 
> > > Peter, any thoughts on what I might have done wrong to get the scheduler
> > > into a state where it was ignoring a runnable realtime task? 
> > 
> > Not really, the only thing I can think of is something like poking at
> > task->state while its sleeping. One you set it to TASK_RUNNING wakeups
> > will be ignored since its already running ;-)
> 
> Well, that does give my something to check for -- thank you!

OK.  So I don't poke TASK_RUNNING into task->state, but I do poke
TASK_INTERRUPTIBLE into it via schedule_timeout_interruptible().
This happens without synchronization, and could run concurrently with
a wake_up() -- though from what I can see, if the task was running,
the wait queue would be empty, so nothing would happen.

However, Bruno's stack dump leads me to believe that the badness happened
while rcu_kthread was in schedule_timeout_interruptible().

So, is there something special I need to do for this case, where I
might have schedule_timeout_interruptible() concurrent with wake_up()
attempts?

						Thanx, Paul
