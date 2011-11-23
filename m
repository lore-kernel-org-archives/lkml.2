Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab1KWBxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:53:34 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:16226
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab1KWBxc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:53:32 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371Kc89bh1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ECC52E2.3040702@freescale.com>
Date: Wed, 23 Nov 2011 09:56:50 +0800
From: LiuShuo <b35362@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, Liu Shuo <Shuo.Liu@freescale.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: Re: [PATCH v3 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1321349355-1639-1-git-send-email-b35362@freescale.com> <1321349355-1639-2-git-send-email-b35362@freescale.com> <1321349355-1639-3-git-send-email-b35362@freescale.com> <4ECC368C.3010801@freescale.com>
In-Reply-To: <4ECC368C.3010801@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月23日 07:55, Scott Wood 写道:
> On 11/15/2011 03:29 AM, b35362@freescale.com wrote:
>> From: Liu Shuo<b35362@freescale.com>
>>
>> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
>> to support the Nand flash chip whose page size is larger than 2K bytes,
>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>> them to a large buffer.
>>
>> Signed-off-by: Liu Shuo<Shuo.Liu@freescale.com>
>> Signed-off-by: Shengzhou Liu<Shengzhou.Liu@freescale.com>
>> Signed-off-by: Li Yang<leoli@freescale.com>
>> ---
>>   drivers/mtd/nand/fsl_elbc_nand.c |  216 +++++++++++++++++++++++++++++++++++---
>>   1 files changed, 199 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
>> index c2c231b..415f87e 100644
>> --- a/drivers/mtd/nand/fsl_elbc_nand.c
>> +++ b/drivers/mtd/nand/fsl_elbc_nand.c
>> @@ -55,7 +55,9 @@ struct fsl_elbc_mtd {
>>   	struct device *dev;
>>   	int bank;               /* Chip select bank number           */
>>   	u8 __iomem *vbase;      /* Chip select base virtual address  */
>> -	int page_size;          /* NAND page size (0=512, 1=2048)    */
>> +	int page_size;          /* NAND page size (0=512, 1=2048, 2=4096...),
>> +				 * the mutiple of 2048.
>> +				 */
> That "..." isn't very descriptive.  What happens with 8192-byte pages?
> Is it 3 or 4?
>
> Please just get rid of this and use mtd->writesize.
>
>> +		for (i = 1; i<  priv->page_size; i++) {
>> +			/*
>> +			 * Maybe there are some reasons of FCM hardware timming,
>> +			 * we must insert a FIR_OP_NOP(0x00) before FIR_OP_RB.
>> +			 */
> s/timming/timing/
>
>>   	/* PAGEPROG reuses all of the setup from SEQIN and adds the length */
>>   	case NAND_CMD_PAGEPROG: {
>> +		int len;
>>   		dev_vdbg(priv->dev,
>>   			 "fsl_elbc_cmdfunc: NAND_CMD_PAGEPROG "
>>   			 "writing %d bytes.\n", elbc_fcm_ctrl->index);
>> -
>>   		/* if the write did not start at 0 or is not a full page
>>   		 * then set the exact length, otherwise use a full page
>>   		 * write so the HW generates the ECC.
>>   		 */
>> -		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
>> +		if (elbc_fcm_ctrl->column>= mtd->writesize) {
>> +			/* write oob */
>> +			if (priv->page_size>  1) {
>> +				/* when pagesize of chip is greater than 2048,
>> +				 * we have to write full page to write spare
>> +				 * region, so we fill '0xff' to main region
>> +				 * and some bytes of spare region which we
>> +				 * don't want to rewrite.
>> +				 * (write '1' won't change the original value)
>> +				 */
>> +				memset(elbc_fcm_ctrl->buffer, 0xff,
>> +						elbc_fcm_ctrl->column);
> I don't like relying on this -- can we use RNDIN instead to do a
> discontiguous write?
>
>> +				len = 2112;
> len = min(elbc_fcm_ctrl->index, 2112);
>
>> +			} else
>> +				len = mtd->writesize + mtd->oobsize -
>> +					elbc_fcm_ctrl->column;
>> +			out_be32(&lbc->fbcr, len);
> len = elbc_fcm_ctrl->index - elbc_fcm_ctrl->column;
>
> Use braces on both sides of the if/else if it's needed on one side.
>
>> +		} else if (elbc_fcm_ctrl->column != 0 ||
>>   		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
>>   			out_be32(&lbc->fbcr, elbc_fcm_ctrl->index);
> This should have set fbcr to index - column as well (after adjusting --
> though really it's not a supported use case.  We should only be seeing
> column != 0 for oob.
>
>> @@ -625,10 +776,16 @@ static int fsl_elbc_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
>>   		return -EINVAL;
>>   	}
>>
>> -	for (i = 0; i<  len; i++)
>> -		if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
>> -				!= buf[i])
>> -			break;
>> +	if (mtd->writesize>  2048)
>> +		for (i = 0; i<  len; i++)
>> +			if (elbc_fcm_ctrl->buffer[elbc_fcm_ctrl->index + i]
>> +					!= buf[i])
>> +				break;
>> +	else
>> +		for (i = 0; i<  len; i++)
>> +			if (in_8(&elbc_fcm_ctrl->addr[elbc_fcm_ctrl->index + i])
>> +					!= buf[i])
>> +				break;
> Please use braces around multiline if/for bodies, even if they're
> technically a single statement -- especially when you've got a dangling
> else.
>
>>   	elbc_fcm_ctrl->index += len;
>>   	return i == len&&  elbc_fcm_ctrl->status == LTESR_CC ? 0 : -EIO;
>> @@ -657,6 +814,7 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
>>   	struct fsl_elbc_mtd *priv = chip->priv;
>>   	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
>>   	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
>> +	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = ctrl->nand;
>>   	unsigned int al;
>>
>>   	/* calculate FMR Address Length field */
>> @@ -707,12 +865,17 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
>>   	dev_dbg(priv->dev, "fsl_elbc_init: mtd->oobsize = %d\n",
>>   		mtd->oobsize);
>>
>> +	kfree(elbc_fcm_ctrl->buffer);
>> +	elbc_fcm_ctrl->buffer = NULL;
>> +
>>   	/* adjust Option Register and ECC to match Flash page size */
>>   	if (mtd->writesize == 512) {
>>   		priv->page_size = 0;
>>   		clrbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
>> -	} else if (mtd->writesize == 2048) {
>> -		priv->page_size = 1;
>> +	} else if (mtd->writesize>= 2048) {
>> +		/* page_size = writesize / 2048 */
>> +		priv->page_size = mtd->writesize>>  11;
> Why not just write priv->page_size = mtd->writesize / 2048 in the code
> rather than the comment (it compiles to the same code)?  Other than
> because you were requested to remove priv->page_size, that is. :-)
>
>>   		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
>>   		/* adjust ecc setup if needed */
>>   		if ((in_be32(&lbc->bank[priv->bank].br)&  BR_DECC) ==
>> @@ -723,6 +886,14 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
>>   					&fsl_elbc_oob_lp_eccm0;
>>   			chip->badblock_pattern =&largepage_memorybased;
>>   		}
>> +
>> +		/* re-malloc if pagesize>  2048*/
>> +		if (mtd->writesize>  2048) {
>> +			elbc_fcm_ctrl->buffer = kmalloc(mtd->writesize +
>> +						    mtd->oobsize, GFP_KERNEL);
>> +			if (!elbc_fcm_ctrl->buffer)
>> +				return -ENOMEM;
>> +		}
>>   	} else {
>>   		dev_err(priv->dev,
>>   			"fsl_elbc_init: page size %d is not supported\n",
> buffer is a controller-wide resource, but you're setting it based on the
> most-recently-probed NAND chip.  It should be large enough to
> accommodate the largest page size in use on any connected chip.  Even if
> all chips in the system have the same page size, you're introducing a
> race if a previously-probed chip is already in use (the controller lock
> is not held here).
>
> Just allocate a buffer large enough for a 16K page size in the main init
> function, and print an error in the tail if you encounter a larger page
> size.
>
>> @@ -886,6 +1057,17 @@ static int __devinit fsl_elbc_nand_probe(struct platform_device *pdev)
>>   			goto err;
>>   		}
>>   		elbc_fcm_ctrl->counter++;
>> +		/*
>> +		 * Freescale FCM controller has a 2K size limitation of buffer
>> +		 * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
>> +		 * of chip is greater than 2048.
>> +		 * We malloc a large enough buffer at this point, because we
>> +		 * don't know writesize before calling nand_scan(). We will
>> +		 * re-malloc later if needed.
>> +		 */
>> +		elbc_fcm_ctrl->buffer = kmalloc(4096 * 6, GFP_KERNEL);
>> +		if (!elbc_fcm_ctrl->buffer)
>> +			return -ENOMEM;
> Clean up properly if you fail to allocate the buffer.  This includes
> freeing elbc_fcm_ctrl, setting fsl_lbc_ctrl_dev->nand to NULL, and
> releasing fsl_elbc_nand_mutex.
>
> -Scott
Thanks for your suggestions. I will make it better.

-LiuShuo

