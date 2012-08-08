Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030808Ab2HHTuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:50:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56515 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932903Ab2HHTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:50:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/09FcEJcL0BMgqWA/hJLz+uhqNcnHrGwwgjGQoUO
	C49Gk/N5e/ZSjk
Message-ID: <1344455404.2440.35.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: fix divide by zero at {thread_group,task}_times
From: Mike Galbraith <efault@gmx.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 08 Aug 2012 21:50:04 +0200
In-Reply-To: <20120808092714.GA3580@redhat.com>
References: <20120808092714.GA3580@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 11:27 +0200, Stanislaw Gruszka wrote: 
> On architectures where cputime_t is 64 bit type, is possible to trigger
> divide by zero on do_div(temp, (__force u32) total) line, if total is a
> non zero number but has lower 32 bit's zeroed. Removing casting is not
> a good solution since some do_div() implementations do cast to u32
> internally.

I wonder if do_div() vs div64_u64() makes a big difference.  I swiped
all the kernel bits, and took them to userland.  32bit built do_div()
and div64_u64() both sucked equally compared to 64bit.. on Q6600.  Too
bad P4 box kicked the bucket...

boring numbers..

marge:~ # gcc -O2 -m32 -DDO_DIV -g -o xx xx.c
marge:~ # taskset -c 0 perf stat -- taskset -c 3 ./xx

 Performance counter stats for 'taskset -c 3 ./xx':

      13067.570787 task-clock:HG             #    0.999 CPUs utilized          
              1117 context-switches:HG       #    0.085 K/sec                  
                11 CPU-migrations:HG         #    0.001 K/sec                  
               225 page-faults:HG            #    0.017 K/sec                  
       31211154646 cycles:HG                 #    2.388 GHz                     [50.00%]
   <not supported> stalled-cycles-frontend:HG
   <not supported> stalled-cycles-backend:HG
       69004479084 instructions:HG           #    2.21  insns per cycle         [75.00%]
       16004049251 branches:HG               # 1224.715 M/sec                   [75.00%]
            106179 branch-misses:HG          #    0.00% of all branches         [75.00%]

      13.074907234 seconds time elapsed

marge:~ # gcc -O2 -m32 -g -o xx xx.c
marge:~ # taskset -c 0 perf stat -- taskset -c 3 ./xx

 Performance counter stats for 'taskset -c 3 ./xx':

      13065.936608 task-clock:HG             #    0.999 CPUs utilized          
              1117 context-switches:HG       #    0.085 K/sec                  
                 3 CPU-migrations:HG         #    0.000 K/sec                  
               225 page-faults:HG            #    0.017 K/sec                  
       31202249014 cycles:HG                 #    2.388 GHz                     [50.01%]
   <not supported> stalled-cycles-frontend:HG
   <not supported> stalled-cycles-backend:HG
       69013127982 instructions:HG           #    2.21  insns per cycle         [75.00%]
       16003545136 branches:HG               # 1224.830 M/sec                   [75.00%]
            106156 branch-misses:HG          #    0.00% of all branches         [75.00%]

      13.073238280 seconds time elapsed

64bit is loads faster.

marge:~ # gcc -O2 -m64 -DDO_DIV -g -o xx xx.c
marge:~ # taskset -c 0 perf stat -- taskset -c 3 ./xx

 Performance counter stats for 'taskset -c 3 ./xx':

       5575.994225 task-clock:HG             #    0.999 CPUs utilized          
               473 context-switches:HG       #    0.085 K/sec                  
                 5 CPU-migrations:HG         #    0.001 K/sec                  
               251 page-faults:HG            #    0.045 K/sec                  
       13311760132 cycles:HG                 #    2.387 GHz                     [50.00%]
   <not supported> stalled-cycles-frontend:HG
   <not supported> stalled-cycles-backend:HG
        7003731700 instructions:HG           #    0.53  insns per cycle         [75.04%]
        1001242479 branches:HG               #  179.563 M/sec                   [75.05%]
             37489 branch-misses:HG          #    0.00% of all branches         [74.98%]

       5.579075361 seconds time elapsed

marge:~ # gcc -O2 -m64 -g -o xx xx.c
marge:~ # taskset -c 0 perf stat -- taskset -c 3 ./xx

 Performance counter stats for 'taskset -c 3 ./xx':

       5576.756281 task-clock:HG             #    0.999 CPUs utilized          
               482 context-switches:HG       #    0.086 K/sec                  
                 5 CPU-migrations:HG         #    0.001 K/sec                  
               251 page-faults:HG            #    0.045 K/sec                  
       13316232700 cycles:HG                 #    2.388 GHz                     [49.98%]
   <not supported> stalled-cycles-frontend:HG
   <not supported> stalled-cycles-backend:HG
        7006965347 instructions:HG           #    0.53  insns per cycle         [74.99%]
        1001095727 branches:HG               #  179.512 M/sec                   [75.04%]
             39450 branch-misses:HG          #    0.00% of all branches         [75.01%]

       5.580954618 seconds time elapsed

