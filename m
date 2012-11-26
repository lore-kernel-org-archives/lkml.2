Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2KZRDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47285 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2KZRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 057/270] scsi_debug: Fix off-by-one bug when unmapping region
Date: Mon, 26 Nov 2012 14:55:47 -0200
Message-Id: <1353949160-26803-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit bc977749e967daa56de1922cf4cb38525631c51c upstream.

Currently it is possible to unmap one more block than user requested to
due to the off-by-one error in unmap_region(). This is probably due to
the fact that the end variable despite its name actually points to the
last block to unmap + 1. However in the condition it is handled as the
last block of the region to unmap.

The bug was not previously spotted probably due to the fact that the
region was not zeroed, which has changed with commit
be1dd78de5686c062bb3103f9e86d444a10ed783. With that commit we were able
to corrupt the ext4 file system on 256M scsi_debug device with LBPRZ
enabled using fstrim.

Since the 'end' semantic is the same in several functions there this
commit just fixes the condition to use the 'end' variable correctly in
that context.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..f4cc413 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2054,7 +2054,7 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end && block < map_size) {
+		if (rem == 0 && lba + granularity < end && block < map_size) {
 			clear_bit(block, map_storep);
 			if (scsi_debug_lbprz)
 				memset(fake_storep +
-- 
1.7.9.5

