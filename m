Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab2FDPVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:21:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2FDPVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:21:31 -0400
Message-ID: <1338823271.28282.75.camel@twins>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 17:21:11 +0200
In-Reply-To: <20120604150040.GD25126@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
	 <1338814063.7356.192.camel@marge.simpson.net>
	 <20120604130740.GC25126@linux.vnet.ibm.com>
	 <1338820234.7356.250.camel@marge.simpson.net>
	 <20120604143802.GB26651@linux.vnet.ibm.com>
	 <1338820895.7356.252.camel@marge.simpson.net>
	 <20120604150040.GD25126@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 20:30 +0530, Srivatsa Vaddagiri wrote:
> * Mike Galbraith <efault@gmx.de> [2012-06-04 16:41:35]:
> 
> > But high priority SCHED_OTHER tasks do not hog the CPU, they get their
> > fair share as defined by the user.
> 
> Consider this case. System with 2 cores (each with 2 thread) and 3
> cgroups :
> 
> 	A (1024) -> has 2 tasks (A0, A1)
> 	B (2048) -> has 2 tasks (B0, B1)
> 	C (1024) -> has 1 tasks (C0 - pinned to CPUs 1,2)
> 
> (B0, B1) collectively are eligible to consume 2 full cpus worth of
> bandwidth, (A0, A1) together are eligible to consume 1 full-cpu
> worth of bandwidth and finally C0 is eligible to get 1 full-cpu worth of
> bandwidth. 

The much simpler way to say that is: 5 tasks, two of 512, 3 of 1024.

> Currently C0 is sleeping as a result of which tasks could be spread as:
> 
> 	CPU0 -> A0
> 	CPU1 -> A1
> 
> 	CPU2 -> B0
> 	CPU3 -> B1
> 
> Now C0 wakes up and lands on CPU2 (which was its prev_cpu).
> 
> 	CPU0 -> A0
> 	CPU1 -> A1
> 
> 	CPU2 -> B0, C0
> 	CPU3 -> B1

That's 512, 512, 2048, 1024.

> Ideally CPU1 needs to pull it C0 to itself (while A1 moves to CPU0). Do
> you agree to that? I doubt that happens because of how CPU0 does load
> balance on behalf of itself and CPU1 (and thus fails to pull C0 to its
> core).

Right, 0 can't pull C0 because of cpus_allowed, it can however pull B0,
resulting in: {A0, B0}:1536, {A1}:512, {C0}:1024, {B1}:1024, the next
balance pass of 1 will then pull A0, resulting in: {B0}:1024, {A0,
A1}:1024, {C0}:1024, {B1}:1024

And all is well again.

That is not to say you couldn't contrive a scenario where it would be
needed.. 
