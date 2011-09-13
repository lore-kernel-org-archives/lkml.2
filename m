Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1IMRmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:42:02 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56174 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab1IMRl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:41:58 -0400
Date: Tue, 13 Sep 2011 23:11:50 +0530
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
Message-ID: <20110913174150.GA3062@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <20110913050306.GB7254@linux.vnet.ibm.com>
 <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931591.5977.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315931591.5977.26.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 18:33:09]:

> On Tue, 2011-09-13 at 21:51 +0530, Srivatsa Vaddagiri wrote:
> > > which increases the time you force a task to sleep that's holding locks etc..
> > 
> > Ideally all tasks should get capped at the same time, given that there is
> > a global pool from which everyone pulls bandwidth? So while one vcpu/task
> > (holding a lock) gets capped, other vcpus/tasks (that may want the same lock)
> > should ideally not be running for long after that, avoiding lock inversion
> > related problems you point out.
> 
> No this simply cannot be true.. You force groups to sleep so that other
> groups can run, right? Therefore shared kernel locks will cause
> inversion.

Ah ..shared locks of "host" kernel ..true ..that can still cause
lock-inversion yes.

I had in mind user-space (or "guest" kernel) locks - which can't get inverted 
that easily (one of cgroup's tasks wanting a "userspace" lock which is held by 
another "throttled" task of same cgroup - causing a inversion problem of sorts).
My point was that once a task gets throttled, other sibling tasks should get 
throttled almost immediately after that (given that bandwidth for a cgroup is 
maintained in a global pool from which everyone draws in "small" increments) - 
so a task that gets capped while holding a user-space lock should not
result in other sibling tasks going too much hungry on held locks within the
same period?

> You cannot put both groups to sleep and still expect a utilization of
> 100%.
> 
> Simple example, some task in group A owns the i_mutex of a file, group A
> runs out of time and gets dequeued. Some other task in group B needs
> that same i_mutex.
> 
> > I guess that we may still run into that with current implementation ..
> > Basically global pool may have zero runtime left for current period,
> > forcing a vcpu/task to be throttled, while there is surplus runtime in
> > per-cpu pools, allowing some sibling vcpus/tasks to run for wee bit
> > more, leading to lock-inversion related problems (more idling). That
> > makes me think we can improve directed yield->capping interaction.
> > Essentially when the target task of directed yield is capped, can the
> > "yielding" task donate some of its bandwidth? 
> 
> What moron ever calls yield anyway?

I meant directed yield (yield_to) ..which is used by KVM when it detects 
pause-loops. Essentially, a vcpu spinning in guest-kernel context for too long 
leading to PLE (Pasue-Loop-Exit), which leads to KVM driver doing a directed 
yield to another sibling vcpu ..so the target of directed yield may be a
capped vcpu task, in which case was wondering if directed yield can donate
bit of bandwidth to the throttled task. Again going by what I said earlier about
tasks getting capped more or less at same time, this should occur very 
infrequently ...something for me to test and find out nevertheless!

> If you use yield you're doing it wrong!
