Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0CXVfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:35:05 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:43897 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0CXVfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WnXATYfsjefjfE7EkeU1xf1lZ+mp5VpNsR6V/anVBpi4BghgPdAPiXi467hw0V4uP+
         /UdQzPmUi4g4IH/rWd+uZJ1tdPkjs6h76Vh2kspnzJN0s+IMYAWZmbexGE0z/hLz5IbR
         M2BE4Didy46gYBLT6RaKbWOvTCkRsXtsNNQc8=
MIME-Version: 1.0
In-Reply-To: <1267710030-5717-1-git-send-email-linus.walleij@stericsson.com>
References: <1267710030-5717-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 24 Mar 2010 14:35:01 -0700
X-Google-Sender-Auth: bdd72a9bdd41f621
Message-ID: <e9c3a7c21003241435j25b63c05l5df2aa44fc5dc627@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: COH 901 318 fix bytesleft
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 6:40 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This makes the function to get the number of bytes left in the
> ongoing DMA transaction actually work: the old code did not take
> neither lli:s nor queued jobs into account. Also fix a missing
> spinlock while we're at it.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ----
> Sorry last version of the 0002 patch had a debug print stuck in
> it still. This one is fixed, both patches apply on top of the
> previous ones by the way, I'm digging around in this DMA driver
> now so might as well try to fix a number of issues with it.
> ---
>  drivers/dma/coh901318.c |   96 +++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 88 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index 20889c9..f636c4a 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
[..]
> @@ -831,6 +906,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
>  static int coh901318_alloc_chan_resources(struct dma_chan *chan)
>  {
>        struct coh901318_chan   *cohc = to_coh901318_chan(chan);
> +       unsigned long flags;
>
>        dev_vdbg(COHC_2_DEV(cohc), "[%s] DMA channel %d\n",
>                 __func__, cohc->id);
> @@ -838,11 +914,15 @@ static int coh901318_alloc_chan_resources(struct dma_chan *chan)
>        if (chan->client_count > 1)
>                return -EBUSY;
>
> +       spin_lock_irqsave(&cohc->lock, flags);
> +
>        coh901318_config(cohc, NULL);
>
>        cohc->allocated = 1;
>        cohc->completed = chan->cookie = 1;
>
> +       spin_unlock_irqrestore(&cohc->lock, flags);
> +
>

Should this hunk be broken off and sent to -stable?  My guess is no.
It should be mostly impossible to trigger a problem here since the
channel is expected to be idle while resources are being allocated and
the dmaengine mutex is already protecting against parallel
allocations.  It is an unrelated fix however.

--
Dan
