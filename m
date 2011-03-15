Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1COVCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:02:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39347 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab1COVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=riFtPIupWyOvWmKeYtTIVLUyinDb/CPHCEicWCtqMIk0pfhbrow67017BiZJogQyNq
         pe4GF0067Z+ba4fwJ/vb8KODbmotaEueOjHx/tMfaFfNK6W1mn9BnweXKwoDkWrcIpkE
         cZwlJFzaBF2X1k/7C4Jfns7oqeR72Xx8lqEZE=
Subject: Re: [PATCH 12/16] [media] lmedm04: get rid of on-stack dma buffers
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
In-Reply-To: <1300178655-24832-12-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	 <1300178655-24832-1-git-send-email-florian@mickler.org>
	 <1300178655-24832-12-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 20:54:43 +0000
Message-ID: <1300222483.1910.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch failed for the following reason.

On Tue, 2011-03-15 at 09:43 +0100, Florian Mickler wrote:
> usb_control_msg initiates (and waits for completion of) a dma transfer using
> the supplied buffer. That buffer thus has to be seperately allocated on
> the heap.
> 
> In lib/dma_debug.c the function check_for_stack even warns about it:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
> 
> Note: This change is tested to compile only, as I don't have the hardware.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  drivers/media/dvb/dvb-usb/lmedm04.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index 0a3e88f..bec5439 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -314,12 +314,17 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
>  static int lme2510_return_status(struct usb_device *dev)
>  {
>  	int ret = 0;
> -	u8 data[10] = {0};
> +	u8 *data;
> +
> +	data = kzalloc(10, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
>  
>  	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
>  			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
>  	info("Firmware Status: %x (%x)", ret , data[2]);
>  
> +	kfree(data);
>  	return (ret < 0) ? -ENODEV : data[2];

data has been killed off when we need the buffer contents.
changing to the following fixed.

	ret = (ret < 0) ? -ENODEV : data[2];

	kfree(data);

	return ret;


> @@ -603,7 +608,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
>  					const struct firmware *fw)
>  {
>  	int ret = 0;
> -	u8 data[512] = {0};
> +	u8 *data;
>  	u16 j, wlen, len_in, start, end;
>  	u8 packet_size, dlen, i;
>  	u8 *fw_data;
> @@ -611,6 +616,11 @@ static int lme2510_download_firmware(struct usb_device *dev,
>  	packet_size = 0x31;
>  	len_in = 1;
>  
> +	data = kzalloc(512, GFP_KERNEL);
> +	if (!data) {
> +		info("FRM Could not start Firmware Download (Buffer allocation failed)");

Longer than 80 characters, 

> +		return -ENOMEM;
> +	}
>  
>  	info("FRM Starting Firmware Download");
>  
> @@ -654,7 +664,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
>  	else
>  		info("FRM Firmware Download Completed - Resetting Device");
>  
> -
> +	kfree(data);
>  	return (ret < 0) ? -ENODEV : 0;
>  }
>  

Otherwise the patch as corrected has been put on test. No initial
problems have been encountered.

Regards 

Malcolm



