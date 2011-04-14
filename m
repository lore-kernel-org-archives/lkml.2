Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab1DNSay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:30:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:37833 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab1DNRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Robin@sgi.com" <Robin@sgi.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 040/209] sgi-xpc: XPC fails to discover partitions with all nasids above 128
Date: Thu, 14 Apr 2011 13:41:10 -0400
Message-Id: <1302803039-9400-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin@sgi.com <Robin@sgi.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/misc/sgi-xp/xpc_partition.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index d551f09..6956f7e 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
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
-- 
1.7.4.4

