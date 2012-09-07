Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab2IGMiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:38:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:57790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab2IGMiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:38:05 -0400
Subject: Re: [PATCH][v3] sata_fsl: add workaround for data length mismatch on freescale V2 controller
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1347012095-4404-1-git-send-email-Shaohui.Xie@freescale.com>
Date: Fri, 7 Sep 2012 07:37:53 -0500
Cc: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Anju Bhartiya <Anju.Bhartiya@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <82046C25-828E-4E0F-9F86-8E038AE5C93C@kernel.crashing.org>
References: <1347012095-4404-1-git-send-email-Shaohui.Xie@freescale.com>
To: Shaohui Xie <Shaohui.Xie@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 7, 2012, at 5:01 AM, Shaohui Xie wrote:

> The freescale V2 SATA controller checks if the received data length matches
> the programmed length 'ttl', if not, it assumes that this is an error.
> In ATAPI, the 'ttl' is based on max allocation length and not the actual
> data transfer length, controller will raise 'DLM' (Data length Mismatch)
> error bit in Hstatus register. Along with 'DLM', DE (Device error) and
> FE (fatal Error) bits are also set in Hstatus register, 'E' (Internal Error)
> bit is set in Serror register and CE (Command Error) and DE (Device error)
> registers have the corresponding bit set. In this condition, we need to
> clear errors in following way: in the service routine, based on 'DLM' flag,
> HCONTROL[27] operation clears Hstatus, CE and DE registers, clear Serror
> register.
> 
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> Signed-off-by: Anju Bhartiya <Anju.Bhartiya@freescale.com>
> ---
> changes for v3:
> 1. not using uppercase for variable names;
> 2. remove unnecessary parens;
> 
> changes for v2:
> 1. remove the using of quirk;
> 2. wrap errata codes in condition;
> 
> drivers/ata/sata_fsl.c |   39 +++++++++++++++++++++++++++++++++++----
> 1 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
> index d6577b9..9fbab68 100644
> --- a/drivers/ata/sata_fsl.c
> +++ b/drivers/ata/sata_fsl.c
> @@ -143,6 +143,7 @@ enum {
> 	    FATAL_ERR_CRC_ERR_RX |
> 	    FATAL_ERR_FIFO_OVRFL_TX | FATAL_ERR_FIFO_OVRFL_RX,
> 
> +	INT_ON_DATA_LENGTH_MISMATCH = (1 << 12),
> 	INT_ON_FATAL_ERR = (1 << 5),
> 	INT_ON_PHYRDY_CHG = (1 << 4),
> 
> @@ -1181,25 +1182,55 @@ static void sata_fsl_host_intr(struct ata_port *ap)
> 	u32 hstatus, done_mask = 0;
> 	struct ata_queued_cmd *qc;
> 	u32 SError;
> +	u32 tag;
> +	u32 status_mask = INT_ON_ERROR;
> 
> 	hstatus = ioread32(hcr_base + HSTATUS);
> 
> 	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
> 
> +	/* Read command completed register */
> +	done_mask = ioread32(hcr_base + CC);
> +
> +	/* Workaround for data length mismatch errata */
> +	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
> +		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
> +			qc = ata_qc_from_tag(ap, tag);
> +			if (qc && ata_is_atapi(qc->tf.protocol)) {
> +				u32 hcontrol;
> +#define HCONTROL_CLEAR_ERROR	(1 << 27)

shouldn't we have this #define be part of the enum that the other HCONTROL_ bits/flags are part of?

> +				/* Set HControl[27] to clear error registers */
> +				hcontrol = ioread32(hcr_base + HCONTROL);
> +				iowrite32(hcontrol | HCONTROL_CLEAR_ERROR,
> +						hcr_base + HCONTROL);
> +
> +				/* Clear HControl[27] */
> +				iowrite32(hcontrol & ~HCONTROL_CLEAR_ERROR,
> +						hcr_base + HCONTROL);
> +
> +				/* Clear SError[E] bit */
> +				sata_fsl_scr_write(&ap->link, SCR_ERROR,
> +						SError);
> +
> +				/* Ignore fatal error and device error */
> +				status_mask &= ~(INT_ON_SINGL_DEVICE_ERR
> +						| INT_ON_FATAL_ERR);
> +				break;
> +			}
> +		}
> +	}
> +
> 	if (unlikely(SError & 0xFFFF0000)) {
> 		DPRINTK("serror @host_intr : 0x%x\n", SError);
> 		sata_fsl_error_intr(ap);
> 	}
> 
> -	if (unlikely(hstatus & INT_ON_ERROR)) {
> +	if (unlikely(hstatus & status_mask)) {
> 		DPRINTK("error interrupt!!\n");
> 		sata_fsl_error_intr(ap);
> 		return;
> 	}
> 
> -	/* Read command completed register */
> -	done_mask = ioread32(hcr_base + CC);
> -
> 	VPRINTK("Status of all queues :\n");
> 	VPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
> 		done_mask,
> -- 
> 1.6.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

