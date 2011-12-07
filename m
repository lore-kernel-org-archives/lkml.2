Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1LGDva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:51:30 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57174 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1LGDv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:51:27 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371Kc89bh1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EDEE3AC.7060000@freescale.com>
Date: Wed, 7 Dec 2011 11:55:24 +0800
From: LiuShuo <b35362@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com>
In-Reply-To: <4EDEAEB9.6020703@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月07日 08:09, Scott Wood 写道:
> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
>> From: Liu Shuo<shuo.liu@freescale.com>
>>
>> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
>> to support the Nand flash chip whose page size is larger than 2K bytes,
>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>> them to a large buffer.
>>
>> Signed-off-by: Liu Shuo<shuo.liu@freescale.com>
>> ---
>> v3:
>>      -remove page_size of struct fsl_elbc_mtd.
>>      -do a oob write by NAND_CMD_RNDIN.
>>
>>   drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
>>   1 files changed, 218 insertions(+), 25 deletions(-)
> What is the plan for bad block marker migration?
This patch has been ported to uboot now, I think we can make a special 
uboot image for bad
block marker migration when first use the chip.

>> @@ -473,13 +568,72 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
>>   		 * write so the HW generates the ECC.
>>   		 */
>>   		if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
>> -		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
>> -			out_be32(&lbc->fbcr,
>> -				elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
>> -		else
>> +		    elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize) {
>> +			if (elbc_fcm_ctrl->oob&&  mtd->writesize>  2048) {
>> +				out_be32(&lbc->fbcr, 64);
>> +			} else {
>> +				out_be32(&lbc->fbcr, elbc_fcm_ctrl->index
>> +						- elbc_fcm_ctrl->column);
>> +			}
> We need to limit ourselves to the regions that have actually been
> written to in the buffer.  fbcr needs to be set separately for first and
> last subpages, with intermediate subpages having 0, 64, or 2112 as
> appropriate.  Subpages that are entirely before column or entirely after
> column + index should be skipped.

I have considered this case, but I don't think it is useful.
     1.There isn't a 'length' parameter in driver interface, although we 
can get it from 'index - column'.
     2.To see nand_do_write_oob() in nand_base.c, it fill '0xff' to 
entire oob area first and write the user data by nand_fill_oob(), then 
call ecc.write_oob (default is nand_write_oob_std()). 'column' is 
mtd->writesize and 'length' of write_buf() is mtd->oobsize. So I don't 
think we need to deal with it there.

>> +		} else {
>> +			out_be32(&lbc->fir, FIR_OP_WB<<  FIR_OP1_SHIFT);
>> +			for (i = 1; i<  n; i++) {
>> +				if (i == n - 1) {
>> +					elbc_fcm_ctrl->use_mdr = 1;
>> +					out_be32(&lbc->fir,
>> +						(FIR_OP_WB<<  FIR_OP1_SHIFT) |
>> +						(FIR_OP_CM3<<  FIR_OP2_SHIFT) |
>> +						(FIR_OP_CW1<<  FIR_OP3_SHIFT) |
>> +						(FIR_OP_RS<<  FIR_OP4_SHIFT));
> Please explicitly show the (FIR_OP_NOP<<  FIR_OP0_SHIFT) compenent.
>
>> +	} else if (mtd->writesize>= 2048&&  mtd->writesize<= 16 * 1024) {
>> +
>>   		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
> Don't insert a blank line here.
>
Ok.

-LiuShuo
> -Scott


