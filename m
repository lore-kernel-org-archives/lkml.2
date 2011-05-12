Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab1ELSpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:45:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab1ELSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gjueppQDmGAuyPPxiMNUNauE+YHWhlbqQaF+2R8VyFoBhYq4e8rihG9KFONwbhlneM
         pPqd86gLS1e6x78uJ3RQ==
MIME-Version: 1.0
In-Reply-To: <20110512105547.GK9937@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu> <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
 <20110506065959.GB23166@elte.hu> <BANLkTimevJFjvoDSE2q0bu6gQaajmaZATw@mail.gmail.com>
 <20110511065910.GD22551@elte.hu> <BANLkTikTAhD9f96JBh5ON9FEGPOjTRreVg@mail.gmail.com>
 <20110512105547.GK9937@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 12 May 2011 11:44:48 -0700
Message-ID: <BANLkTi=XCaHH2D9-=wrBAvf3-WjngBPx8w@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 3:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikhil Rao <ncrao@google.com> wrote:
>> On Tue, May 10, 2011 at 11:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >From this latest run on -tip, the instruction count is about ~0.28%
>> more and cycles are approx 3.38% more. From the stalled cycles counts,
>> it looks like most of this increase is coming from backend stalled
>> cycles. It's not clear what type of stalls these are, but if I were to
>> guess, I think it means stalls post-decode (i.e. functional units,
>> load/store, etc.). Is that right?
>
> Yeah, more functional work to be done, and probably a tad more expensive per
> extra instruction executed.
>

OK, this might be the shifts we do in c_d_m(). To confirm this, let me
remove the shifts and see if the number of stalled decreases.

> How did branches and branch misses change?
>

It looks like we take slightly more branches and miss more often.
About 0.2% more branches, and miss about 25% more often (i.e. 2.957%
vs. 2.376%).

-tip:
# taskset 8 perf stat --repeat 100 -e instructions -e cycles -e
branches -e branch-misses /root/data/pipe-test-100k

 Performance counter stats for '/root/data/pipe-test-100k' (100 runs):

       906,385,082 instructions             #      0.835 IPC     ( +-   0.077% )
     1,085,517,988 cycles                     ( +-   0.139% )
       165,921,546 branches                   ( +-   0.071% )
         3,941,788 branch-misses            #      2.376 %       ( +-   0.952% )

        1.061813201  seconds time elapsed   ( +-   0.096% )


-tip+patches:
# taskset 8 perf stat --repeat 100 -e instructions -e cycles -e
branches -e branch-misses /root/data/pipe-test-100k

 Performance counter stats for '/root/data/pipe-test-100k' (100 runs):

       908,150,127 instructions             #      0.829 IPC     ( +-   0.073% )
     1,095,344,326 cycles                     ( +-   0.140% )
       166,266,732 branches                   ( +-   0.071% )
         4,917,179 branch-misses            #      2.957 %       ( +-   0.746% )

        1.065221478  seconds time elapsed   ( +-   0.099% )


Comparing two perf records of branch-misses by hand, we see about the
same number of branch-miss events but the distribution looks less
top-heavy compared to -tip, so we might have a longer tail of branch
misses with the patches. None of the scheduler functions really stand
out.

-tip:
# taskset 8 perf record -e branch-misses /root/pipe-test-30m

# perf report | head -n 20
# Events: 310K cycles
#
# Overhead        Command      Shared Object
      Symbol
# ........  .............  .................
.....................................
#
    11.15%  pipe-test-30m  [kernel.kallsyms]  [k] system_call
     7.70%  pipe-test-30m  [kernel.kallsyms]  [k] x86_pmu_disable_all
     6.63%  pipe-test-30m  libc-2.11.1.so     [.] __GI_read
     6.11%  pipe-test-30m  [kernel.kallsyms]  [k] pipe_read
     5.74%  pipe-test-30m  [kernel.kallsyms]  [k] system_call_after_swapgs
     5.60%  pipe-test-30m  pipe-test-30m      [.] main
     5.55%  pipe-test-30m  [kernel.kallsyms]  [k] find_next_bit
     5.55%  pipe-test-30m  [kernel.kallsyms]  [k] __might_sleep
     5.46%  pipe-test-30m  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     4.55%  pipe-test-30m  [kernel.kallsyms]  [k] sched_clock
     3.82%  pipe-test-30m  [kernel.kallsyms]  [k] pipe_wait
     3.73%  pipe-test-30m  [kernel.kallsyms]  [k] sys_write
     3.65%  pipe-test-30m  [kernel.kallsyms]  [k] anon_pipe_buf_release
     3.61%  pipe-test-30m  [kernel.kallsyms]  [k] update_curr
     2.75%  pipe-test-30m  [kernel.kallsyms]  [k] select_task_rq_fair

-tip+patches:
# taskset 8 perf record -e branch-misses /root/pipe-test-30m

# perf report | head -n 20
# Events: 314K branch-misses
#
# Overhead        Command      Shared Object
      Symbol
# ........  .............  .................
.....................................
#
     7.66%  pipe-test-30m  [kernel.kallsyms]  [k] __might_sleep
     7.59%  pipe-test-30m  [kernel.kallsyms]  [k] system_call_after_swapgs
     5.88%  pipe-test-30m  [kernel.kallsyms]  [k] kill_fasync
     4.42%  pipe-test-30m  [kernel.kallsyms]  [k] fsnotify
     3.96%  pipe-test-30m  [kernel.kallsyms]  [k] update_curr
     3.93%  pipe-test-30m  [kernel.kallsyms]  [k] system_call
     3.91%  pipe-test-30m  [kernel.kallsyms]  [k] update_stats_wait_end
     3.90%  pipe-test-30m  [kernel.kallsyms]  [k] sys_read
     3.88%  pipe-test-30m  pipe-test-30m      [.] main
     3.86%  pipe-test-30m  [kernel.kallsyms]  [k] select_task_rq_fair
     3.81%  pipe-test-30m  libc-2.11.1.so     [.] __GI_read
     3.73%  pipe-test-30m  [kernel.kallsyms]  [k] sysret_check
     3.70%  pipe-test-30m  [kernel.kallsyms]  [k] sys_write
     3.66%  pipe-test-30m  [kernel.kallsyms]  [k] ret_from_sys_call
     3.56%  pipe-test-30m  [kernel.kallsyms]  [k] fsnotify_access

-Thanks,
Nikhil
