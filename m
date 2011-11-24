Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1KXHhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:37:24 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:4279 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1KXHhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:37:22 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz1432Nzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: Liu Shuo-B35362 <B35362@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
Thread-Topic: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
Thread-Index: AQHMqkxsR1hJSS+pyE+oUyIsXX6iVZW7opMg
Date: Thu, 24 Nov 2011 07:37:21 +0000
Message-ID: <3F607A5180246847A760FD34122A1E052DC4CD@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1322095306-13156-1-git-send-email-b35362@freescale.com>
 <1322095306-13156-3-git-send-email-b35362@freescale.com>
In-Reply-To: <1322095306-13156-3-git-send-email-b35362@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.80]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAO7bVO2012599

> Subject: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
> large-page Nand chip
> 
> From: Liu Shuo <b35362@freescale.com>
> 
> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
> to support the Nand flash chip whose page size is larger than 2K bytes,
> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
> them to a large buffer.
> 
> Signed-off-by: Liu Shuo <b35362@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
>  drivers/mtd/nand/fsl_elbc_nand.c |  211
> +++++++++++++++++++++++++++++++++++---
>  1 files changed, 194 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
> index d634c5f..c96e714 100644
> --- a/drivers/mtd/nand/fsl_elbc_nand.c
> +++ b/drivers/mtd/nand/fsl_elbc_nand.c

[snip]

> +static void io_to_buffer(struct mtd_info *mtd, int subpage, int oob)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct fsl_elbc_mtd *priv = chip->priv;
> +	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
> +	void *src, *dst;
> +	int len = (oob ? 64 : 2048);
> +
> +	if (oob)
> +		dst = elbc_fcm_ctrl->buffer + mtd->writesize + subpage * 64;
> +	else
> +		dst = elbc_fcm_ctrl->buffer + subpage * 2048;
> +
> +	src = elbc_fcm_ctrl->addr + (oob ? 2048 : 0);
> +	memcpy_fromio(dst, src, len);

Might be safer to use _memcpy_fromio()

> +}
> +
> +static void buffer_to_io(struct mtd_info *mtd, int subpage, int oob)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	struct fsl_elbc_mtd *priv = chip->priv;
> +	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
> +	void *src, *dst;
> +	int len = (oob ? 64 : 2048);
> +
> +	if (oob)
> +		src = elbc_fcm_ctrl->buffer + mtd->writesize + subpage * 64;
> +	else
> +		src = elbc_fcm_ctrl->buffer + subpage * 2048;
> +
> +	dst = elbc_fcm_ctrl->addr + (oob ? 2048 : 0);
> +	memcpy_toio(dst, src, len);
> +
> +	/* See the in_8() in fsl_elbc_write_buf() */
> +	in_8(elbc_fcm_ctrl->addr);

Should be safer to read back the last char.

- Leo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
