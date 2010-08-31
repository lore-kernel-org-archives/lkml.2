Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0IAPxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:53:01 -0400
Received: from p3plsmtpa01-04.prod.phx3.secureserver.net ([72.167.82.84]:60770
	"HELO p3plsmtpa01-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751301Ab0IAPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:53:00 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2010 11:53:00 EDT
Message-ID: <4C7D4667.5040102@sailtheuniverse.com>
Date: Tue, 31 Aug 2010 11:13:59 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, devel@driverdev.osuosl.org
CC: haiyangz@microsoft.com
Subject: [PATCH 2/5] staging: hv: Fixed lockup problem with bounce_buffer
 scatter list - RESEND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Send from a linux machine, not routed through exchange)

Fixed lockup problem with bounce_buffer scatter list which caused 
crashes in heavy loads.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com

---
 drivers/staging/hv/storvsc_drv.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3b9ccb0..169d701 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -615,6 +615,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	unsigned int request_size = 0;
 	int i;
 	struct scatterlist *sgl;
+	unsigned int sg_count = 0;
 
 	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
 		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction,
@@ -697,6 +698,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	request->DataBuffer.Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
+		sg_count = scsi_sg_count(scmnd);
 
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
@@ -731,15 +733,16 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 					      scsi_sg_count(scmnd));
 
 			sgl = cmd_request->bounce_sgl;
+			sg_count = cmd_request->bounce_sgl_count;
 		}
 
 		request->DataBuffer.Offset = sgl[0].offset;
 
-		for (i = 0; i < scsi_sg_count(scmnd); i++) {
+		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->DataBuffer.PfnArray[i] =
-					page_to_pfn(sg_page((&sgl[i])));
+			request->DataBuffer.PfnArray[i] = 
+				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-- 
1.6.0.2

