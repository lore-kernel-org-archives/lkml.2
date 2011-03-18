Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1CRRUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:20:21 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:41234 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab1CRRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:20:16 -0400
Message-ID: <4D838A25.8010301@iki.fi>
Date: Fri, 18 Mar 2011 18:36:53 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/16] [media] ec168: get rid of on stack dma buffers
References: <20110315093632.5fc9fb77@schatten.dmk.lab> <1300178655-24832-1-git-send-email-florian@mickler.org> <1300178655-24832-5-git-send-email-florian@mickler.org>
In-Reply-To: <1300178655-24832-5-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.4
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 10:43 AM, Florian Mickler wrote:
> usb_control_msg initiates (and waits for completion of) a dma transfer using
> the supplied buffer. That buffer thus has to be seperately allocated on
> the heap.
>
> In lib/dma_debug.c the function check_for_stack even warns about it:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
>
> Note: This change is tested to compile only, as I don't have the hardware.
>
> Signed-off-by: Florian Mickler<florian@mickler.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>

t. Antti

> ---
>   drivers/media/dvb/dvb-usb/ec168.c |   18 +++++++++++++++---
>   1 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/ec168.c b/drivers/media/dvb/dvb-usb/ec168.c
> index 52f5d4f..1ba3e5d 100644
> --- a/drivers/media/dvb/dvb-usb/ec168.c
> +++ b/drivers/media/dvb/dvb-usb/ec168.c
> @@ -36,7 +36,9 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
>   	int ret;
>   	unsigned int pipe;
>   	u8 request, requesttype;
> -	u8 buf[req->size];
> +	u8 *buf;
> +
> +
>
>   	switch (req->cmd) {
>   	case DOWNLOAD_FIRMWARE:
> @@ -72,6 +74,12 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
>   		goto error;
>   	}
>
> +	buf = kmalloc(req->size, GFP_KERNEL);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
>   	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_OUT)) {
>   		/* write */
>   		memcpy(buf, req->data, req->size);
> @@ -84,13 +92,13 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
>   	msleep(1); /* avoid I2C errors */
>
>   	ret = usb_control_msg(udev, pipe, request, requesttype, req->value,
> -		req->index, buf, sizeof(buf), EC168_USB_TIMEOUT);
> +		req->index, buf, req->size, EC168_USB_TIMEOUT);
>
>   	ec168_debug_dump(request, requesttype, req->value, req->index, buf,
>   		req->size, deb_xfer);
>
>   	if (ret<  0)
> -		goto error;
> +		goto err_dealloc;
>   	else
>   		ret = 0;
>
> @@ -98,7 +106,11 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
>   	if (!ret&&  requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
>   		memcpy(req->data, buf, req->size);
>
> +	kfree(buf);
>   	return ret;
> +
> +err_dealloc:
> +	kfree(buf);
>   error:
>   	deb_info("%s: failed:%d\n", __func__, ret);
>   	return ret;


-- 
http://palosaari.fi/
