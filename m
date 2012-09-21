Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2IUNS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:18:28 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29122 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2IUNS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:18:26 -0400
Message-ID: <505C691D.4080801@hp.com>
Date: Fri, 21 Sep 2012 06:18:21 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue>
In-Reply-To: <20120921115942.27611.67488.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2012 4:59 AM, Raghavendra K T wrote:
> In some special scenarios like #vcpu <= #pcpu, PLE handler may
> prove very costly,

Yes.
>   because there is no need to iterate over vcpus
> and do unsuccessful yield_to burning CPU.
>
> An idea to solve this is:
> 1) As Avi had proposed we can modify hardware ple_window
> dynamically to avoid frequent PL-exit.

Yes. We had to do this to get around some scaling issues for large 
(>20way) guests (with no overcommitment)

As part of some experimentation we even tried "switching off"  PLE too :(



> (IMHO, it is difficult to
> decide when we have mixed type of VMs).

Agree.

Not sure if the following alternatives have also been looked at :

- Could the  behavior  associated with the "ple_window" be modified to 
be a function of some [new] per-guest attribute (which can be conveyed 
to the host as part of the guest launch sequence). The user can choose 
to set this [new] attribute for a given guest. This would help avoid the 
frequent exits due to PLE (as Avi had mentioned earlier) ?

- Can the PLE feature ( in VT) be "enhanced" to be made a per guest 
attribute ?


IMHO, the approach of not taking a frequent exit is better than taking 
an exit and returning back from the handler etc.

Thanks
Vinod




>
> Another idea, proposed in the first patch, is to identify
> non-overcommit case and just return from the PLE handler.
>
> There are are many ways to identify non-overcommit scenario.
> 1) Using loadavg etc (get_avenrun/calc_global_load
>   /this_cpu_load)
>
> 2) Explicitly check nr_running()/num_online_cpus()
>
> 3) Check source vcpu runqueue length.
>
> Not sure how can we make use of (1) effectively/how to use it.
> (2) has significant overhead since it iterates all cpus.
> so this patch uses third method. (I feel it is uglier to export
> runqueue length, but expecting suggestion on this).
>
> In second patch, when we have large number of small guests, it is
> possible that a spinning vcpu fails to yield_to any vcpu of same
> VM and go back and spin. This is also not effective when we are
> over-committed. Instead, we do a schedule() so that we give chance
> to other VMs to run.
>
> Raghavendra K T(2):
>   Handle undercommitted guest case in PLE handler
>   Be courteous to other VMs in overcommitted scenario in PLE handler
>
> Results:
> base = 3.6.0-rc5 + ple handler optimization patches from kvm tree.
> patched = base + patch1 + patch2
> machine: x240 with 16 core with HT enabled (32 cpu thread).
> 32 vcpu guest with 8GB RAM.
>
> +-----------+-----------+-----------+------------+-----------+
>           ebizzy (record/sec higher is better)
> +-----------+-----------+-----------+------------+-----------+
>     base        stddev       patched    stdev        %improve
> +-----------+-----------+-----------+------------+-----------+
>   11293.3750   624.4378	 18209.6250   371.7061	  61.24166
>    3641.8750   468.9400	  3725.5000   253.7823	   2.29621
> +-----------+-----------+-----------+------------+-----------+
>
> +-----------+-----------+-----------+------------+-----------+
>          kernbench (time in sec lower is better)
> +-----------+-----------+-----------+------------+-----------+
>     base        stddev       patched    stdev        %improve
> +-----------+-----------+-----------+------------+-----------+
>      30.6020     1.3018	    30.8287     1.1517	  -0.74080
>      64.0825     2.3764	    63.4721     5.0191	   0.95252
>      95.8638     8.7030	    94.5988     8.3832	   1.31958
> +-----------+-----------+-----------+------------+-----------+
>
> Note:
> on mx3850x5 machine with 32 cores HT disabled I got around
> ebizzy      209%
> kernbench   6%
> improvement for 1x scenario.
>
> Thanks Srikar for his active partipation in discussing ideas and
> reviewing the patch.
>
> Please let me know your suggestions and comments.
> ---
>   include/linux/sched.h |    1 +
>   kernel/sched/core.c   |    6 ++++++
>   virt/kvm/kvm_main.c   |    7 +++++++
>   3 files changed, 14 insertions(+), 0 deletions(-)
>
> .
>

