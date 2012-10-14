Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2JNOue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:50:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46716 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab2JNOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:04 -0400
Message-Id: <20121014143540.098942410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 046/147] [SCSI] zfcp: Bounds checking for deferred error trace
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 01e60527f0a49b3d7df603010bd6079bb4b6cf07 upstream.

The pl vector has scount elements, i.e. pl[scount-1] is the last valid
element. For maximum sized requests, payload->counter == scount after
the last loop iteration. Therefore, do bounds checking first (with
boolean shortcut) to not access the invalid element pl[scount].

Do not trust the maximum sbale->scount value from the HBA
but ensure we won't access the pl vector out of our allocated bounds.
While at it, clean up scoping and prevent unnecessary memset.

Minor fix for 86a9668a8d29ea711613e1cb37efa68e7c4db564
"[SCSI] zfcp: support for hardware data router"

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_dbf.c  |    2 +-
 drivers/s390/scsi/zfcp_qdio.c |   16 ++++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 3c1d220..c6e47d5 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -191,7 +191,7 @@ void zfcp_dbf_hba_def_err(struct zfcp_adapter *adapter, u64 req_id, u16 scount,
 	length = min((u16)sizeof(struct qdio_buffer),
 		     (u16)ZFCP_DBF_PAY_MAX_REC);
 
-	while ((char *)pl[payload->counter] && payload->counter < scount) {
+	while (payload->counter < scount && (char *)pl[payload->counter]) {
 		memcpy(payload->data, (char *)pl[payload->counter], length);
 		debug_event(dbf->pay, 1, payload, zfcp_dbf_plen(length));
 		payload->counter++;
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index b9fffc8..50b5615 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -102,18 +102,22 @@ static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int qdio_err,
 {
 	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
 	struct zfcp_adapter *adapter = qdio->adapter;
-	struct qdio_buffer_element *sbale;
 	int sbal_no, sbal_idx;
-	void *pl[ZFCP_QDIO_MAX_SBALS_PER_REQ + 1];
-	u64 req_id;
-	u8 scount;
 
 	if (unlikely(qdio_err)) {
-		memset(pl, 0, ZFCP_QDIO_MAX_SBALS_PER_REQ * sizeof(void *));
 		if (zfcp_adapter_multi_buffer_active(adapter)) {
+			void *pl[ZFCP_QDIO_MAX_SBALS_PER_REQ + 1];
+			struct qdio_buffer_element *sbale;
+			u64 req_id;
+			u8 scount;
+
+			memset(pl, 0,
+			       ZFCP_QDIO_MAX_SBALS_PER_REQ * sizeof(void *));
 			sbale = qdio->res_q[idx]->element;
 			req_id = (u64) sbale->addr;
-			scount = sbale->scount + 1; /* incl. signaling SBAL */
+			scount = min(sbale->scount + 1,
+				     ZFCP_QDIO_MAX_SBALS_PER_REQ + 1);
+				     /* incl. signaling SBAL */
 
 			for (sbal_no = 0; sbal_no < scount; sbal_no++) {
 				sbal_idx = (idx + sbal_no) %


