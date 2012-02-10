Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2BJReU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:34:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34211 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab2BJReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:34:16 -0500
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paul@paulmenage.org, rjw@sisk.pl, tj@kernel.org,
        frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20120210165338.GI2458@linux.vnet.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
	 <1328671335.2482.72.camel@laptop> <4F32174E.2050207@linux.vnet.ibm.com>
	 <20120209075701.GE18387@elte.hu> <4F3386E9.7090606@linux.vnet.ibm.com>
	 <20120209151158.GA22489@elte.hu> <1328889127.25989.14.camel@laptop>
	 <20120210165338.GI2458@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 18:34:04 +0100
Message-ID: <1328895244.25989.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 08:53 -0800, Paul E. McKenney wrote:
> On Fri, Feb 10, 2012 at 04:52:07PM +0100, Peter Zijlstra wrote:
> > On Thu, 2012-02-09 at 16:11 +0100, Ingo Molnar wrote:
> > 
> > > > My understanding of the code is that when a CPU is taken 
> > > > offline, it is removed from all the cpusets and then the 
> > > > scan_for_empty_cpusets() function is run to move tasks from 
> > > > empty cpusets to their parent cpusets.
> > > 
> > > Why is that done that way? offlining a CPU should be an 
> > > invariant as far as cpusets are concerned.
> > 
> > Can't, tasks need to run someplace. There's two choices, add a still
> > online cpu to the now empty cpuset or move the tasks to a parent that
> > still has online cpus.
> > 
> > Both are destructive.
> 
> OK, I will ask the stupid question...  Hey, somebody has to!  ;-)
> 
> Would it make sense for offlining the last CPU in a cpuset to be
> destructive, but to allow offlining of a non-last CPU to be reversible?

No, that's very inconsistent and will lead to way more 'surprises'. 

> /me ducks.  ;-)

/me quacks ;-)

Now the whole problem here seems to be that suspend uses cpu-hotplug to
reduce the machine to UP -- I've no clue why it does that but I can
imagine its because the BIOS calls only work on CPU0 and/or the resume
only wakes CPU0 so you have to bootstrap the SMP thing again..

Some suspend person wanna clarify? Rafael?

Anyway, the whole suspend case is magic anyway since all tasks will have
been frozen, so we could simply leave all of cpuset alone and ignore the
hotplug notifier on CPU_TASKS_FROZEN callbacks, hmm?

Do we unfreeze after we bring up the machine again?

