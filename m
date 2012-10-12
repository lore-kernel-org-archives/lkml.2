Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab2JLOEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:04:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab2JLOEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:04:38 -0400
Message-ID: <50782344.3030209@redhat.com>
Date: Fri, 12 Oct 2012 10:03:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <dhillf@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Dan Smith <danms@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/33] autonuma: alloc/free/init task_autonuma
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com> <1349308275-2174-16-git-send-email-aarcange@redhat.com> <20121011155302.GA3317@csn.ul.ie> <50770314.7060800@redhat.com> <20121011175953.GT1818@redhat.com>
In-Reply-To: <20121011175953.GT1818@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 01:59 PM, Andrea Arcangeli wrote:
> On Thu, Oct 11, 2012 at 01:34:12PM -0400, Rik van Riel wrote:

>> That is indeed a future optimization I have suggested
>> in the past. Allocation of this struct could be deferred
>> until the first time knuma_scand unmaps pages from the
>> process to generate NUMA page faults.
>
> I already tried this, and quickly noticed that for mm_autonuma we
> can't, or we wouldn't have memory to queue the "mm" into knuma_scand
> in the first place.
>
> For task_autonuma we could, but then we wouldn't be able to inherit
> the task_autonuma->task_autonuma_nid across clone/fork which kind of
> makes sense to me (and it's done by default without knob at the
> moment). It's actually more important for clone than for fork but it
> might be good for fork too if it doesn't exec immediately.
>
> Another option is to move task_autonuma_nid in the task_structure
> (it's in the stack so it won't cost RAM). Then I probably can defer
> the task_autonuma if I remove the child_inheritance knob.
>
> In knuma_scand we don't have the task pointer, so task_autonuma would
> need to be allocated in the NUMA page faults, the first time it fires.

One thing that could be done is have the (few) mm and
task specific bits directly in the mm and task structs,
and have the sized-by-number-of-nodes statistics in
a separate numa_stats struct.

At that point, the numa_stats struct could be lazily
allocated, reducing the memory allocations at fork
time by 2 (and the frees at exit time, for short lived
processes).

-- 
All rights reversed
