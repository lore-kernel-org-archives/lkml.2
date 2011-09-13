Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1IMQVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:21:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37684 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1IMQVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:21:50 -0400
Date: Tue, 13 Sep 2011 21:51:19 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913162119.GA3045@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1315423342.11101.25.camel@twins>
 <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <20110913050306.GB7254@linux.vnet.ibm.com>
 <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315922848.5977.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 16:07:28]:

> > > > This is perhaps not optimal (as it may lead to more lock contentions), but 
> > > > something to note for those who care for both capping and utilization in
> > > > equal measure!
> > > 
> > > You meant lock inversion, which leads to more idle time :-)
> > 
> > I think 'cfs_b->lock' contention would go up significantly when reducing
> > sysctl_sched_cfs_bandwidth_slice, while for something like 'balancing' lock 
> > (taken with SD_SERIALIZE set and more frequently when tuning down
> > max_interval?), yes it may increase idle time! Did you have any other
> > lock in mind when speaking of inversion?
> 
> I can't read it seems.. I thought you were talking about increasing the
> period,

Mm ..I brought up the increased lock contention with reference to this
experimental result that I posted earlier:

  > Tuning min_interval and max_interval of various sched_domains to 1
  > and also setting sched_cfs_bandwidth_slice_us to 500 does cut down idle
  > time further to 2.7%

Value of sched_cfs_bandwidth_slice_us was reduced from default of 5000us
to 500us, which (along with reduction of min/max interval) helped cut down
idle time further (3.9% -> 2.7%). I was commenting that this may not necessarily
be optimal (as for example low 'sched_cfs_bandwidth_slice_us' could result
in all cpus contending for cfs_b->lock very frequently).

> which increases the time you force a task to sleep that's holding locks etc..

Ideally all tasks should get capped at the same time, given that there is
a global pool from which everyone pulls bandwidth? So while one vcpu/task
(holding a lock) gets capped, other vcpus/tasks (that may want the same lock)
should ideally not be running for long after that, avoiding lock inversion
related problems you point out.

I guess that we may still run into that with current implementation ..
Basically global pool may have zero runtime left for current period,
forcing a vcpu/task to be throttled, while there is surplus runtime in
per-cpu pools, allowing some sibling vcpus/tasks to run for wee bit
more, leading to lock-inversion related problems (more idling). That
makes me think we can improve directed yield->capping interaction.
Essentially when the target task of directed yield is capped, can the
"yielding" task donate some of its bandwidth?

- vatsa
