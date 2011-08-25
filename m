Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1HYKwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:52:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1HYKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:52:32 -0400
Message-ID: <4E562947.3000304@ru.mvista.com>
Date: Thu, 25 Aug 2011 14:51:51 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Adam Cozzette <acozzette@cs.hmc.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>,
        edwin_rong <edwin_rong@realsil.com.cn>,
        wwang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] ums_realtek: do not use stack memory for DMA
References: <20110824182237.GC5450@[192.168.0.12]>
In-Reply-To: <20110824182237.GC5450@[192.168.0.12]>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-08-2011 22:22, Adam Cozzette wrote:

> This patch changes rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
> allocate temporary buffers with kmalloc. This way stack addresses are not used
> for DMA when these functions call rts51x_bulk_transport.

> Signed-off-by: Adam Cozzette<acozzette@cs.hmc.edu>
> ---
>   realtek_cr.c |   35 ++++++++++++++++++++++++++++++-----
>   1 file changed, 30 insertions(+), 5 deletions(-)

> diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
> index 34adc4b..232167a 100644
> --- a/drivers/usb/storage/realtek_cr.c
> +++ b/drivers/usb/storage/realtek_cr.c
[...]
> @@ -342,6 +351,12 @@ static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
>   {
>   	int retval;
>   	u8 cmnd[12] = { 0 };
> +	u8 *buf;
> +
> +	buf = kmalloc(len, GFP_NOIO);
> +	if (buf == NULL)
> +		return USB_STOR_TRANSPORT_ERROR;
> +	memcpy(buf, data, len);

    You could use kmemdup() instead of kmalloc()/memcpy()...

WBR, Sergei
