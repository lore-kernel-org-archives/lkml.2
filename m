Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0LLXqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0LLXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:19 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Robin@sgi.com, holt@sgi.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [79/223] sgi-xpc: XPC fails to discover partitions with all nasids above 128
Message-Id: <20101212234618.476AAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Robin@sgi.com <Robin@sgi.com>

commit c22c7aeff69796f46ae0fcec141538e28f50b24e upstream.

UV hardware defines 256 memory protection regions versus the baseline 64
with increasing size for the SN2 ia64.  This was overlooked when XPC was
modified to accomodate both UV and SN2.

Without this patch, a user could reconfigure their existing system and
suddenly disable cross-partition communications with no indication of what
has gone wrong.  It also prevents larger configurations from using
cross-partition communication.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/misc/sgi-xp/xpc_partition.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_partition.c
+++ linux/drivers/misc/sgi-xp/xpc_partition.c
@@ -439,18 +439,23 @@ xpc_discovery(void)
 	 * nodes that can comprise an access protection grouping. The access
 	 * protection is in regards to memory, IOI and IPI.
 	 */
-	max_regions = 64;
 	region_size = xp_region_size;
 
-	switch (region_size) {
-	case 128:
-		max_regions *= 2;
-	case 64:
-		max_regions *= 2;
-	case 32:
-		max_regions *= 2;
-		region_size = 16;
-		DBUG_ON(!is_shub2());
+	if (is_uv())
+		max_regions = 256;
+	else {
+		max_regions = 64;
+
+		switch (region_size) {
+		case 128:
+			max_regions *= 2;
+		case 64:
+			max_regions *= 2;
+		case 32:
+			max_regions *= 2;
+			region_size = 16;
+			DBUG_ON(!is_shub2());
+		}
 	}
 
 	for (region = 0; region < max_regions; region++) {
