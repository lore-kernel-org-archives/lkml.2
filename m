Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1CVAt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:49:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41524 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1CVAty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nN1MhKELSzeVm3O+3wPHt2JlTncmWGMK7m+1/XOQDytVibv41N6kZUOqv4YmogzUZZ
         97IUmOp6schharyFqwO5/JWMU2qm5oaccYZAyz63z2Yg7oknWj3DbKkaASyiKB+nTOsr
         RXrDkp3dy3C7rfSDMLI4LVwkMOtw6G2juGVg8=
MIME-Version: 1.0
In-Reply-To: <1299174901-16762-4-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
	<1299174901-16762-4-git-send-email-iws@ovro.caltech.edu>
Date: Mon, 21 Mar 2011 17:49:49 -0700
X-Google-Sender-Auth: v1J8Y_Yj8fsqwaXYP5GfqiOMd0E
Message-ID: <AANLkTim07cvTwm+KfY=Fh6SofQWyPV_3ns7qKAjzpN=d@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] fsldma: use channel name in printk output
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 9:54 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> This makes debugging the driver much easier when multiple channels are
> running concurrently. In addition, you can see how much descriptor
> memory each channel has allocated via the dmapool API in sysfs.
>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
>  drivers/dma/fsldma.c |   69 +++++++++++++++++++++++++------------------------
>  drivers/dma/fsldma.h |    1 +
>  2 files changed, 36 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 2e1af45..e535cd1 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -37,7 +37,12 @@
>
>  #include "fsldma.h"
>
> -static const char msg_ld_oom[] = "No free memory for link descriptor\n";
> +#define chan_dbg(chan, fmt, arg...)                                    \
> +       dev_dbg(chan->dev, "%s: " fmt, chan->name, ##arg)
> +#define chan_err(chan, fmt, arg...)                                    \
> +       dev_err(chan->dev, "%s: " fmt, chan->name, ##arg)
> +

I already have this applied, but if you want to send an incremental
cleanup patch you could achieve a similar effect without increasing
the size of fsldma_chan by using the class device that is created by
dma_async_device_register.

Something like:

#define to_chan_dev(chan) (&chan->common.dev->device)
#define chan_err(chan, fmt, arg...) \
   dev_err(chan->dev, "%s: " fmt, dev_name(to_chan_dev(chan)), ##arg)

...where dev_name() returns something like "dma0chan0".

--
Dan
