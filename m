Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab1LGTLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:11:48 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:27762
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757933Ab1LGTLr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:11:47 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371Kc89bh1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EDFBA6D.9080500@freescale.com>
Date: Wed, 7 Dec 2011 13:11:41 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com> <4EDEE3AC.7060000@freescale.com>
In-Reply-To: <4EDEE3AC.7060000@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 09:55 PM, LiuShuo wrote:
> 于 2011年12月07日 08:09, Scott Wood 写道:
>> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
>>> From: Liu Shuo<shuo.liu@freescale.com>
>>>
>>> Freescale FCM controller has a 2K size limitation of buffer RAM. In
>>> order
>>> to support the Nand flash chip whose page size is larger than 2K bytes,
>>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>>> them to a large buffer.
>>>
>>> Signed-off-by: Liu Shuo<shuo.liu@freescale.com>
>>> ---
>>> v3:
>>>      -remove page_size of struct fsl_elbc_mtd.
>>>      -do a oob write by NAND_CMD_RNDIN.
>>>
>>>   drivers/mtd/nand/fsl_elbc_nand.c |  243
>>> ++++++++++++++++++++++++++++++++++----
>>>   1 files changed, 218 insertions(+), 25 deletions(-)
>> What is the plan for bad block marker migration?
> This patch has been ported to uboot now, I think we can make a special
> uboot image for bad
> block marker migration when first use the chip.

It should not be a special image, and there should be some way to mark
that the migration has happened.  Even if we do the migration in U-Boot,
Linux could check for the marker and if absent, disallow access and tell
the user to run the migration tool.

>>> @@ -473,13 +568,72 @@ static void fsl_elbc_cmdfunc(struct mtd_info
>>> *mtd, unsigned int command,
>>>            * write so the HW generates the ECC.
>>>            */
>>>           if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
>>> -            elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize)
>>> -            out_be32(&lbc->fbcr,
>>> -                elbc_fcm_ctrl->index - elbc_fcm_ctrl->column);
>>> -        else
>>> +            elbc_fcm_ctrl->index != mtd->writesize + mtd->oobsize) {
>>> +            if (elbc_fcm_ctrl->oob&&  mtd->writesize>  2048) {
>>> +                out_be32(&lbc->fbcr, 64);
>>> +            } else {
>>> +                out_be32(&lbc->fbcr, elbc_fcm_ctrl->index
>>> +                        - elbc_fcm_ctrl->column);
>>> +            }
>> We need to limit ourselves to the regions that have actually been
>> written to in the buffer.  fbcr needs to be set separately for first and
>> last subpages, with intermediate subpages having 0, 64, or 2112 as
>> appropriate.  Subpages that are entirely before column or entirely after
>> column + index should be skipped.
> 
> I have considered this case, but I don't think it is useful.
>     1.There isn't a 'length' parameter in driver interface, although we
> can get it from 'index - column'.

Right.  column is start, and index is end + 1.  We have the bounds of
what has been written.

>     2.To see nand_do_write_oob() in nand_base.c, it fill '0xff' to
> entire oob area first and write the user data by nand_fill_oob(), then
> call ecc.write_oob (default is nand_write_oob_std()).

Do we really want to assume that that's what it will always do?

And if we do want to make such assumptions, we could rip out all usage
of index/column here, and just handle "oob" and "full page" cases.

-Scott

