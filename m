Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2GVKHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 06:07:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2GVKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 06:07:37 -0400
Message-ID: <500BD0DD.3000309@redhat.com>
Date: Sun, 22 Jul 2012 13:07:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: CFS vs. cpufreq/cstates vs. latency
References: <50057565.7030405@redhat.com>
In-Reply-To: <50057565.7030405@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 05:23 PM, Rik van Riel wrote:
> While tracking down a latency issue with communication between
> KVM guests, we ran into a very interesting issue, an interplay
> of CFS and power saving code.
> 
> About 3/4 of the 230us latency came from CPUs waking up out of
> C-states. Disabling C states reduced the latency to 60us...
> 
> The issue? The communication is between various threads and
> processes, each of which last ran on a CPU that is now in a
> deeper C state. The total latency from that is "CPU wakeup
> latency * NR CPUs woken".
> 
> This problem could be common to many different multi-threaded
> or multi-process applications. It looks like something that
> would be fixable at the scheduler + cpufreq level.
> 
> Specifically, waking up some process requires that the CPU
> which is running the wakeup is already in C0 state. If the
> CPU on which the to-be-woken task ran last is in a deep C
> state, it may make sense to simply run the woken up task
> on the local CPU, not the CPU where it was originally.
> 
> I seem to remember some scheduling code that (for power
> saving reasons) tried running all the tasks on one CPU,
> until that CPU got busy, and then spilled over onto other
> CPUs.
> 
> I do not seem to be able to find that code in recent kernels,
> but I have the feeling that a policy like that (related to
> WAKE_AFFINE scheduling?) could improve this issue.
> 
> As an additional benefit, it has the possibility of further
> improving power saving.
> 
> What do the scheduler and cpufreq people think about this
> problem?
> 
> Any preferred ways to solve the "N * cpu wakeup latency"
> problem that is plaguing multi-process and multi-threaded
> workloads?

A few notes:

- if you go into deep C-state, it may be worthwhile to migrate all the
interrupts away from that cpu.  sysfs says C3 latency is 200 us on one
of my machines, if we go there we should migrate anything important away.

- I believe some of those C-states flush the cache, so executing on a
cpu that is has awoken from one of these states will be slow for a
while; needs to be taken into account.

- C1 state is listed as having 3 us latency.  If we're expecting a
wakeup soon and are sensitive to latency, it's better to spin for a bit
before sleeping.


-- 
error compiling committee.c: too many arguments to function


