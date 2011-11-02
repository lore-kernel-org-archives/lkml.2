Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab1KCBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab1KCBgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:53 2011
Message-Id: <20111102221453.769999201@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Radford <aradford@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [040/107] [SCSI] 3w-9xxx: fix iommu_iova leak
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 96067723e46b0dd24ae7b934085ab4eff4d26a1b upstream.

Following reports on the list, it looks like the 3e-9xxx driver will leak dma
mappings every time we get a transient queueing error back from the card.
This is because it maps the sg list in the routine that sends the command, but
doesn't unmap again in the transient failure path (even though the command is
sent back to the block layer).  Fix by unmapping before returning the status.

Reported-by: Chris Boot <bootc@bootc.net>
Tested-by: Chris Boot <bootc@bootc.net>
Acked-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/3w-9xxx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1786,10 +1786,12 @@ static int twa_scsi_queue(struct scsi_cm
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		break;
 	case 1:
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;


