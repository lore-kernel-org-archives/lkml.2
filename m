Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0KUOIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:08:46 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62277 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0KUOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:08:45 -0500
Message-ID: <4CE9277D.9050505@ru.mvista.com>
Date: Sun, 21 Nov 2010 17:06:53 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jan Dumon <j.dumon@option.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/62] usb: Use static const
References: <cover.1290305773.git.joe@perches.com> <ed2a5bd07f07601ba12ce3c8fcbce2dd954c35aa.1290305776.git.joe@perches.com>
In-Reply-To: <ed2a5bd07f07601ba12ce3c8fcbce2dd954c35aa.1290305776.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-11-2010 5:38, Joe Perches wrote:

> Using static const generally increases object text and decreases data size.
> It also generally decreases overall object size.

>     text	   data	    bss	    dec	    hex	filename
>    36120	    312	   9000	  45432	   b178	drivers/net/usb/hso.o.old
>    36043	    312	   9008	  45363	   b133	drivers/net/usb/hso.o.new

> Consolidate duplicated code into new fix_crc_bug function
> and declare data in that function static const.

> Signed-off-by: Joe Perches<joe@perches.com>
[...]

> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index be8cc2a..c77d0ea 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -1001,6 +1001,18 @@ static void packetizeRx(struct hso_net *odev, unsigned char *ip_pkt,
>   	}
>   }
>
> +static void fix_crc_bug(struct urb *urb, __le16 max_packet_size)
> +{
> +	static const u8 crc_check[4] = { 0xDE, 0xAD, 0xBE, 0xEF };
> +	u32 rest = urb->actual_length % le16_to_cpu(max_packet_size);
> +
> +	if (((rest == 5) || (rest == 6)) &&
> +	    !memcmp(((u8 *)urb->transfer_buffer) + urb->actual_length - 4,

    Parens around '(u8 *)urb->transfer_buffer' not needed. Could get rid of 
them, while at it...

> +		    crc_check, 4)) {
> +		urb->actual_length -= 4;
> +	}
> +}
> +
>   /* Moving data from usb to kernel (in interrupt state) */
>   static void read_bulk_callback(struct urb *urb)
>   {

WBR, Sergei
