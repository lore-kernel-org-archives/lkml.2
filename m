Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2F3ORr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 10:17:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40008 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2F3ORp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 10:17:45 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com> <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 30 Jun 2012 17:17:24 +0300
Message-ID: <CAK=WgbYcySfWMLBRCJ9B38Bew0ELBgORtnJbGgfqfMda_+3q9w@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Jun 22, 2012 at 5:31 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Carveout did not set device address when IOMMU is not supported.
> Fix this by assigning dma address to device address to carveout
> if IOMMU is not supported.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/remoteproc/remoteproc_core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index bee4644..8185c11 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -628,6 +628,10 @@ static int rproc_handle_carveout(struct rproc *rproc,
>                  * dual M3 subsystem).
>                  */
>                 rsc->pa = dma;
> +       } else {
> +               rsc->da = dma;
> +               dev_dbg(dev, "carveout: %s va %p dma %x\n",
> +                                       rsc->name, va, rsc->da);

To simplify things, will the below work for you?

diff --git a/drivers/remoteproc/remoteproc_core.c
b/drivers/remoteproc/remoteproc_core.c
index c4d4a21..f03d074 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -713,23 +713,27 @@ static int rproc_handle_carveout(struct rproc *rproc,
 		list_add_tail(&mapping->node, &rproc->mappings);

 		dev_dbg(dev, "carveout mapped 0x%x to 0x%x\n", rsc->da, dma);
-
-		/*
-		 * Some remote processors might need to know the pa
-		 * even though they are behind an IOMMU. E.g., OMAP4's
-		 * remote M3 processor needs this so it can control
-		 * on-chip hardware accelerators that are not behind
-		 * the IOMMU, and therefor must know the pa.
-		 *
-		 * Generally we don't want to expose physical addresses
-		 * if we don't have to (remote processors are generally
-		 * _not_ trusted), so we might want to do this only for
-		 * remote processor that _must_ have this (e.g. OMAP4's
-		 * dual M3 subsystem).
-		 */
-		rsc->pa = dma;
 	}

+	/*
+	 * Some remote processors might need to know the pa
+	 * even though they are behind an IOMMU. E.g., OMAP4's
+	 * remote M3 processor needs this so it can control
+	 * on-chip hardware accelerators that are not behind
+	 * the IOMMU, and therefor must know the pa.
+	 *
+	 * Generally we don't want to expose physical addresses
+	 * if we don't have to (remote processors are generally
+	 * _not_ trusted), so we might want to do this only for
+	 * remote processor that _must_ have this (e.g. OMAP4's
+	 * dual M3 subsystem).
+	 *
+	 * Non-IOMMU processors might also want to have this info.
+	 * In this case, the device address and the physical address
+	 * are the same.
+	 */
+	rsc->pa = dma;
+
 	carveout->va = va;
 	carveout->len = rsc->len;
 	carveout->dma = dma;

Thanks,
Ohad.
