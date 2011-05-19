Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1ESBHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:07:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1ESBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:07:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD46D39.3060408@jp.fujitsu.com>
Date: Thu, 19 May 2011 10:07:05 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kosaki.motohiro@jp.fujitsu.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        mike.marciniszyn@qlogic.com, ralph.campbell@qlogic.com
Subject: [PATCH] infiniband, qib: convert old cpumask api into new one.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt new APIs. we plan to remove old one later and plan to
change current->cpus_allowed implementation.

No functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
Cc: Ralph Campbell <ralph.campbell@qlogic.com>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index de7d17d..dd9e1a2 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1527,6 +1527,7 @@ done_chk_sdma:
 		struct qib_filedata *fd = fp->private_data;
 		const struct qib_ctxtdata *rcd = fd->rcd;
 		const struct qib_devdata *dd = rcd->dd;
+		unsigned int weight;

 		if (dd->flags & QIB_HAS_SEND_DMA) {
 			fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
@@ -1545,8 +1546,8 @@ done_chk_sdma:
 		 * it just means that sooner or later we don't recommend
 		 * a cpu, and let the scheduler do it's best.
 		 */
-		if (!ret && cpus_weight(current->cpus_allowed) >=
-		    qib_cpulist_count) {
+		weight = cpumask_weight(tsk_cpus_allowed(current));
+		if (!ret && weight >= qib_cpulist_count) {
 			int cpu;
 			cpu = find_first_zero_bit(qib_cpulist,
 						  qib_cpulist_count);
@@ -1554,13 +1555,13 @@ done_chk_sdma:
 				__set_bit(cpu, qib_cpulist);
 				fd->rec_cpu_num = cpu;
 			}
-		} else if (cpus_weight(current->cpus_allowed) == 1 &&
-			test_bit(first_cpu(current->cpus_allowed),
+		} else if (weight == 1 &&
+			test_bit(cpumask_first(tsk_cpus_allowed(current)),
 				 qib_cpulist))
 			qib_devinfo(dd->pcidev, "%s PID %u affinity "
 				    "set to cpu %d; already allocated\n",
 				    current->comm, current->pid,
-				    first_cpu(current->cpus_allowed));
+				    cpumask_first(tsk_cpus_allowed(current)));
 	}

 	mutex_unlock(&qib_mutex);
-- 
1.7.3.1


