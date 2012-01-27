Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2A1A25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 19:28:57 -0500
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:39388 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab2A1A2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 19:28:55 -0500
X-Greylist: delayed 3149 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 19:28:55 EST
From: Krishna Gudipati <kgudipat@Brocade.com>
To: "'Jesper Juhl'" <jj@chaosbits.net>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        Krishna Gudipati <kgudipat@Brocade.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Jing Huang" <huangj@Brocade.com>,
        "'James E.J. Bottomley'" <JBottomley@parallels.com>,
        "'Joe Perches'" <joe@perches.com>
Date: Fri, 27 Jan 2012 15:36:11 -0800
Subject: RE: [PATCH] SCSI, bfa: don't leak mem in
 bfad_im_bsg_els_ct_request()
Thread-Topic: [PATCH] SCSI, bfa: don't leak mem in
 bfad_im_bsg_els_ct_request()
Thread-Index: AczdSrDvoVPj7Yp4TJWdzMLqILPoHQAAW5Iw
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A260325B189@HQ1-EXCH02.corp.brocade.com>
References: <alpine.LNX.2.00.1201280021320.13952@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1201280021320.13952@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-27_07:2012-01-27,2012-01-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1201270304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good. Thanks for the patch.

Acked-by: Krishna Gudipati <kgudipat@brocade.com>

---------------

If 'drv_fcxp = kzalloc(sizeof(struct bfad_fcxp), GFP_KERNEL);' fails
and returns NULL, then we'll leak the memory allocated to 'bsg_fcpt'
when we jump to 'out:' and the variable subsequently goes out of
scope.

Also remove the cast of the kzalloc() return value. kzalloc() returns
a void* which is implicitly converted, so the explicit cast is
pointless.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/bfa/bfad_bsg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

 Compile tested only, as I have no hardware to test for real.

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 530de2b..8005c6c 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3047,8 +3047,7 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	 * Allocate buffer for bsg_fcpt and do a copy_from_user op for payload
 	 * buffer of size bsg_data->payload_len
 	 */
-	bsg_fcpt = (struct bfa_bsg_fcpt_s *)
-		   kzalloc(bsg_data->payload_len, GFP_KERNEL);
+	bsg_fcpt = kzalloc(bsg_data->payload_len, GFP_KERNEL);
 	if (!bsg_fcpt)
 		goto out;
 
@@ -3060,6 +3059,7 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 
 	drv_fcxp = kzalloc(sizeof(struct bfad_fcxp), GFP_KERNEL);
 	if (drv_fcxp == NULL) {
+		kfree(bsg_fcpt);
 		rc = -ENOMEM;
 		goto out;
 	}
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
