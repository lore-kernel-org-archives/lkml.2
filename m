Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1KCBxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:53:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45125 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KCBxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:53:25 -0400
X-AuditID: cbfee61b-b7b7fae000005864-55-4eb1f40b16c9
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'S, Venkatraman'" <svenkatr@ti.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, dh.han@samsung.com
References: <1320220990-13378-1-git-send-email-tgih.jun@samsung.com>
 <CANfBPZ_mF7XLGc=f7dohHvEnQOQ4cxSpcx0My_pMWFqa+HzP-g@mail.gmail.com>
In-reply-to: <CANfBPZ_mF7XLGc=f7dohHvEnQOQ4cxSpcx0My_pMWFqa+HzP-g@mail.gmail.com>
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Thu, 03 Nov 2011 10:53:15 +0900
Message-id: <001e01cc99cb$5a144370$0e3cca50$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyZU512xzlpmktaR0+LpQkGpXPKhwAcK1dQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S, Venkatraman <svenkatr@ti.com> wrote:
> On Wed, Nov 2, 2011 at 1:33 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > This patch supports packed command of eMMC4.5 device.
> > Several reads(or writes) can be grouped in packed command
> > and all data of the individual commands can be sent in a
> > single transfer on the bus.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >  drivers/mmc/card/block.c |  355 ++++++++++++++++++++++++++++++++++++++++++++--
> >  drivers/mmc/card/queue.c |   48 ++++++-
> >  drivers/mmc/card/queue.h |   12 ++
> >  include/linux/mmc/core.h |    3 +
> >  4 files changed, 404 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> > index a1cb21f..6c49656 100644
> > --- a/drivers/mmc/card/block.c
> > +++ b/drivers/mmc/card/block.c
> > @@ -59,6 +59,13 @@ MODULE_ALIAS("mmc:block");
> >  #define INAND_CMD38_ARG_SECTRIM1 0x81
> >  #define INAND_CMD38_ARG_SECTRIM2 0x88
> >
> > +#define mmc_req_rel_wr(req)    (((req->cmd_flags & REQ_FUA) || \
> > +                       (req->cmd_flags & REQ_META)) && \
> > +                       (rq_data_dir(req) == WRITE))
> > +#define PACKED_CMD_VER         0x01
> > +#define PACKED_CMD_RD          0x01
> > +#define PACKED_CMD_WR          0x02
> > +
> >  static DEFINE_MUTEX(block_mutex);
> >
> >  /*
> > @@ -943,7 +950,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
> >         * kind.  If it was a write, we may have transitioned to
> >         * program mode, which we have to wait for it to complete.
> >         */
> > -       if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
> > +       if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
> > +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {
> >                u32 status;
> >                do {
> >                        int err = get_card_status(card, &status, 5);
> > @@ -980,12 +988,67 @@ static int mmc_blk_err_check(struct mmc_card *card,
> >        if (!brq->data.bytes_xfered)
> >                return MMC_BLK_RETRY;
> >
> > +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> > +               if (unlikely(brq->data.blocks << 9 != brq->data.bytes_xfered))
> > +                       return MMC_BLK_PARTIAL;
> > +               else
> > +                       return MMC_BLK_SUCCESS;
> > +       }
> > +
> >        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
> >                return MMC_BLK_PARTIAL;
> >
> >        return MMC_BLK_SUCCESS;
> >  }
> >
> > +static int mmc_blk_packed_err_check(struct mmc_card *card,
> > +                            struct mmc_async_req *areq)
> > +{
> > +       struct mmc_queue_req *mq_mrq = container_of(areq, struct mmc_queue_req,
> > +                                                   mmc_active);
> > +       int err, check, status;
> > +       u8 ext_csd[512];
> > +
> > +       check = mmc_blk_err_check(card, areq);
> > +
> > +       if (check == MMC_BLK_SUCCESS)
> > +               return check;
> > +
> > +       if (check == MMC_BLK_PARTIAL) {
> > +               err = get_card_status(card, &status, 0);
> > +               if (err)
> > +                       return MMC_BLK_ABORT;
> > +
> > +               if (status & R1_EXP_EVENT) {
> > +                       err = mmc_send_ext_csd(card, ext_csd);
> > +                       if (err)
> > +                               return MMC_BLK_ABORT;
> > +
> > +                       if ((ext_csd[EXT_CSD_EXP_EVENTS_STATUS + 0] &
> > +                                               EXT_CSD_PACKED_FAILURE) &&
> > +                                       (ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
> > +                                        EXT_CSD_PACKED_GENERIC_ERROR)) {
> > +                               if (ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
> > +                                               EXT_CSD_PACKED_INDEXED_ERROR) {
> > +                                       /* Make be 0-based */
> > +                                       mq_mrq->packed_fail_idx =
> > +                                               ext_csd[EXT_CSD_PACKED_FAILURE_INDEX] - 1;
> > +                                       return MMC_BLK_PARTIAL;
> > +                               } else {
> > +                                       return MMC_BLK_RETRY;
> > +                               }
> > +                       }
> > +               } else {
> > +                       return MMC_BLK_RETRY;
> > +               }
> > +       }
> > +
> > +       if (check != MMC_BLK_ABORT)
> > +               return MMC_BLK_RETRY;
> > +       else
> > +               return MMC_BLK_ABORT;
> > +}
> > +
> >  static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
> >                               struct mmc_card *card,
> >                               int disable_multi,
> > @@ -1129,6 +1192,211 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
> >        mmc_queue_bounce_pre(mqrq);
> >  }
> >
> > +static u8 mmc_blk_chk_packable(struct mmc_queue *mq, struct request *req)
> > +{
> > +       struct request_queue *q = mq->queue;
> > +       struct mmc_card *card = mq->card;
> > +       struct request *cur = req, *next = NULL;
> > +       struct mmc_blk_data *md = mq->data;
> > +       bool en_rel_wr = card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN;
> > +       unsigned int req_sectors = 0, phys_segments = 0;
> > +       unsigned int max_blk_count, max_phys_segs;
> > +       u8 max_packed_rw = 0;
> > +       u8 reqs = 0;
> > +
> > +       if (!(md->flags & MMC_BLK_CMD23) &&
> > +                       !card->ext_csd.packed_event_en)
> > +               goto no_packed;
> > +
> > +       if (rq_data_dir(cur) == READ)
> > +               max_packed_rw = card->ext_csd.max_packed_reads;
> > +       else
> > +               max_packed_rw = card->ext_csd.max_packed_writes;
> > +
> > +       if (max_packed_rw == 0)
> > +               goto no_packed;
> > +
> > +       if (mmc_req_rel_wr(cur) &&
> > +                       (md->flags & MMC_BLK_REL_WR) &&
> > +                       !en_rel_wr) {
> > +               goto no_packed;
> > +       }
> > +
> > +       max_blk_count = min(card->host->max_blk_count,
> > +                       card->host->max_req_size >> 9);
> > +       if (unlikely(max_blk_count > 0xffff))
> > +               max_blk_count = 0xffff;
> > +
> > +       max_phys_segs = queue_max_segments(q);
> > +       req_sectors += blk_rq_sectors(cur);
> > +       phys_segments += req->nr_phys_segments;
> > +
> > +       if (rq_data_dir(cur) == WRITE) {
> > +               req_sectors++;
> > +               phys_segments++;
> > +       }
> > +
> > +       while (reqs < max_packed_rw - 1) {
> > +               next = blk_fetch_request(q);
> > +               if (!next)
> > +                       break;
> > +
> > +               if (rq_data_dir(cur) != rq_data_dir(next)) {
> > +                       blk_requeue_request(q, next);
> > +                       break;
> > +               }
> > +
> > +               if (mmc_req_rel_wr(next) &&
> > +                               (md->flags & MMC_BLK_REL_WR) &&
> > +                               !en_rel_wr) {
> > +                       blk_requeue_request(q, next);
> > +                       break;
> > +               }
> > +
> > +               req_sectors += blk_rq_sectors(next);
> > +               if (req_sectors > max_blk_count) {
> > +                       blk_requeue_request(q, next);
> > +                       break;
> > +               }
> > +
> > +               phys_segments +=  next->nr_phys_segments;
> > +               if (phys_segments > max_phys_segs) {
> > +                       blk_requeue_request(q, next);
> > +                       break;
> > +               }
> I mentioned this before - if the next request is not packable and requeued,
> blk_fetch_request will retrieve it again and this while loop will
> never terminate.
> 
If next request is not packable, it is requeued and 'break' terminates this loop.
So it not infinite.
> > +
> > +               list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
> > +               cur = next;
> > +               reqs++;
> > +       }
> > +
> > +       if (reqs > 0) {
> > +               list_add(&req->queuelist, &mq->mqrq_cur->packed_list);
> > +               return (reqs + 1);
> > +       }
> > +
> > +no_packed:
> > +       mq->mqrq_cur->packed_cmd = MMC_PACKED_NONE;
> > +       return reqs;
> > +}
> > +
> > +static void mmc_blk_packed_hdr_wrq_prep(struct mmc_queue_req *mqrq,
> > +                              struct mmc_card *card,
> > +                              struct mmc_queue *mq,
> > +                              u8 reqs)
> > +{
> > +       struct mmc_blk_request *brq = &mqrq->brq;
> > +       struct request *req = mqrq->req;
> > +       struct request *prq;
> > +       struct mmc_blk_data *md = mq->data;
> > +       bool do_rel_wr;
> > +       u32 *packed_cmd_hdr = mqrq->packed_cmd_hdr;
> > +       u8 i =1;
> > +
> > +       mqrq->packed_cmd = (rq_data_dir(req) == READ) ?
> > +               MMC_PACKED_WR_HDR : MMC_PACKED_WRITE;
> > +       mqrq->packed_blocks = 0;
> > +       mqrq->packed_fail_idx = -1;
> > +
> > +       memset(packed_cmd_hdr, 0, sizeof(mqrq->packed_cmd_hdr));
> > +       packed_cmd_hdr[0] = (reqs << 16) |
> > +               (((rq_data_dir(req) == READ) ? PACKED_CMD_RD: PACKED_CMD_WR) << 8) |
> > +               PACKED_CMD_VER;
> > +
> > +       /*
> > +        * Argument for each entry of packed group
> > +        */
> > +       list_for_each_entry(prq, &mqrq->packed_list, queuelist) {
> > +               do_rel_wr = mmc_req_rel_wr(prq) && (md->flags & MMC_BLK_REL_WR);
> > +               /* Argument of CMD23*/
> > +               packed_cmd_hdr[(i * 2)] = (do_rel_wr ? MMC_CMD23_ARG_REL_WR : 0) |
> > +                       blk_rq_sectors(prq);
> > +               /* Argument of CMD18 or CMD25 */
> > +               packed_cmd_hdr[((i * 2)) + 1] = mmc_card_blockaddr(card) ?
> > +                       blk_rq_pos(prq) : blk_rq_pos(prq) << 9;
> > +               mqrq->packed_blocks += blk_rq_sectors(prq);
> > +               i++;
> > +       }
> > +
> > +       memset(brq, 0, sizeof(struct mmc_blk_request));
> > +       brq->mrq.cmd = &brq->cmd;
> > +       brq->mrq.data = &brq->data;
> > +       brq->mrq.sbc = &brq->sbc;
> > +       brq->mrq.stop = &brq->stop;
> > +
> > +       brq->sbc.opcode = MMC_SET_BLOCK_COUNT;
> > +       brq->sbc.arg = MMC_CMD23_ARG_PACKED |
> > +               ((rq_data_dir(req) == READ) ? 1 : mqrq->packed_blocks + 1);
> > +       brq->sbc.flags = MMC_RSP_R1 | MMC_CMD_AC;
> > +
> > +       brq->cmd.opcode = MMC_WRITE_MULTIPLE_BLOCK;
> > +       brq->cmd.arg = blk_rq_pos(req);
> > +       if (!mmc_card_blockaddr(card))
> > +               brq->cmd.arg <<= 9;
> > +       brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
> > +
> > +       brq->data.blksz = 512;
> > +       /*
> > +        * Write separately the packd command header only for packed read.
> > +        * In case of packed write, header is sent with blocks of data.
> > +        */
> > +       brq->data.blocks = (rq_data_dir(req) == READ) ?
> > +               1 : mqrq->packed_blocks + 1;
> > +       brq->data.flags |= MMC_DATA_WRITE;
> > +
> > +       brq->stop.opcode = MMC_STOP_TRANSMISSION;
> > +       brq->stop.arg = 0;
> > +       brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> > +
> > +       mmc_set_data_timeout(&brq->data, card);
> > +
> > +       brq->data.sg = mqrq->sg;
> > +       brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
> > +
> > +       mqrq->mmc_active.mrq = &brq->mrq;
> > +       mqrq->mmc_active.err_check = mmc_blk_packed_err_check;
> > +
> > +       mmc_queue_bounce_pre(mqrq);
> > +}
> > +
> > +static void mmc_blk_packed_rrq_prep(struct mmc_queue_req *mqrq,
> > +                              struct mmc_card *card,
> > +                              struct mmc_queue *mq)
> > +{
> > +       struct mmc_blk_request *brq = &mqrq->brq;
> > +       struct request *req = mqrq->req;
> > +
> > +       mqrq->packed_cmd = MMC_PACKED_READ;
> > +
> > +       memset(brq, 0, sizeof(struct mmc_blk_request));
> > +       brq->mrq.cmd = &brq->cmd;
> > +       brq->mrq.data = &brq->data;
> > +       brq->mrq.stop = &brq->stop;
> > +
> > +       brq->cmd.opcode = MMC_READ_MULTIPLE_BLOCK;
> > +       brq->cmd.arg = blk_rq_pos(req);
> > +       if (!mmc_card_blockaddr(card))
> > +               brq->cmd.arg <<= 9;
> > +       brq->cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
> > +       brq->data.blksz = 512;
> > +       brq->data.blocks = mqrq->packed_blocks;
> > +       brq->data.flags |= MMC_DATA_READ;
> > +
> > +       brq->stop.opcode = MMC_STOP_TRANSMISSION;
> > +       brq->stop.arg = 0;
> > +       brq->stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> > +
> > +       mmc_set_data_timeout(&brq->data, card);
> > +
> > +       brq->data.sg = mqrq->sg;
> > +       brq->data.sg_len = mmc_queue_map_sg(mq, mqrq);
> > +
> > +       mqrq->mmc_active.mrq = &brq->mrq;
> > +       mqrq->mmc_active.err_check = mmc_blk_packed_err_check;
> > +
> > +       mmc_queue_bounce_pre(mqrq);
> > +}
> > +
> >  static int mmc_blk_cmd_err(struct mmc_blk_data *md, struct mmc_card *card,
> >                           struct mmc_blk_request *brq, struct request *req,
> >                           int ret)
> > @@ -1166,15 +1434,33 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >        int ret = 1, disable_multi = 0, retry = 0, type;
> >        enum mmc_blk_status status;
> >        struct mmc_queue_req *mq_rq;
> > -       struct request *req;
> > +       struct request *req, *prq;
> >        struct mmc_async_req *areq;
> > +       u8 reqs = 0;
> >
> >        if (!rqc && !mq->mqrq_prev->req)
> >                return 0;
> >
> > +       if (rqc)
> > +               reqs = mmc_blk_chk_packable(mq, rqc);
> > +
> >        do {
> >                if (rqc) {
> > -                       mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> > +                       if (reqs >= 2) {
> > +                               mmc_blk_packed_hdr_wrq_prep(mq->mqrq_cur, card, mq, reqs);
> > +                               if (rq_data_dir(rqc) == READ) {
> > +                                       areq = &mq->mqrq_cur->mmc_active;
> > +                                       mmc_wait_for_req(card->host, areq->mrq);
> > +                                       status = mmc_blk_packed_err_check(card, areq);
> > +                                       if (status == MMC_BLK_SUCCESS) {
> > +                                               mmc_blk_packed_rrq_prep(mq->mqrq_cur, card, mq);
> > +                                       } else {
> > +                                               goto check_status;
> > +                                       }
> > +                               }
> > +                       } else {
> 
> IIUC, the code in mmc_blk_chk_packable
> <snip>
>        if (reqs > 0) {
>                list_add(&req->queuelist, &mq->mqrq_cur->packed_list);
>               return (reqs + 1);
> </snip>
> adds the request to the packed list, and needs to be reversed if it's
> decided to not to do a packed request ?
Any condition or reason  not to do packed request after several requests
is added in packed list? I didn't catch your comment exactly.

> 
> 
> > +                               mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> > +                       }
> >                        areq = &mq->mqrq_cur->mmc_active;
> >                } else
> >                        areq = NULL;
> > @@ -1182,6 +1468,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >                if (!areq)
> >                        return 0;
> >
> > +check_status:
> >                mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
> >                brq = &mq_rq->brq;
> >                req = mq_rq->req;
> > @@ -1195,10 +1482,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >                         * A block was successfully transferred.
> >                         */
> >                        mmc_blk_reset_success(md, type);
> > -                       spin_lock_irq(&md->lock);
> > -                       ret = __blk_end_request(req, 0,
> > +
> > +                       if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> > +                               int idx = mq_rq->packed_fail_idx, i = 0;
> > +                               while (!list_empty(&mq_rq->packed_list)) {
> > +                                       prq = list_entry_rq(mq_rq->packed_list.next);
> > +                                       if (idx == i) {
> > +                                               /* retry from error index */
> > +                                               reqs -= idx;
> > +                                               mq_rq->req = prq;
> > +                                               ret = 1;
> > +                                               break;
> > +                                       }
> > +                                       list_del_init(&prq->queuelist);
> > +                                       spin_lock_irq(&md->lock);
> > +                                       ret = __blk_end_request(prq, 0, blk_rq_bytes(prq));
> > +                                       spin_unlock_irq(&md->lock);
> > +                                       i++;
> > +                               }
> > +                               break;
> > +                       } else {
> > +                               spin_lock_irq(&md->lock);
> > +                               ret = __blk_end_request(req, 0,
> >                                                brq->data.bytes_xfered);
> > -                       spin_unlock_irq(&md->lock);
> > +                               spin_unlock_irq(&md->lock);
> > +                       }
> > +
> >                        /*
> >                         * If the blk_end_request function returns non-zero even
> >                         * though all data has been transferred and no errors
> > @@ -1257,7 +1566,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >                        break;
> >                }
> >
> > -               if (ret) {
> > +               if (ret && (mq_rq->packed_cmd == MMC_PACKED_NONE)) {
> >                        /*
> >                         * In case of a incomplete request
> >                         * prepare it again and resend.
> > @@ -1270,13 +1579,37 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >        return 1;
> >
> >  cmd_abort:
> > -       spin_lock_irq(&md->lock);
> > -       while (ret)
> > -               ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
> > -       spin_unlock_irq(&md->lock);
> > +       if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> > +               spin_lock_irq(&md->lock);
> > +               while (ret)
> > +                       ret = __blk_end_request(req, -EIO, blk_rq_cur_bytes(req));
> > +               spin_unlock_irq(&md->lock);
> > +       } else {
> > +               while (!list_empty(&mq_rq->packed_list)) {
> > +                       prq = list_entry_rq(mq_rq->packed_list.next);
> > +                       list_del_init(&prq->queuelist);
> > +                       spin_lock_irq(&md->lock);
> > +                       __blk_end_request(prq, -EIO, blk_rq_bytes(prq));
> > +                       spin_unlock_irq(&md->lock);
> > +               }
> > +       }
> >
> >  start_new_req:
> >        if (rqc) {
> > +               /*
> > +                * If current request is packed, it need to put back.
> > +                */
> > +               if (mq->mqrq_cur->packed_cmd != MMC_PACKED_NONE) {
> > +                       while (!list_empty(&mq->mqrq_cur->packed_list)) {
> > +                               prq = list_entry_rq(mq->mqrq_cur->packed_list.prev);
> > +                               if (prq->queuelist.prev != &mq->mqrq_cur->packed_list) {
> > +                                       list_del_init(&prq->queuelist);
> > +                                       blk_requeue_request(mq->queue, prq);
> > +                               } else {
> > +                                       list_del_init(&prq->queuelist);
> > +                               }
> > +                       }
> > +               }
> >                mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> >                mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
> >        }
> > diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> > index dcad59c..3a4542e 100644
> > --- a/drivers/mmc/card/queue.c
> > +++ b/drivers/mmc/card/queue.c
> > @@ -172,6 +172,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
> >
> >        memset(&mq->mqrq_cur, 0, sizeof(mq->mqrq_cur));
> >        memset(&mq->mqrq_prev, 0, sizeof(mq->mqrq_prev));
> > +       INIT_LIST_HEAD(&mqrq_cur->packed_list);
> > +       INIT_LIST_HEAD(&mqrq_prev->packed_list);
> >        mq->mqrq_cur = mqrq_cur;
> >        mq->mqrq_prev = mqrq_prev;
> >        mq->queue->queuedata = mq;
> > @@ -372,6 +374,39 @@ void mmc_queue_resume(struct mmc_queue *mq)
> >        }
> >  }
> >
> > +static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
> > +                               struct mmc_queue_req *mqrq,
> > +                               struct scatterlist *sg)
> > +{
> > +       struct scatterlist *__sg;
> > +       unsigned int sg_len = 0;
> > +       struct request *req;
> > +       enum mmc_packed_cmd cmd;
> > +
> > +       cmd = mqrq->packed_cmd;
> > +
> > +       if (cmd == MMC_PACKED_WR_HDR || cmd == MMC_PACKED_WRITE) {
> > +               __sg =sg;
> > +               sg_set_buf(__sg, mqrq->packed_cmd_hdr,
> > +                               sizeof(mqrq->packed_cmd_hdr));
> > +               sg_len++;
> > +               if (cmd == MMC_PACKED_WR_HDR) {
> > +                       sg_mark_end(__sg);
> > +                       return sg_len;
> > +               }
> > +               __sg->page_link &= ~0x02;
> > +       }
> > +
> > +       __sg = sg + sg_len;
> > +       list_for_each_entry(req, &mqrq->packed_list, queuelist) {
> > +               sg_len += blk_rq_map_sg(mq->queue, req, __sg);
> > +               __sg = sg + (sg_len - 1);
> > +               (__sg++)->page_link &= ~0x02;
> > +       }
> > +       sg_mark_end(sg + (sg_len - 1));
> > +       return sg_len;
> > +}
> > +
> >  /*
> >  * Prepare the sg list(s) to be handed of to the host driver
> >  */
> > @@ -382,12 +417,19 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq, struct mmc_queue_req *mqrq)
> >        struct scatterlist *sg;
> >        int i;
> >
> > -       if (!mqrq->bounce_buf)
> > -               return blk_rq_map_sg(mq->queue, mqrq->req, mqrq->sg);
> > +       if (!mqrq->bounce_buf) {
> > +               if (!list_empty(&mqrq->packed_list))
> > +                       return mmc_queue_packed_map_sg(mq, mqrq, mqrq->sg);
> > +               else
> > +                       return blk_rq_map_sg(mq->queue, mqrq->req, mqrq->sg);
> > +       }
> >
> >        BUG_ON(!mqrq->bounce_sg);
> >
> > -       sg_len = blk_rq_map_sg(mq->queue, mqrq->req, mqrq->bounce_sg);
> > +       if (!list_empty(&mqrq->packed_list))
> > +               sg_len = mmc_queue_packed_map_sg(mq, mqrq, mqrq->bounce_sg);
> > +       else
> > +               sg_len = blk_rq_map_sg(mq->queue, mqrq->req, mqrq->bounce_sg);
> >
> >        mqrq->bounce_sg_len = sg_len;
> >
> > diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
> > index d2a1eb4..5d0131e 100644
> > --- a/drivers/mmc/card/queue.h
> > +++ b/drivers/mmc/card/queue.h
> > @@ -12,6 +12,13 @@ struct mmc_blk_request {
> >        struct mmc_data         data;
> >  };
> >
> > +enum mmc_packed_cmd {
> > +       MMC_PACKED_NONE = 0,
> > +       MMC_PACKED_WR_HDR,
> > +       MMC_PACKED_WRITE,
> > +       MMC_PACKED_READ,
> > +};
> > +
> >  struct mmc_queue_req {
> >        struct request          *req;
> >        struct mmc_blk_request  brq;
> > @@ -20,6 +27,11 @@ struct mmc_queue_req {
> >        struct scatterlist      *bounce_sg;
> >        unsigned int            bounce_sg_len;
> >        struct mmc_async_req    mmc_active;
> > +       struct list_head        packed_list;
> > +       u32                     packed_cmd_hdr[128];
> > +       unsigned int            packed_blocks;
> > +       enum mmc_packed_cmd     packed_cmd;
> > +       int             packed_fail_idx;
> >  };
> >
> >  struct mmc_queue {
> > diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> > index 174a844..3c61d5a 100644
> > --- a/include/linux/mmc/core.h
> > +++ b/include/linux/mmc/core.h
> > @@ -18,6 +18,8 @@ struct mmc_request;
> >  struct mmc_command {
> >        u32                     opcode;
> >        u32                     arg;
> > +#define MMC_CMD23_ARG_REL_WR   (1 << 31)
> > +#define MMC_CMD23_ARG_PACKED   ((0 << 31) | (1 << 30))
> >        u32                     resp[4];
> >        unsigned int            flags;          /* expected response type */
> >  #define MMC_RSP_PRESENT        (1 << 0)
> > @@ -143,6 +145,7 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
> >  extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
> >        struct mmc_command *, int);
> >  extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
> > +extern int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd);
> 
> Stray change / doesn't belong to this patch.
Do you mean to split this in another patch?

Thanks,
Seungwon Jeon.
> 
> >
> >  #define MMC_ERASE_ARG          0x00000000
> >  #define MMC_SECURE_ERASE_ARG   0x80000000
> > --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

