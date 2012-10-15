Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2JOOfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:35:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49874 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2JOOfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:35:32 -0400
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
In-Reply-To: <507BFD2C.3010808@linux.vnet.ibm.com>
References: <20120921120000.27611.71321.sendpatchset@codeblue>
	 <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com>
	 <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com>
	 <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com>
	 <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins>
	 <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com>
	 <1349837987.5551.182.camel@oc6622382223.ibm.com>
	 <5075B63C.5030603@linux.vnet.ibm.com>
	 <1349897783.22418.15.camel@oc2024037011.ibm.com>
	 <507BFD2C.3010808@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Oct 2012 09:34:55 -0500
Message-ID: <1350311695.22418.86.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101514-5930-0000-0000-00000D167055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 17:40 +0530, Raghavendra K T wrote:
> On 10/11/2012 01:06 AM, Andrew Theurer wrote:
> > On Wed, 2012-10-10 at 23:24 +0530, Raghavendra K T wrote:
> >> On 10/10/2012 08:29 AM, Andrew Theurer wrote:
> >>> On Wed, 2012-10-10 at 00:21 +0530, Raghavendra K T wrote:
> >>>> * Avi Kivity <avi@redhat.com> [2012-10-04 17:00:28]:
> >>>>
> >>>>> On 10/04/2012 03:07 PM, Peter Zijlstra wrote:
> >>>>>> On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
> >>>>>>>
> [...]
> >>> A big concern I have (if this is 1x overcommit) for ebizzy is that it
> >>> has just terrible scalability to begin with.  I do not think we should
> >>> try to optimize such a bad workload.
> >>>
> >>
> >> I think my way of running dbench has some flaw, so I went to ebizzy.
> >> Could you let me know how you generally run dbench?
> >
> > I mount a tmpfs and then specify that mount for dbench to run on.  This
> > eliminates all IO.  I use a 300 second run time and number of threads is
> > equal to number of vcpus.  All of the VMs of course need to have a
> > synchronized start.
> >
> > I would also make sure you are using a recent kernel for dbench, where
> > the dcache scalability is much improved.  Without any lock-holder
> > preemption, the time in spin_lock should be very low:
> >
> >
> >>      21.54%      78016         dbench  [kernel.kallsyms]   [k] copy_user_generic_unrolled
> >>       3.51%      12723         dbench  libc-2.12.so        [.] __strchr_sse42
> >>       2.81%      10176         dbench  dbench              [.] child_run
> >>       2.54%       9203         dbench  [kernel.kallsyms]   [k] _raw_spin_lock
> >>       2.33%       8423         dbench  dbench              [.] next_token
> >>       2.02%       7335         dbench  [kernel.kallsyms]   [k] __d_lookup_rcu
> >>       1.89%       6850         dbench  libc-2.12.so        [.] __strstr_sse42
> >>       1.53%       5537         dbench  libc-2.12.so        [.] __memset_sse2
> >>       1.47%       5337         dbench  [kernel.kallsyms]   [k] link_path_walk
> >>       1.40%       5084         dbench  [kernel.kallsyms]   [k] kmem_cache_alloc
> >>       1.38%       5009         dbench  libc-2.12.so        [.] memmove
> >>       1.24%       4496         dbench  libc-2.12.so        [.] vfprintf
> >>       1.15%       4169         dbench  [kernel.kallsyms]   [k] __audit_syscall_exit
> >
> 
> Hi Andrew,
> I ran the test with dbench with tmpfs. I do not see any improvements in
> dbench for 16k ple window.
> 
> So it seems apart from ebizzy no workload benefited by that. and I
> agree that, it may not be good to optimize for ebizzy.
> I shall drop changing to 16k default window and continue with other
> original patch series. Need to experiment with latest kernel.

Thanks for running this again.  I do believe there are some workloads,
when run at 1x overcommit, would benefit from a larger ple_window [with
he current ple handling code], but I do not also want to potentially
degrade >1x with a larger window.  I do, however, think there may be a
another option.  I have not fully worked this out, but I think I am on
to something.

I decided to revert back to just a yield() instead of a yield_to().  My
motivation was that yield_to() [for large VMs] is like a dog chasing its
tail, round and round we go....   Just yield(), in particular a yield()
which results in yielding to something -other- than the current VM's
vcpus, helps synchronize the execution of sibling vcpus by deferring
them until the lock holder vcpu is running again.  The more we can do to
get all vcpus running at the same time, the far less we deal with the
preemption problem.  The other benefit is that yield() is far, far lower
overhead than yield_to()

This does assume that vcpus from same VM do not share same runqueues.
Yielding to a sibling vcpu with yield() is not productive for larger VMs
in the same way that yield_to() is not.  My recent results include
restricting vcpu placement so that sibling vcpus do not get to run on
the same runqueue.  I do believe we could implement a initial placement
and load balance policy to strive for this restriction (making it purely
optional, but I bet could also help user apps which use spin locks).

For 1x VMs which still vm_exit due to PLE, I believe we could probably
just leave the ple_window alone, as long as we mostly use yield()
instead of yield_to().  The problem with the unneeded exits in this case
has been the overhead in routines leading up to yield_to() and the
yield_to() itself.  If we use yield() most of the time, this overhead
will go away.

Here is a comparison of yield_to() and yield():

dbench with 20-way VMs, 8 of them on 80-way host:

no PLE			  426 +/- 11.03%
no PLE w/ gangsched	32001 +/- .37%
PLE with yield()	29207 +/- .28%
PLE with yield_to()	 8175 +/- 1.37%

Yield() is far and way better than yield_to() here and almost approaches
gang sched result.  Here is a link for the perf sched map bitmap:

https://docs.google.com/open?id=0B6tfUNlZ-14weXBfVnFFZGw1akU

The thrashing is way down and sibling vcpus tend to run together,
approximating the behavior of the gang scheduling without needing to
actually implement gang scheduling.

I did test a smaller VM:

dbench with 10-way VMs, 16 of them on 80-way host:

no PLE			 6248 +/- 7.69%	  
no PLE w/ gangsched	28379 +/- .07%
PLE with yield()	29196 +/- 1.62%
PLE with yield_to()	32217 +/- 1.76%

There is some degrade from yield() to yield_to() here, but nearly as
large as the uplift we see on the larger VMs.  Regardless, I have an
idea to fix that: Instead of using yield() all the time, we could use
yield_to(), but limit the rate per vcpu to something like 1 per jiffie.
All other exits use yield().  That rate of yield_to() should be more
than enough for the smaller VMs, and the result should be hopefully just
the same as the current code.  I have not coded this up yet, but it's my
next step.

I am also hopeful the limitation of yield_to() will also make the 1x
issue just go away as well (even with 4096 ple_window).  The vast
majority of exits will result in yield() which should be harmless.

Keep in mind this did require ensuring sibling vcpus do not share host
runqueues -I do think that can be possible given some optional scheduler
tweaks.

> 
> (PS: Thanks for pointing towards, perf in latest kernel. It works fine.)
> 
> Results:
> dbench run for 120 sec 30 sec warmup 8 iterations using tmpfs
> base = 3.6.0-rc5 with ple handler optimization patch.
> 
> x => base + ple_window = 4k
> + => base + ple_window = 16k
> * => base + ple_gap = 0
> 
> dbench 1x overcommit case
> =========================
>      N           Min           Max        Median           Avg        Stddev
> x   8        5322.5       5519.05       5482.71     5461.0962     63.522276
> +   8       5255.45       5530.55       5496.94     5455.2137     93.070363
> *   8       5350.85       5477.81      5408.065     5418.4338     44.762697
> 
> 
> dbench 2x overcommit case
> ==========================
> 
>      N           Min           Max        Median           Avg        Stddev
> x   8       3054.32       3194.47       3137.33      3132.625     54.491615
> +   8        3040.8       3148.87      3088.615     3088.1887     32.862336
> *   8       3031.51       3171.99        3083.6     3097.4612     50.526977
> 

-Andrew

