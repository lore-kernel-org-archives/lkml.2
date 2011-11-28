Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1K1Iw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:52:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:32425 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1K1Iw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:52:56 -0500
X-AuditID: cbfee61b-b7bdbae000001970-52-4ed34be6808d
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: "'S, Venkatraman'" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
References: <aad7cb35699550e89526a5fb083c520d.squirrel@www.codeaurora.org>
In-reply-to: <aad7cb35699550e89526a5fb083c520d.squirrel@www.codeaurora.org>
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Mon, 28 Nov 2011 17:52:54 +0900
Message-id: <000201ccadab$1e57b8a0$5b0729e0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcytPIeCLj3bt5IQTDG04nR08dsqHQAbUtvw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez wrote:
> >> >> On Wed, Nov 2, 2011 at 1:33 PM, Seungwon Jeon <tgih.jun@samsung.com>
> >> wrote:
> >> >> > @@ -943,7 +950,8 @@ static int mmc_blk_err_check(struct mmc_card
> >> *card,
> >> >> >         * kind.  If it was a write, we may have transitioned to
>       * program mode, which we have to wait for it to complete.
>       */
> >> >> > -       if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=
> >> READ) {
> >> >> > +       if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) !=
> >> READ) ||
> >> >> > +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR))
> Since the header's direction is WRITE I don't think we also need to check
> if mq_mrq->packed_cmd == MMC_PACKED_WR_HDR since it will be covered by the
> original condition.
The header is written. But origin request is about read.
That means rq_data_dir(req) is READ. So new condition is needed.
> >> {
> >> >> >                u32 status;
> >> >> >                do {
> >> >> >                        int err = get_card_status(card, &status,
> 5);
> A general question, not related specifically to packed commands - Do you
> know why the status is not checked to see which error we got?
This status is for checking whether the card is ready for new data.
> >> >> > @@ -980,12 +988,67 @@ static int mmc_blk_err_check(struct mmc_card
> >> *card,
> >> >> >        if (!brq->data.bytes_xfered)
> >> >> >                return MMC_BLK_RETRY;
> >> >> >
> >> >> > +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> >> >> > +               if (unlikely(brq->data.blocks << 9 !=
> >> brq->data.bytes_xfered))
> >> >> > +                       return MMC_BLK_PARTIAL;
> >> >> > +               else
> >> >> > +                       return MMC_BLK_SUCCESS;
> >> >> > +       }
> >> >> > +
> >> >> >        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
> >> >> >                return MMC_BLK_PARTIAL;
> >> >> >
> >> >> >        return MMC_BLK_SUCCESS;
> >> >> >  }
> >> >> >
> >> >> > +static int mmc_blk_packed_err_check(struct mmc_card *card, +
>                        struct mmc_async_req *areq)
> >> >> > +{
> >> >> > +       struct mmc_queue_req *mq_mrq = container_of(areq, struct
> >> mmc_queue_req,
> >> >> > +                                                   mmc_active); +
>       int err, check, status;
> >> >> > +       u8 ext_csd[512];
> >> >> > +
> >> >> > +       check = mmc_blk_err_check(card, areq);
> >> >> > +
> >> >> > +       if (check == MMC_BLK_SUCCESS)
> >> >> > +               return check;
> I think we need to check the status for all cases and not only in case of
> MMC_BLK_PARTIAL. For example, in cases where the header was traferred
> successfully but had logic errors (wrong number of sectors etc.)
> mmc_blk_err_check will return MMC_BLK_SUCCESS although the packed commands
> failed.
Similarly, Sahitya Tummala is already mentioned this.
Other error case will be checked in next version.
The case you suggested is about read or write?
Device may detect error and stop transferring the data.
> >> >> > +
> >> >> > +       if (check == MMC_BLK_PARTIAL) {
> >> >> > +               err = get_card_status(card, &status, 0);
> >> >> > +               if (err)
> >> >> > +                       return MMC_BLK_ABORT;
> >> >> > +
> >> >> > +               if (status & R1_EXP_EVENT) {
> >> >> > +                       err = mmc_send_ext_csd(card, ext_csd); +
>                     if (err)
> >> >> > +                               return MMC_BLK_ABORT;
> >> >> > +
> >> >> > +                       if ((ext_csd[EXT_CSD_EXP_EVENTS_STATUS +
> 0]
> why do we need the + 0?
It is explicit expression, no more, no less.
Actually, there is no need.
> >> &
> >> >> > +
> >> EXT_CSD_PACKED_INDEXED_ERROR) {
> >> >> > +                                       /* Make be 0-based */
> The comment is not understood
PACKED_FAILURE_INDEX starts from '1'
It is converted to 0-base for use.
> >> >> > +                                       mq_mrq->packed_fail_idx =
> +
> Thanks,
> Maya Erez
> --
> Seny by a Consultant for Qualcomm innovation center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

