Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab0FYJ54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:57:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0FYJ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:57:54 -0400
Date: Fri, 25 Jun 2010 11:55:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100625095548.GA6292@redhat.com>
References: <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com> <20100624215702.GA21360@redhat.com> <20100625034105.GD2391@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625034105.GD2391@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Paul E. McKenney wrote:
>
> On Thu, Jun 24, 2010 at 11:57:02PM +0200, Oleg Nesterov wrote:
> > On 06/24, Paul E. McKenney wrote:
> > >
> > > 4.	Some other thread might do pthread_exit(), removing itself
> > > 	from the thread group, and again might do so while the hapless
> > > 	reader is referencing that thread.  In this case, we want
> > > 	the hapless reader to continue scanning the remainder of the
> > > 	thread group.
> >
> > Yes.
> >
> > But, if that thread was used as a starting point g, then
> >
> > 	before the patch:	loop forever
> > 	after the patch:	break
>
> So it is OK to skip some of the other threads in this case, even
> though they were present throughout the whole procedure?

I think, yes. We can miss them in any case, they can go away before
while_each_thread(g, t) starts the scan.

If g == group_leader (old or new), then we should notice this thread
at least.

Otherwise we can miss them all, with or without next_thread_careful().

Oleg.

