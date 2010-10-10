Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab0JJKzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:55:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55581 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0JJKzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:55:05 -0400
Message-ID: <4CB19B1F.9000300@ru.mvista.com>
Date: Sun, 10 Oct 2010 14:53:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Alon Ziv <alon+git@nolaviz.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add Opticon OPN2001 write support
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org> <1286692340-18639-3-git-send-email-alon-git@nolaviz.org>
In-Reply-To: <1286692340-18639-3-git-send-email-alon-git@nolaviz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-10-2010 10:32, Alon Ziv wrote:

> OPN2001 expects write operations to arrive as a vendor-specific command
> through the control pipe (instead of using a separate bulk-out pipe).

> Signed-off-by: Alon Ziv<alon-git@nolaviz.org>
> ---
>   drivers/usb/serial/opticon.c |   30 ++++++++++++++++++++++++++----
>   1 files changed, 26 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
> index 9ff19c8..4fe7c3d 100644
> --- a/drivers/usb/serial/opticon.c
> +++ b/drivers/usb/serial/opticon.c
[...]
> @@ -237,10 +240,29 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
>
>   	usb_serial_debug_data(debug,&port->dev, __func__, count, buffer);
>
> -	usb_fill_bulk_urb(urb, serial->dev,
> -			  usb_sndbulkpipe(serial->dev,
> -					  port->bulk_out_endpointAddress),
> -			  buffer, count, opticon_write_bulk_callback, priv);
> +	if (port->bulk_out_endpointAddress) {
> +		usb_fill_bulk_urb(urb, serial->dev,
> +				  usb_sndbulkpipe(serial->dev,
> +						  port->bulk_out_endpointAddress),
> +				  buffer, count, opticon_write_bulk_callback, priv);

    Please align all follow-up lines uniformly.

> +	} else {
> +		struct usb_ctrlrequest *dr;
> +
> +		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);

    sizeof(*dr) is a preferred form.

> +		usb_fill_control_urb(urb, serial->dev,
> +			usb_sndctrlpipe(serial->dev, 0),
> +			(unsigned char *)dr, buffer, count,
> +			opticon_write_bulk_callback, priv);

    More tabs needed for alignment, I think...

WBR, Sergei
