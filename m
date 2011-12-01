Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1LANvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:51:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1LANvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:51:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6546"; a="140298200"
Message-ID: <5573ef5046779298ee1555838015e0e3.squirrel@www.codeaurora.org>
In-Reply-To: <000201ccadab$1e57b8a0$5b0729e0$%jun@samsung.com>
References: <aad7cb35699550e89526a5fb083c520d.squirrel@www.codeaurora.org>
    <000201ccadab$1e57b8a0$5b0729e0$%jun@samsung.com>
Date: Thu, 1 Dec 2011 05:51:43 -0800 (PST)
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, "'S, Venkatraman'" <svenkatr@ti.com>,
        linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maya Erez wrote:
>> >> >> On Wed, Nov 2, 2011 at 1:33 PM, Seungwon Jeon
>> <tgih.jun@samsung.com>
>> >> wrote:
>> >> >> > @@ -980,12 +988,67 @@ static int mmc_blk_err_check(struct
>> mmc_card
>> >> *card,
>> >> >> >        if (!brq->data.bytes_xfered)
>> >> >> >                return MMC_BLK_RETRY;
>> >> >> >
>> >> >> > +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
>> >> >> > +               if (unlikely(brq->data.blocks << 9 !=
>> >> brq->data.bytes_xfered))
>> >> >> > +                       return MMC_BLK_PARTIAL;
>> >> >> > +               else
>> >> >> > +                       return MMC_BLK_SUCCESS;
>> >> >> > +       }
>> >> >> > +
>> >> >> >        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
>> >> >> >                return MMC_BLK_PARTIAL;
>> >> >> >
>> >> >> >        return MMC_BLK_SUCCESS;
>> >> >> >  }
>> >> >> >
>> >> >> > +static int mmc_blk_packed_err_check(struct mmc_card *card, +
>>                        struct mmc_async_req *areq)
>> >> >> > +{
>> >> >> > +       struct mmc_queue_req *mq_mrq = container_of(areq, struct
>> >> mmc_queue_req,
>> >> >> > +                                                   mmc_active);
>> +
>>       int err, check, status;
>> >> >> > +       u8 ext_csd[512];
>> >> >> > +
>> >> >> > +       check = mmc_blk_err_check(card, areq);
>> >> >> > +
>> >> >> > +       if (check == MMC_BLK_SUCCESS)
>> >> >> > +               return check;
>> I think we need to check the status for all cases and not only in case
>> of
>> MMC_BLK_PARTIAL. For example, in cases where the header was traferred
>> successfully but had logic errors (wrong number of sectors etc.)
>> mmc_blk_err_check will return MMC_BLK_SUCCESS although the packed
>> commands
>> failed.
> Similarly, Sahitya Tummala is already mentioned this.
> Other error case will be checked in next version.
> The case you suggested is about read or write?
> Device may detect error and stop transferring the data.
Sahitya suggested to also check other error cases that mmc_blk_err_check
returns (such as MMC_BLK_CMD_ERR, MMC_BLK_ECC_ERR and MMC_BLK_DATA_ERR).
I suggest to also check the exception bit in the status even if
mmc_blk_err_check returned success, since mmc_blk_err_check might not
catch all the packed commands failures. One example for such a failure is
when the header of read packed commands will have logical error.

Thanks,
Maya
--
Seny by a Consultant for Qualcomm innovation center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum



