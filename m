Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2F0SDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:03:25 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:39596 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab2F0SDX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:03:23 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 14:03:23 EDT
From: Krishna Gudipati <kgudipat@Brocade.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        Jing Huang <huangj@Brocade.com>
CC: "'James E.J. Bottomley'" <JBottomley@parallels.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'kernel-janitors@vger.kernel.org'" <kernel-janitors@vger.kernel.org>
Date: Wed, 27 Jun 2012 10:45:31 -0700
Subject: RE: [patch -resend] [SCSI] bfa: dereferencing freed memory in
 bfad_im_probe()
Thread-Topic: [patch -resend] [SCSI] bfa: dereferencing freed memory in
 bfad_im_probe()
Thread-Index: Ac1UQ0ABQfbMym+VSZG2oekisqvK2wASVq9Q
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A28396BCE91@HQ1-EXCH02.corp.brocade.com>
References: <20120627085800.GA3007@mwanda>
 <20120627085958.GB31212@elgon.mountain>
In-Reply-To: <20120627085958.GB31212@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-06-27_05:2012-06-27,2012-06-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1112030000 definitions=main-1206270178
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, June 27, 2012 2:00 AM
To: Jing Huang
Cc: Krishna Gudipati; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch -resend] [SCSI] bfa: dereferencing freed memory in bfad_im_probe()

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

-----

Thanks for the patch.

Acked-by: Krishna Gudipati <kgudipat@brocade.com>

