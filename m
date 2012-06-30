Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2F3MBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 08:01:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:27224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2F3MBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 08:01:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117642656"
From: Octavian Purdila <octavian.purdila@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] resource: make sure requested range intersects root range
Date: Sat, 30 Jun 2012 15:00:57 +0300
Message-Id: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the requested and root ranges do not intersect the logic in
__reserve_region_with_split will cause an infinite recursion which
will overflow the stack as seen in the warning bellow.

This particular stack overflow was caused by requesting the
(100000000-107ffffff) range while the root range was (0-ffffffff). In
this case __request_resource would return the whole root range as
conflict range (i.e. 0-ffffffff). Then, the logic in
__reserve_region_with_split would continue the recursion requesting
the new range as (conflict->end+1, end) which incidentally in this
case equals the originally requested range.

This patch aborts looking for a usable range when the requested one is
completely outside the root range to avoid the infinite recursion, and
since this indicates a problem in the layers above, it also prints an
error message indicating the requested and root range in order to make
the problem more easily traceable.

[    5.968374] WARNING: at kernel/sched.c:4129 sub_preempt_count+0x63/0x89()
[    5.975150] Modules linked in:
[    5.978184] Pid: 1, comm: swapper Not tainted 3.0.22-mid27-00004-gb72c817 #46
[    5.985324] Call Trace:
[    5.987759]  [<c1039dfc>] ? console_unlock+0x17b/0x18d
[    5.992891]  [<c1039620>] warn_slowpath_common+0x48/0x5d
[    5.998194]  [<c1031758>] ? sub_preempt_count+0x63/0x89
[    6.003412]  [<c1039644>] warn_slowpath_null+0xf/0x13
[    6.008453]  [<c1031758>] sub_preempt_count+0x63/0x89
[    6.013499]  [<c14d60c4>] _raw_spin_unlock+0x27/0x3f
[    6.018453]  [<c10c6349>] add_partial+0x36/0x3b
[    6.022973]  [<c10c7c0a>] deactivate_slab+0x96/0xb4
[    6.027842]  [<c14cf9d9>] __slab_alloc.isra.54.constprop.63+0x204/0x241
[    6.034456]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.039842]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.045232]  [<c10c7dc9>] kmem_cache_alloc_trace+0x51/0xb0
[    6.050710]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
[    6.056100]  [<c103f78f>] kzalloc.constprop.5+0x29/0x38
[    6.061320]  [<c17b45e9>] __reserve_region_with_split+0x1c/0xd1
[    6.067230]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
...
[    7.179057]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
[    7.184970]  [<c17b4779>] reserve_region_with_split+0x30/0x42
[    7.190709]  [<c17a8ebf>] e820_reserve_resources_late+0xd1/0xe9
[    7.196623]  [<c17c9526>] pcibios_resource_survey+0x23/0x2a
[    7.202184]  [<c17cad8a>] pcibios_init+0x23/0x35
[    7.206789]  [<c17ca574>] pci_subsys_init+0x3f/0x44
[    7.211659]  [<c1002088>] do_one_initcall+0x72/0x122
[    7.216615]  [<c17ca535>] ? pci_legacy_init+0x3d/0x3d
[    7.221659]  [<c17a27ff>] kernel_init+0xa6/0x118
[    7.226265]  [<c17a2759>] ? start_kernel+0x334/0x334
[    7.231223]  [<c14d7482>] kernel_thread_helper+0x6/0x10

Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 kernel/resource.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index e1d2b8e..54402be 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -789,7 +789,13 @@ void __init reserve_region_with_split(struct resource *root,
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (start > root->end || end < root->start)
+		pr_err("Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
+		       (unsigned long long)start, (unsigned long long)end,
+		       (unsigned long long)root->start,
+		       (unsigned long long)root->end);
+	else
+		__reserve_region_with_split(root, start, end, name);
 	write_unlock(&resource_lock);
 }
 
-- 
1.7.9.5

