Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1FVLFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:05:43 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60564 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668Ab1FVLFl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinGRy5KRJLYmEzzeFhOm0WpngzhhA@mail.gmail.com>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
	<1308699521-20556-2-git-send-email-per.forlin@linaro.org>
	<BANLkTikhZRb5GWFvTVG0bFjD6rAyJPka1w@mail.gmail.com>
	<BANLkTi=TY3wrH2GH1B2p+L506aUKOjg9uA@mail.gmail.com>
	<BANLkTinW1Wrvq6ma6L7he5iCtVCeofL-cg@mail.gmail.com>
	<BANLkTinGRy5KRJLYmEzzeFhOm0WpngzhhA@mail.gmail.com>
Date: Wed, 22 Jun 2011 16:35:33 +0530
Message-ID: <BANLkTimareJo2DCJkN9mH_oGFOuT_cZXpw@mail.gmail.com>
Subject: Re: [PATCH v7 01/11] mmc: add non-blocking mmc request function
From: "S, Venkatraman" <svenkatr@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev <linaro-dev@lists.linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 2:38 PM, Per Forlin <per.forlin@linaro.org> wrote:
> On 22 June 2011 10:53, S, Venkatraman <svenkatr@ti.com> wrote:
>> On Wed, Jun 22, 2011 at 2:15 PM, Per Forlin <per.forlin@linaro.org> wrote:
>>> On 22 June 2011 09:42, Venkatraman S <svenkatr@ti.com> wrote:
>>>> On Wed, Jun 22, 2011 at 5:08 AM, Per Forlin <per.forlin@linaro.org> wrote:
>>>>> Previously there has only been one function mmc_wait_for_req()
>>>>> to start and wait for a request. This patch adds
>>>>>  * mmc_start_req() - starts a request wihtout waiting
>>>>>   If there is on ongoing request wait for completion
>>>>>   of that request and start the new one and return.
>>>>>   Does not wait for the new command to complete.
>>>>>
>>>>> This patch also adds new function members in struct mmc_host_ops
>>>>> only called from core.c
>>>>>  * pre_req - asks the host driver to prepare for the next job
>>>>>  * post_req - asks the host driver to clean up after a completed job
>>>>>
>>>>> The intention is to use pre_req() and post_req() to do cache maintenance
>>>>> while a request is active. pre_req() can be called while a request is active
>>>>> to minimize latency to start next job. post_req() can be used after the next
>>>>> job is started to clean up the request. This will minimize the host driver
>>>>> request end latency. post_req() is typically used before ending the block
>>>>> request and handing over the buffer to the block layer.
>>>>>
>>>>> Add a host-private member in mmc_data to be used by
>>>>> pre_req to mark the data. The host driver will then
>>>>> check this mark to see if the data is prepared or not.
>>>>>
>>>>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>>>>> ---
>>>>>  drivers/mmc/core/core.c  |  110 +++++++++++++++++++++++++++++++++++++++++----
>>>>>  include/linux/mmc/core.h |    6 ++-
>>>>>  include/linux/mmc/host.h |   21 +++++++++
>>>>>  3 files changed, 126 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>>>>> index 68091dd..c82fa3b 100644
>>>>> --- a/drivers/mmc/core/core.c
>>>>> +++ b/drivers/mmc/core/core.c
>>>>> @@ -198,9 +198,106 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>>>>>
>>>>>  static void mmc_wait_done(struct mmc_request *mrq)
>>>>>  {
>>>>> -       complete(mrq->done_data);
>>>>> +       complete(&mrq->completion);
>>>>>  }
>>>>>
>>>>> +static void __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
>>>>> +{
>>>>> +       init_completion(&mrq->completion);
>>>>> +       mrq->done = mmc_wait_done;
>>>>> +       mmc_start_request(host, mrq);
>>>>> +}
>>>>> +
>>>>> +static void mmc_wait_for_req_done(struct mmc_host *host,
>>>>> +                                 struct mmc_request *mrq)
>>>>> +{
>>>>> +       wait_for_completion(&mrq->completion);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + *     mmc_pre_req - Prepare for a new request
>>>>> + *     @host: MMC host to prepare command
>>>>> + *     @mrq: MMC request to prepare for
>>>>> + *     @is_first_req: true if there is no previous started request
>>>>> + *                     that may run in parellel to this call, otherwise false
>>>>> + *
>>>>> + *     mmc_pre_req() is called in prior to mmc_start_req() to let
>>>>> + *     host prepare for the new request. Preparation of a request may be
>>>>> + *     performed while another request is running on the host.
>>>>> + */
>>>>> +static void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
>>>>> +                bool is_first_req)
>>>>> +{
>>>>> +       if (host->ops->pre_req)
>>>>> +               host->ops->pre_req(host, mrq, is_first_req);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + *     mmc_post_req - Post process a completed request
>>>>> + *     @host: MMC host to post process command
>>>>> + *     @mrq: MMC request to post process for
>>>>> + *     @err: Error, if non zero, clean up any resources made in pre_req
>>>>> + *
>>>>> + *     Let the host post process a completed request. Post processing of
>>>>> + *     a request may be performed while another reuqest is running.
>>>>> + */
>>>>> +static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
>>>>> +                        int err)
>>>>> +{
>>>>> +       if (host->ops->post_req)
>>>>> +               host->ops->post_req(host, mrq, err);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + *     mmc_start_req - start a non-blocking request
>>>>> + *     @host: MMC host to start command
>>>>> + *     @areq: async request to start
>>>>> + *     @error: out parameter returns 0 for success, otherwise non zero
>>>>> + *
>>>>> + *     Start a new MMC custom command request for a host.
>>>>> + *     If there is on ongoing async request wait for completion
>>>>> + *     of that request and start the new one and return.
>>>>> + *     Does not wait for the new request to complete.
>>>>> + *
>>>>> + *     Returns the completed async request, NULL in case of none completed.
>>>>> + */
>>>>> +struct mmc_async_req *mmc_start_req(struct mmc_host *host,
>>>>> +                                   struct mmc_async_req *areq, int *error)
>>>>> +{
>>>>> +       int err = 0;
>>>>> +       struct mmc_async_req *data = host->areq;
>>>>> +
>>>>> +       /* Prepare a new request */
>>>>> +       if (areq)
>>>>> +               mmc_pre_req(host, areq->mrq, !host->areq);
>>>>> +
>>>>> +       if (host->areq) {
>>>>> +               mmc_wait_for_req_done(host, host->areq->mrq);
>>>>> +               err = host->areq->err_check(host->card, host->areq);
>>>>> +               if (err) {
>>>>> +                       mmc_post_req(host, host->areq->mrq, 0);
>>>>> +                       if (areq)
>>>>> +                               mmc_post_req(host, areq->mrq, -EINVAL);
>>>>> +
>>>>> +                       host->areq = NULL;
>>>>> +                       goto out;
>>>> In this sequence, would the return value (data) have the previous areq ?
>>>> Is that intentional - doesn't seem to fit with the description.
>>> It will return the data that belongs to the completed request. The
>>> completed request will be the same as the previous request. The
>>> mmc_start_req will start a new request and return data for the
>>> completed request, if any.
>>>
>>
>> I meant that in case of an error (err !=0), data is already assigned
>> to host->areq
>> and goto out returns 'data'. So my question was 'Does returning a non-null
>> pointer for a unsuccessful request doesn't fit with the description, does it ?'
>>
> Now I get it. Thanks for your patience :)
>
>>>>> +       struct mmc_async_req *data = host->areq;
> ...
>>>>> +               mmc_wait_for_req_done(host, host->areq->mrq);
>>>>> +               err = host->areq->err_check(host->card, host->areq);
> in case of error host->areq is returned. Basically the failing request
> is returned.
> block.c needs the failing request in order to do error handling.
>
>>>>> + *     @error: out parameter returns 0 for success, otherwise non zero
> This parameter indicates error.
>
> Returning NULL is not error. NULL is returned when starting a new
> request and there is no ongoing (previous) request.
>
Thanks. This comment
>>>>> + *     Returns the completed async request, NULL in case of none completed.

should be modified to reflect this, otherwise the patch looks good.
Regards,
Venkat.
