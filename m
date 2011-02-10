Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1BJV5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:57:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52011 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab1BJV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:57:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH powerpc 2/2] powerpc: mask smp_processor_id() false positive
Date: Thu, 10 Feb 2011 13:57:27 -0800
Message-Id: <1297375047-18608-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110210215710.GA18429@linux.vnet.ibm.com>
References: <20110210215710.GA18429@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtas_event_scan() function uses smp_processor_id() to select a
starting point in cpu_online_mask, and does so under the protection
of get_online_cpus().  This might not select the current processor
in any case, so switch to raw_smp_processor_id().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/rtasd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 049dbec..7980ec0 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -412,7 +412,8 @@ static void rtas_event_scan(struct work_struct *w)
 
 	get_online_cpus();
 
-	cpu = cpumask_next(smp_processor_id(), cpu_online_mask);
+	/* raw_ OK because just using CPU as starting point. */
+	cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
         if (cpu >= nr_cpu_ids) {
 		cpu = cpumask_first(cpu_online_mask);
 
-- 
1.7.3.2

