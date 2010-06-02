Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab0FBVzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:55:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35255 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab0FBVzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i/85EPTQ2ouUPNfmSTBsTMGoDIlCgT15ul9dbtkryxU7mG2Ui95hBDb2RCmB+3xe67
         ZZUINcbFpfmykX4rq7kVbLTEbwNx2w0JwFjTGgVBPEj4aYTzh5rKdcUkqJtag3V+OC6Z
         qKb66dAO8u53o55huIOYA/GPO3Csm/Y4duPUE=
MIME-Version: 1.0
In-Reply-To: <19462.12578.143627.398866@gargle.gargle.HOWL>
References: <19462.12578.143627.398866@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Jun 2010 14:54:46 -0700
Message-ID: <AANLkTiky9UF-aqeZCFleOFSIVw3vDiYbLUdTkkYEWN2B@mail.gmail.com>
Subject: Re: [PATCH 1/8] ath9k: Determine Firmware on probe
To: Sujith <Sujith.Manoharan@atheros.com>,
       Marcel Holtmann <marcel@holtmann.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 3:23 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Do not assign the FW name to driver_info but determine
> it dynamically on device probe. This facilitates adding new
> firmware.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |   39 ++++++++++++++++++++----------
>  drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
>  2 files changed, 27 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 77b3591..7da55eb 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -16,12 +16,9 @@
>
>  #include "htc.h"
>
> -#define ATH9K_FW_USB_DEV(devid, fw)                                    \
> -       { USB_DEVICE(0x0cf3, devid), .driver_info = (unsigned long) fw }
> -
>  static struct usb_device_id ath9k_hif_usb_ids[] = {
> -       ATH9K_FW_USB_DEV(0x9271, "ar9271.fw"),
> -       ATH9K_FW_USB_DEV(0x1006, "ar9271.fw"),
> +       { USB_DEVICE(0x0cf3, 0x9271) },
> +       { USB_DEVICE(0x0cf3, 0x1006) },
>        { },
>  };
>
> @@ -790,21 +787,21 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>                return -EIO;
>
>        dev_info(&hif_dev->udev->dev, "ath9k_htc: Transferred FW: %s, size: %ld\n",
> -                "ar9271.fw", (unsigned long) hif_dev->firmware->size);
> +                hif_dev->fw_name, (unsigned long) hif_dev->firmware->size);
>
>        return 0;
>  }
>
> -static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
> -                                 const char *fw_name)
> +static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
>  {
>        int ret;
>
>        /* Request firmware */
> -       ret = request_firmware(&hif_dev->firmware, fw_name, &hif_dev->udev->dev);
> +       ret = request_firmware(&hif_dev->firmware, hif_dev->fw_name,
> +                              &hif_dev->udev->dev);
>        if (ret) {
>                dev_err(&hif_dev->udev->dev,
> -                       "ath9k_htc: Firmware - %s not found\n", fw_name);
> +                       "ath9k_htc: Firmware - %s not found\n", hif_dev->fw_name);
>                goto err_fw_req;
>        }
>
> @@ -820,7 +817,8 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev,
>        ret = ath9k_hif_usb_download_fw(hif_dev);
>        if (ret) {
>                dev_err(&hif_dev->udev->dev,
> -                       "ath9k_htc: Firmware - %s download failed\n", fw_name);
> +                       "ath9k_htc: Firmware - %s download failed\n",
> +                       hif_dev->fw_name);
>                goto err_fw_download;
>        }
>
> @@ -847,7 +845,6 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>  {
>        struct usb_device *udev = interface_to_usbdev(interface);
>        struct hif_device_usb *hif_dev;
> -       const char *fw_name = (const char *) id->driver_info;
>        int ret = 0;
>
>        hif_dev = kzalloc(sizeof(struct hif_device_usb), GFP_KERNEL);
> @@ -872,7 +869,23 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>                goto err_htc_hw_alloc;
>        }
>
> -       ret = ath9k_hif_usb_dev_init(hif_dev, fw_name);
> +       /* Find out which firmware to load */
> +
> +       switch(hif_dev->device_id) {
> +       case 0x9271:
> +       case 0x1006:
> +               hif_dev->fw_name = "ar9271.fw";
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       if (!hif_dev->fw_name) {
> +               dev_err(&udev->dev, "Can't determine firmware !\n");
> +               goto err_htc_hw_alloc;
> +       }
> +
> +       ret = ath9k_hif_usb_dev_init(hif_dev);
>        if (ret) {
>                ret = -EINVAL;
>                goto err_hif_init_usb;
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
> index 0aca49b..b2647e8 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -90,6 +90,7 @@ struct hif_device_usb {
>        struct usb_anchor regout_submitted;
>        struct usb_anchor rx_submitted;
>        struct sk_buff *remain_skb;
> +       const char *fw_name;
>        int rx_remain_len;
>        int rx_pkt_len;
>        int rx_transfer_len;

I had done some something similar for ar9170 a while back [1] when
adding AVM FRITZ support to ar9170 and then got complaints from Marcel
on this approach since it requires synching the PCI device IDs in two
places. I frankly don't care how we do this but we should try to at
least stick to one way of doing this.

[1] http://osdir.com/ml/linux-wireless/2009-05/msg01219.html

  Luis
