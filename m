Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2FZIt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:49:27 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:53349 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab2FZItY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <007b01cd4d15$40673510$c1359f30$%jun@samsung.com>
References: <007b01cd4d15$40673510$c1359f30$%jun@samsung.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 26 Jun 2012 14:19:00 +0530
Message-ID: <CANfBPZ-Rt-RqBgBCj9Y-p5jEOk8Xs9j6xS_pzu83U_rMr_2qCQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v7 2/3] mmc: core: Support packed write command for
 eMMC4.5 device
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Maya Erez <merez@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:13 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> This patch supports packed write command of eMMC4.5 device.
> Several writes can be grouped in packed command and all data
> of the individual commands can be sent in a single transfer
> on the bus.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/mmc/card/block.c   |  406 +++++++++++++++++++++++++++++++++++++++++---
>  drivers/mmc/card/queue.c   |   45 +++++-
>  drivers/mmc/card/queue.h   |   12 ++
>  drivers/mmc/core/mmc_ops.c |    1 +
>  include/linux/mmc/core.h   |    4 +
>  5 files changed, 441 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 7e3f453..eb99e35 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -58,6 +58,12 @@ MODULE_ALIAS("mmc:block");
>  #define INAND_CMD38_ARG_SECTRIM1 0x81
>  #define INAND_CMD38_ARG_SECTRIM2 0x88
>
> +#define mmc_req_rel_wr(req)    (((req->cmd_flags & REQ_FUA) || \
> +                       (req->cmd_flags & REQ_META)) && \
> +                       (rq_data_dir(req) == WRITE))
> +#define PACKED_CMD_VER         0x01
> +#define PACKED_CMD_WR          0x02
> +
>  static DEFINE_MUTEX(block_mutex);
>
>  /*
> @@ -123,9 +129,21 @@ enum mmc_blk_status {
>        MMC_BLK_NOMEDIUM,
>  };
>
> +enum {
> +       MMC_PACKED_N_IDX = -1,
> +       MMC_PACKED_N_ZERO,
> +       MMC_PACKED_N_SINGLE,
> +};
> +
>  module_param(perdev_minors, int, 0444);
>  MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
>
> +static inline void mmc_blk_clear_packed(struct mmc_queue_req *mqrq)
> +{
> +       mqrq->packed_cmd = MMC_PACKED_NONE;
> +       mqrq->packed_num = MMC_PACKED_N_ZERO;
> +}
> +
>  static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
>  {
>        struct mmc_blk_data *md;
> @@ -1081,12 +1099,61 @@ static int mmc_blk_err_check(struct mmc_card *card,
>        if (!brq->data.bytes_xfered)
>                return MMC_BLK_RETRY;
>
> +       if (mq_mrq->packed_cmd != MMC_PACKED_NONE) {
> +               if (unlikely(brq->data.blocks << 9 != brq->data.bytes_xfered))
> +                       return MMC_BLK_PARTIAL;
> +               else
> +                       return MMC_BLK_SUCCESS;
> +       }
> +
>        if (blk_rq_bytes(req) != brq->data.bytes_xfered)
>                return MMC_BLK_PARTIAL;
>
>        return MMC_BLK_SUCCESS;
>  }
>
> +static int mmc_blk_packed_err_check(struct mmc_card *card,
> +                                   struct mmc_async_req *areq)
> +{
> +       struct mmc_queue_req *mq_rq = container_of(areq, struct mmc_queue_req,
> +                       mmc_active);
> +       struct request *req = mq_rq->req;
> +       int err, check, status;
> +       u8 ext_csd[512];
> +
> +       mq_rq->packed_retries--;
> +       check = mmc_blk_err_check(card, areq);
> +       err = get_card_status(card, &status, 0);
> +       if (err) {
> +               pr_err("%s: error %d sending status command\n",
> +                               req->rq_disk->disk_name, err);
> +               return MMC_BLK_ABORT;
> +       }
> +
> +       if (status & R1_EXP_EVENT) {
> +               err = mmc_send_ext_csd(card, ext_csd);
> +               if (err) {
> +                       pr_err("%s: error %d sending ext_csd\n",
> +                                       req->rq_disk->disk_name, err);
> +                       return MMC_BLK_ABORT;
> +               }
> +
> +               if ((ext_csd[EXT_CSD_EXP_EVENTS_STATUS] &
> +                                       EXT_CSD_PACKED_FAILURE) &&
> +                               (ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
> +                                EXT_CSD_PACKED_GENERIC_ERROR)) {
> +                       if (ext_csd[EXT_CSD_PACKED_CMD_STATUS] &
> +                                       EXT_CSD_PACKED_INDEXED_ERROR) {
> +                               mq_rq->packed_fail_idx =
> +                                 ext_csd[EXT_CSD_PACKED_FAILURE_INDEX] - 1;
> +                               return MMC_BLK_PARTIAL;
> +                       }
> +               }
> +       }
> +
> +       return check;
> +}
> +
>  static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
>                               struct mmc_card *card,
>                               int disable_multi,
> @@ -1241,10 +1308,197 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
>        mmc_queue_bounce_pre(mqrq);
>  }
>
> +static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
> +{
> +       struct request_queue *q = mq->queue;
> +       struct mmc_card *card = mq->card;
> +       struct request *cur = req, *next = NULL;
> +       struct mmc_blk_data *md = mq->data;
> +       bool en_rel_wr = card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN;
> +       unsigned int req_sectors = 0, phys_segments = 0;
> +       unsigned int max_blk_count, max_phys_segs;
> +       u8 put_back = 0;
> +       u8 max_packed_rw = 0;
> +       u8 reqs = 0;
> +
> +       mmc_blk_clear_packed(mq->mqrq_cur);
> +
> +       if (!(md->flags & MMC_BLK_CMD23) ||
> +                       !card->ext_csd.packed_event_en)
> +               goto no_packed;
> +
> +       if ((rq_data_dir(cur) == WRITE) &&
> +                       (card->host->caps2 & MMC_CAP2_PACKED_WR))
> +               max_packed_rw = card->ext_csd.max_packed_writes;
> +
> +       if (max_packed_rw == 0)
> +               goto no_packed;
> +
> +       if (mmc_req_rel_wr(cur) &&
> +                       (md->flags & MMC_BLK_REL_WR) &&
> +                       !en_rel_wr) {
> +               goto no_packed;
> +       }
> +
> +       max_blk_count = min(card->host->max_blk_count,
> +                       card->host->max_req_size >> 9);
> +       if (unlikely(max_blk_count > 0xffff))
> +               max_blk_count = 0xffff;
> +
> +       max_phys_segs = queue_max_segments(q);
> +       req_sectors += blk_rq_sectors(cur);
> +       phys_segments += cur->nr_phys_segments;
> +
> +       if (rq_data_dir(cur) == WRITE) {
> +               req_sectors++;
> +               phys_segments++;
> +       }
> +
> +       while (reqs < max_packed_rw - 1) {
> +               spin_lock_irq(q->queue_lock);
> +               next = blk_fetch_request(q);
> +               spin_unlock_irq(q->queue_lock);
> +               if (!next)
> +                       break;
> +
> +               if (next->cmd_flags & REQ_DISCARD ||
> +                               next->cmd_flags & REQ_FLUSH) {
> +                       put_back = 1;
> +                       break;
> +               }
> +
> +               if (rq_data_dir(cur) != rq_data_dir(next)) {
> +                       put_back = 1;
> +                       break;
> +               }
> +
> +               if (mmc_req_rel_wr(next) &&
> +                               (md->flags & MMC_BLK_REL_WR) &&
> +                               !en_rel_wr) {
> +                       put_back = 1;
> +                       break;
> +               }
> +
> +               req_sectors += blk_rq_sectors(next);
> +               if (req_sectors > max_blk_count) {
> +                       put_back = 1;
> +                       break;
> +               }
> +
> +               phys_segments +=  next->nr_phys_segments;
> +               if (phys_segments > max_phys_segs) {
> +                       put_back = 1;
> +                       break;
> +               }
> +
> +               list_add_tail(&next->queuelist, &mq->mqrq_cur->packed_list);
> +               cur = next;
> +               reqs++;
> +       }
> +
> +       if (put_back) {
> +               spin_lock_irq(q->queue_lock);
> +               blk_requeue_request(q, next);
> +               spin_unlock_irq(q->queue_lock);
> +       }
> +
> +       if (reqs > 0) {
> +               list_add(&req->queuelist, &mq->mqrq_cur->packed_list);
> +               mq->mqrq_cur->packed_num = ++reqs;
> +               mq->mqrq_cur->packed_retries = reqs;

^^ This means that the number of times the packed command is retried
is equal to the number of requests
it packs ? How are they related ?

> +               return reqs;
> +       }
> +
> +no_packed:
> +       mmc_blk_clear_packed(mq->mqrq_cur);
> +       return 0;
> +}
> +
