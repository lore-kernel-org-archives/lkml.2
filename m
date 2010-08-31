Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0HaLDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:03:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5097 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0HaLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:03:33 -0400
X-SpamScore: 5
X-BigFish: VPS5(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h5bep5bfs43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L80JZ3-02-5BP-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 13:01:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] stop OProfile calling arch_exit when arch_init
 fails
Message-ID: <20100831110152.GD22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.10 14:51:58, Will Deacon wrote:
> These patches remove the oprofile_arch_exit call from oprofile_init,
> allowing architectures that perform memory allocation in their init
> functions to be simplified. This requires some changes to the ARM and
> x86 OProfile backends to ensure that their init functions clean up
> after themselves if they fail.
> 
> This is required for Matt's combined OProfile/Perf driver which will
> be shared between all architectures.
> 
> Patches taken against tip/master.
> 
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> Will Deacon (3):
>   oprofile: don't call arch exit code from init code on failure
>   ARM: oprofile: fix and simplify init/exit functions
>   x86: oprofile: fix oprofile_arch_init behaviour on failure
> 
>  arch/arm/oprofile/common.c |   47 +++++++++++++++++++++++--------------------
>  arch/x86/oprofile/init.c   |   26 ++++++++++++++----------
>  drivers/oprofile/oprof.c   |   11 +--------
>  3 files changed, 42 insertions(+), 42 deletions(-)

I have applied patch #1 and #2 to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

with some small modifications:

Patch #1: Commit message, x86 removed.
Patch #2: Order of freeing memory:

+out:
+       if (ret) {
+               for_each_possible_cpu(cpu)
+                       kfree(perf_events[cpu]);
+               kfree(counter_config);
+       }
+

There is also the patch below on top of it.

Thanks Will,

-Robert

--

>From 4cbe75be5c6ae86bdc7daec864eeb2dfd66f48bb Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 30 Aug 2010 18:21:55 +0200
Subject: [PATCH] oprofile, arm: initialize perf_event pointers with NULL

The pointers must be NULL'ed to avoid double-freeing the pointers in
rare cases during reinitialization.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index c3652f7..d660cb8 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -351,6 +351,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	int cpu, ret = 0;
 
+	memset(&perf_events, 0, sizeof(perf_events));
+
 	perf_num_counters = armpmu_get_max_events();
 
 	counter_config = kcalloc(perf_num_counters,
-- 
1.7.1.1


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

