Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0I1Vrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:47:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:38791 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0I1Vrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:47:48 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, janjaap@bos.nl,
        geert@linux-m68k.org, jaxboe@fusionio.com, martin.petersen@oracle.com,
        adobriyan@gmail.com, cdfrey@foursquare.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/1] um: ubd: Fix data corruption
Date: Tue, 28 Sep 2010 23:47:36 +0200
Message-Id: <1285710456-4435-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under high load the file system gets corrupted.
This patch fixes the issue.

Many thanks to Janjaap Bos <janjaap@bos.nl>!

LKML-Reference: <AANLkTi=PTp7YW_eYxtF-H2QSxgei3whWH59wU0C9oCkz () mail ! gmail ! com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/ubd_kern.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..2874b83 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -748,9 +748,12 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 	}
 	ubd_dev->fd = fd;
 
-	if(ubd_dev->cow.file != NULL){
-		blk_queue_max_hw_sectors(ubd_dev->queue, 8 * sizeof(long));
+	/* A setting higher than 1 sector currently (>= v2.6.31) generates
+		data loss, both for raw and cow ubd. */
+	blk_queue_max_hw_sectors(ubd_dev->queue, 1 * sizeof(long));
+	blk_queue_max_segments(ubd_dev->queue, 1 * sizeof(long));
 
+	if (ubd_dev->cow.file != NULL) {
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
-- 
1.6.6.1

