Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab1GLHFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:05:00 -0400
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:55763 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab1GLHE6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:04:58 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 03:04:58 EDT
From: Jing Huang <huangj@Brocade.COM>
To: Dan Carpenter <error27@gmail.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Krishna Gudipati <kgudipat@Brocade.COM>
Date: Mon, 11 Jul 2011 23:54:46 -0700
Subject: RE: [patch 2/2] [SCSI] bfa: test is always false in
 bfa_sfp_media_get()
Thread-Topic: [patch 2/2] [SCSI] bfa: test is always false in
 bfa_sfp_media_get()
Thread-Index: Acw7sCBX7McqMT+JQ3yTBtjA8jEiDwErDKzA
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A82D670214@HQ1-EXCH01.corp.brocade.com>
References: <20110706074024.GE18655@shale.localdomain>
In-Reply-To: <20110706074024.GE18655@shale.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-07-12_02:2011-07-12,2011-07-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1107110311
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Dan Carpenter [mailto:error27@gmail.com]
>Sent: Wednesday, July 06, 2011 12:40 AM
>To: Jing Huang
>Cc: James E.J. Bottomley; open list:BROCADE BFA FC SC...; linux-
>kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
>Subject: [patch 2/2] [SCSI] bfa: test is always false in bfa_sfp_media_get()
>
>e10g.r.e10g_unall is only 1 bit so "if (e10g.r.e10g_unall & 0x80)"
>is always false.  e10g is a union between an unsigned char and named
>bitfields.  The intent here was to test the named bitfield by
>itself.
>
>We can change the previous tests as well.  That improves the
>readability and it looks like it fixes a endian bug as well.
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>
>---
>I don't understand where __BIGENDIAN is defined.  Only this driver
>references it.  How does that work?
>
>diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
>index 052373b..090a19d 100644
>--- a/drivers/scsi/bfa/bfa_ioc.c
>+++ b/drivers/scsi/bfa/bfa_ioc.c
>@@ -3589,11 +3589,11 @@ bfa_sfp_media_get(struct bfa_sfp_s *sfp)
> 			 (xmtr_tech & SFP_XMTR_TECH_SA))
> 			*media = BFA_SFP_MEDIA_SW;
> 		/* Check 10G Ethernet Compilance code */
>-		else if (e10g.b & 0x10)
>+		else if (e10g.r.e10g_sr)
> 			*media = BFA_SFP_MEDIA_SW;
>-		else if (e10g.b & 0x60)
>+		else if (e10g.r.e10g_lr && e10g.r.e10g_lrm)
> 			*media = BFA_SFP_MEDIA_LW;
>-		else if (e10g.r.e10g_unall & 0x80)
>+		else if (e10g.r.e10g_unall)
> 			*media = BFA_SFP_MEDIA_UNKNOWN;
> 		else
> 			bfa_trc(sfp, 0);

Hi Dan,

__BIGENIDIAN is a bug and it needs to be replaced with __BIG_ENDIAN.
The first two changes will introduce endianness issue without having __BIGENDIAN fixed.
The third change is good but also needs the same fix to make the code endianness netural,.

Thanks
Jing
