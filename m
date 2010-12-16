Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0LPTC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:02:56 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39387 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0LPTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:02:55 -0500
Subject: [PATCH] cciss: fix cciss_revalidate panic.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Thu, 16 Dec 2010 13:02:00 -0600
Message-ID: <20101216190200.630.8596.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <StephenM.Cameron>

If you delete a logical drive, and then run BLKRRPART (e.g. via fdisk)
on a logical drive which is "after" the deleted logical drive in the h->drv[]
array, then cciss_revalidate panics because it will access the null pointer
h->drv[x] when x hits the deleted drive.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f291587..8e0f925 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2834,6 +2834,8 @@ static int cciss_revalidate(struct gendisk *disk)
 	InquiryData_struct *inq_buff = NULL;
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
+		if (!h->drv[logvol])
+			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;

