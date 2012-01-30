Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2A3SOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:14:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1270 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2A3SOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:14:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 30 Jan 2012 10:14:24 -0800
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Ingo Molnar'" <mingo@elte.hu>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Antti Miettinen <amiettinen@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Kevin Kranzusch <KKranzusch@nvidia.com>
Date: Mon, 30 Jan 2012 10:14:23 -0800
Subject: Fix bug: Scheduler's idle-load-balancer not running in first 5 mins
 after bootup
Thread-Topic: Fix bug: Scheduler's idle-load-balancer not running in first 5
 mins after bootup
Thread-Index: AczaMJze7gR8TJCfSwalICpzB0nx6AAAdJ6QAMLix1AAjxqtkA==
Message-ID: <1DD7BFEDD3147247B1355BEFEFE466523791832BD5@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ran into this at Nvidia. QA filed a bug saying coremark_4pthreads scores lower (as if running on 3 cores) when run shortly after bootup. But later its score increases to expected values on 4 cores.

This patch is relevant to linux-2.6.39 but I noticed this fix is not made in linux-3.0, 3.1, 3.2 or 3.3 also.

Please see commit log for more details of the problem and fix.

Thanks,
  Diwakar.
  Tegra Android Kernel SW Engg.
  NVIDIA.
  Santa Clara, CA

commit d04d7ef0e3f8c70bd6cd5abb2abc0236aa8d1f7c
Author: Diwakar Tundlam <dtundlam@nvidia.com>
Date:   Wed Jan 18 18:58:57 2012 -0800

    scheduler: domain: init next_balance in nohz_idle_balancer with jiffies
    
    The next_balance parameter of nohz_idle_balancer should be initialized
    to jiffies since jiffies itself is initialized to 300 seconds shy of
    overflow. Otherwise, nohz_idle_balancer does not run for the first 5
    mins after bootup.
    
    Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
    Reviewed-by: Aleksandr Frid <afrid@nvidia.com>
    Reviewed-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
    Reviewed-by: Satya Popuri <spopuri@nvidia.com>

 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c index c5b09f7..506c5da 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8288,6 +8288,7 @@ void __init sched_init(void)
        atomic_set(&nohz.load_balancer, nr_cpu_ids);
        atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
        atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+       nohz.next_balance = jiffies;
 #endif
        /* May be allocated at isolcpus cmdline parse time */
        if (cpu_isolated_map == NULL)
