Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0JLHt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:49:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33003 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab0JLHt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:49:26 -0400
Date: Tue, 12 Oct 2010 13:19:10 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 0/7] CFS Bandwidth Control
Message-ID: <20101012074910.GA9893@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Its been a while since we posted CPS hard limits (aka CFS bandwidth control
now) patches, hence a quick recap first:

- I have been working on CFS hard limits since last year and have posted
  a few versions of the same (last post: http://lkml.org/lkml/2010/1/5/44)
- Paul Turner and Nikhil Rao meanwhile started working on CFS bandwidth
  control and have posted a couple of versions.
  (last post v2: http://lwn.net/Articles/385055/)

Paul's approach mainly changed the way the CPU hard limit was represented. After
his post, I decided to work with them and discontinue my patch series since
their global bandwidth specification for group appears more flexible than
the RT-type per-cpu bandwidth specification I had in my series.

Since Paul seems to be busy, I am taking the freedom of posting the next
version of his patches with a few enhancements to the slack time handling.
(more on this later)

Main changes in this post:

- Return the unused and remaining local quota at each CPU to the global
  runtime pool.
- A few fixes:
	- Explicitly wake up the idle cpu during unthrottle.
	- Optimally handle throttling of current task within enqueue_task.
	- Fix compilation break with CONFIG_PREEMPT on.
	- Fix a compilation break at intermediate patch level.
- Applies on 2.6.36-rc7.

More about slack time issue
---------------------------
Bandwidth available to a group is specified by two parameters: cpu.cfs_quota_us
and cpu.cfs_period_us. cpu.cfs_quota_us is the max CPU time a group can
consume within the time period of cpu.cfs_period_us. The quota available
to a group within a period is maintained in a per-group global pool. In each
CPU, the consumption happens by obtaining a slice of this global pool.

If the local quota (obtained as slices of global pool) isn't fully consumed
within a given period, a group can potentially get more CPU time than
its allowed for in the next interval. This is due to the slack time that may
be left over from the previous interval. More details about how this is fixed
is present in the description part of patch 7/7. Here I will only show the
benefit of handling the slack time correctly through this experiment:

On a 16 CPU system, two different kinds of tasks were run as part of a group
which had quota/bandwidth as 500000/500000 [=> 500ms/500ms], which means that
the group was capped at 1CPU worth of time every period.

Type A task: Complete CPU hog.
Type B task: Sleeps for 500ms and runs as CPU hog for next 500ms. And this cycle
		repeats.

1 task of type A and 15 tasks of type B were run for 20s, each bound to a
different CPU. At the end of 20s, the CPU time obtained by each of them
looked like this:

-----------------------------------------------------------------------
			Without returning	Returning slack time
			slack time to global	to global pool
			pool			(with patch 7/7)
-----------------------------------------------------------------------
1 type A task		7.96s			10.71s
15 type B tasks		12.36s			9.79s
-----------------------------------------------------------------------

This shows the effects of slack time and the benefit of handling it correctly.

I request the scheduler maintainers and others for comments on these patches.

Regards,
Bharata.
