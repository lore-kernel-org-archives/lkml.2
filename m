Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0LOQpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:45:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:39277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0LOQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:45:51 -0500
Message-ID: <4D08F0A2.9010301@kernel.org>
Date: Wed, 15 Dec 2010 17:45:22 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 4/5] vmstat: User per cpu atomics to avoid
 interrupt disable / enable
References: <20101214162842.542421046@linux.com> <20101214162854.811759020@linux.com>
In-Reply-To: <20101214162854.811759020@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:45:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> Currently the operations to increment vm counters must disable interrupts
> in order to not mess up their housekeeping of counters.
> 
> So use this_cpu_cmpxchg() to avoid the overhead. Since we can no longer
> count on preremption being disabled we still have some minor issues.
> The fetching of the counter thresholds is racy.
> A threshold from another cpu may be applied if we happen to be
> rescheduled on another cpu.  However, the following vmstat operation
> will then bring the counter again under the threshold limit.
> 
> The operations for __xxx_zone_state are not changed since the caller
> has taken care of the synchronization needs (and therefore the cycle
> count is even less than the optimized version for the irq disable case
> provided here).
> 
> The optimization using this_cpu_cmpxchg will only be used if the arch
> supports efficient this_cpu_ops (must have CONFIG_CMPXCHG_LOCAL set!)
> 
> The use of this_cpu_cmpxchg reduces the cycle count for the counter
> operations by %80 (inc_zone_page_state goes from 170 cycles to 32).
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
+/*
+ * If we have cmpxchg_local support then we do not need to incur the overhead
+ * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ *
+ * mod_state() modifies the zone counter state through atomic per cpu
+ * operations.
+ *
+ * Overstep mode specifies how overstep should handled:
+ *     0       No overstepping
+ *     1       Overstepping half of threshold
+ *     -1      Overstepping minus half of threshold
+*/
+static inline void mod_state(struct zone *zone,
+       enum zone_stat_item item, int delta, int overstep_mode)
+{
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	long o, n, t, z;
+
+	do {
+		z = 0;  /* overflow to zone counters */
+
+		/*
+		 * The fetching of the stat_threshold is racy. We may apply
+		 * a counter threshold to the wrong the cpu if we get
+		 * rescheduled while executing here. However, the following
+		 * will apply the threshold again and therefore bring the
+		 * counter under the threshold.
+		 */

What does "the following" mean here?  Later executions of the
function?  It seems like the counter can go out of the threshold at
least temporarily, which probably is okay but I think the comment can
be improved a bit.

Thanks.

-- 
tejun
