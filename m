Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0IRTPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:10 -0400
Received: from kroah.org ([198.145.64.141]:43283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab0IRTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:59 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.846280359@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [030/129] staging: hv: Fixed lockup problem with bounce_buffer scatter list
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hank Janssen <hjanssen@microsoft.com>

commit 77c5ceaff31645ea049c6706b99e699eae81fb88 upstream.

Fixed lockup problem with bounce_buffer scatter list which caused
crashes in heavy loads. And minor code indentation cleanup in effected
area.

Removed whitespace and noted minor indentation changes in description as
pointed out by Joe Perches. (Thanks for reviewing Joe)

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/storvsc_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -646,6 +646,7 @@ static int storvsc_queuecommand(struct s
 	unsigned int request_size = 0;
 	int i;
 	struct scatterlist *sgl;
+	unsigned int sg_count = 0;
 
 	DPRINT_ENTER(STORVSC_DRV);
 
@@ -730,6 +731,7 @@ static int storvsc_queuecommand(struct s
 	request->DataBuffer.Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
+		sg_count = scsi_sg_count(scmnd);
 
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
@@ -764,15 +766,16 @@ static int storvsc_queuecommand(struct s
 					      scsi_sg_count(scmnd));
 
 			sgl = cmd_request->bounce_sgl;
+			sg_count = cmd_request->bounce_sgl_count;
 		}
 
 		request->DataBuffer.Offset = sgl[0].offset;
 
-		for (i = 0; i < scsi_sg_count(scmnd); i++) {
+		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
 			request->DataBuffer.PfnArray[i] =
-					page_to_pfn(sg_page((&sgl[i])));
+				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */


