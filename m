Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0IOIgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:36:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52173 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750701Ab0IOIgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:36:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194/TUHlah4KZt4oFTRYnvOhHNO6CZTlCme+I2bjU
	nVwKfd2Ibp/0ja
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v3)
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100914202503.GA1496@Krystal>
References: <20100914202503.GA1496@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 10:37:11 +0200
Message-Id: <1284539831.21727.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 16:25 -0400, Mathieu Desnoyers wrote:
> This patch tweaks the fair vruntime calculation of both the parent and the child
> after a fork to double vruntime increment speed, but this is only applied to
> their first slice after the fork. The goal of this scheme is that their
> respective vruntime will increment faster in the first slice after the fork, so
> a workload doing many forks (e.g.  make -j10) will have a limited impact on
> latency-sensitive workloads.
> 
> This is an alternative to START_DEBIT which does not have the downside of moving
> newly forked threads to the end of the runqueue.
> 
> Changelog since v2:
> - Apply vruntime penality even the first time the exec time has moved across
>   the timeout.
> 
> Changelog since v1:
> - Moving away from modifying the task weight from within the scheduler, as it is
>   error-prone: modifying the weight of a queued task leads to cpu weight errors.
>   For the moment, just tweak calc_delta_fair vruntime calculation. Eventually we
>   could revisit the weight modification approach if we decide that it's worth
>   the more intrusive changes. I redid the START_NICE benchmark, which did not
>   change much: it is still appealing.

Some numbers from my Q6600 box, applied to v2.6.36-rc3-409-g3e6dce7. 

pinned wakeup-latency competing with pinned make -j10
(taskset -c 3 ./wakeup-latency& sleep 30 && killall wakeup-latency)

STOCK (ouch ouch ouch!, excellent testcase)
maximum latency: 80558.8 µs     111838.0 µs      98196.6 µs
average latency:  9682.4 µs       9357.8 µs       9559.0 µs
missed timer events:   0               0               0

NO_START_DEBIT
maximum latency: 20015.5 µs      19247.8 µs      17204.2 µs  
average latency:  4923.0 µs       4985.2 µs       4879.5 µs
missed timer events:   0               0               0

START_NICE
maximum latency: 19185.1 µs      19988.8 µs      19492.3 µs
average latency: 4616.2 µs        4688.4 µs       4842.9 µs
missed timer events: 0                 0               0


x264 8 threads (ultrafast)
STOCK
     414.43     412.46     406.37 fps

NO_START_DEBIT
     425.13     426.70     427.01 fps

START_NICE
     423.80     424.87     419.00 fps


pert (100% hog perturbation measurement proggy) competing with make -j3, 10 sec sample interval

STOCK
pert/s:      131 >16763.81us:      239 min:  0.15 max:54498.30 avg:5702.18 sum/s:746986us overhead:74.70%
pert/s:      126 >18677.42us:      224 min:  0.13 max:65777.41 avg:6022.36 sum/s:761227us overhead:76.09%
pert/s:      127 >20308.15us:      215 min:  0.11 max:64017.28 avg:5952.13 sum/s:757706us overhead:75.71%
pert/s:      129 >21925.00us:      204 min:  0.41 max:67134.26 avg:5819.16 sum/s:752418us overhead:75.17% <== competition got

NO_START_DEBIT
pert/s:      113 >32566.80us:      140 min:  0.33 max:70870.38 avg:6937.03 sum/s:783885us overhead:78.39%
pert/s:      112 >33261.53us:      127 min:  0.35 max:72063.85 avg:6964.25 sum/s:784871us overhead:78.40%
pert/s:      111 >33372.61us:      112 min:  0.37 max:61722.37 avg:7022.35 sum/s:784397us overhead:78.44%
pert/s:      112 >34183.11us:      115 min:  0.38 max:76023.87 avg:6931.32 sum/s:781853us overhead:78.19%

START_NICE
pert/s:      153 >20082.61us:      181 min:  0.06 max:52532.34 avg:4563.81 sum/s:702371us overhead:70.24%
pert/s:      144 >21018.81us:      191 min:  0.14 max:53890.46 avg:4998.69 sum/s:722810us overhead:72.25%
pert/s:      145 >22969.69us:      185 min:  0.12 max:76028.37 avg:5026.94 sum/s:729912us overhead:72.69%
pert/s:      150 >23758.97us:      168 min:  0.12 max:56992.14 avg:4732.80 sum/s:709920us overhead:70.94%




