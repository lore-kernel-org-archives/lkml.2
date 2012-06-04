Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab2FDPAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:00:53 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44140 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2FDPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:00:52 -0400
Date: Mon, 4 Jun 2012 20:30:40 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604150040.GD25126@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338801907.7356.163.camel@marge.simpson.net>
 <1338810796.28282.32.camel@twins>
 <1338814063.7356.192.camel@marge.simpson.net>
 <20120604130740.GC25126@linux.vnet.ibm.com>
 <1338820234.7356.250.camel@marge.simpson.net>
 <20120604143802.GB26651@linux.vnet.ibm.com>
 <1338820895.7356.252.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338820895.7356.252.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060415-8878-0000-0000-000002C591FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-06-04 16:41:35]:

> But high priority SCHED_OTHER tasks do not hog the CPU, they get their
> fair share as defined by the user.

Consider this case. System with 2 cores (each with 2 thread) and 3
cgroups :

	A (1024) -> has 2 tasks (A0, A1)
	B (2048) -> has 2 tasks (B0, B1)
	C (1024) -> has 1 tasks (C0 - pinned to CPUs 1,2)

(B0, B1) collectively are eligible to consume 2 full cpus worth of
bandwidth, (A0, A1) together are eligible to consume 1 full-cpu
worth of bandwidth and finally C0 is eligible to get 1 full-cpu worth of
bandwidth. 

Currently C0 is sleeping as a result of which tasks could be spread as:

	CPU0 -> A0
	CPU1 -> A1

	CPU2 -> B0
	CPU3 -> B1

Now C0 wakes up and lands on CPU2 (which was its prev_cpu).

	CPU0 -> A0
	CPU1 -> A1

	CPU2 -> B0, C0
	CPU3 -> B1

Ideally CPU1 needs to pull it C0 to itself (while A1 moves to CPU0). Do
you agree to that? I doubt that happens because of how CPU0 does load
balance on behalf of itself and CPU1 (and thus fails to pull C0 to its
core).

- vatsa

