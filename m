Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1FXFLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 01:11:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54442 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1FXFLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 01:11:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E041C6A.4000701@jp.fujitsu.com>
Date: Fri, 24 Jun 2011 14:11:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
References: <20110621071649.862846205@google.com> <4E01BE6B.2090701@jp.fujitsu.com> <1308830816.1022.112.camel@twins> <20110623124310.GA15430@elte.hu>
In-Reply-To: <20110623124310.GA15430@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------030306050303060102060809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030306050303060102060809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(2011/06/23 21:43), Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> On Wed, 2011-06-22 at 19:05 +0900, Hidetoshi Seto wrote:
>>
>>> I'll continue my test/benchmark on this v7 for a while. Though I 
>>> believe no more bug is there, I'll let you know if there is 
>>> something.
>>
>> Would that testing include performance of a kernel without these 
>> patches vs one with these patches in a configuration where the new 
>> feature is compiled in but not used?
>>
>> It does add a number of if (!cfs_rq->runtime_enabled) return 
>> branches all over the place, some possibly inside a function call 
>> (depending on what the auto-inliner does). So while the impact 
>> should be minimal, it would be very good to test it is indeed so.
> 
> Yeah, doing such performance tests is absolutely required. Branches 
> and instructions impact should be measured as well, beyond the cycles 
> impact.
> 
> The changelog of this recent commit:
> 
>   c8b281161dfa: sched: Increase SCHED_LOAD_SCALE resolution
> 
> gives an example of how to do such measurements.

Thank you for useful guidance!

I've run pipe-test-100k on both of a kernel without patches (3.0-rc4)
and one with patches (3.0-rc4+), in similar way as that described in
the change log you pointed (but I add "-d" for more details).

I sampled 4 results for each: repeat 10 times * 3 + repeat 200 times * 1.
Cgroups are not used in both, therefore of course CFS bandwidth control
is not used in one that have patched.  Results are archived and attached.

Here is a comparison in diff style:

=====
--- /home/seto/bwc-pipe-test/bwc-rc4-orig.txt   2011-06-24 11:52:16.000000000 +0900
+++ /home/seto/bwc-pipe-test/bwc-rc4-patched.txt        2011-06-24 12:08:32.000000000 +0900
 [seto@SIRIUS-F14 perf]$ taskset 1 ./perf stat -d -d -d --repeat 200 ../../../pipe-test-100k

  Performance counter stats for '../../../pipe-test-100k' (200 runs):

-        865.139070 task-clock                #    0.468 CPUs utilized            ( +-  0.22% )
-           200,167 context-switches          #    0.231 M/sec                    ( +-  0.00% )
-                 0 CPU-migrations            #    0.000 M/sec                    ( +- 49.62% )
-               142 page-faults               #    0.000 M/sec                    ( +-  0.07% )
-     1,671,107,623 cycles                    #    1.932 GHz                      ( +-  0.16% ) [28.23%]
-       838,554,329 stalled-cycles-frontend   #   50.18% frontend cycles idle     ( +-  0.27% ) [28.21%]
-       453,526,560 stalled-cycles-backend    #   27.14% backend  cycles idle     ( +-  0.43% ) [28.33%]
-     1,434,140,915 instructions              #    0.86  insns per cycle
-                                             #    0.58  stalled cycles per insn  ( +-  0.06% ) [34.01%]
-       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
-         6,653,998 branch-misses             #    2.38% of all branches          ( +-  0.16% ) [33.93%]
-       495,463,378 L1-dcache-loads           #  572.698 M/sec                    ( +-  0.05% ) [28.12%]
-        27,903,270 L1-dcache-load-misses     #    5.63% of all L1-dcache hits    ( +-  0.28% ) [27.84%]
-           885,210 LLC-loads                 #    1.023 M/sec                    ( +-  3.21% ) [21.80%]
-             9,479 LLC-load-misses           #    1.07% of all LL-cache hits     ( +-  0.63% ) [ 5.61%]
-       830,096,007 L1-icache-loads           #  959.494 M/sec                    ( +-  0.08% ) [11.18%]
-       123,728,370 L1-icache-load-misses     #   14.91% of all L1-icache hits    ( +-  0.06% ) [16.78%]
-       504,932,490 dTLB-loads                #  583.643 M/sec                    ( +-  0.06% ) [22.30%]
-         2,056,069 dTLB-load-misses          #    0.41% of all dTLB cache hits   ( +-  2.23% ) [22.20%]
-     1,579,410,083 iTLB-loads                # 1825.614 M/sec                    ( +-  0.06% ) [22.30%]
-           394,739 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.27%]
-         2,286,363 L1-dcache-prefetches      #    2.643 M/sec                    ( +-  0.72% ) [22.40%]
-           776,096 L1-dcache-prefetch-misses #    0.897 M/sec                    ( +-  1.45% ) [22.54%]
+        859.259725 task-clock                #    0.472 CPUs utilized            ( +-  0.24% )
+           200,165 context-switches          #    0.233 M/sec                    ( +-  0.00% )
+                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
+               142 page-faults               #    0.000 M/sec                    ( +-  0.06% )
+     1,659,371,974 cycles                    #    1.931 GHz                      ( +-  0.18% ) [28.23%]
+       829,806,955 stalled-cycles-frontend   #   50.01% frontend cycles idle     ( +-  0.32% ) [28.32%]
+       490,316,435 stalled-cycles-backend    #   29.55% backend  cycles idle     ( +-  0.46% ) [28.34%]
+     1,445,166,061 instructions              #    0.87  insns per cycle
+                                             #    0.57  stalled cycles per insn  ( +-  0.06% ) [34.01%]
+       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]
+         5,056,568 branch-misses             #    1.79% of all branches          ( +-  0.19% ) [33.94%]
+       500,660,789 L1-dcache-loads           #  582.665 M/sec                    ( +-  0.06% ) [28.05%]
+        26,802,313 L1-dcache-load-misses     #    5.35% of all L1-dcache hits    ( +-  0.26% ) [27.83%]
+           872,571 LLC-loads                 #    1.015 M/sec                    ( +-  3.73% ) [21.82%]
+             9,050 LLC-load-misses           #    1.04% of all LL-cache hits     ( +-  0.55% ) [ 5.70%]
+       794,396,111 L1-icache-loads           #  924.512 M/sec                    ( +-  0.06% ) [11.30%]
+       130,179,414 L1-icache-load-misses     #   16.39% of all L1-icache hits    ( +-  0.09% ) [16.85%]
+       511,119,889 dTLB-loads                #  594.837 M/sec                    ( +-  0.06% ) [22.37%]
+         2,452,378 dTLB-load-misses          #    0.48% of all dTLB cache hits   ( +-  2.31% ) [22.14%]
+     1,597,897,243 iTLB-loads                # 1859.621 M/sec                    ( +-  0.06% ) [22.17%]
+           394,366 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.24%]
+         1,897,401 L1-dcache-prefetches      #    2.208 M/sec                    ( +-  0.64% ) [22.38%]
+           879,391 L1-dcache-prefetch-misses #    1.023 M/sec                    ( +-  0.90% ) [22.54%]

-       1.847093132 seconds time elapsed                                          ( +-  0.19% )
+       1.822131534 seconds time elapsed                                          ( +-  0.21% )
=====

As Peter have expected, the number of branches is slightly increased.

-       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
+       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]

However, looking overall, I think there is no significant problem on
the score with this patch set.  I'd love to hear from maintainers.


Thanks,
H.Seto

--------------030306050303060102060809
Content-Type: application/octet-stream;
 name="bwc-pipe-test.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bwc-pipe-test.tar.bz2"

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
--------------030306050303060102060809--

