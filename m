Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0I2VQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:16:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0I2VQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TTiU9qTWJ00aQ3nYXzr3P1/asNDkKhg5ky+6dnyUETv7Z7i0T/IikNaDZuz019szKJ
         hZ/9WVisXBPndJPw80gbrthAtsfVArfdKQA//KjE4BM5thncQ0wyjeO++MaLZ61iTnOk
         MzgVoYBBGXR9zZazgQfBBlQiYR5i4X92fsMgc=
MIME-Version: 1.0
In-Reply-To: <1285682257-16482-1-git-send-email-linus.walleij@stericsson.com>
References: <1285682257-16482-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 29 Sep 2010 14:16:00 -0700
X-Google-Sender-Auth: _zXPgSYHGdtFCfzCGNUPXwXLWys
Message-ID: <AANLkTi=b-Wzp4-0vg_AVz0os08dC7hX6gZBQn8WHfcF5@mail.gmail.com>
Subject: Re: [PATCH] driver for the ARM PL080/PL081 PrimeCells v5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Peter Pearse <peter.pearse@arm.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 6:57 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
> based on the implementation earlier submitted by Peter Pearse.
> This is working like a charm for memcpy and slave DMA to the PL011
> PrimeCell on the PB11MPCore.
>
> This DMA controller is used in mostly unmodified form in the ARM
> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
> in the ST SPEAr platform.
>
> It has been converted to use the header from the Samsung PL080
> derivate instead of its own defintions. The Samsungs have a custom
> driver in their mach-* folders though, atleast we can share the
> register definitions.
>
> Cc: Peter Pearse <peter.pearse@arm.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Acked-by: Viresh Kumar <viresh.kumar@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Changes v4->v5:
> - Squashed in all the follow-up patches
> - Deny transfers at prep() time and hold a scary lock across to
>  tx_submit() time in order to avoid pending works being pulled out
>  by completed transfers before submitting
> - inline dummy filter function
>
> Notes: I had to keep the condition that slave prep() calls will
> bail out immediately and not queue up like memcpy calls do. The
> reason is that a memcpy will always proceed once there is a
> physical channel available, whereas a slave transfer also needs
> to mux in a signal after acquiring the physical channel, and this
> can fail, which would mean that jobs would have to fail
> asynchronously as well which seems a bit unsafe to me.
> Waiting for the muxing to be available is no alternative either
> since there is no guarantee this will ever happen resulting in
> serious starvation, better to fail at prep() time IMO.

Yes, let's go with the simpler / safe option now we can always get
fancier later.

> +/*
> + * Initialize a descriptor to be used by memcpy submit
> + */
> +static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
> +               struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> +               size_t len, unsigned long flags)
> +{
> +       struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
> +       struct pl08x_driver_data *pl08x = plchan->host;
> +       struct pl08x_txd *txd;
> +       int ret;
> +
> +       txd = kzalloc(sizeof(struct pl08x_txd), GFP_KERNEL);
> +       if (!txd) {
> +               dev_err(&pl08x->adev->dev,
> +                       "%s no memory for descriptor\n", __func__);
> +               return NULL;
> +       }

With your acknowledgment I'll append a patch to convert this to
GFP_NOWAIT because device_prep_dma_memcpy() is meant to be callable
from atomic contexts.

--
Dan
