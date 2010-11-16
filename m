Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0KPQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:57:25 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:45925 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0KPQ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:57:22 -0500
Subject: Re: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time
 accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101113183810.GA9021@redhat.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.404670062@linux.vnet.ibm.com>
	 <20101113183810.GA9021@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Tue, 16 Nov 2010 17:57:15 +0100
Message-ID: <1289926635.1940.100.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Sat, 2010-11-13 at 19:38 +0100, Oleg Nesterov wrote:
> First of all, let me repeat, I am not going to discuss whether we need
> these changes or not, I do not know even if I understand your motivation.

Sorry, if I was not clear enough with my descriptions. Let me try to
describe my motivation again:

The cumulative accounting patch implements an infrastructure that makes
it possible to collect all CPU time usage between two task snapshots
without using task exit events. The main idea is to show cumulative CPU
time fields for each task in the top command that contain the CPU time
of children that died in the last interval.

Example 1 (simple case):
A "make" process forked several gcc processes after snapshot 1 and all
of them exited before snapshot 2. We subtract the cumulative CPU times
of "make" of snapshot 2 from the cumulative times of "make" of snapshot
1. The result will be the consumed CPU time of the dead gcc processes in
the last interval. The value is that we can see in top that "make" is
"responsible" for this CPU time.

Example 2:
We have the gcc processes in snapshot 1 but not in snapshot 2. Then the
top command has to find the nearest relative (e.g. the parent process)
that is still alive in snapshot 2, create the delta of the cumulative
time for this process and subtract the CPU time of the gcc processes of
snapshot 1. This gives you the CPU time that was consumed by the gcc
processes between snapshot 1 and 2.

With your help we identified two problems that make this approach
impossible or at least not exact with the current Linux implementation:
1. Cumulative CPU time counters are not complete (SA_NOCLDWAIT)
2. Because of reparent to init, there are situations where it is
   not clear to which tasks the CPU time of dead tasks between
   two snapshots has been accounted. This is a problem for example 2.

The patch tries to solve the problem by adding a second set of
cumulative data that contains all CPU time of dead children and adds the
parallel hierarchy to make it unambiguous which parent got the CPU time
of dead tasks (needed for example 2).

I hope that you understand now the value and the motivation of fixing
the two problems.

I know that new userspace APIs should be added with care and should be
avoided when the value of a new function is not big enough. I also can
understand the objections from Peter and your concerns. So is the value
of the new function big enough?

I will answer your other technical comments in a separate mail.

Michael

