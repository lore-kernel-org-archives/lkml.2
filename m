Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2DFMiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:38:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2DFMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:38:49 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH] x86: cache_info: Fix setup of l2/l3 ids
Date: Fri,  6 Apr 2012 15:38:14 +0300
Message-Id: <1333715894-25995-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

On some architectures (such as vSMP), it is possible to have CPUs with a
different number of cores sharing the same cache.

The current implementation implicitly assumes that all CPUs will have
the same number of cores sharing caches, and as a result, different CPUs
can end up with the same l2/l3 ids.

Fix this by masking out the shared cache bits, instead of shifting the
APICID. By doing so, it is guaranteed that the generated cache ids are
always unique.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: rebased, simplified, and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..caa6cb0 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -615,14 +615,14 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 					new_l2 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(num_threads_sharing);
-					l2_id = c->apicid >> index_msb;
+					l2_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				case 3:
 					new_l3 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(
 							num_threads_sharing);
-					l3_id = c->apicid >> index_msb;
+					l3_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				default:
 					break;
-- 
1.7.7.6

