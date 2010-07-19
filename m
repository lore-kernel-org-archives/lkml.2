Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936477Ab0GSR7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:59:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:48677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934711Ab0GSR7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,227,1278313200"; 
   d="scan'208";a="639812445"
Message-ID: <4C44928E.8060506@linux.intel.com>
Date: Mon, 19 Jul 2010 10:59:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] slab: use deferable timers for its periodic housekeeping
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] slab: use deferable timers for its periodic housekeeping

slab has a "once every 2 second" timer for its housekeeping.
As the number of logical processors is growing, its more and more
common that this 2 second timer becomes the primary wakeup source.

This patch turns this housekeeping timer into a deferable timer,
which means that the timer does not interrupt idle, but just runs
at the next event that wakes the cpu up.

The impact is that the timer likely runs a bit later, but during the
delay no code is running so there's not all that much reason for
a difference in housekeeping to occur because of this delay.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  mm/slab.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7451bda..ef3cd3d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -884,7 +884,7 @@ static void __cpuinit start_cpu_timer(int cpu)
       */
      if (keventd_up() && reap_work->work.func == NULL) {
          init_reap_node(cpu);
-        INIT_DELAYED_WORK(reap_work, cache_reap);
+        INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
          schedule_delayed_work_on(cpu, reap_work,
                      __round_jiffies_relative(HZ, cpu));
      }
-- 
1.6.1.3

