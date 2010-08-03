Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab0HCRhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:37:05 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:15361 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab0HCRg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:36:58 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 2/6] staging: hv: Fixed lockup problem with bounce_buffer
 scatter list
Thread-Topic: [PATCH 2/6] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list
Thread-Index: AcszLN0XE1cvJoW/S1u5tYxf4xhZuw==
Date: Tue, 3 Aug 2010 17:31:53 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FD1D29@TK5EX14MBXC114.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

Fixed lockup problem with bounce_buffer scatter list which caused crashes in heavy loads.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com> 

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
 		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction, @@ -697,6 +698,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	request->DataBuffer.Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
+		sg_count = scsi_sg_count(scmnd);
 
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) { @@ -731,15 +733,16 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
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

