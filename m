Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878Ab0HLVih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:38:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41051 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab0HLVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RmSVORAa21O1PMtxsPQ4TbQAEIXldgDWs5/o5dA6V4YIbtNk2DmR3DO83aqQeXD9a7
         D77hSN/lsGFFUeWaYUCO5Ez40qOcdf8JTNZOkznjBGwze50+3Iuu2PauAYzQo5dMFrmg
         TbrDkoQlzvFPW6vGfrZf/E28G7We/B36jCD0Q=
MIME-Version: 1.0
In-Reply-To: <201008102300.o7AN0WQA000440@hera.kernel.org>
References: <201008102300.o7AN0WQA000440@hera.kernel.org>
Date: Thu, 12 Aug 2010 23:38:32 +0200
X-Google-Sender-Auth: jpBlFmNWUgV6631o9QbszOG7xgc
Message-ID: <AANLkTinrtjD-VKhS03OOuxxyf0hTLFZ3uQQPL=siARoQ@mail.gmail.com>
Subject: Re: USB: EHCI Debug Port Device Gadget
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: stephane duverger <stephane.duverger@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7CLclgi013879

On Wed, Aug 11, 2010 at 01:00, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/f6c826a90055dd05905982f7a3f60e0bcaa0434e

>    USB: EHCI Debug Port Device Gadget

> diff --git a/drivers/usb/gadget/dbgp.c b/drivers/usb/gadget/dbgp.c
> new file mode 100644
> index 0000000..0ed50a2
> --- /dev/null
> +++ b/drivers/usb/gadget/dbgp.c

> +static int dbgp_setup(struct usb_gadget *gadget,
> +                     const struct usb_ctrlrequest *ctrl)
> +{
> +       struct usb_request *req = dbgp.req;
> +       u8 request = ctrl->bRequest;
> +       u16 value = le16_to_cpu(ctrl->wValue);
> +       u16 length = le16_to_cpu(ctrl->wLength);
> +       int err = 0;
> +       void *data;
> +       u16 len;
> +
> +       gadget->ep0->driver_data = gadget;
> +
> +       if (request == USB_REQ_GET_DESCRIPTOR) {
> +               switch (value>>8) {
> +               case USB_DT_DEVICE:
> +                       dev_dbg(&dbgp.gadget->dev, "setup: desc device\n");
> +                       len = sizeof device_desc;
> +                       data = &device_desc;
> +                       break;
> +               case USB_DT_DEBUG:
> +                       dev_dbg(&dbgp.gadget->dev, "setup: desc debug\n");
> +                       len = sizeof dbg_desc;
> +                       data = &dbg_desc;
> +                       break;
> +               default:
> +                       goto fail;
> +               }
> +       } else if (request == USB_REQ_SET_FEATURE &&
> +                  value == USB_DEVICE_DEBUG_MODE) {
> +               len = 0;
> +               data = NULL;
> +               dev_dbg(&dbgp.gadget->dev, "setup: feat debug\n");
> +#ifdef CONFIG_USB_G_DBGP_PRINTK
> +               err = dbgp_enable_ep();
> +#else
> +               err = gserial_connect(dbgp.serial, 0);
> +#endif
> +               if (err < 0)
> +                       goto fail;
> +       } else
> +               goto fail;
> +
> +       if (len >= 0) {

warning: comparison is always true due to limited range of data type

len is u16. Perhaps the test was intended to be `(len > 0)'?

> +               req->length = min(length, len);
> +               req->zero = len < req->length;
> +               if (data && req->length)
> +                       memcpy(req->buf, data, req->length);
> +
> +               req->complete = dbgp_setup_complete;
> +               return usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
> +       }
> +
> +fail:
> +       dev_dbg(&dbgp.gadget->dev,
> +               "setup: failure req %x v %x\n", request, value);
> +       return err;
> +}
> +
> +static struct usb_gadget_driver dbgp_driver = {
> +       .function = "dbgp",
> +       .speed = USB_SPEED_HIGH,
> +       .bind = dbgp_bind,
> +       .unbind = dbgp_unbind,
> +       .setup = dbgp_setup,
> +       .disconnect = dbgp_disconnect,
> +       .driver = {
> +               .owner = THIS_MODULE,
> +               .name = "dbgp"
> +       },
> +};
> +
> +static int __init dbgp_init(void)
> +{
> +       return usb_gadget_register_driver(&dbgp_driver);
> +}
> +
> +static void __exit dbgp_exit(void)
> +{
> +       usb_gadget_unregister_driver(&dbgp_driver);
> +#ifdef CONFIG_USB_G_DBGP_SERIAL
> +       gserial_cleanup();
> +#endif
> +}
> +
> +MODULE_AUTHOR("Stephane Duverger");
> +MODULE_LICENSE("GPL");
> +module_init(dbgp_init);
> +module_exit(dbgp_exit);
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
