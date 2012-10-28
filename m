Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2J1Xaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:30:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42241 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978Ab2J1X2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:32 -0400
Message-Id: <20121028231545.899327283@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 029/105] [SCSI] scsi_debug: Fix off-by-one bug when unmapping region
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; unwrap the if-statement]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2045,8 +2045,7 @@ static void unmap_region(sector_t lba, u
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end &&
-		    block < map_size)
+		if (rem == 0 && lba + granularity < end && block < map_size)
 			clear_bit(block, map_storep);
 
 		lba += granularity - rem;


