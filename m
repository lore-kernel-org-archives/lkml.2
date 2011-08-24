Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1HXPVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:21:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48759 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1HXPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WYcLpOtP-uy_nNHqe6yzOaxzW1cPMo==5UfUt0FqFrDA@mail.gmail.com>
References: <CAKYAXd9MwO-JEMNt9-0C8pzgYn5Tvtv8ovJ35TNiqqe8PWGogQ@mail.gmail.com>
	<CAH9JG2WYcLpOtP-uy_nNHqe6yzOaxzW1cPMo==5UfUt0FqFrDA@mail.gmail.com>
Date: Thu, 25 Aug 2011 00:21:03 +0900
Message-ID: <CAKYAXd91fbPHLbw7uiWosKPAJraHe6VEz=yY6MARMAbMXAWH2Q@mail.gmail.com>
Subject: Re: RFC : mmc: mmc_blk_issue_secdiscard_rq() and mmc_blk_issue_discard_rq()
 effectively merged into one.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linus.walleij@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7OFLKJ0000954

Hi. Park.

I understand. Thanks for your reply.

2011/8/24 Kyungmin Park <kmpark@infradead.org>:
> Hi,
>
> On Wed, Aug 24, 2011 at 2:09 PM, NamJae Jeon <linkinjeon@gmail.com> wrote:
>> Hi.
>>
>> I am wordering why mmc_blk_issue_secdiscard_rq() and
>> mmc_blk_issue_discard_rq() is seperated.
>> So I try to make mmc_blk_issue_secdiscard_rq() and
>> mmc_blk_issue_discard_rq() effectively merged into one.
>>
>> I want to know your opinion.
>
> I think not special reason. It can merge one function. but note that
> secdiscard function is rarely called. there's only one path from
> BLKSECDISCARD ioctl.
>
> however discard is different. it's called relatively frequently if you
> turn on discard mount option. or often when batched discard.
> So it's helpful to reduce the code size if one function is used. it's
> more helpful to optimize the code flow when discard is used.
>
> Thank you,
> Kyungmin Park
>>
>> Thanks.
>>
>> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
>> static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
>> {
>>        struct mmc_blk_data *md = mq->data;
>>        struct mmc_card *card = md->queue.card;
>>        unsigned int from, nr, arg;
>>        int err = 0;
>>        from = blk_rq_pos(req);
>>        nr = blk_rq_sectors(req);
>>        if (req->cmd_flags & REQ_SECURE) {
>>                if (!mmc_can_secure_erase_trim(card)) {
>>                        err = -EOPNOTSUPP;
>>                        goto out;
>>                }
>>                if(mmc_can_trim(card) &&
>> !mmc_erase_group_aligned(card, from, nr))
>>                        arg = MMC_SECURE_TRIM1_ARG;
>>                else
>>                        arg = MMC_SECURE_ERASE_ARG;
>>        }
>>        else {
>>                if (!mmc_can_erase(card)) {
>>                        err = -EOPNOTSUPP;
>>                        goto out;
>>                }
>>                if (mmc_can_trim(card))
>>                        arg = MMC_TRIM_ARG;
>>                else
>>                        arg = MMC_ERASE_ARG;
>>        }
>>
>>        if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>>                if(req->cmd_flags & REQ_SECURE)
>>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>                                        NAND_CMD38_ARG_EXT_CSD,
>>                                        arg == MMC_SECURE_TRIM1_ARG ?
>>                                        INAND_CMD38_ARG_SECTRIM1 :
>>                                        INAND_CMD38_ARG_SECERASE,
>>                                        0);
>>                else
>>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>                                        INAND_CMD38_ARG_EXT_CSD,
>>                                        arg == MMC_TRIM_ARG ?
>>                                        INAND_CMD38_ARG_TRIM :
>>                                        INAND_CMD38_ARG_ERASE,
>>                                        0);
>>                if (err)
>>                        goto out;
>>        }
>>        err = mmc_erase(card, from, nr, arg);
>>        if (!err && arg == MMC_SECURE_TRIM1_ARG) {
>>                if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>                                         INAND_CMD38_ARG_EXT_CSD,
>>                                         INAND_CMD38_ARG_SECTRIM2,
>>                                         0);
>>                        if (err)
>>                                goto out;
>>                }
>>                err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
>>        }
>> out:
>>        spin_lock_irq(&md->lock);
>>        __blk_end_request(req, err, blk_rq_bytes(req));
>>        spin_unlock_irq(&md->lock);
>>        return err ? 0 : 1;
>> }
>>
>>
>> static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>> {
>>        int ret;
>>        struct mmc_blk_data *md = mq->data;
>>        struct mmc_card *card = md->queue.card;
>>        mmc_claim_host(card->host);
>>        ret = mmc_blk_part_switch(card, md);
>>        if (ret) {
>>                ret = 0;
>>                goto out;
>>        }
>>        if (req->cmd_flags & REQ_DISCARD) {
>>                ret = mmc_blk_issue_discard_rq(mq, req);
>>        } else if (req->cmd_flags & REQ_FLUSH) {
>>                ret = mmc_blk_issue_flush(mq, req);
>>        } else {
>>                ret = mmc_blk_issue_rw_rq(mq, req);
>>        }
>> out:
>>        mmc_release_host(card->host);
>>        return ret;
>> }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
