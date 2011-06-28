Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1F1Jkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:40:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37551 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab1F1Jjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <1309248717-14606-13-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
	<1309248717-14606-13-git-send-email-per.forlin@linaro.org>
Date: Tue, 28 Jun 2011 11:39:41 +0200
Message-ID: <BANLkTikkv+RQKZCX2PeZUDhM1gnVXCKO2w@mail.gmail.com>
Subject: Re: [PATCH v8 12/12] mmc: block: add handling for two parallel block
 requests in issue_rw_rq
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2011 10:11, Per Forlin <per.forlin@linaro.org> wrote:
> Change mmc_blk_issue_rw_rq() to become asynchronous.
> The execution flow looks like this:
> The mmc-queue calls issue_rw_rq(), which sends the request
> to the host and returns back to the mmc-queue. The mmc-queue calls
> issue_rw_rq() again with a new request. This new request is prepared,
> in isuue_rw_rq(), then it waits for the active request to complete before
> pushing it to the host. When to mmc-queue is empty it will call
> isuue_rw_rq() with req=NULL to finish off the active request
> without starting a new request.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/card/block.c |   80 +++++++++++++++++++++++++++++++++++++--------
>  drivers/mmc/card/queue.c |   17 +++++++---
>  drivers/mmc/card/queue.h |    1 +
>  3 files changed, 78 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 7ed2c68..825741e 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
...
> @@ -1066,6 +1085,13 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
>                        ret = __blk_end_request(req, 0,
>                                                brq->data.bytes_xfered);
>                        spin_unlock_irq(&md->lock);
> +                       if (status == MMC_BLK_SUCCESS && ret) {
> +                               /* If this happen it is a bug */
> +                               printk(KERN_ERR "%s BUG rq_tot %d d_xfer %d\n",
> +                                      __func__, blk_rq_bytes(req),
> +                                      brq->data.bytes_xfered);
+ rqc = NULL
If there is a new request (rqc != NULL)  it will already be started
when reaching this point.
If rqc is set it will be started again at start_new_req.

I wonder if this paranoia check is necessary. If "status ==
MMC_BLK_SUCCESS" all bytes are transferred and no error returned from
mmc layer.
 __blk_end_request would always return 0 in this case, please comment
if you disagree.

...
> + start_new_req:
> +       if (rqc) {
> +               mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
> +               mmc_start_req(card->host, &mq->mqrq_cur->mmc_active, NULL);
> +       }
> +
>        return 0;
>  }

/Per
