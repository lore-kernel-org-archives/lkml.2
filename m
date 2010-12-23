Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0LWIaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:30:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36793 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0LWIa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pLEyGEO2b1eoKRw4SsRiC7yXkONsnsUHI01Wb6HMUvRNsdCK/Ez7lhzHpJ0VMrkbOH
         tXLh2M7lGp6+Kj2TszekHHHa7u2z0tI/AEl3Vas+XhRqDxZq8I0HHyJDaRMJwIhk4L4S
         0PlwQ/f0rOEvUAFZSYBPYzAxwzcsBZFW/L1TU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinOMOkY6AUW8Z6FWMMWU9u0_sNjA2r_31u9-A8v@mail.gmail.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<AANLkTinOMOkY6AUW8Z6FWMMWU9u0_sNjA2r_31u9-A8v@mail.gmail.com>
Date: Thu, 23 Dec 2010 17:30:27 +0900
Message-ID: <AANLkTikEz=4asJqEP34vUmitqmocd9QJqaUZY+SdQtWN@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 5:17 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/12/23 Dan Williams <dan.j.williams@intel.com>:
>> On Wed, Dec 22, 2010 at 4:29 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>>> As described above in my code analysis, pl08x_tasklet takes the spinlock,
>>> calls pl011_dma_tx_callback and eventually back to pl08x_prep_slave_sg
>>> and pl08x_prep_channel_resources which then try to take the spinlock
>>> again, leading to deadlock.
>>
>> This is listed in the dmaengine documentation [1], but I obviously
>> missed this before merging.  This also would have been caught by
>> lockdep as required by SubmitChecklist.
>
> Yeah, my bad. I'll get better at this... :-(
> (I blame it partially on inaccessible hardware, sob sob. I do like to
> run lockdep.)
>
>> It looks like this driver needs a full scrub
>> which seems unreasonable to complete and test over the holidays before
>> .37 lands.  Linus we either need to mark this "depends on BROKEN" or
>> revert it.
>
> Isn't it really as simple as to release the spinlock during callbacks?
> That lock is only intended to protect the plchan variables, not to block
> anyone from queueing new stuff during the callback (as happens now).
>
> It can release that lock, make a callback where a new descriptor
> gets queued, and then take it again and start looking at the queue,
> at which point it discovers the new desc and process it.
>
> So something like this:
>
>
> From: Linus Walleij <linus.walleij@stericsson.com>
> Date: Thu, 23 Dec 2010 09:06:14 +0100
> Subject: [PATCH] dma: release pl08x channel lock during callback
>
> The spinlock is not really safeguarding any resources during the
> callback, so let's release it before that and take it back
> afterwards so as to avoid deadlocks.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/dma/amba-pl08x.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index b605cc9..7879a22 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1651,8 +1651,11 @@ static void pl08x_tasklet(unsigned long data)
>                /*
>                 * Callback to signal completion
>                 */
> -               if (callback)
> -                       callback(callback_param);
> +               if (callback) {
> +                        spin_unlock(&plchan->lock);
> +                        callback(callback_param);
> +                        spin_lock(&plchan->lock);
> +                }
How about adding completed requests to a list and go on to do important
channel management stuff, and do callbacks at the end after dropping the lock.
As in pl330_tasklet of drivers/dma/pl330.c
