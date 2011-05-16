Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1EPVWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:22:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:37238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab1EPVWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:22:41 -0400
Date: Mon, 16 May 2011 21:22:31 GMT
From: tip-bot for Frank Arnold <frank.arnold@amd.com>
Message-ID: <tip-42be450565b0fc4607fae3e3a7da038d367a23ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        frank.arnold@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        frank.arnold@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        borislav.petkov@amd.com
In-Reply-To: <1305553188-21061-3-git-send-email-bp@amd64.org>
References: <1305553188-21061-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD, cacheinfo: Fix L3 cache index disable checks
Git-Commit-ID: 42be450565b0fc4607fae3e3a7da038d367a23ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 21:22:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42be450565b0fc4607fae3e3a7da038d367a23ed
Gitweb:     http://git.kernel.org/tip/42be450565b0fc4607fae3e3a7da038d367a23ed
Author:     Frank Arnold <frank.arnold@amd.com>
AuthorDate: Mon, 16 May 2011 15:39:47 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 May 2011 11:24:27 -0700

x86, AMD, cacheinfo: Fix L3 cache index disable checks

We provide two slots to disable cache indices, and have a check to
prevent both slots to be used for the same index.

If the user disables the same index on different subcaches, both slots
will hold the same index, e.g.

  $ echo 2047 > /sys/devices/system/cpu/cpu0/cache/index3/cache_disable_0
  $ cat /sys/devices/system/cpu/cpu0/cache/index3/cache_disable_0
  2047
  $ echo 1050623 > /sys/devices/system/cpu/cpu0/cache/index3/cache_disable_1
  $ cat /sys/devices/system/cpu/cpu0/cache/index3/cache_disable_1
  2047

due to the fact that the check was looking only at index bits [11:0]
and was ignoring writes to bits outside that range. The more correct
fix is to simply check whether the index is within the bounds of
[0..l3->indices].

While at it, cleanup comments and drop now-unused local macros.

Signed-off-by: Frank Arnold <frank.arnold@amd.com>
Link: http://lkml.kernel.org/r/1305553188-21061-3-git-send-email-bp@amd64.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 31590a0..c105c53 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -453,27 +453,16 @@ int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
 {
 	int ret = 0;
 
-#define SUBCACHE_MASK	(3UL << 20)
-#define SUBCACHE_INDEX	0xfff
-
-	/*
-	 * check whether this slot is already used or
-	 * the index is already disabled
-	 */
+	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(l3, slot);
 	if (ret >= 0)
 		return -EINVAL;
 
-	/*
-	 * check whether the other slot has disabled the
-	 * same index already
-	 */
-	if (index == amd_get_l3_disable_slot(l3, !slot))
+	if (index > l3->indices)
 		return -EINVAL;
 
-	/* do not allow writes outside of allowed bits */
-	if ((index & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((index & SUBCACHE_INDEX) > l3->indices))
+	/* check whether the other slot has disabled the same index already */
+	if (index == amd_get_l3_disable_slot(l3, !slot))
 		return -EINVAL;
 
 	amd_l3_disable_index(l3, cpu, slot, index);
