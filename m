Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0FYDml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 23:42:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49687 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0FYDmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 23:42:39 -0400
Date: Thu, 24 Jun 2010 20:42:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Friesen <chris.friesen@genband.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100625034236.GE2391@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621205128.GI2354@linux.vnet.ibm.com>
 <20100622212357.GA19670@redhat.com>
 <20100622221226.GP2290@linux.vnet.ibm.com>
 <20100623152421.GA8445@redhat.com>
 <20100624180726.GK2373@linux.vnet.ibm.com>
 <4C23A90A.9040303@genband.com>
 <20100624220007.GB21360@redhat.com>
 <m1sk4c7z4l.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sk4c7z4l.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 05:08:10PM -0700, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > On 06/24, Chris Friesen wrote:
> >>
> >> On 06/24/2010 12:07 PM, Paul E. McKenney wrote:
> >>
> >> > 3.	The thread-group leader might do pthread_exit(), removing itself
> >> > 	from the thread group -- and might do so while the hapless reader
> >> > 	is referencing that thread.
> >> >
> >> > 	But isn't this prohibited?  Or is it really legal to do a
> >> > 	pthread_create() to create a new thread and then have the
> >> > 	parent thread call pthread_exit()?  Not something I would
> >> > 	consider trying in my own code!  Well, I might, just to
> >> > 	be perverse, but...  ;-)
> >>
> >> I believe SUS allows the main thread to explicitly call pthread_exit(),
> >> leaving the other threads to run.  If the main() routine just returns
> >> then it implicitly calls exit().
> >
> > Correct.
> >
> > But, to clarify, if the main thread does pthread_exit() (sys_exit,
> > actually), it won't be removed from the group. It will be zombie
> > until all other threads exit.
> 
> That we don't cleanup that zombie leaders is unfortunate really, it
> means we have the entire de_thread special case.  But short fixing
> libpthread to not make bad assumptions there is little we can do about
> it really.

Keeping the zombie leaders does make at least one of the lockless
scan cases quite a bit simpler.  I think, anyway.

> I'm only half following this conversation.
> 
> If what we are looking for is a stable list_head that won't disappear
> on us we should be able to put one in sighand_struct or signal_struct
> (I forget which is which at the moment) and have a list_head that
> lives for the life of the longest living thread, and that won't get
> messed up by things like de_thread, and then next_thread could simply
> return NULL when we hit the end of the list.

Oleg did suggest this possibility, but there were complications that
I do not claim to fully understand.

						Thanx, Paul
