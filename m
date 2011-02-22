Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1BVIJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:09:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1BVIJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:09:52 -0500
Date: Tue, 22 Feb 2011 09:09:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: masami.hiramatsu.pt@hitachi.com, acme@redhat.com, fweisbec@gmail.com,
        hpa@zytor.com, ananth@in.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, eric.dumazet@gmail.com,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] x86: separating entry text section
Message-ID: <20110222080934.GB7001@elte.hu>
References: <20110220125948.GC25700@elte.hu>
 <1298298313-5980-1-git-send-email-jolsa@redhat.com>
 <1298298313-5980-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298298313-5980-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> Putting x86 entry code to the separate section: .entry.text.

Trying to apply your patch i noticed one detail:

> before patch:
>      26282174  L1-icache-load-misses      ( +-   0.099% )  (scaled from 81.00%)
>   0.206651959  seconds time elapsed   ( +-   0.152% )
> 
> after patch:
>      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
>   0.210509948  seconds time elapsed   ( +-   0.140% )

So time elapsed actually went up.

hackbench is notoriously unstable when it comes to runtime - and increasing the 
--repeat value only has limited effects on that.

Dropping all system caches:

   echo 1 > /proc/sys/vm/drop_caches

Seems to do a better job of 'resetting' system state, but if we put that into the 
measured workload then the results are all over the place (as we now depend on IO 
being done):

 # cat hb10

 echo 1 > /proc/sys/vm/drop_caches
 ./hackbench 10

 # perf stat --repeat 3 ./hb10

 Time: 0.097
 Time: 0.095
 Time: 0.101

 Performance counter stats for './hb10' (3 runs):

         21.351257 task-clock-msecs         #      0.044 CPUs    ( +-  27.165% )
                 6 context-switches         #      0.000 M/sec   ( +-  34.694% )
                 1 CPU-migrations           #      0.000 M/sec   ( +-  25.000% )
               410 page-faults              #      0.019 M/sec   ( +-   0.081% )
        25,407,650 cycles                   #   1189.984 M/sec   ( +-  49.154% )
        25,407,650 instructions             #      1.000 IPC     ( +-  49.154% )
         5,126,580 branches                 #    240.107 M/sec   ( +-  46.012% )
           192,272 branch-misses            #      3.750 %       ( +-  44.911% )
           901,701 cache-references         #     42.232 M/sec   ( +-  12.857% )
           802,767 cache-misses             #     37.598 M/sec   ( +-   9.282% )

        0.483297792  seconds time elapsed   ( +-  31.152% )

So here's a perf stat feature suggestion to solve such measurement problems: a new 
'pre-run' 'dry' command could be specified that is executed before the real 'hot' 
run is executed. Something like this:

  perf stat --pre-run-script ./hb10 --repeat 10 ./hackbench 10

Would do the cache-clearing before each run, it would run hackbench once (dry run) 
and then would run hackbench 10 for real - and would repeat the whole thing 10 
times. Only the 'hot' portion of the run would be measured and displayed in the perf 
stat output event counts.

Another observation:

>      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)

Could you please do runs that do not display 'scaled from' messages? Since we are 
measuring a relatively small effect here, and scaling adds noise, it would be nice 
to ensure that the effect persists with non-scaled events as well:

You can do that by reducing the number of events that are measured. The PMU can not 
measure all those L1 cache events you listed - so only use the most important one 
and add cycles and instructions to make sure the measurements are comparable:

  -e L1-icache-load-misses -e instructions -e cycles

Btw., there's another 'perf stat' feature suggestion: it would be nice if it was 
possible to 'record' a perf stat run, and do a 'perf diff' over it. That would 
compare the two runs all automatically, without you having to do the comparison 
manually.

Thanks,

	Ingo
