Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0DAPIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:08:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:13387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0DAPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,348,1267430400"; 
   d="scan'208";a="785774996"
Subject: [PATCH] sched: Fix sched_getaffinity(): Invalid argument issue
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: linux-kernel@vger.kernel.org
Cc: alex.shi@intel.com
Content-Type: text/plain
Organization: intel.com
Date: Thu, 01 Apr 2010 23:10:04 +0800
Message-Id: <1270134604.19373.7.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit cd3d8031eb fixed NU_CPUS > 1024 issue for old glibc binary
code compatibility. But it forget another situation: if the
nr_cpu_ids < len, the system call will return  -EINVAL incorrectly.

The situation happened on my NHM-EP machine with 16 LCPUs.
$ taskset -c 0 ls
sched_getaffinity: Invalid argument
failed to get pid 0's affinity.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 49d2fa7..fb9661b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4901,8 +4901,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 {
 	int ret;
 	cpumask_var_t mask;
+	size_t retlen = min_t(size_t, nr_cpu_ids, cpumask_size());
 
-	if (len < nr_cpu_ids)
+	if (len < retlen)
 		return -EINVAL;
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
@@ -4912,8 +4913,6 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		size_t retlen = min_t(size_t, len, cpumask_size());
-
 		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
 		else
-- 
1.6.3



