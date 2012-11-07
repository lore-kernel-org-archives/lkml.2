Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab2KGGGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:06:01 -0500
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:49120 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab2KGGF7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:05:59 -0500
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: Kent Overstreet <koverstreet@google.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
CC: "tj@kernel.org" <tj@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "neilb@suse.de" <neilb@suse.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "Moore, Eric" <Eric.Moore@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 7 Nov 2012 11:35:51 +0530
Subject: RE: [PATCH v4 08/24] block: Remove some unnecessary bi_vcnt usage
Thread-Topic: [PATCH v4 08/24] block: Remove some unnecessary bi_vcnt usage
Thread-Index: Ac2rE5fEgLs5ZA0/Q6u4UZ8cT6lTNgRmhuSg
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E7398080@inbmail02.lsi.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-9-git-send-email-koverstreet@google.com>
In-Reply-To: <1350331769-14856-9-git-send-email-koverstreet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Kent Overstreet
Sent: Tuesday, October 16, 2012 1:39 AM
To: linux-bcache@vger.kernel.org; linux-kernel@vger.kernel.org; dm-devel@redhat.com
Cc: Kent Overstreet; tj@kernel.org; axboe@kernel.dk; neilb@suse.de; vgoyal@redhat.com; Moore, Eric; James E.J. Bottomley; linux-scsi@vger.kernel.org
Subject: [PATCH v4 08/24] block: Remove some unnecessary bi_vcnt usage

More prep work for immutable bvecs/effecient bio splitting - usage of bi_vcnt has to be auditing, so getting rid of all the unnecessary usage makes that easier.

Plus, bio_segments() is really what this code wanted, as it respects the current value of bi_idx.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Eric Moore <Eric.Moore@lsi.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
---
 drivers/message/fusion/mptsas.c          |  6 +++---
 drivers/scsi/libsas/sas_expander.c       |  6 +++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c index 551262e..5406a9f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2235,10 +2235,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
 		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
-		    rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
+		    ioc->name, __func__, bio_segments(req->bio), blk_rq_bytes(req),
+		    bio_segments(rsp->bio), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index efc6e72..ee331a7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2151,10 +2151,10 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
-		       rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
+		       __func__, bio_segments(req->bio), blk_rq_bytes(req),
+		       bio_segments(rsp->bio), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index c6cf20f..403a57b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1939,7 +1939,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	ioc->transport_cmds.status = MPT2_CMD_PENDING;
 
 	/* Check if the request is split across multiple segments */
-	if (req->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1) {
 		u32 offset = 0;
 
 		/* Allocate memory and copy the request */ @@ -1971,7 +1971,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	/* Check if the response needs to be populated across
 	 * multiple segments */
-	if (rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(rsp->bio) > 1) {
 		pci_addr_in = pci_alloc_consistent(ioc->pdev, blk_rq_bytes(rsp),
 		    &pci_dma_in);
 		if (!pci_addr_in) {
@@ -2038,7 +2038,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (req->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(req) - 4), pci_dma_out);
 	} else {
@@ -2054,7 +2054,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
 	    MPI2_SGE_FLAGS_END_OF_LIST);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(rsp->bio) > 1) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(rsp) + 4), pci_dma_in);
 	} else {
@@ -2099,7 +2099,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
 		/* check if the resp needs to be copied from the allocated
 		 * pci mem */
-		if (rsp->bio->bi_vcnt > 1) {
+		if (bio_segments(rsp->bio) > 1) {
 			u32 offset = 0;
 			u32 bytes_to_copy =
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
--
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
