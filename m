Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1K0TlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:41:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41901 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1K0TlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:41:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6543"; a="141345145"
Message-ID: <aad7cb35699550e89526a5fb083c520d.squirrel@www.codeaurora.org>
Date: Sun, 27 Nov 2011 11:41:11 -0800 (PST)
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5      
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: "'S, Venkatraman'" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> On Wed, Nov 2, 2011 at 1:33 PM, Seungwon Jeon <tgih.jun@samsung.com>
>> wrote:
>> >> > @@ -943,7 +950,8 @@ static int mmc_blk_err_check(struct mmc_card
>> *card,
>> >> >         * kind.  If it was a write, we may have transitioned to  
      * program mode, which we have to wait for it to complete.  
      */
>> >> > -       if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=
>> READ) {
>> >> > +       if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) !=
>> READ) ||
>> >> > +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR))
Since the header's direction is WRITE I don't think we also need to check
if mq_mrq->packed_cmd == MMC_PACKED_WR_HDR since it will be covered by the
original condition.
>> {
>> >> >                u32 status;
>> >> >                do {
>> >> >                        int err = get_card_status(card, &status,
5);
A general question, not related specifically to packed commands - Do you
know why the status is not checked to see which error we got?
>> >> > @@ -980,12 +988,67 @@ static int mmc_blk_err_check(struct mmc_card
>> *card,
>> >> >        if (!brq->data.bytes_xfered)
>> >> >                return MMC_BLK_RETRY;
>> >> >
>> >> > +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
>> >> > +               if (unlikely(brq->data.blocks << 9 !=
>> brq->data.bytes_xfered))
>> >> > +                       return MMC_BLK_PARTIAL;
>> >> > +               else
>> >> > +                       return MMC_BLK_SUCCESS;
>> >> > +       }
>> >> > +
>> >> >        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
>> >> >                return MMC_BLK_PARTIAL;
>> >> >
>> >> >        return MMC_BLK_SUCCESS;
>> >> >  }
>> >> >
>> >> > +static int mmc_blk_packed_err_check(struct mmc_card *card, +    
                       struct mmc_async_req *areq)
>> >> > +{
>> >> > +       struct mmc_queue_req *mq_mrq = container_of(areq, struct
>> mmc_queue_req,
>> >> > +                                                   mmc_active); +
      int err, check, status;
>> >> > +       u8 ext_csd[512];
>> >> > +
>> >> > +       check = mmc_blk_err_check(card, areq);
>> >> > +
>> >> > +       if (check == MMC_BLK_SUCCESS)
>> >> > +               return check;
I think we need to check the status for all cases and not only in case of
MMC_BLK_PARTIAL. For example, in cases where the header was traferred
successfully but had logic errors (wrong number of sectors etc.)
mmc_blk_err_check will return MMC_BLK_SUCCESS although the packed commands
failed.
>> >> > +
>> >> > +       if (check == MMC_BLK_PARTIAL) {
>> >> > +               err = get_card_status(card, &status, 0);
>> >> > +               if (err)
>> >> > +                       return MMC_BLK_ABORT;
>> >> > +
>> >> > +               if (status & R1_EXP_EVENT) {
>> >> > +                       err = mmc_send_ext_csd(card, ext_csd); +  
                    if (err)
>> >> > +                               return MMC_BLK_ABORT;
>> >> > +
>> >> > +                       if ((ext_csd[EXT_CSD_EXP_EVENTS_STATUS +
0]
why do we need the + 0?
>> &
>> >> > +                                              
>> EXT_CSD_PACKED_INDEXED_ERROR) {
>> >> > +                                       /* Make be 0-based */
The comment is not understood
>> >> > +                                       mq_mrq->packed_fail_idx =
+                                              
Thanks,
Maya Erez
--
Seny by a Consultant for Qualcomm innovation center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


