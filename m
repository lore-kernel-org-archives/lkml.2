Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1ATRhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:37:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37481 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1ATRhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:37:37 -0500
MIME-Version: 1.0
X-Originating-IP: [172.22.72.244]
In-Reply-To: <1294370641-6791-1-git-send-email-olof@lixom.net>
References: <1294370641-6791-1-git-send-email-olof@lixom.net>
Date: Thu, 20 Jan 2011 09:37:24 -0800
Message-ID: <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com>
Subject: Re: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm devices"
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, James Morris <jmorris@namei.org>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are all TPM maintainers MIA? This is a trivial patch that fixes a
panic, and it was a late-added regression in 2.6.37.


-Olof

On Thu, Jan 6, 2011 at 7:24 PM, Olof Johansson <olof@lixom.net> wrote:
> commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 adds a check for
> PNP device id to the common tpm_tis_init() function, which in some
> cases (force=1) will be called without the device being a member of
> a pnp_dev. Oopsing and panics ensue.
>
> Move the test up to before the call to tpm_tis_init(), since it
> just modifies a global variable anyway.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: stable@kernel.org [2.6.37+]
> ---
>  drivers/char/tpm/tpm_tis.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index c17a305..dd21df5 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -493,9 +493,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>                 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>                 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>
> -       if (is_itpm(to_pnp_dev(dev)))
> -               itpm = 1;
> -
>        if (itpm)
>                dev_info(dev, "Intel iTPM workaround enabled\n");
>
> @@ -637,6 +634,9 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>        else
>                interrupts = 0;
>
> +       if (is_itpm(pnp_dev))
> +               itpm = 1;
> +
>        return tpm_tis_init(&pnp_dev->dev, start, len, irq);
>  }
>
> --
> 1.7.3.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
