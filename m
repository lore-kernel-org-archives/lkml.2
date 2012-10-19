Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2JSDbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:31:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:51150 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2JSCrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 17/62] SCSI: scsi_debug: Fix off-by-one bug when unmapping region
Date: Thu, 18 Oct 2012 19:44:45 -0700
Message-Id: <20121019024258.745872768@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2054,7 +2054,7 @@ static void unmap_region(sector_t lba, u
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end && block < map_size) {
+		if (rem == 0 && lba + granularity < end && block < map_size) {
 			clear_bit(block, map_storep);
 			if (scsi_debug_lbprz)
 				memset(fake_storep +


