Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2FRRSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:18:22 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:49059 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2FRRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:18:21 -0400
Message-ID: <201206181718.q5IHIKne030367@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 18 Jun 2012 13:11:21 -0400
Subject: [PATCH] arch/tile: big-endian: properly bswap instruction bundles when backtracing
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction bundles are always little-endian, even when running in
big-endian mode.  I missed this internal bug fix when cherry-picking
the big-endian code to return to the community.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/backtrace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
index 9092ce8..f8b74ca 100644
--- a/arch/tile/kernel/backtrace.c
+++ b/arch/tile/kernel/backtrace.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <asm/byteorder.h>
 #include <asm/backtrace.h>
 #include <asm/tile-desc.h>
 #include <arch/abi.h>
@@ -336,8 +337,12 @@ static void find_caller_pc_and_caller_sp(CallerLocation *location,
 				bytes_to_prefetch / sizeof(tile_bundle_bits);
 		}
 
-		/* Decode the next bundle. */
-		bundle.bits = prefetched_bundles[next_bundle++];
+		/*
+		 * Decode the next bundle.
+		 * TILE always stores instruction bundles in little-endian
+		 * mode, even when the chip is running in big-endian mode.
+		 */
+		bundle.bits = le64_to_cpu(prefetched_bundles[next_bundle++]);
 		bundle.num_insns =
 			parse_insn_tile(bundle.bits, pc, bundle.insns);
 		num_info_ops = bt_get_info_ops(&bundle, info_operands);
-- 
1.7.10.3

