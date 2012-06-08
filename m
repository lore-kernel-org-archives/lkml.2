Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007Ab2FHMbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:31:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43592 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab2FHMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:31:40 -0400
Date: Fri, 8 Jun 2012 15:31:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch -resend] drbd: fix resync_dump_detail() output
Message-ID: <20120608123128.GA18293@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tests here aren't correct.  It should be doing a shift before doing
the bitwise AND.  (bme->flags & BME_NO_WRITES) is always false and
(bme->flags & BME_LOCKED) checks for BME_NO_WRITES instead of checking
for locked.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I sent this to the drbd-user list in March, but never recieved a
response.

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 2959cdf..ffe1ee4 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -187,8 +187,10 @@ static void resync_dump_detail(struct seq_file *seq, struct lc_element *e)
 	struct bm_extent *bme = lc_entry(e, struct bm_extent, lce);
 
 	seq_printf(seq, "%5d %s %s\n", bme->rs_left,
-		   bme->flags & BME_NO_WRITES ? "NO_WRITES" : "---------",
-		   bme->flags & BME_LOCKED ? "LOCKED" : "------"
+		   test_bit(BME_NO_WRITES, &bme->flags) ?
+			"NO_WRITES" : "---------",
+		   test_bit(BME_LOCKED, &bme->flags) ?
+			"LOCKED" : "------"
 		   );
 }
 
