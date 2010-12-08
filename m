Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0LHCRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:17:23 -0500
Received: from kroah.org ([198.145.64.141]:45971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab0LHAqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.071058996@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>
Subject: [027/127] sgi-xpc: XPC fails to discover partitions with all nasids above 128
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/misc/sgi-xp/xpc_partition.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -433,18 +433,23 @@ xpc_discovery(void)
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


