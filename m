Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab2J3MRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:17:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42427 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585Ab2J3MRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:17:18 -0400
Subject: Re: [PATCH V2 RFC 0/3] kvm: Improving undercommit,overcommit
 scenarios
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
In-Reply-To: <20121029140621.15448.92083.sendpatchset@codeblue>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 30 Oct 2012 07:17:00 -0500
Message-ID: <1351599420.23105.14.camel@oc6622382223.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103012-7282-0000-0000-00000E675001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 19:36 +0530, Raghavendra K T wrote:
> In some special scenarios like #vcpu <= #pcpu, PLE handler may
> prove very costly, because there is no need to iterate over vcpus
> and do unsuccessful yield_to burning CPU.
> 
>  Similarly, when we have large number of small guests, it is
> possible that a spinning vcpu fails to yield_to any vcpu of same
> VM and go back and spin. This is also not effective when we are
> over-committed. Instead, we do a yield() so that we give chance
> to other VMs to run.
> 
> This patch tries to optimize above scenarios.
> 
>  The first patch optimizes all the yield_to by bailing out when there
>  is no need to continue yield_to (i.e., when there is only one task 
>  in source and target rq).
> 
>  Second patch uses that in PLE handler.
> 
>  Third patch uses overall system load knowledge to take decison on
>  continuing in yield_to handler, and also yielding in overcommits.
>  To be precise, 
>  * loadavg is converted to a scale of 2048  / per CPU 
>  * a load value of less than 1024 is considered as undercommit and we
>  return from PLE handler in those cases 
>  * a load value of greater than 3586 (1.75 * 2048) is considered as overcommit
>   and  we yield to other VMs in such cases.
> 
> (let threshold = 2048)
> Rationale for using threshold/2 for undercommit limit:
>  Having a load below (0.5 * threshold) is used to avoid (the concern rasied by Rik)
> scenarios where we still have lock holder preempted vcpu waiting to be
> scheduled. (scenario arises when rq length is > 1 even when we are under
> committed)
> 
> Rationale for using (1.75 * threshold) for overcommit scenario:
> This is a heuristic where we should probably see rq length > 1
> and a vcpu of a different VM is waiting to be scheduled.
> 
>  Related future work (independent of this series):
> 
>  - Dynamically changing PLE window depending on system load.
> 
>  Result on 3.7.0-rc1 kernel shows around 146% improvement for ebizzy 1x
>  with 32 core PLE machine with 32 vcpu guest.
>  I believe we should get very good improvements for overcommit (especially > 2)
>  on large machines with small vcpu guests. (Could not test this as I do not have
>  access to a bigger machine)
> 
> base = 3.7.0-rc1 
> machine: 32 core mx3850 x5 PLE mc
> 
> --+-----------+-----------+-----------+------------+-----------+
>                ebizzy (rec/sec higher is beter)
> --+-----------+-----------+-----------+------------+-----------+
>     base        stdev       patched     stdev       %improve     
> --+-----------+-----------+-----------+------------+-----------+
> 1x  2543.3750    20.2903    6279.3750    82.5226   146.89143   
> 2x  2410.8750    96.4327    2450.7500   207.8136     1.65396
> 3x  2184.9167   205.5226    2178.3333    97.2034    -0.30131
> --+-----------+-----------+-----------+------------+-----------+
> 
> --+-----------+-----------+-----------+------------+-----------+
>         dbench (throughput in MB/sec. higher is better)
> --+-----------+-----------+-----------+------------+-----------+
>     base        stdev       patched     stdev       %improve     
> --+-----------+-----------+-----------+------------+-----------+
> 1x  5545.4330   596.4344    7042.8510  1012.0924    27.00272
> 2x  1993.0970    43.6548    1990.6200    75.7837    -0.12428
> 3x  1295.3867    22.3997    1315.5208    36.0075     1.55429
> --+-----------+-----------+-----------+------------+-----------+

Could you include a PLE-off result for 1x over-commit, so we know what
the best possible result is?

Looks like skipping the yield_to() for rq = 1 helps, but I'd like to
know if the performance is the same as PLE off for 1x.  I am concerned
the vcpu to task lookup is still expensive.

Based on Peter's comments I would say the 3rd patch and the 2x,3x
results are not conclusive at this time.

I think we should also discuss what we think a good target is.  We
should know what our high-water mark is, and IMO, if we cannot get
close, then I do not feel we are heading down the right path.  For
example, if dbench aggregate throughput for 1x with PLE off is 10000
MB/sec, then the best possible 2x,3x result, should be a little lower
than that due to task switching the vcpus and sharing chaches.  This
should be quite evident with current PLE handler and smaller VMs (like
10 vcpus or less).
> 
>  Changes since V1:
>  - Discard the idea of exporting nrrunning and optimize in core scheduler (Peter)
>  - Use yield() instead of schedule in overcommit scenarios (Rik)
>  - Use loadavg knowledge to detect undercommit/overcommit
> 
>  Peter Zijlstra (1):
>   Bail out of yield_to when source and target runqueue has one task
> 
>  Raghavendra K T (2):
>   Handle yield_to failure return for potential undercommit case
>   Check system load and handle different commit cases accordingly
> 
>  Please let me know your comments and suggestions.
> 
>  Link for V1:
>  https://lkml.org/lkml/2012/9/21/168
> 
>  kernel/sched/core.c | 25 +++++++++++++++++++------
>  virt/kvm/kvm_main.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 65 insertions(+), 16 deletions(-)

-Andrew Theurer


