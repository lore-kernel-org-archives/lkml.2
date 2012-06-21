Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2FUVut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774Ab2FUVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:33 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 14/15] UBI: Fastmap: Improve invalidate_fastmap()
Date: Thu, 21 Jun 2012 23:50:07 +0200
Message-Id: <1340315408-27375-15-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 68be3d5..582f5ee 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1332,8 +1332,21 @@ static int invalidate_fastmap(struct ubi_device *ubi,
 			      struct ubi_fastmap_layout *fm)
 {
 	int ret, i;
+	struct ubi_vid_hdr *vh;
 
 	ret = erase_block(ubi, fm->e[0]->pnum);
+	if (ret < 0)
+		return ret;
+
+	vh = new_fm_vhdr(ubi, UBI_FM_SB_VOLUME_ID);
+	if (!vh)
+		return -ENOMEM;
+
+	/* deleting the current fastmap SB is not enough, an old SB may exist,
+	 * so create a (corrupted) SB such that fastmap will find it and fall
+	 * back to scanning mode in any case */
+	vh->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
+	ret = ubi_io_write_vid_hdr(ubi, fm->e[0]->pnum, vh);
 
 	for (i = 0; i < fm->used_blocks; i++)
 		ubi_wl_put_fm_peb(ubi, fm->e[i], fm->to_be_tortured[i]);
-- 
1.7.6.5

