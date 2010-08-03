Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0HCQOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:14:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37587 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0HCQOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xmqCo4XgYh20aMKbOfOBi3lyrYIY7Jb8IAqqFHYhh+nI6vz7tK2VGmEHgBKA0ETAvw
         bz1b3+yeCBVq6PHb3h3t4EkCLWrs2/yiloWNnJ4c589SHR3eJw1swM40nbs+IK6HU1qq
         Fr+r5h45sNc+6C1+0QwL2dXJBH8jAG1MiGyv0=
MIME-Version: 1.0
In-Reply-To: <1280850203-5532-1-git-send-email-segooon@gmail.com>
References: <1280850203-5532-1-git-send-email-segooon@gmail.com>
Date: Tue, 3 Aug 2010 18:14:11 +0200
Message-ID: <AANLkTinzvwP74oNaS+mWRnostnGrZZ-iY2SsjMzo=CW4@mail.gmail.com>
Subject: Re: [PATCH 06/11] rt2x00: do not use PCI resources before 
	pci_enable_device()
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Alban Browaeys <prahal@yahoo.com>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 5:43 PM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> IRQ and resource[] may not have correct values until
> after PCI hotplug setup occurs at pci_enable_device() time.
>
> The semantic match that finds this problem is as follows:
>
> // <smpl>
> @@
> identifier x;
> identifier request ~= "pci_request.*|pci_resource.*";
> @@
>
> (
> * x->irq
> |
> * x->resource
> |
> * request(x, ...)
> )
>  ...
> *pci_enable_device(x)
> // </smpl>
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Good catch.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00pci.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index 19b262e..63c2cc4 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -240,16 +240,16 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>        struct rt2x00_dev *rt2x00dev;
>        int retval;
>
> -       retval = pci_request_regions(pci_dev, pci_name(pci_dev));
> +       retval = pci_enable_device(pci_dev);
>        if (retval) {
> -               ERROR_PROBE("PCI request regions failed.\n");
> +               ERROR_PROBE("Enable device failed.\n");
>                return retval;
>        }
>
> -       retval = pci_enable_device(pci_dev);
> +       retval = pci_request_regions(pci_dev, pci_name(pci_dev));
>        if (retval) {
> -               ERROR_PROBE("Enable device failed.\n");
> -               goto exit_release_regions;
> +               ERROR_PROBE("PCI request regions failed.\n");
> +               goto exit_disable_device;
>        }
>
>        pci_set_master(pci_dev);
> @@ -260,14 +260,14 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>        if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
>                ERROR_PROBE("PCI DMA not supported.\n");
>                retval = -EIO;
> -               goto exit_disable_device;
> +               goto exit_release_regions;
>        }
>
>        hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
>        if (!hw) {
>                ERROR_PROBE("Failed to allocate hardware.\n");
>                retval = -ENOMEM;
> -               goto exit_disable_device;
> +               goto exit_release_regions;
>        }
>
>        pci_set_drvdata(pci_dev, hw);
> @@ -300,13 +300,12 @@ exit_free_reg:
>  exit_free_device:
>        ieee80211_free_hw(hw);
>
> -exit_disable_device:
> -       if (retval != -EBUSY)
> -               pci_disable_device(pci_dev);
> -
>  exit_release_regions:
>        pci_release_regions(pci_dev);
>
> +exit_disable_device:
> +       pci_disable_device(pci_dev);
> +
>        pci_set_drvdata(pci_dev, NULL);
>
>        return retval;
> --
> 1.7.0.4
>
>
