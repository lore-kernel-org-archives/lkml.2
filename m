Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1KXR6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:58:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1KXR6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:58:11 -0500
Message-ID: <4ECE85A9.5070808@redhat.com>
Date: Thu, 24 Nov 2011 12:58:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: On numa interfaces and stuff
References: <1321541021.27735.64.camel@twins>
In-Reply-To: <1321541021.27735.64.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 09:43 AM, Peter Zijlstra wrote:

> The abstraction proposed is that of coupling threads (tasks) with
> virtual address ranges (vmas) and guaranteeing they are all located on
> the same node. This leaves the kernel in charge of where to place all
> that and gives it the freedom to move them around, as long as the
> threads and v-ranges stay together.

I believe this abstraction makes sense.

Programs that are small enough to fit in one NUMA node
do not need any modification, since the default could
just be to keep all memory and threads together.

With unmap & migrate-on-fault, we can make a reasonable
attempt at leaving behind the memory that is not part of
the working set if the programs running on one NUMA node
do not quite fit on that node memory-wise.

I expect we will always have some unbalance here, because
we cannot expect memory and CPU use for programs to correspond
in a predictable way.  Some small programs may use lots of
CPU, and some large memory programs may use less CPU.

> A typical use for this would be HPC where the compute threads and
> v-space want to stay on the node, but starting multiple jobs will allow
> the kernel to balance resources properly etc.
>
> Another use-case would be kvm/qemu like things where you group vcpus and
> v-space to provide virtual numa nodes to the guest OS.

Databases, Java and any other workload with long-running
workloads are a good candidate, too.

> I spoke to a number of people in Prague and PJT wanted to merge the task
> grouping the below does into cgroups, preferably the cpu controller I
> think. The advantage of doing so is that it removes a duplicate layer of
> accounting, the dis-advantage however is that it entangles it with the
> cpu-controller in that you might not want the threads you group to be
> scheduled differently etc. Also it would restrict the functionality to a
> cgroup enabled kernel only.
>
> AA mentioned wanting to run a pte scanner to dynamically find the numa
> distribution of tasks, although I think assigning them to a particular
> node and assuming they all end up there is simpler (and less overhead).


> If your application is large enough to not fit on a single node you've
> got to manually interfere anyway if you care about performance.

There are two cases here.

If the application is multi-threaded and needs more CPUs than
what are available on one NUMA node, using your APIs to bind
threads to memory areas is obviously the way to go.

For programs that do not use all their memory simultaneously
and do not use as many CPUs, unmap & migrate-on-fault may
well "catch" the working set on the same node where the threads
are running, leaving less used memory elsewhere.

> As to memory migration (and I think a comment in the below patch refers
> to it) we can unmap and lazy migrate on fault. Alternatively AA
> mentioned a background process that trickle migrates everything. I don't
> really like the latter option since it hides the work/overhead in yet
> another opaque kernel thread.

There's something to be said for both approaches.

On the one hand, doing unmap & migrate-on-fault with 2MB
pages could be slow. Especially if memory on the destination
side needs to be compacted/defragmented first!

Andrea and I talked about some ideas to reduce the latency
of compacting memory.  I will try those ideas out soon, to
see if they are realistic and make enough of a difference.

On the other hand, moving the memory that is not in the
working set is not only extra overhead, but it could even
be counter-productive, since it can take away space from
the memory that IS the working set.

Since most of the code will be the stuff that does the
actual mechanism of migration, we should be able to just
experiment with both for a while.

