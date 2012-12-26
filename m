Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2LZGc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 01:32:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41783 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2LZGc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 01:32:27 -0500
From: ling.ma.program@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ml@alipay.com>
Subject: [Suggestion] [x86]: Compiler Option Os is better on latest x86
Date: Wed, 26 Dec 2012 14:32:17 +0800
Message-Id: <1356503537-4987-1-git-send-email-ling.ma@alipay.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ml@alipay.com>

  Currently we use O2 as compiler option for better performance,
although it will enlarge code size, in modern CPUs larger instructon
and unified cache, sophisticated instruction prefetch weaken instruction
cache miss, meanwhile flags such as -falign-functions, -falign-jumps,
-falign-loops, -falign-labels are very helpful to improve CPU front-end
throughput because CPU fetch instruction by 16 aligned–bytes code block
per cycle.

  In order to save power and get higher performance, Sandy Bridge 
starts to introduce decoded-cache, instructions will be kept in it
after decode stage. When CPU refetches the instruction, decoded cache could
provide 32 aligned-bytes instruction block, instead of 16 bytes from I-cache,
fewer branch miss penalty resulted from shorter pipeline. It requires hot
code should be put into decoded cache as possible we can. Sandy Bridge,
Ivy Bridge, and Haswell all implemented this feature, Os-Optimize for size
should be better than O2 on them.

Based on above reasons, we compiled linux kernel 3.6.9 with O2 and Os
respectively. The results show Os improve performance netperf 4.8%,
2.7% for volano as below

O2 + netperf
Performance counter stats for 'netperf' (3 runs):

       5416.157986 task-clock                #    0.541 CPUs utilized            ( +-  0.19% )
           348,249 context-switches          #    0.064 M/sec                    ( +-  0.17% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-  0.00% )
               353 page-faults               #    0.000 M/sec                    ( +-  0.16% )
    13,166,254,384 cycles                    #    2.431 GHz                      ( +-  0.18% )
     8,827,499,807 stalled-cycles-frontend   #   67.05% frontend cycles idle     ( +-  0.29% )
     5,951,234,060 stalled-cycles-backend    #   45.20% backend  cycles idle     ( +-  0.44% )
     8,122,481,914 instructions              #    0.62  insns per cycle
                                             #    1.09  stalled cycles per insn  ( +-  0.17% )
     1,415,864,138 branches                  #  261.415 M/sec                    ( +-  0.17% )
        16,975,308 branch-misses             #    1.20% of all branches          ( +-  0.61% )

      10.007215371 seconds time elapsed                                          ( +-  0.03% )

Os + netperf

Performance counter stats for 'netperf' (3 runs):

       5395.386704 task-clock                #    0.539 CPUs utilized            ( +-  0.14% )
           345,880 context-switches          #    0.064 M/sec                    ( +-  0.25% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +-  0.00% )
               354 page-faults               #    0.000 M/sec                    ( +-  0.00% )
    13,142,706,297 cycles                    #    2.436 GHz                      ( +-  0.23% )
     8,379,382,641 stalled-cycles-frontend   #   63.76% frontend cycles idle     ( +-  0.50% )
     5,513,722,219 stalled-cycles-backend    #   41.95% backend  cycles idle     ( +-  0.71% )
     8,554,202,795 instructions              #    0.65  insns per cycle
                                             #    0.98  stalled cycles per insn  ( +-  0.25% )
     1,530,020,505 branches                  #  283.579 M/sec                    ( +-  0.25% )
        17,710,406 branch-misses             #    1.16% of all branches          ( +-  1.00% )

      10.004859867 seconds time elapsed               

During the same time (10.004859867 seconds) IPC from Os is 0.65, O2 is 0.62, Os improved performance 4.8%

O2 + volano
Performance counter stats for './loopclient.sh openjdk' (3 runs):

     210627.115313 task-clock                #    0.781 CPUs utilized            ( +-  0.92% )
        13,812,610 context-switches          #    0.066 M/sec                    ( +-  0.17% )
         2,352,755 CPU-migrations            #    0.011 M/sec                    ( +-  0.84% )
           208,333 page-faults               #    0.001 M/sec                    ( +-  1.58% )
   525,627,073,405 cycles                    #    2.496 GHz                      ( +-  0.96% )
   428,177,571,365 stalled-cycles-frontend   #   81.46% frontend cycles idle     ( +-  1.09% )
   370,885,224,739 stalled-cycles-backend    #   70.56% backend  cycles idle     ( +-  1.18% )
   187,662,577,544 instructions              #    0.36  insns per cycle
                                             #    2.28  stalled cycles per insn  ( +-  0.31% )
    35,684,976,425 branches                  #  169.423 M/sec                    ( +-  0.45% )
     1,062,086,942 branch-misses             #    2.98% of all branches          ( +-  0.08% )

     269.764578435 seconds time elapsed    
         
Os + volano
Performance counter stats for './loopclient.sh openjdk' (3 runs):

     209545.786941 task-clock                #    0.778 CPUs utilized            ( +-  0.66% )
        13,864,142 context-switches          #    0.066 M/sec                    ( +-  0.29% )
         2,326,826 CPU-migrations            #    0.011 M/sec                    ( +-  0.83% )
           205,575 page-faults               #    0.001 M/sec                    ( +-  2.63% )
   523,366,588,452 cycles                    #    2.498 GHz                      ( +-  0.75% )
   419,200,472,430 stalled-cycles-frontend   #   80.10% frontend cycles idle     ( +-  0.86% )
   362,044,374,737 stalled-cycles-backend    #   69.18% backend  cycles idle     ( +-  0.96% )
   193,274,857,837 instructions              #    0.37  insns per cycle
                                             #    2.17  stalled cycles per insn  ( +-  0.51% )
    37,657,832,686 branches                  #  179.712 M/sec                    ( +-  0.42% )
     1,061,005,300 branch-misses             #    2.82% of all branches          ( +-  0.86% )

     269.410275674 seconds time elapsed                                          ( +-  0.06% )

During the same  time (269.410275674 seconds) IPC from Os is 0.37, O2 is 0.36, Os improved performance 2.7%

So our initial conclusion is Os is better than O2 for current & coming x86 CPUs.
If I was wrong, please correct me.

Thanks
Ling
