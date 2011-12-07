Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1LGAJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:09:36 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:51497
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab1LGAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:09:35 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EDEAEB9.6020703@freescale.com>
Date: Tue, 6 Dec 2011 18:09:29 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <shuo.liu@freescale.com>
CC: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
In-Reply-To: <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
> From: Liu Shuo <shuo.liu@freescale.com>
> 
> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
> to support the Nand flash chip whose page size is larger than 2K bytes,
> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
> them to a large buffer.
> 
> Signed-off-by: Liu Shuo <shuo.liu@freescale.com>
> ---
> v3:
>     -remove page_size of struct fsl_elbc_mtd.
>     -do a oob write by NAND_CMD_RNDIN. 
> 
>  drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
>  1 files changed, 218 insertions(+), 25 deletions(-)

What is the plan for bad block marker migration?

> @@ -473,13 +568,72 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
>  		 * write so the HW generates the ECC.
>  		 */
>  		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
> -		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
> -			out_be32(&lbc->fbcr,
> -				elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
> -		else
> +		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize) {
> +			if (elbc_fcm_ctrl->oob && mtd->writesize > 2048) {
> +				out_be32(&lbc->fbcr, 64);
> +			} else {
> +				out_be32(&lbc->fbcr, elbc_fcm_ctrl->index
> +						- elbc_fcm_ctrl->column);
> +			}

We need to limit ourselves to the regions that have actually been
written to in the buffer.  fbcr needs to be set separately for first and
last subpages, with intermediate subpages having 0, 64, or 2112 as
appropriate.  Subpages that are entirely before column or entirely after
column + index should be skipped.

> +		} else {
> +			out_be32(&lbc->fir, FIR_OP_WB << FIR_OP1_SHIFT);
> +			for (i = 1; i < n; i++) {
> +				if (i == n - 1) {
> +					elbc_fcm_ctrl->use_mdr = 1;
> +					out_be32(&lbc->fir,
> +						(FIR_OP_WB  << FIR_OP1_SHIFT) |
> +						(FIR_OP_CM3 << FIR_OP2_SHIFT) |
> +						(FIR_OP_CW1 << FIR_OP3_SHIFT) |
> +						(FIR_OP_RS  << FIR_OP4_SHIFT));

Please explicitly show the (FIR_OP_NOP << FIR_OP0_SHIFT) compenent.

> +	} else if (mtd->writesize >= 2048 && mtd->writesize <= 16 * 1024) {
> +
>  		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);

Don't insert a blank line here.

-Scott

