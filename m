Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0I3Nrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:47:46 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:54321 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab0I3Nro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:47:44 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100929191916.21E1840038@magilla.sf.frob.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250541.1837.95.camel@holzheu-laptop>
	 <20100923171025.GA26623@redhat.com>
	 <1285330688.2179.305.camel@holzheu-laptop>
	 <20100926181127.GA26985@redhat.com>
	 <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	 <20100927165133.GA23535@redhat.com>
	 <20100929191916.21E1840038@magilla.sf.frob.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 30 Sep 2010 15:47:40 +0200
Message-ID: <1285854460.1856.14.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,

On Wed, 2010-09-29 at 12:19 -0700, Roland McGrath wrote: 
> > > I would consider it to be a BUG() that the time is not accounted.
> > > Independent of the fact that a parent wants to see the SIGCHLD and
> > > the exit status of its child the process time of the child should be
> > > accounted, no?
> > 
> > I do not know. It doesn't look like a BUG(), I mean it looks as if
> > the code was intentionally written this way.
> 
> POSIX specifies this behavior: "If the child is never waited for (for
> example, if the parent has SA_NOCLDWAIT set or sets SIGCHLD to SIG_IGN),
> the resource information for the child process is discarded and not
> included in the resource information provided by getrusage()."

Thanks! That information was missing! Although still for me it not seems
to be a good decision to do it that way. Because of that it currently is
not possible to evaluate all consumed CPU time by looking at the current
processes. Time can simply disappear.

What about adding a new set of CPU time fields (e.g. cr-times) for the
cumulative "autoreap" children times to the signal struct and export
them via taskstats?

Then the following set of CPU times will give a complete picture (I also
added steal time (st) that is currently not accounted in Linux per
task):

* task->(u/s/st-time):
  Time that has been consumed by task itself

* task->signal->(c-u/s/st-time):
  Time that has been consumed by dead children of process where parent
  has done a sys_wait()

* task->signal->(u/s/st-time):
  Time that has been consumed by dead threads of thread group of process
  - NEW: Has to be exported via taskstats

* task->signal->(cr-u/s/st-time):
  Time that has been consumed by dead children that reaped 
  themselves, because parent ignored SIGCHLD or has set SA_NOCLDWAIT
  - NEW: Fields have to be added to signal struct
  - NEW: Has to be exported via taskstats

Michael

