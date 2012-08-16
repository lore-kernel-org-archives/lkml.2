Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2HPLEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:04:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47465 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab2HPLEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:04:13 -0400
Date: Thu, 16 Aug 2012 14:04:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mvsas: fix a && vs & bug
Message-ID: <20120816110401.GA12318@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "1 << (slot_idx % 32)" condition is always true.  The intent was to
test a bit field here using bitwise AND.  We do the test correctly a few
lines later in the do while loop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker fix.  Untested.  Would apply to the -stable kernel.

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 7e423e5..16349aa 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -622,7 +622,7 @@ static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 {
 	u32 tmp;
 	tmp = mvs_cr32(mvi, MVS_COMMAND_ACTIVE+(slot_idx >> 3));
-	if (tmp && 1 << (slot_idx % 32)) {
+	if (tmp & 1 << (slot_idx % 32)) {
 		mv_printk("command active %08X,  slot [%x].\n", tmp, slot_idx);
 		mvs_cw32(mvi, MVS_COMMAND_ACTIVE + (slot_idx >> 3),
 			1 << (slot_idx % 32));
