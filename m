Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1GGDyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 23:54:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab1GGDyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 23:54:21 -0400
Date: Thu, 7 Jul 2011 11:53:51 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110707035351.GE18411@localhost.localdomain>
References: <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
 <20110626103526.GA11093@elte.hu>
 <20110629040521.GG4186@localhost.localdomain>
 <20110701122824.GE28008@elte.hu>
 <20110705035813.GC4656@localhost.localdomain>
 <20110705085032.GA3169@elte.hu>
 <20110705085252.GA5274@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20110705085252.GA5274@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 11:53:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 11:53:35,
	Serialize complete at 2011-07-07 11:53:35
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Oh, please measure with lockdep (CONFIG_PROVE_LOCKING) turned off. No 
> > production kernel has it enabled and it has quite some overhead (as 
> > visible in the profile), skewing results.
> > 
> > >      2.04%     -0.09%  pipe-test-100k     [.] main
> > >      0.00%     +1.79%  [kernel.kallsyms]  [k] add_preempt_count
> > 
> > I'd also suggest to turn off CONFIG_PREEMPT_DEBUG.
> 
> The best way to get a good 'reference config' to measure scheduler 
> overhead on do something like:
> 
> 	make defconfig
> 	make localyesconfig
> 
> The first step will configure a sane default kernel, the second one 
> will enable all drivers that are needed on that box. You should be 
> able to boot the resulting bzImage and all drivers should be built-in 
> and are easily profilable.

Thanks for the information. I've re-tested the patches using the config
got by the way you gave, these are the results:

table 1. shows the differences of cycles, instructions and branches
         between drop caches and no drop caches. each drop caches case
         is run as reboot, drop caches, then perf. The patch cases are
         run with cpu cgroup disabled.

                          cycles                   instructions             branches
-----------------------------------------------------------------------------------------------
base                      1,146,384,132            1,151,216,688            212,431,532
base, drop caches         1,150,931,998 ( 0.39%)   1,150,099,127 (-0.10%)   212,216,507 (-0.10%)
base, drop caches         1,144,685,532 (-0.15%)   1,151,115,796 (-0.01%)   212,412,336 (-0.01%)
base, drop caches         1,148,922,524 ( 0.22%)   1,150,636,042 (-0.05%)   212,322,280 (-0.05%)
-----------------------------------------------------------------------------------------------
patch                     1,163,717,547            1,165,238,015            215,092,327
patch, drop caches        1,161,301,415 (-0.21%)   1,165,905,415 (0.06%)    215,220,114 (0.06%)
patch, drop caches        1,161,388,127 (-0.20%)   1,166,315,396 (0.09%)    215,300,854 (0.10%)
patch, drop caches        1,167,839,222 ( 0.35%)   1,166,287,755 (0.09%)    215,294,118 (0.09%)
-----------------------------------------------------------------------------------------------


table 2. shows the differences between patch and no-patch. quota is set
         to a large value to avoid processes being throttled.

        quota/period          cycles                   instructions             branches
--------------------------------------------------------------------------------------------------
base                          1,146,384,132           1,151,216,688            212,431,532
patch   cgroup disabled       1,163,717,547 (1.51%)   1,165,238,015 ( 1.22%)   215,092,327 ( 1.25%)
patch   10000000000/1000      1,244,889,136 (8.59%)   1,299,128,502 (12.85%)   243,162,542 (14.47%)
patch   10000000000/10000     1,253,305,706 (9.33%)   1,299,167,897 (12.85%)   243,175,027 (14.47%)
patch   10000000000/100000    1,252,374,134 (9.25%)   1,299,314,357 (12.86%)   243,203,923 (14.49%)
patch   10000000000/1000000   1,254,165,824 (9.40%)   1,299,751,347 (12.90%)   243,288,600 (14.53%)
--------------------------------------------------------------------------------------------------


(any questions please let me know.)




outputs from perf:



base
--------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        741.615458 task-clock                #    0.432 CPUs utilized            ( +-  0.05% )
           200,001 context-switches          #    0.270 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 57.62% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,146,384,132 cycles                    #    1.546 GHz                      ( +-  0.06% )
       528,191,000 stalled-cycles-frontend   #   46.07% frontend cycles idle     ( +-  0.11% )
       245,053,477 stalled-cycles-backend    #   21.38% backend  cycles idle     ( +-  0.14% )
     1,151,216,688 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       212,431,532 branches                  #  286.444 M/sec                    ( +-  0.04% )
         3,192,969 branch-misses             #    1.50% of all branches          ( +-  0.26% )

       1.717638863 seconds time elapsed                                          ( +-  0.02% )



base, drop caches
------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        743.991156 task-clock                #    0.432 CPUs utilized            ( +-  0.05% )
           200,001 context-switches          #    0.269 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 57.62% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,150,931,998 cycles                    #    1.547 GHz                      ( +-  0.06% )
       532,150,859 stalled-cycles-frontend   #   46.24% frontend cycles idle     ( +-  0.11% )
       248,132,791 stalled-cycles-backend    #   21.56% backend  cycles idle     ( +-  0.14% )
     1,150,099,127 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       212,216,507 branches                  #  285.241 M/sec                    ( +-  0.05% )
         3,234,741 branch-misses             #    1.52% of all branches          ( +-  0.24% )

       1.720283100 seconds time elapsed                                          ( +-  0.02% )



base, drop caches
------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        741.228159 task-clock                #    0.432 CPUs utilized            ( +-  0.05% )
           200,001 context-switches          #    0.270 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 49.85% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,144,685,532 cycles                    #    1.544 GHz                      ( +-  0.06% )
       528,095,499 stalled-cycles-frontend   #   46.13% frontend cycles idle     ( +-  0.10% )
       245,336,551 stalled-cycles-backend    #   21.43% backend  cycles idle     ( +-  0.14% )
     1,151,115,796 instructions              #    1.01  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       212,412,336 branches                  #  286.568 M/sec                    ( +-  0.04% )
         3,128,390 branch-misses             #    1.47% of all branches          ( +-  0.25% )

       1.717165952 seconds time elapsed                                          ( +-  0.02% )



base, drop caches
------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        743.564054 task-clock                #    0.433 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.269 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 74.48% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,148,922,524 cycles                    #    1.545 GHz                      ( +-  0.07% )
       532,489,993 stalled-cycles-frontend   #   46.35% frontend cycles idle     ( +-  0.11% )
       248,064,979 stalled-cycles-backend    #   21.59% backend  cycles idle     ( +-  0.15% )
     1,150,636,042 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       212,322,280 branches                  #  285.547 M/sec                    ( +-  0.04% )
         3,123,001 branch-misses             #    1.47% of all branches          ( +-  0.25% )

       1.718876342 seconds time elapsed                                          ( +-  0.02% )








patch, cgroup disabled
-----------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        739.608960 task-clock                #    0.426 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.270 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,163,717,547 cycles                    #    1.573 GHz                      ( +-  0.06% )
       541,274,832 stalled-cycles-frontend   #   46.51% frontend cycles idle     ( +-  0.11% )
       248,207,739 stalled-cycles-backend    #   21.33% backend  cycles idle     ( +-  0.14% )
     1,165,238,015 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       215,092,327 branches                  #  290.819 M/sec                    ( +-  0.04% )
         3,355,695 branch-misses             #    1.56% of all branches          ( +-  0.15% )

       1.734269082 seconds time elapsed                                          ( +-  0.02% )



patch, cgroup disabled, drop caches
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        737.995897 task-clock                #    0.426 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.271 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 57.62% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,161,301,415 cycles                    #    1.574 GHz                      ( +-  0.06% )
       538,706,207 stalled-cycles-frontend   #   46.39% frontend cycles idle     ( +-  0.10% )
       247,842,667 stalled-cycles-backend    #   21.34% backend  cycles idle     ( +-  0.15% )
     1,165,905,415 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.04% )
       215,220,114 branches                  #  291.628 M/sec                    ( +-  0.04% )
         3,344,324 branch-misses             #    1.55% of all branches          ( +-  0.15% )

       1.731173126 seconds time elapsed                                          ( +-  0.02% )



patch, cgroup disabled, drop caches
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        737.789383 task-clock                #    0.427 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.271 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 70.64% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.05% )
     1,161,388,127 cycles                    #    1.574 GHz                      ( +-  0.06% )
       538,324,103 stalled-cycles-frontend   #   46.35% frontend cycles idle     ( +-  0.10% )
       248,382,647 stalled-cycles-backend    #   21.39% backend  cycles idle     ( +-  0.14% )
     1,166,315,396 instructions              #    1.00  insns per cycle        
                                             #    0.46  stalled cycles per insn  ( +-  0.03% )
       215,300,854 branches                  #  291.819 M/sec                    ( +-  0.04% )
         3,337,456 branch-misses             #    1.55% of all branches          ( +-  0.15% )

       1.729696593 seconds time elapsed                                          ( +-  0.02% )



patch, cgroup disabled, drop caches
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):

        740.796454 task-clock                #    0.427 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.270 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 52.78% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.05% )
     1,167,839,222 cycles                    #    1.576 GHz                      ( +-  0.06% )
       543,240,067 stalled-cycles-frontend   #   46.52% frontend cycles idle     ( +-  0.10% )
       250,219,423 stalled-cycles-backend    #   21.43% backend  cycles idle     ( +-  0.15% )
     1,166,287,755 instructions              #    1.00  insns per cycle        
                                             #    0.47  stalled cycles per insn  ( +-  0.03% )
       215,294,118 branches                  #  290.625 M/sec                    ( +-  0.03% )
         3,435,316 branch-misses             #    1.60% of all branches          ( +-  0.15% )

       1.735473959 seconds time elapsed                                          ( +-  0.02% )








patch, period/quota 1000/10000000000
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):
        773.180003 task-clock                #    0.437 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.259 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 57.62% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,244,889,136 cycles                    #    1.610 GHz                      ( +-  0.06% )
       557,331,396 stalled-cycles-frontend   #   44.77% frontend cycles idle     ( +-  0.10% )
       244,081,415 stalled-cycles-backend    #   19.61% backend  cycles idle     ( +-  0.14% )
     1,299,128,502 instructions              #    1.04  insns per cycle        
                                             #    0.43  stalled cycles per insn  ( +-  0.04% )
       243,162,542 branches                  #  314.497 M/sec                    ( +-  0.04% )
         3,630,994 branch-misses             #    1.49% of all branches          ( +-  0.16% )

       1.769489922 seconds time elapsed                                          ( +-  0.02% )



patch, period/quota 10000/10000000000
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):
        776.884689 task-clock                #    0.438 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.257 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 57.62% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,253,305,706 cycles                    #    1.613 GHz                      ( +-  0.06% )
       566,262,435 stalled-cycles-frontend   #   45.18% frontend cycles idle     ( +-  0.10% )
       249,193,264 stalled-cycles-backend    #   19.88% backend  cycles idle     ( +-  0.13% )
     1,299,167,897 instructions              #    1.04  insns per cycle        
                                             #    0.44  stalled cycles per insn  ( +-  0.04% )
       243,175,027 branches                  #  313.013 M/sec                    ( +-  0.04% )
         3,774,613 branch-misses             #    1.55% of all branches          ( +-  0.13% )

       1.773111308 seconds time elapsed                                          ( +-  0.02% )



patch, period/quota 100000/10000000000
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):
        776.756709 task-clock                #    0.439 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.257 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 52.78% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,252,374,134 cycles                    #    1.612 GHz                      ( +-  0.05% )
       565,520,222 stalled-cycles-frontend   #   45.16% frontend cycles idle     ( +-  0.09% )
       249,412,383 stalled-cycles-backend    #   19.92% backend  cycles idle     ( +-  0.12% )
     1,299,314,357 instructions              #    1.04  insns per cycle        
                                             #    0.44  stalled cycles per insn  ( +-  0.04% )
       243,203,923 branches                  #  313.102 M/sec                    ( +-  0.04% )
         3,793,064 branch-misses             #    1.56% of all branches          ( +-  0.13% )

       1.771283272 seconds time elapsed                                          ( +-  0.01% )



patch, period/quota 1000000/10000000000
------------------------------------
 Performance counter stats for './pipe-test-100k' (500 runs):
        778.091675 task-clock                #    0.439 CPUs utilized            ( +-  0.04% )
           200,001 context-switches          #    0.257 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 61.13% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.06% )
     1,254,165,824 cycles                    #    1.612 GHz                      ( +-  0.05% )
       567,280,955 stalled-cycles-frontend   #   45.23% frontend cycles idle     ( +-  0.09% )
       249,428,011 stalled-cycles-backend    #   19.89% backend  cycles idle     ( +-  0.12% )
     1,299,751,347 instructions              #    1.04  insns per cycle        
                                             #    0.44  stalled cycles per insn  ( +-  0.04% )
       243,288,600 branches                  #  312.673 M/sec                    ( +-  0.04% )
         3,811,879 branch-misses             #    1.57% of all branches          ( +-  0.13% )

       1.773436668 seconds time elapsed                                          ( +-  0.02% )
