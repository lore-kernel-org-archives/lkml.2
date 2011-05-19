Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1ESBE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:04:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50915 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1ESBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:04:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD46CAA.9030609@jp.fujitsu.com>
Date: Thu, 19 May 2011 10:04:42 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, infinipath@qlogic.com,
        linux-kernel@vger.kernel.org
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH] infiniband, ipath: convert old cpumask api into new one
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt new api. we plan to remove old one later. Almost change are
trivial. but there is one real fix. following code is unsafe.

	int ncpus = num_online_cpus()
	for (i = 0; i < ncpus; i++) {
		..
	}

because 1) we don't guarantee last bit of online cpus is equal
to num_online_cpus(). some arch assign sparse cpu number.
2) cpu hotplugging may change cpu_online_mask at same time.
we need to pin it by get_online_cpus().

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: Ralph Campbell <infinipath@qlogic.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index bdf4422..aab5d89 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
+#include <linux/cpu.h>
 #include <asm/pgtable.h>

 #include "ipath_kernel.h"
@@ -1684,17 +1685,19 @@ static int find_best_unit(struct file *fp,
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpumask_empty(&current->cpus_allowed) &&
-	    !cpumask_full(&current->cpus_allowed)) {
+	if (!cpumask_empty(tsk_cpus_allowed(current)) &&
+	    !cpumask_full(tsk_cpus_allowed(current))) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
-		for (i = 0; i < ncpus; i++)
-			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
+		get_online_cpus();
+		for_each_online_cpu(i)
+			if (cpumask_test_cpu(i, tsk_cpus_allowed(current))) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);
 				curcpu = i;
 				nset++;
 			}
+		put_online_cpus();
 		if (curcpu != -1 && nset != ncpus) {
 			if (npresent) {
 				prefunit = curcpu / (ncpus / npresent);
-- 
1.7.3.1


