Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030763Ab2CUKMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:12:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37720 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030708Ab2CUKMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:12:00 -0400
Message-ID: <4F69A956.2060905@linux.vnet.ibm.com>
Date: Wed, 21 Mar 2012 18:11:34 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Dhaval Giani <dhaval.giani@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Benjamin Segall <bsegall@google.com>,
        Ranjit Manomohan <ranjitm@google.com>, Nikhil Rao <ncrao@google.com>,
        jmc@cs.unc.edu, Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Abhishek Srivastava <a.srivastava.800@gmail.com>
Subject: Re: [ANNOUNCE] LinSched for v3.3-rc7
References: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com> <CAPhKKr-W+nh9Xzmwz83MUpzPuBfkj_TxjiZ+8NA5hndDUQB7bA@mail.gmail.com> <4F699D6C.7090400@linux.vnet.ibm.com> <CAPM31RKh-TeQimQaww_dtN598Sd07ARy86jQC1WGm8OVg-HDdQ@mail.gmail.com>
In-Reply-To: <CAPM31RKh-TeQimQaww_dtN598Sd07ARy86jQC1WGm8OVg-HDdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032110-2674-0000-0000-000003C7E619
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 05:54 PM, Paul Turner wrote:

> On Wed, Mar 21, 2012 at 2:20 AM, Michael Wang
> <wangyun@linux.vnet.ibm.com> wrote:
>> On 03/15/2012 12:08 PM, Dhaval Giani wrote:
>>
>>> [Adding abhishek to the cc]
>>>
>>> On Wed, Mar 14, 2012 at 8:58 PM, Paul Turner <pjt@google.com> wrote:
>>>> Hi All,
>>>>
>>>> [ Take 2, gmail tried to a non text/plain component into the last email .. ]
>>>>
>>>> Quick start version:
>>>>
>>>> Available under linsched-alpha at:
>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/pjt/linsched.git  .linsched
>>>>
>>>> NOTE: The branch history is still subject to some revision as I am
>>>> still re-partitioning some of the patches.  Once this is complete, I
>>>> will promote linsched-alpha into a linsched branch at which point it
>>>> will no longer be subject to history re-writes.
>>>>
>>>> After checking out the code:
>>>> cd tools/linsched
>>>> make
>>>> cd tests
>>>> ./run_tests.sh basic_tests
>>>> << then try changing some scheduler parameters, e.g. sched_latency,
>>>> and repeating >>
>>>>
>>>> (Note:  The basic_tests are unit-tests, these are calibrated to the
>>>> current scheduler tunables and should strictly be considered sanity
>>>> tests.  Please see the mcarlo-sim work for a more useful testing
>>>> environment.)
>>>>
>>>> Extended version:
>>>>
>>>> First of all, apologies in the delay to posting this -- I know there's
>>>> been a lot of interest.  We made the choice to first rebase to v3.3
>>>> since there were fairly extensive changes, especially within the
>>>> scheduler, that meant we had the opportunity to significantly clean up
>>>> some of the LinSched code.  (For example, previously we were
>>>> processing kernel/sched* using awk as a Makefile step so that we could
>>>> extract the necessary structure information without modifying
>>>> sched.c!)  While the code benefited greatly from this, there were
>>>> several other changes that required fairly extensive modification in
>>>> this process (and in the meanwhile the v3.1 version became less
>>>> representative due to the extent of the above changes); which pushed
>>>> things out much further than I would have liked.  I suppose the moral
>>>> of the story is always release early, and often.
>>>>
>>>> That said, I'm relatively happy with the current state of integration,
>>>> there's certainly some specific areas that can still be greatly
>>>> improved (in particular, the main simulator loop has not had as much
>>>> attention paid as the LinSched<>Kernel interactions and there's a long
>>>> list of TODOs that could be improved there), but things are now mated
>>>> fairly cleanly through the use of a new LinSched architecture.  This
>>>> is a total re-write of almost all LinSched<>Kernel interactions versus
>>>> the previous (2.6.35) version, and has allowed us to now carry almost
>>>> zero modifications against the kernel source.  It's both possible to
>>>> develop/test in place, as well as being patch compatible.  The
>>>> remaining touch-points now total just 20 lines!  Half of these are
>>>> likely mergable, with the other 10 lines being more LinSched specific
>>>> at this point in time, I've broken these down below:
>>>>
>>>> The total damage:
>>>>  include/linux/init.h      |    6 ++++++   (linsched ugliness,
>>>> unfortunately necessary until we boot-strap proper initcall support)
>>>>  include/linux/rcupdate.h  |    3 +++    (only necessary to allow -O0
>>>> compilation which is extremely handy for analyzing the scheduler using
>>>> gdb)
>>>>  kernel/pid.c              |    4 ++++        (linsched ugliness,
>>>> these can go eventually)
>>>>  kernel/sched/fair.c       |    2 +-          (this is just the
>>>> promotion of 1 structure and function from static state which weren't
>>>> published in the sched/ re-factoring that we need from within the
>>>> simulator)
>>>>  kernel/sched/stats.c      |    2 +-
>>>>  kernel/time/timekeeping.c |    3 ++-    (this fixes a time-dilation
>>>> error due to rounding when our clock-source has ns-resolution, e.g.
>>>> shift==1)
>>
>>
>> The edit in timekeeping:
>>
>> xtime.tv_nsec = ((s64)timekeeper.xtime_nsec + (1ULL << timekeeper.shift)
>> - 1) >> timekeeper.shift;
>>
>> Looks better then the old code which blindly add 1ns for the lost in
>> rounding, is it possible to commit this change to mainline?
>>
> 
> Yes, these patches patches are about to go out as a free-standing
> series as suggested by Ingo.
> 

I see.

I think this LinSched is interesting and very useful while study or
testing the code, have we got some TODOs now as you mentioned before?

I'd like to see whether I can do some help :)

Regards,
Michael Wang

> - Paul
> 
>> Regards,
>> Michael Wang
>>
>>>>  6 files changed, 17 insertions(+), 3 deletions(-)
>>>>
>>>> Summarized changes vs 2.6.35 (previous version):
>>>>
>>>> - The original LinSched (understandably) simplified many of the kernel
>>>> interactions in order to make simulation easier.  Unfortunately, this
>>>> has serious side-effects on the accuracy of simulation.  We've now
>>>> introduced a large portion of this state, including: irq and soft-irq
>>>> contexts (we now perform periodic load-balance out of SCHED_SOFTIRQ
>>>> for example), support for active load-balancing, correctly modeled
>>>> nohz interactions, ipi and stop-task support.
>>>>
>>>> - Support for record and replay of application scheduling via perf.
>>>> This is not yet well integrated, but under tests exist the tools to
>>>> record an applications behavior using perf sched record, and then play
>>>> it back in the simulator.
>>>>
>>>> - Load-balancer scoring.  This one is a very promising new avenue for
>>>> load-balancer testing.  We analyzed several workloads and found that
>>>> they could be well-modeled using a log-normal distribution.
>>>> Parameterizing these models then allows us to construct a large (500)
>>>> test-case set of randomly generated workloads that behave similarly.
>>>> By integrating the variance between the current load-balance and an
>>>> offline computed (currently greedy first-fit) balance we're able to
>>>> automatically identify and score an approximation of our distance from
>>>> an ideal load-balance.  Historically, such scores are very difficult
>>>> to interpret, however, that's where our ability to generate a large
>>>> set of test-cases above comes in.  This allows us to exploit a nice
>>>> property, it's much easier to design a scoring function that diverges
>>>> (in this case the variance) than a nice stable one that converges.  We
>>>> can then catch regressions in load-balancer quality by measuring the
>>>> divergence in this set of scoring functions across our set of
>>>> test-cases.  This particular feature needs a large set of
>>>> documentation in itself (todo), but to get started with playing with
>>>> it see Makefile.mcarlo-sims in tools/linsched/tests.  In particular to
>>>> evaluate the entire set across a variety of topologies the following
>>>> command can be issued:
>>>>  make -j <num_cpus * 2 > -f Makefile.mcarlo-sims
>>>> (The included 'diff-mcarlo-500' tool can then be used to make
>>>> comparisons across result sets.)
>>>>
>>>> - Validation versus real hardware.  Under tests/validation we've
>>>> included a tool for replaying and recording the above simulations on a
>>>> live-machine.  These can then be compared to simulated runs using the
>>>> tools above to ensure that LinSched is modelling your architecture
>>>> reasonably appropriately.  We did some reasonably extensive
>>>> comparisons versus several x86 topologies in the v3.1 code using this;
>>>> it's a fundamentally hard problem -- in particular there's much more
>>>> clock drift between events on real hardware, but the results showed
>>>> the included topologies to be a reasonable simulacrum under LinSched.
>>>>
>>>> What's to come?
>>>> - More documentation, especially about the use of the new
>>>> load-balancer scoring tools.
>>>> - The history is very coarse right now as a result of going through a
>>>> rebase cement-mixer.  I'd like to incrementally refactor some of the
>>>> larger commits; once this is done I will promote linsched-alpha to a
>>>> stable linsched branch that won't be subject to history re-writes.
>>>> - KBuild integration.  We currently build everything out of the
>>>> tools/linsched makefiles.  One of the immediate TODOs involves
>>>> re-working the arch/linsched half of this to work with kbuild so that
>>>> its less hacky/fragile.
>>>> - Writing up some of the existing TODOs as starting points for anyone
>>>> who wants to get involved.
>>>>
>>>> I'd also like to take a moment to specially recognize the effort of
>>>> the following contributors, all of whom were involved extensively in
>>>> the work above.  Things have come a long way since the 5000 lines of
>>>> "#ifdef LINSCHED", the current status would not be possible without
>>>> them.
>>>>  Ben Segall, Dhaval Giani, Ranjit Manomohan, Nikhil Rao, and Abhishek
>>>> Srivastava
>>>>
>>>> Thanks!
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
> 


