Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1EPNkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:40:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58862 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1EPNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:40:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frank Arnold <frank.arnold@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] x86, AMD, cacheinfo: Fix L3 cache index disable checks
Date: Mon, 16 May 2011 15:39:47 +0200
Message-Id: <1305553188-21061-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305553188-21061-1-git-send-email-bp@amd64.org>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Arnold <frank.arnold@amd.com>

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
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
-- 
1.7.4.rc2

