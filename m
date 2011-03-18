Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1CRRUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:20:12 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:37304 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab1CRRUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:20:07 -0400
X-Greylist: delayed 2700 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 13:20:07 EDT
Message-ID: <4D8389B2.60507@iki.fi>
Date: Fri, 18 Mar 2011 18:34:58 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 09/16] [media] au6610: get rid of on-stack dma buffer
References: <20110315093632.5fc9fb77@schatten.dmk.lab> <1300178655-24832-1-git-send-email-florian@mickler.org> <1300178655-24832-9-git-send-email-florian@mickler.org>
In-Reply-To: <1300178655-24832-9-git-send-email-florian@mickler.org>
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


This patch did not found from patchwork! Probably skipped due to broken 
Cc at my contact. Please resend.

Anyhow, I tested and reviewed it.

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>

[1] https://patchwork.kernel.org/project/linux-media/list/

Antti



> ---
>   drivers/media/dvb/dvb-usb/au6610.c |   22 ++++++++++++++++------
>   1 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
> index eb34cc3..2351077 100644
> --- a/drivers/media/dvb/dvb-usb/au6610.c
> +++ b/drivers/media/dvb/dvb-usb/au6610.c
> @@ -33,8 +33,16 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
>   {
>   	int ret;
>   	u16 index;
> -	u8 usb_buf[6]; /* enough for all known requests,
> -			  read returns 5 and write 6 bytes */
> +	u8 *usb_buf;
> +
> +	/*
> +	 * allocate enough for all known requests,
> +	 * read returns 5 and write 6 bytes
> +	 */
> +	usb_buf = kmalloc(6, GFP_KERNEL);
> +	if (!usb_buf)
> +		return -ENOMEM;
> +
>   	switch (wlen) {
>   	case 1:
>   		index = wbuf[0]<<  8;
> @@ -45,14 +53,15 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
>   		break;
>   	default:
>   		warn("wlen = %x, aborting.", wlen);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto error;
>   	}
>
>   	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), operation,
>   			      USB_TYPE_VENDOR|USB_DIR_IN, addr<<  1, index,
> -			      usb_buf, sizeof(usb_buf), AU6610_USB_TIMEOUT);
> +			      usb_buf, 6, AU6610_USB_TIMEOUT);
>   	if (ret<  0)
> -		return ret;
> +		goto error;
>
>   	switch (operation) {
>   	case AU6610_REQ_I2C_READ:
> @@ -60,7 +69,8 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
>   		/* requested value is always 5th byte in buffer */
>   		rbuf[0] = usb_buf[4];
>   	}
> -
> +error:
> +	kfree(usb_buf);
>   	return ret;
>   }
>


-- 
http://palosaari.fi/
