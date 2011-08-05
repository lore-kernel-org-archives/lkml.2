Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1HENPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:15:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57661 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1HENPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:15:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Andre Przywara <Andre.Przywara@amd.com>,
        Martin Pohlack <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3.1 0/3] x86, AMD: Correct F15h IC aliasing issue
Date: Fri,  5 Aug 2011 15:15:07 +0200
Message-Id: <1312550110-24160-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

a small refinement of the patchset from yesterday per hpa's comments:

* put mask and flags into a single cacheline and make it __read_mostly

* change alignment computation back to clearing bits [14:12] so that a
mask of 0x0 can have no effect on the address.

Please take a look and apply, if no objections.

Thanks.

---
Changelog:

v3:
here's an updated and revised patchset addressing all comments from last
time:

* saturate bits [14:12] instead of clearing them
* calculate the mask from the CPUID 0x8000_0005 IC identifier instead of
hardcoding it

v2:
here's the second version of this patch which actually turned into a
small patchset. As Ingo suggested, the initial patch stays first to ease
backporting and the following 3 patches address (hopefully) all review
comments from the initial submission. The patchset has been tested with
Debian's old stable lenny (i.e. 5.0) distro in a 32-bit environment and
all worked as expected.

Below some performance data to show that there is no noticeable
performance degradation introduced by the changeset.

So please, do take a look again and let me know.

Thanks.

VA alignment enabled.
====================

 Performance counter stats for './build.sh' (10 runs):

    3187047.935990 task-clock                #   24.001 CPUs utilized            ( +-  1.37% )
           510,888 context-switches          #    0.000 M/sec                    ( +-  0.44% )
            60,712 CPU-migrations            #    0.000 M/sec                    ( +-  0.51% )
        26,046,891 page-faults               #    0.008 M/sec                    ( +-  0.00% )
 1,841,068,123,735 cycles                    #    0.578 GHz                      ( +-  1.10% ) [63.39%]
   560,044,437,348 stalled-cycles-frontend   #   30.42% frontend cycles idle     ( +-  1.13% ) [64.65%]
   436,165,228,465 stalled-cycles-backend    #   23.69% backend  cycles idle     ( +-  1.19% ) [67.21%]
 1,461,854,088,667 instructions              #    0.79  insns per cycle
                                             #    0.38  stalled cycles per insn  ( +-  0.77% ) [70.31%]
   334,169,452,362 branches                  #  104.852 M/sec                    ( +-  1.20% ) [69.43%]
    21,485,007,982 branch-misses             #    6.43% of all branches          ( +-  0.68% ) [65.01%]

     132.787483539 seconds time elapsed                                          ( +-  1.37% )


VA alignment disabled
=====================

Performance counter stats for './build.sh' (10 runs):

    3173688.887193 task-clock                #   24.001 CPUs utilized            ( +-  1.37% )
           511,425 context-switches          #    0.000 M/sec                    ( +-  0.28% )
            60,522 CPU-migrations            #    0.000 M/sec                    ( +-  0.60% )
        26,046,902 page-faults               #    0.008 M/sec                    ( +-  0.00% )
 1,832,825,813,094 cycles                    #    0.578 GHz                      ( +-  0.96% ) [63.60%]
   563,123,451,900 stalled-cycles-frontend   #   30.72% frontend cycles idle     ( +-  0.96% ) [63.97%]
   439,565,070,106 stalled-cycles-backend    #   23.98% backend  cycles idle     ( +-  1.23% ) [66.69%]
 1,465,314,643,020 instructions              #    0.80  insns per cycle
                                             #    0.38  stalled cycles per insn  ( +-  0.74% ) [70.11%]
   332,416,669,982 branches                  #  104.741 M/sec                    ( +-  0.85% ) [69.71%]
    21,181,821,204 branch-misses             #    6.37% of all branches          ( +-  0.97% ) [65.93%]

     132.230903628 seconds time elapsed                                          ( +-  1.37% )

stock 3.0
=========

 Performance counter stats for './build.sh' (10 runs):

    3369707.240439 task-clock                #   24.001 CPUs utilized            ( +-  1.18% )
           510,450 context-switches          #    0.000 M/sec                    ( +-  0.29% )
            58,906 CPU-migrations            #    0.000 M/sec                    ( +-  0.35% )
        26,057,272 page-faults               #    0.008 M/sec                    ( +-  0.00% )
 1,836,326,075,063 cycles                    #    0.545 GHz                      ( +-  1.05% ) [63.51%]
   561,850,647,545 stalled-cycles-frontend   #   30.60% frontend cycles idle     ( +-  1.03% ) [64.17%]
   439,923,021,200 stalled-cycles-backend    #   23.96% backend  cycles idle     ( +-  1.10% ) [66.64%]
 1,467,236,934,265 instructions              #    0.80  insns per cycle
                                             #    0.38  stalled cycles per insn  ( +-  0.87% ) [70.06%]
   331,937,054,120 branches                  #   98.506 M/sec                    ( +-  0.81% ) [69.83%]
    21,228,553,080 branch-misses             #    6.40% of all branches          ( +-  0.87% ) [65.79%]

     140.398317711 seconds time elapsed                                          ( +-  1.18% )


