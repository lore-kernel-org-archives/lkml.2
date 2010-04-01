Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0DAQbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897Ab0DAQbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:31:03 -0400
Date: Thu, 1 Apr 2010 18:00:08 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401160008.GS5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <1270137002.1598.65.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270137002.1598.65.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:50:02PM +0200, Peter Zijlstra wrote:
> You also seem to move the tlb_gather stuff around, we have patches in

Well that patchset is years old, there are much more recent patches to
move tlb_gather around so that it will happen after the mmu_notifier
invalidate calls. That is only relevant to allow mmu notifier handlers
to schedule.

> -rt that make tlb_gather preemptible, once i_mmap_lock is preemptible we
> can do in mainline too.

Ok. However just moving it inside the mmu notifier range calls won't
slowdown anything or reduce its effectiveness, either ways will be
fine with XPMEM. This is only XPMEM material and tlb_gather is the
trivial part of it. The hard part is to make those locks schedule
capable, and I'm sure XPMEM developers will greatly appreciate such a
change. I thought initially it had to be conditional to XPMEM=y but
maintaining two different locks is a bit of a pain (especially for
distros that wants to ship a single kernel) but as this effort
started, it'd provide some minor latency improvement in that 1msec
when a new virtual machine starts or when a new taks registers itself
to GRU or XPMEM device drivers. I'm personally fine to make these
either mutexes or rwsem unconditionally as you prefer.
