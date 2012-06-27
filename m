Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2F0JBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:01:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20444 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2F0JBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:01:08 -0400
Date: Wed, 27 Jun 2012 12:00:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2 -resend] SCSI: advansys: handle errors from scsi_dma_map()
Message-ID: <20120627090055.GD31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_dma_map() returns -ENOMEM on error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Tue, 20 Sep 2011.

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 374c4ed..b2c3a1a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8426,6 +8426,12 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	/* Build ASC_SCSI_Q */
 	use_sg = scsi_dma_map(scp);
+	if (use_sg < 0) {
+		scsi_dma_unmap(scp);
+		scp->result = HOST_BYTE(DID_SOFT_ERROR);
+		return ASC_ERROR;
+	}
+
 	if (use_sg != 0) {
 		int sgcnt;
 		struct scatterlist *slp;
