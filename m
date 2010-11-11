Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0KKVFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:05:20 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54829 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756779Ab0KKVFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:05:19 -0500
Message-Id: <20101111210515.112937290@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Nov 2010 15:05:07 -0600
From: Robin@sgi.com, "Holt <holt"@sgi.com
To: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch] XPC fails to discover partitions with all nasids above 128.
References: <20101111210506.081564086@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv_max_regions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV hardware defines 256 memory protection regions versus the baseline
64 with increasing size for the SN2 ia64.  This was overlooked when XPC
was modified to accomodate both UV and SN2.

Without this patch, a user could reconfigure their existing system and
suddenly disable cross-partition communications with no indication of
what has gone wrong.  It also prevents larger configurations from using
cross-partition communication.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: stable@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org

---

 drivers/misc/sgi-xp/xpc_partition.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: pv1012187/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- pv1012187.orig/drivers/misc/sgi-xp/xpc_partition.c	2010-11-11 15:01:51.963024726 -0600
+++ pv1012187/drivers/misc/sgi-xp/xpc_partition.c	2010-11-11 15:02:26.471574791 -0600
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

