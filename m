Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab2F0JAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:00:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27313 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2F0JAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:00:10 -0400
Date: Wed, 27 Jun 2012 11:59:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jing Huang <huangj@brocade.com>
Cc: Krishna C Gudipati <kgudipat@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] [SCSI] bfa: dereferencing freed memory in
 bfad_im_probe()
Message-ID: <20120627085958.GB31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bfad_thread_workq(bfad) was not BFA_STATUS_OK then we freed "im"
and then dereferenced it.

I did a little clean up because it seemed nicer to return directly
instead of doing a superfluous goto.  I looked at other functions in
this file and it seems like returning directly is standard.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is the third time I have sent this patch.  It was previously sent
on Fri, 29 Jul 2011 and Wed, 29 Feb 2012.

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 1ac09af..2eebf8d 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -687,25 +687,21 @@ bfa_status_t
 bfad_im_probe(struct bfad_s *bfad)
 {
 	struct bfad_im_s      *im;
-	bfa_status_t    rc = BFA_STATUS_OK;
 
 	im = kzalloc(sizeof(struct bfad_im_s), GFP_KERNEL);
-	if (im == NULL) {
-		rc = BFA_STATUS_ENOMEM;
-		goto ext;
-	}
+	if (im == NULL)
+		return BFA_STATUS_ENOMEM;
 
 	bfad->im = im;
 	im->bfad = bfad;
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
-		rc = BFA_STATUS_FAILED;
+		return BFA_STATUS_FAILED;
 	}
 
 	INIT_WORK(&im->aen_im_notify_work, bfad_aen_im_notify_handler);
-ext:
-	return rc;
+	return BFA_STATUS_OK;
 }
 
 void
