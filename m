Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1FVHmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:42:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49228 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVHma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j1HNmyR6ucvAHktONh452WErKQb7jhhO1mA53sEq//Lv0dLO8Rb+sBgHH/mj0/X3ct
         Iz2uYgv9YPIp0nsviX21nmIllgec0q1HNDoqO6itc+2sa+ftP+iZwWyXO6IEyTRp+593
         pG5cD8bsqSbb0i7XvrIKwcMHJCe8GqBJreaUM=
MIME-Version: 1.0
In-Reply-To: <1308699521-20556-2-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
	<1308699521-20556-2-git-send-email-per.forlin@linaro.org>
Date: Wed, 22 Jun 2011 13:12:28 +0530
X-Google-Sender-Auth: jlPCyK7lv8QMPJv5-hmunuZUx_Q
Message-ID: <BANLkTikhZRb5GWFvTVG0bFjD6rAyJPka1w@mail.gmail.com>
Subject: Re: [PATCH v7 01/11] mmc: add non-blocking mmc request function
From: Venkatraman S <svenkatr@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 5:08 AM, Per Forlin <per.forlin@linaro.org> wrote:
> Previously there has only been one function mmc_wait_for_req()
> to start and wait for a request. This patch adds
>  * mmc_start_req() - starts a request wihtout waiting
>   If there is on ongoing request wait for completion
>   of that request and start the new one and return.
>   Does not wait for the new command to complete.
>
> This patch also adds new function members in struct mmc_host_ops
> only called from core.c
>  * pre_req - asks the host driver to prepare for the next job
>  * post_req - asks the host driver to clean up after a completed job
>
> The intention is to use pre_req() and post_req() to do cache maintenance
> while a request is active. pre_req() can be called while a request is active
> to minimize latency to start next job. post_req() can be used after the next
> job is started to clean up the request. This will minimize the host driver
> request end latency. post_req() is typically used before ending the block
> request and handing over the buffer to the block layer.
>
> Add a host-private member in mmc_data to be used by
> pre_req to mark the data. The host driver will then
> check this mark to see if the data is prepared or not.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/core/core.c  |  110 +++++++++++++++++++++++++++++++++++++++++----
>  include/linux/mmc/core.h |    6 ++-
>  include/linux/mmc/host.h |   21 +++++++++
>  3 files changed, 126 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 68091dd..c82fa3b 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -198,9 +198,106 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>
>  static void mmc_wait_done(struct mmc_request *mrq)
>  {
> -       complete(mrq->done_data);
> +       complete(&mrq->completion);
>  }
>
> +static void __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
> +{
> +       init_completion(&mrq->completion);
> +       mrq->done = mmc_wait_done;
> +       mmc_start_request(host, mrq);
> +}
> +
> +static void mmc_wait_for_req_done(struct mmc_host *host,
> +                                 struct mmc_request *mrq)
> +{
> +       wait_for_completion(&mrq->completion);
> +}
> +
> +/**
> + *     mmc_pre_req - Prepare for a new request
> + *     @host: MMC host to prepare command
> + *     @mrq: MMC request to prepare for
> + *     @is_first_req: true if there is no previous started request
> + *                     that may run in parellel to this call, otherwise false
> + *
> + *     mmc_pre_req() is called in prior to mmc_start_req() to let
> + *     host prepare for the new request. Preparation of a request may be
> + *     performed while another request is running on the host.
> + */
> +static void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
> +                bool is_first_req)
> +{
> +       if (host->ops->pre_req)
> +               host->ops->pre_req(host, mrq, is_first_req);
> +}
> +
> +/**
> + *     mmc_post_req - Post process a completed request
> + *     @host: MMC host to post process command
> + *     @mrq: MMC request to post process for
> + *     @err: Error, if non zero, clean up any resources made in pre_req
> + *
> + *     Let the host post process a completed request. Post processing of
> + *     a request may be performed while another reuqest is running.
> + */
> +static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
> +                        int err)
> +{
> +       if (host->ops->post_req)
> +               host->ops->post_req(host, mrq, err);
> +}
> +
> +/**
> + *     mmc_start_req - start a non-blocking request
> + *     @host: MMC host to start command
> + *     @areq: async request to start
> + *     @error: out parameter returns 0 for success, otherwise non zero
> + *
> + *     Start a new MMC custom command request for a host.
> + *     If there is on ongoing async request wait for completion
> + *     of that request and start the new one and return.
> + *     Does not wait for the new request to complete.
> + *
> + *     Returns the completed async request, NULL in case of none completed.
> + */
> +struct mmc_async_req *mmc_start_req(struct mmc_host *host,
> +                                   struct mmc_async_req *areq, int *error)
> +{
> +       int err = 0;
> +       struct mmc_async_req *data = host->areq;
> +
> +       /* Prepare a new request */
> +       if (areq)
> +               mmc_pre_req(host, areq->mrq, !host->areq);
> +
> +       if (host->areq) {
> +               mmc_wait_for_req_done(host, host->areq->mrq);
> +               err = host->areq->err_check(host->card, host->areq);
> +               if (err) {
> +                       mmc_post_req(host, host->areq->mrq, 0);
> +                       if (areq)
> +                               mmc_post_req(host, areq->mrq, -EINVAL);
> +
> +                       host->areq = NULL;
> +                       goto out;
In this sequence, would the return value (data) have the previous areq ?
Is that intentional - doesn't seem to fit with the description.

> +               }
> +       }
> +
> +       if (areq)
> +               __mmc_start_req(host, areq->mrq);
> +
> +       if (host->areq)
> +               mmc_post_req(host, host->areq->mrq, 0);
> +
> +       host->areq = areq;
> + out:
> +       if (error)
> +               *error = err;
> +       return data;
> +}
> +EXPORT_SYMBOL(mmc_start_req);
> +
