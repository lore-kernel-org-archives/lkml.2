Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab1ANRsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:48:02 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33614 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab1ANRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:47:55 -0500
Date: Fri, 14 Jan 2011 23:17:41 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 2/4] sched: Add yield_to(task, preempt)
 functionality.
Message-ID: <20110114174741.GB28632@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20110114030209.53765a0a@annuminas.surriel.com>
 <20110114030357.03c3060a@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114030357.03c3060a@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 03:03:57AM -0500, Rik van Riel wrote:
> From: Mike Galbraith <efault@gmx.de>
> 
> Currently only implemented for fair class tasks.
> 
> Add a yield_to_task method() to the fair scheduling class. allowing the
> caller of yield_to() to accelerate another thread in it's thread group,
> task group.
> 
> Implemented via a scheduler hint, using cfs_rq->next to encourage the
> target being selected.  We can rely on pick_next_entity to keep things
> fair, so noone can accelerate a thread that has already used its fair
> share of CPU time.

If I recall correctly, one of the motivations for yield_to_task (rather than
a simple yield) was to avoid leaking bandwidth to other guests i.e we don't want
the remaining timeslice of spinning vcpu to be given away to other guests but
rather donate it to another (lock-holding) vcpu and thus retain the bandwidth
allocated to the guest.

I am not sure whether we are meeting that objective via this patch, as
lock-spinning vcpu would simply yield after setting next buddy to preferred
vcpu on target pcpu, thereby leaking some amount of bandwidth on the pcpu
where it is spinning. Would be nice to see what kind of fairness impact this 
has under heavy contention scenario.

- vatsa
