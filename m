Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab2DYNvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:51:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab2DYNvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:51:10 -0400
Date: Wed, 25 Apr 2012 06:50:50 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-a720b2dd2470a52345df11dca8d6c1466599f812@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        borislav.petkov@amd.com, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        dan.carpenter@oracle.com, borislav.petkov@amd.com
In-Reply-To: <20120419070053.GB16645@elgon.mountain>
References: <20120419070053.GB16645@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, intel_cacheinfo:
  Fix error return code in amd_set_l3_disable_slot()
Git-Commit-ID: a720b2dd2470a52345df11dca8d6c1466599f812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:50:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a720b2dd2470a52345df11dca8d6c1466599f812
Gitweb:     http://git.kernel.org/tip/a720b2dd2470a52345df11dca8d6c1466599f812
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 19 Apr 2012 12:35:08 +0200
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 19 Apr 2012 18:30:28 +0200

x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()

If the L3 disable slot is already in use, return -EEXIST instead of
-EINVAL. The caller, store_cache_disable(), checks this return value to
print an appropriate warning.

Also, we want to signal with -EEXIST that the current index we're
disabling has actually been already disabled on the node:

$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
-bash: echo: write error: File exists
$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_1
-bash: echo: write error: File exists
$ echo 12 > /sys/devices/system/cpu/cpu5/cache/index3/cache_disable_1
-bash: echo: write error: File exists

The old code would say

-bash: echo: write error: Invalid argument

for disable slot 1 when playing the example above with no output in
dmesg, which is clearly misleading.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120419070053.GB16645@elgon.mountain
[Boris: add testing for the other index too]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..b8f3653 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -433,14 +433,14 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
-		return -EINVAL;
+		return -EEXIST;
 
 	if (index > nb->l3_cache.indices)
 		return -EINVAL;
 
 	/* check whether the other slot has disabled the same index already */
 	if (index == amd_get_l3_disable_slot(nb, !slot))
-		return -EINVAL;
+		return -EEXIST;
 
 	amd_l3_disable_index(nb, cpu, slot, index);
 
@@ -468,8 +468,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
-			printk(KERN_WARNING "L3 disable slot %d in use!\n",
-					    slot);
+			pr_warning("L3 slot %d in use/index already disabled!\n",
+				   slot);
 		return err;
 	}
 	return count;
