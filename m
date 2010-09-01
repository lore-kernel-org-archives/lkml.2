Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0IAWpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:45:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1212 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0IAWpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:45:30 -0400
Subject: Re: [PATCH 2/5] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list - RESEND
From: Joe Perches <joe@perches.com>
To: Hank Janssen <hjanssen@sailtheuniverse.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <4C7D601B.3060708@sailtheuniverse.com>
References: <4C7D4667.5040102@sailtheuniverse.com>
	 <1283359091.1797.179.camel@Joe-Laptop>
	 <4C7D601B.3060708@sailtheuniverse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 15:45:28 -0700
Message-ID: <1283381128.1797.238.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 13:03 -0700, Hank Janssen wrote:
> On 09/01/2010 09:38 AM, Joe Perches wrote:
> > On Tue, 2010-08-31 at 11:13 -0700, Hank Janssen wrote:
> >> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> >> -			request->DataBuffer.PfnArray[i] =
> >> -					page_to_pfn(sg_page((&sgl[i])));
> >> +			request->DataBuffer.PfnArray[i] = 
> >> +				page_to_pfn(sg_page((&sgl[i])));
> > I did a bit of a doubletake reading this last change.
> > This isn't actually a part of your fix and it introduces
> > a whitespace error.
> I will resubmit this patch and clean up the whitespace error.
> 
> When change the code I normally also change the indentation to the
> correct format for that area of the code. That is how the whitespace
> snuck in there.

At least mention the whitespace change in the description
or perhaps use a different coding style for readability
that uses temporaries to avoid the split lines.

Something like:

 drivers/staging/hv/storvsc_drv.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 075b61b..874891b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -611,6 +611,8 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	struct storvsc_driver_object *storvsc_drv_obj =
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
+	struct hv_multipage_buffer *rmpb;
+	u64 *rmpba;
 	struct storvsc_cmd_request *cmd_request;
 	unsigned int request_size = 0;
 	int i;
@@ -693,8 +695,10 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	request->SenseBuffer = scmnd->sense_buffer;
 	request->SenseBufferSize = SCSI_SENSE_BUFFERSIZE;
 
+	rmpb = &request->DataBuffer;
+	rmpba = rmpb->PfnArray;
 
-	request->DataBuffer.Length = scsi_bufflen(scmnd);
+	rmpb->Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 
@@ -733,20 +737,17 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 			sgl = cmd_request->bounce_sgl;
 		}
 
-		request->DataBuffer.Offset = sgl[0].offset;
+		rmpb->Offset = sgl[0].offset;
 
 		for (i = 0; i < scsi_sg_count(scmnd); i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->DataBuffer.PfnArray[i] =
-					page_to_pfn(sg_page((&sgl[i])));
+			*rmpba++ = page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->DataBuffer.Offset =
-			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->DataBuffer.PfnArray[0] =
-			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
+		rmpb->Offset = virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
+		*rmpba = virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
 retry_request:


