Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1J1FoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:44:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64623 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1J1FoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:44:16 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-53-4eaa412dc170
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'S, Venkatraman'" <svenkatr@ti.com>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        dh.han@samsung.com
References: <1319712841-28579-1-git-send-email-tgih.jun@samsung.com>
 <CANfBPZ_i3wcPkBnv-wOYbSUib=0k9bpem3ZGWg4TcjNE9NZywg@mail.gmail.com>
In-reply-to: <CANfBPZ_i3wcPkBnv-wOYbSUib=0k9bpem3ZGWg4TcjNE9NZywg@mail.gmail.com>
Subject: RE: [PATCH] mmc: core: Add packed command for eMMC4.5 device
Date: Fri, 28 Oct 2011 14:44:12 +0900
Message-id: <001601cc9534$9f474d70$ddd5e850$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyUq5qKDhp+A33jTpC+XPg8+2SPOAAh6xGg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S, Venkatraman <svenkatr@ti.com>  wrote: 
> On Thu, Oct 27, 2011 at 4:24 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > This patch supports packed command feature of eMMC4.5 Spec.
> > Several reads(or writes) can be grouped in packed command
> > and all data of the individual commands can be sent in one
> > transfer on the bus.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >  drivers/mmc/card/block.c |  349 ++++++++++++++++++++++++++++++++++++++++++++--
> >  drivers/mmc/card/queue.c |   48 ++++++-
> >  drivers/mmc/card/queue.h |   12 ++
> >  drivers/mmc/core/mmc.c   |   20 +++
> >  include/linux/mmc/card.h |    3 +
> >  include/linux/mmc/host.h |    1 +
> >  include/linux/mmc/mmc.h  |   15 ++
> >  7 files changed, 434 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> > index 4fd5723..0258a81 100644
> > --- a/drivers/mmc/card/block.c
> > +++ b/drivers/mmc/card/block.c
> > @@ -45,6 +45,7 @@
> >  #include <asm/uaccess.h>
> >
> >  #include "queue.h"
> > +#include "../core/mmc_ops.h"
> 
> I don't think this is the right way to include files.  The core
> directory should be in the include path already.
Ok, I'll make be well-formed.
> 
> >
> >  MODULE_ALIAS("mmc:block");
> >  #ifdef MODULE_PARAM_PREFIX
> > @@ -59,6 +60,10 @@ MODULE_ALIAS("mmc:block");
> >  #define INAND_CMD38_ARG_SECTRIM1 0x81
> >  #define INAND_CMD38_ARG_SECTRIM2 0x88
> >
> > +#define mmc_req_rel_wr(req)    (((req->cmd_flags & REQ_FUA) || \
> > +                       (req->cmd_flags & REQ_META)) && \
> > +                       (rq_data_dir(req) == WRITE))
> > +
> >  static DEFINE_MUTEX(block_mutex);
> >
> >  /*
> > @@ -943,7 +948,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
> >         * kind.  If it was a write, we may have transitioned to
> >         * program mode, which we have to wait for it to complete.
> >         */
> > -       if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
> > +       if ((!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) ||
> > +                       (mq_mrq->packed_cmd == MMC_PACKED_WR_HDR)) {
> >                u32 status;
> >                do {
> >                        int err = get_card_status(card, &status, 5);
> > @@ -980,12 +986,67 @@ static int mmc_blk_err_check(struct mmc_card *card,
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
> > @@ -1126,6 +1187,207 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
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
> > +
> > +               list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
> > +               cur = next;
> > +               reqs++;
> > +       }
> 
> IIRC, blk_fetch_request gets it from the top of the request_queue and
> blk_requeue_request puts it back to the top of the queue
> (request_queue->queue_head). Hence, possibly, this loop will keep
> fetching and requeing the same request repeatedly ?
Right. If fetched request is not packable to previous requests,
then it will be queued to top of request_queue.
> 
> 
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
> > +               (((rq_data_dir(req) == READ) ? 0x01 : 0x02) << 8) | (0x01 << 0);
> > +
> Too many magic numbers here.
Ok. It will be modified.
> 
> > +       /*
> > +        * Argument for each entry of packed group
> > +        */
> > +       list_for_each_entry(prq, &mqrq->packed_list, queuelist) {
> > +               do_rel_wr = mmc_req_rel_wr(prq) && (md->flags & MMC_BLK_REL_WR);
> > +               /* Argument of CMD23*/
> > +               packed_cmd_hdr[(i * 2)] = (do_rel_wr ? (1 << 31) : 0) |
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
> > +       brq->sbc.arg = (0 << 31) | (1 << 30) |
> > +               ((rq_data_dir(req) == READ) ? 1 : mqrq->packed_blocks + 1);
> 
> .. and here ^^..
> 
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
> > @@ -1163,15 +1425,33 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
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
> > +                               mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> > +                       }
> >                        areq = &mq->mqrq_cur->mmc_active;
> >                } else
> >                        areq = NULL;
> > @@ -1179,6 +1459,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >                if (!areq)
> >                        return 0;
> >
> > +check_status:
> >                mq_rq = container_of(areq, struct mmc_queue_req, mmc_active);
> >                brq = &mq_rq->brq;
> >                req = mq_rq->req;
> > @@ -1192,10 +1473,32 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
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
> > @@ -1254,7 +1557,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> >                        break;
> >                }
> >
> > -               if (ret) {
> > +               if (ret && (mq_rq->packed_cmd == MMC_PACKED_NONE)) {
> >                        /*
> >                         * In case of a incomplete request
> >                         * prepare it again and resend.
> > @@ -1267,13 +1570,37 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
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
> > diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> > index 3627044..eab01c1 100644
> > --- a/drivers/mmc/core/mmc.c
> > +++ b/drivers/mmc/core/mmc.c
> > @@ -487,6 +487,9 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
> >                        ext_csd[EXT_CSD_CACHE_SIZE + 1] << 8 |
> >                        ext_csd[EXT_CSD_CACHE_SIZE + 2] << 16 |
> >                        ext_csd[EXT_CSD_CACHE_SIZE + 3] << 24;
> > +
> > +               card->ext_csd.max_packed_writes = ext_csd[EXT_CSD_MAX_PACKED_WRITES];
> > +               card->ext_csd.max_packed_reads = ext_csd[EXT_CSD_MAX_PACKED_READS];
> >        }
> >
> >  out:
> > @@ -1072,6 +1075,23 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
> >                card->ext_csd.cache_ctrl = err ? 0 : 1;
> >        }
> >
> > +       if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> > +                       (card->ext_csd.max_packed_writes > 0) &&
> > +                       (card->ext_csd.max_packed_reads > 0)) {
> > +               err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +                               EXT_CSD_EXP_EVENTS_CTRL,
> > +                               EXT_CSD_PACKED_EVENT_EN,
> > +                               card->ext_csd.generic_cmd6_time);
> > +               if (err && err != -EBADMSG)
> > +                       goto free_card;
> > +               if (err) {
> > +                       pr_warning("%s: Enabling packed event failed\n",
> > +                                       mmc_hostname(card->host));
> > +                       err = 0;
> > +               } else
> > +                       card->ext_csd.packed_event_en = 1;
> > +       }
> > +
> >        if (!oldcard)
> >                host->card = card;
> >
> > diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> > index 6e04e10..3ffd93f 100644
> > --- a/include/linux/mmc/card.h
> > +++ b/include/linux/mmc/card.h
> > @@ -52,6 +52,9 @@ struct mmc_ext_csd {
> >        u8                      part_config;
> >        u8                      cache_ctrl;
> >        u8                      rst_n_function;
> > +       u8                      max_packed_writes;
> > +       u8                      max_packed_reads;
> > +       u8                      packed_event_en;
> >        unsigned int            part_time;              /* Units: ms */
> >        unsigned int            sa_timeout;             /* Units: 100ns */
> >        unsigned int            generic_cmd6_time;      /* Units: 10ms */
> > diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> > index a3ac9c4..d2e4210 100644
> > --- a/include/linux/mmc/host.h
> > +++ b/include/linux/mmc/host.h
> > @@ -242,6 +242,7 @@ struct mmc_host {
> >  #define MMC_CAP2_CACHE_CTRL    (1 << 1)        /* Allow cache control */
> >  #define MMC_CAP2_POWEROFF_NOTIFY (1 << 2)      /* Notify poweroff supported */
> >  #define MMC_CAP2_NO_MULTI_READ (1 << 3)        /* Multiblock reads don't work */
> > +#define MMC_CAP2_PACKED_CMD    (1 << 4)        /* Allow packed command */
> >
> >        mmc_pm_flag_t           pm_caps;        /* supported pm features */
> >        unsigned int        power_notify_type;
> > diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> > index 0e71356..1988780 100644
> > --- a/include/linux/mmc/mmc.h
> > +++ b/include/linux/mmc/mmc.h
> > @@ -138,6 +138,7 @@ static inline bool mmc_op_multi(u32 opcode)
> >  #define R1_CURRENT_STATE(x)    ((x & 0x00001E00) >> 9) /* sx, b (4 bits) */
> >  #define R1_READY_FOR_DATA      (1 << 8)        /* sx, a */
> >  #define R1_SWITCH_ERROR                (1 << 7)        /* sx, c */
> > +#define R1_EXP_EVENT           (1 << 6)        /* sr, a */
> >  #define R1_APP_CMD             (1 << 5)        /* sr, c */
> >
> >  #define R1_STATE_IDLE  0
> > @@ -273,6 +274,10 @@ struct _mmc_csd {
> >  #define EXT_CSD_FLUSH_CACHE            32      /* W */
> >  #define EXT_CSD_CACHE_CTRL             33      /* R/W */
> >  #define EXT_CSD_POWER_OFF_NOTIFICATION 34      /* R/W */
> > +#define EXT_CSD_PACKED_FAILURE_INDEX   35      /* RO */
> > +#define EXT_CSD_PACKED_CMD_STATUS      36      /* RO */
> > +#define EXT_CSD_EXP_EVENTS_STATUS      54      /* RO, 2 bytes */
> > +#define EXT_CSD_EXP_EVENTS_CTRL        56      /* R/W, 2 bytes */
> >  #define EXT_CSD_GP_SIZE_MULT           143     /* R/W */
> >  #define EXT_CSD_PARTITION_ATTRIBUTE    156     /* R/W */
> >  #define EXT_CSD_PARTITION_SUPPORT      160     /* RO */
> > @@ -313,6 +318,8 @@ struct _mmc_csd {
> >  #define EXT_CSD_POWER_OFF_LONG_TIME    247     /* RO */
> >  #define EXT_CSD_GENERIC_CMD6_TIME      248     /* RO */
> >  #define EXT_CSD_CACHE_SIZE             249     /* RO, 4 bytes */
> > +#define EXT_CSD_MAX_PACKED_WRITES      500     /* RO */
> > +#define EXT_CSD_MAX_PACKED_READS       501     /* RO */
> >  #define EXT_CSD_HPI_FEATURES           503     /* RO */
> >
> >  /*
> > @@ -364,6 +371,14 @@ struct _mmc_csd {
> >  #define EXT_CSD_PWR_CL_4BIT_MASK       0x0F    /* 8 bit PWR CLS */
> >  #define EXT_CSD_PWR_CL_8BIT_SHIFT      4
> >  #define EXT_CSD_PWR_CL_4BIT_SHIFT      0
> > +
> > +#define EXT_CSD_PACKED_EVENT_EN        (1<<3)
> > +
> > +#define EXT_CSD_PACKED_FAILURE (1<<3)
> > +
> > +#define EXT_CSD_PACKED_GENERIC_ERROR   (1<<0)
> > +#define EXT_CSD_PACKED_INDEXED_ERROR   (1<<1)
> > +
> >  /*
> >  * MMC_SWITCH access modes
> >  */
> > --
> > 1.7.2.3
> >
> 
> It'd be helpful if you split this patch into several smaller ones for
> easier review.
> Also please copy linux-kernel mailing list for wider review.
split path... I'll consider it, if possible.
Thank you for review.

Best regards,
Seungwon Jeon.

