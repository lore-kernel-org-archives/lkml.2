Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0F1XoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:44:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43939 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0F1XoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:44:00 -0400
Date: Mon, 28 Jun 2010 16:43:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100628234358.GJ2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621205128.GI2354@linux.vnet.ibm.com>
 <20100622212357.GA19670@redhat.com>
 <20100622221226.GP2290@linux.vnet.ibm.com>
 <20100623152421.GA8445@redhat.com>
 <20100624180726.GK2373@linux.vnet.ibm.com>
 <20100624215702.GA21360@redhat.com>
 <20100625034105.GD2391@linux.vnet.ibm.com>
 <20100625095548.GA6292@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625095548.GA6292@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 11:55:48AM +0200, Oleg Nesterov wrote:
> On 06/24, Paul E. McKenney wrote:
> >
> > On Thu, Jun 24, 2010 at 11:57:02PM +0200, Oleg Nesterov wrote:
> > > On 06/24, Paul E. McKenney wrote:
> > > >
> > > > 4.	Some other thread might do pthread_exit(), removing itself
> > > > 	from the thread group, and again might do so while the hapless
> > > > 	reader is referencing that thread.  In this case, we want
> > > > 	the hapless reader to continue scanning the remainder of the
> > > > 	thread group.
> > >
> > > Yes.
> > >
> > > But, if that thread was used as a starting point g, then
> > >
> > > 	before the patch:	loop forever
> > > 	after the patch:	break
> >
> > So it is OK to skip some of the other threads in this case, even
> > though they were present throughout the whole procedure?
> 
> I think, yes. We can miss them in any case, they can go away before
> while_each_thread(g, t) starts the scan.
> 
> If g == group_leader (old or new), then we should notice this thread
> at least.
> 
> Otherwise we can miss them all, with or without next_thread_careful().

Just to be sure that we are actually talking about the same scenario...

Suppose that a task group is lead by 2908 and has member 2909, 2910,
2911, and 2912.  Suppose that 2910 does pthread_exit() just as some
other task is "ls"ing the relevant /proc entry.  Is it really OK for
"ls" to show 2909 but not 2911 and 2912, even though 2911 and 2912
were alive and kicking the entire time?

							Thanx, Paul
