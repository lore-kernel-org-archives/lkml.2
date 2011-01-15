Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1AOXYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:24:17 -0500
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57966 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab1AOXYQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:24:16 -0500
From: Jing Huang <huangj@Brocade.COM>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Date: Sat, 15 Jan 2011 15:24:06 -0800
Subject: RE: [PATCH] SCSI, Brocade FC HBA: Remember to always
 release_firmware() so we don't leak memory.
Thread-Topic: [PATCH] SCSI, Brocade FC HBA: Remember to always
 release_firmware() so we don't leak memory.
Thread-Index: AcuypXVloFKYvBuwR06IVbybm8q7ZgCZSN/Q
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5D390937D@HQ1-EXCH01.corp.brocade.com>
References: <alpine.LNX.2.00.1101122306480.27008@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101122306480.27008@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-15_08:2011-01-14,2011-01-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=7
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1101150109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing the issue. The patch looks good to me.

Acked-by: Jing Huang <huangj@brocade.com>

>-----Original Message-----
>From: Jesper Juhl [mailto:jj@chaosbits.net]
>Sent: Wednesday, January 12, 2011 2:10 PM
>To: linux-kernel@vger.kernel.org
>Cc: linux-scsi@vger.kernel.org; James E.J. Bottomley; Jing Huang
>Subject: [PATCH] SCSI, Brocade FC HBA: Remember to always release_firmware()
>so we don't leak memory.
>
>Once we've called request_firmware() we must remember to call
>release_firmware() to free memory. We don't currently do this in
>bfad_read_firmware(); causing a memory leak.
>
>Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>---
> bfad.c |   11 +++++------
> 1 file changed, 5 insertions(+), 6 deletions(-)
>
>  Compile tested only.
>
>diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
>index 44524cf..d7bafeb 100644
>--- a/drivers/scsi/bfa/bfad.c
>+++ b/drivers/scsi/bfa/bfad.c
>@@ -1558,23 +1558,22 @@ bfad_read_firmware(struct pci_dev *pdev, u32
>**bfi_image,
>
> 	if (request_firmware(&fw, fw_name, &pdev->dev)) {
> 		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
>-		goto error;
>+		*bfi_image = NULL;
>+		goto out;
> 	}
>
> 	*bfi_image = vmalloc(fw->size);
> 	if (NULL == *bfi_image) {
> 		printk(KERN_ALERT "Fail to allocate buffer for fw image "
> 			"size=%x!\n", (u32) fw->size);
>-		goto error;
>+		goto out;
> 	}
>
> 	memcpy(*bfi_image, fw->data, fw->size);
> 	*bfi_image_size = fw->size/sizeof(u32);
>-
>+out:
>+	release_firmware(fw);
> 	return *bfi_image;
>-
>-error:
>-	return NULL;
> }
>
> u32 *
>
>
>--
>Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
>Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
>Plain text mails only, please.

