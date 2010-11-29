Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0K2Q0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:26:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab0K2Q0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:26:18 -0500
Date: Mon, 29 Nov 2010 16:26:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frede_Feuerstein@gmx.net, Ingo Molnar <mingo@elte.hu>,
        603229@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Scheduler grouping failure; division by zero in
	select_task_rq_fair
Message-ID: <20101129162605.GH8695@decadent.org.uk>
References: <1290449310.3868.13.camel@localhost> <1290470134.6770.929.camel@localhost> <1290514638.3892.16.camel@localhost> <1290900814.3292.84.camel@localhost> <1290920436.4255.1025.camel@localhost> <1290975266.3292.316.camel@localhost> <1291031425.32004.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291031425.32004.16.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:50:25PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-11-28 at 20:14 +0000, Ben Hutchings wrote:
> 
> > [    0.856002] Pid: 2, comm: kthreadd Not tainted 2.6.32-5-amd64 #1 W1100z/2100z
> 
> What's in that kernel? is that simply the latest .32-stable?

No, we have quite a few backported driver features and some bug fixes
that aren't in stable yet.  No scheduler or topology changes except
reverting 669c55e9f99b90e46eaa0f98a67ec53d46dc969a for ABI reasons
(which I guess we don't actually need to do).

> > [    0.536554] CPU0 attaching sched-domain:
> > [    0.540004]  domain 0: span 0-1 level MC
> > [    0.548002]   groups: 0 1
> > [    0.560003]   domain 1: span 0-3 level NODE
> > [    0.568002]    groups:
> > [    0.574179] ERROR: domain->cpu_power not set
> > [    0.576002]
> > [    0.580002] ERROR: groups don't span domain->span
> > [    0.584004] CPU1 attaching sched-domain:
> > [    0.588007]  domain 0: span 0-1 level MC
> > [    0.596002]   groups: 1 0 (cpu_power = 1023)
> > [    0.612002] ERROR: parent span is not a superset of domain->span
> > [    0.616003]   domain 1: span 1-3 level CPU
> > [    0.624002]    groups: 1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
> > [    0.644003]    domain 2: span 0-3 level NODE
> > [    0.652004]     groups: 1-3 (cpu_power = 4096)
> > [    0.668002] ERROR: domain->cpu_power not set
> > [    0.672002]
> > [    0.676002] ERROR: groups don't span domain->span
> > [    0.680004] CPU2 attaching sched-domain:
> > [    0.684003]  domain 0: span 2-3 level MC
> > [    0.692003]   groups: 2 3
> > [    0.704003]   domain 1: span 1-3 level CPU
> > [    0.712003]    groups: 2-3 (cpu_power = 2048) 1 (cpu_power = 2048)
> > [    0.736003]    domain 2: span 0-3 level NODE
> > [    0.744003]     groups: 1-3 (cpu_power = 4096)
> > [    0.760003] ERROR: domain->cpu_power not set
> > [    0.764003]
> > [    0.768003] ERROR: groups don't span domain->span
> > [    0.772004] CPU3 attaching sched-domain:
> > [    0.776003]  domain 0: span 2-3 level MC
> > [    0.784003]   groups: 3 2
> > [    0.794183]   domain 1: span 1-3 level CPU
> > [    0.800003]    groups: 2-3 (cpu_power = 2048) 1 (cpu_power = 2048)
> > [    0.822183]    domain 2: span 0-3 level NODE
> > [    0.828003]     groups: 1-3 (cpu_power = 4096)
> > [    0.842180] ERROR: domain->cpu_power not set
> > [    0.844003]
> > [    0.848003] ERROR: groups don't span domain->span
> 
> Hrm that smells like the architecture topology setup is wrecked, looks
> like the NUMA setup is bonkers.
[...]

Right, that's what I thought.  Question is whether the topology setup
code should fix this up or whether the schedular init should (as it
appears to have done before 2.6.32).

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
