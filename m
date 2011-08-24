Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1HXFwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:52:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47124 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1HXFwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9MwO-JEMNt9-0C8pzgYn5Tvtv8ovJ35TNiqqe8PWGogQ@mail.gmail.com>
References: <CAKYAXd9MwO-JEMNt9-0C8pzgYn5Tvtv8ovJ35TNiqqe8PWGogQ@mail.gmail.com>
Date: Wed, 24 Aug 2011 14:52:14 +0900
X-Google-Sender-Auth: lt4t9g0_L1WXmax9Jb9dLtdOwTI
Message-ID: <CAH9JG2WYcLpOtP-uy_nNHqe6yzOaxzW1cPMo==5UfUt0FqFrDA@mail.gmail.com>
Subject: Re: RFC : mmc: mmc_blk_issue_secdiscard_rq() and mmc_blk_issue_discard_rq()
 effectively merged into one.
From: Kyungmin Park <kmpark@infradead.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 24, 2011 at 2:09 PM, NamJae Jeon <linkinjeon@gmail.com> wrote:
> Hi.
>
> I am wordering why mmc_blk_issue_secdiscard_rq() and
> mmc_blk_issue_discard_rq() is seperated.
> So I try to make mmc_blk_issue_secdiscard_rq() and
> mmc_blk_issue_discard_rq() effectively merged into one.
>
> I want to know your opinion.

I think not special reason. It can merge one function. but note that
secdiscard function is rarely called. there's only one path from
BLKSECDISCARD ioctl.

however discard is different. it's called relatively frequently if you
turn on discard mount option. or often when batched discard.
So it's helpful to reduce the code size if one function is used. it's
more helpful to optimize the code flow when discard is used.

Thank you,
Kyungmin Park
>
> Thanks.
>
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
> static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
> {
>        struct mmc_blk_data *md = mq->data;
>        struct mmc_card *card = md->queue.card;
>        unsigned int from, nr, arg;
>        int err = 0;
>        from = blk_rq_pos(req);
>        nr = blk_rq_sectors(req);
>        if (req->cmd_flags & REQ_SECURE) {
>                if (!mmc_can_secure_erase_trim(card)) {
>                        err = -EOPNOTSUPP;
>                        goto out;
>                }
>                if(mmc_can_trim(card) &&
> !mmc_erase_group_aligned(card, from, nr))
>                        arg = MMC_SECURE_TRIM1_ARG;
>                else
>                        arg = MMC_SECURE_ERASE_ARG;
>        }
>        else {
>                if (!mmc_can_erase(card)) {
>                        err = -EOPNOTSUPP;
>                        goto out;
>                }
>                if (mmc_can_trim(card))
>                        arg = MMC_TRIM_ARG;
>                else
>                        arg = MMC_ERASE_ARG;
>        }
>
>        if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>                if(req->cmd_flags & REQ_SECURE)
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                        NAND_CMD38_ARG_EXT_CSD,
>                                        arg == MMC_SECURE_TRIM1_ARG ?
>                                        INAND_CMD38_ARG_SECTRIM1 :
>                                        INAND_CMD38_ARG_SECERASE,
>                                        0);
>                else
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                        INAND_CMD38_ARG_EXT_CSD,
>                                        arg == MMC_TRIM_ARG ?
>                                        INAND_CMD38_ARG_TRIM :
>                                        INAND_CMD38_ARG_ERASE,
>                                        0);
>                if (err)
>                        goto out;
>        }
>        err = mmc_erase(card, from, nr, arg);
>        if (!err && arg == MMC_SECURE_TRIM1_ARG) {
>                if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                         INAND_CMD38_ARG_EXT_CSD,
>                                         INAND_CMD38_ARG_SECTRIM2,
>                                         0);
>                        if (err)
>                                goto out;
>                }
>                err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
>        }
> out:
>        spin_lock_irq(&md->lock);
>        __blk_end_request(req, err, blk_rq_bytes(req));
>        spin_unlock_irq(&md->lock);
>        return err ? 0 : 1;
> }
>
>
> static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> {
>        int ret;
>        struct mmc_blk_data *md = mq->data;
>        struct mmc_card *card = md->queue.card;
>        mmc_claim_host(card->host);
>        ret = mmc_blk_part_switch(card, md);
>        if (ret) {
>                ret = 0;
>                goto out;
>        }
>        if (req->cmd_flags & REQ_DISCARD) {
>                ret = mmc_blk_issue_discard_rq(mq, req);
>        } else if (req->cmd_flags & REQ_FLUSH) {
>                ret = mmc_blk_issue_flush(mq, req);
>        } else {
>                ret = mmc_blk_issue_rw_rq(mq, req);
>        }
> out:
>        mmc_release_host(card->host);
>        return ret;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
