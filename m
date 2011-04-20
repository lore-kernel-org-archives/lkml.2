Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1DTLcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:32:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56930 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1DTLcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <1302116833-24540-9-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
	<1302116833-24540-9-git-send-email-per.forlin@linaro.org>
Date: Wed, 20 Apr 2011 13:32:18 +0200
Message-ID: <BANLkTikf_yJiXnprkAC2s=q1Oyqs0cGWZA@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] mmc: add handling for two parallel block
 requests in issue_rw_rq
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 April 2011 21:07, Per Forlin <per.forlin@linaro.org> wrote:
> Change mmc_blk_issue_rw_rq() to become asynchronous.
> The execution flow looks like this:
> The mmc-queue calls issue_rw_rq(), which sends the request
> to the host and returns back to the mmc-queue. The mmc-queue calls
> isuue_rw_rq() again with a new request. This new request is prepared,
> in isuue_rw_rq(), then it waits for the active request to complete before
> pushing it to the host. When to mmc-queue is empty it will call
> isuue_rw_rq() with req=NULL to finish off the active request
> without starting a new request.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/card/block.c |  157 +++++++++++++++++++++++++++++++++++++++-------
>  drivers/mmc/card/queue.c |    2 +-
>  2 files changed, 134 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index eef3510..2b14d1c 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -59,6 +59,7 @@ static int mmc_queue_thread(void *d)
>                mq->mqrq_cur->req = req;
>                spin_unlock_irq(q->queue_lock);
>
Call set_current_state(TASK_RUNNING) before issue_fn() otherwise
issue_fn will execute as TASK_INTERRUPTIBLE.
Will be added in the version 3 of this patchset.

> +               mq->issue_fn(mq, req);
>                if (!req) {
>                        if (kthread_should_stop()) {
>                                set_current_state(TASK_RUNNING);
> @@ -71,7 +72,6 @@ static int mmc_queue_thread(void *d)
>                }
>                set_current_state(TASK_RUNNING);
>
> -               mq->issue_fn(mq, req);
>        } while (1);
>        up(&mq->thread_sem);
>
> --
> 1.7.4.1
>
>
