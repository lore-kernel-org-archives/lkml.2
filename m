Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0JSW0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:26:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50041 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab0JSW0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tnZOcrVs/T+6lTdPiP62/fdyIvt/wbetrezyhYThPj3yo5OpJhmMsSrQPQJsT3yrTv
         483/78g/X4Dz8ecg+bWE2Wf5doAlgFr3lsb6gSq+RfejCoUYE82VyWKFmmYc9403vTpK
         LnvTDGVfjIlf/J7nT9Tn08YGkgYOU6W1a9MyY=
MIME-Version: 1.0
In-Reply-To: <1287327110-9158-1-git-send-email-segooon@gmail.com>
References: <1287327110-9158-1-git-send-email-segooon@gmail.com>
Date: Tue, 19 Oct 2010 15:26:05 -0700
X-Google-Sender-Auth: aGT-0yso2GSpDqZxm11U_8e7kaM
Message-ID: <AANLkTik15Z2_wyDRDOHOnpKKPgb+PHWs477esndgWmex@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: fix signedness bug
From: Dan Williams <dan.j.williams@intel.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 7:51 AM, Vasiliy Kulikov <segooon@gmail.com> wrote:
> mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
> failed imx_dma_request_by_prio() made no sence.  Explicitly check
> signed values.
>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  drivers/dma/imx-dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 346be62..75d870f 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -335,7 +335,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
>
>                imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
>                                DMA_PRIO_MEDIUM);
> -               if (imxdmac->channel < 0)
> +               if ((int)imxdmac->channel < 0)
>                        goto err_init;

Should this be:

               if ((int)imxdmac->channel < 0) {
                       ret = -ENODEV;
                       goto err_init;
               }

...because I get the following in my compilation tests.
drivers/dma/imx-dma.c: In function 'imxdma_probe':
drivers/dma/imx-dma.c:324: warning: 'ret' may be used uninitialized in
this function

--
Dan
