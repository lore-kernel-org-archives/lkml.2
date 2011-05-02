Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1EBVEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:04:43 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:17826 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EBVEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:04:41 -0400
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
From: Ben Hutchings <bhutchings@solarflare.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
        davem@davemloft.net, pmcenery@gmail.com, david.hill@ubisoft.com,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
In-Reply-To: <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
References: <1304264799.2833.82.camel@localhost>
	 <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Mon, 02 May 2011 22:04:34 +0100
Message-ID: <1304370274.2833.192.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 May 2011 21:04:40.0324 (UTC) FILETIME=[8D631440:01CC090C]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18110.005
X-TM-AS-Result: No--10.837500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 21:35 +0200, L. Alberto Giménez wrote:
> Since commit ea812ca1b06113597adcd8e70c0f84a413d97544 (x86: Align skb w/ start
> of cacheline on newer core 2/Xeon Arch), NET_IP_ALIGN changed from 2 to 0, and
> the constant is used to reserve more room for the socket buffer.
> 
> Some people have reported that tethering stopped working and David Hill
> submited a patch that redefined NET_IP_ALIGN. Pointed by Ben Hutchings, the
> patch has been reworked to use a private constant.
> 
> I have no more an iPhone device to test it, so it is only compile-tested.
> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> ---
>  drivers/net/usb/ipheth.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index 7d42f9a..8f1ffc7 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -80,6 +80,8 @@
>  #define IPHETH_CARRIER_CHECK_TIMEOUT round_jiffies_relative(1 * HZ)
>  #define IPHETH_CARRIER_ON       0x04
>  
> +#define IPHETH_IP_ALIGN 2
> +
>  static struct usb_device_id ipheth_table[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(
>  		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE,
> @@ -205,15 +207,15 @@ static void ipheth_rcvbulk_callback(struct urb *urb)
>  	len = urb->actual_length;
>  	buf = urb->transfer_buffer;
>  
> -	skb = dev_alloc_skb(NET_IP_ALIGN + len);
> +	skb = dev_alloc_skb(IPHETH_IP_ALIGN + len);
>  	if (!skb) {
>  		err("%s: dev_alloc_skb: -ENOMEM", __func__);
>  		dev->net->stats.rx_dropped++;
>  		return;
>  	}
>  
> -	skb_reserve(skb, NET_IP_ALIGN);
> -	memcpy(skb_put(skb, len), buf + NET_IP_ALIGN, len - NET_IP_ALIGN);
> +	skb_reserve(skb, IPHETH_IP_ALIGN);
> +	memcpy(skb_put(skb, len), buf + IPHETH_IP_ALIGN, len - IPHETH_IP_ALIGN);
[...]

So this was using NET_IP_ALIGN as an offset into the URB.  Which was
totally bogus, as its value has long been architecture-dependent.  The
code is also claiming to put len bytes but only copying len - delta.

The correct code would be something like:

	if (urb->actual_length <= IPHETH_IP_ALIGN) {
		dev->net->stats.rx_length_errors++;
		return;
	}
	len = urb->actual_length - IPHETH_IP_ALIGN;
	buf = urb->transfer_buffer + IPHETH_IP_ALIGN;
	
	dev_alloc_skb(len);
	...
	memcpy(skb_put(skb, len), buf, len);

Ben.

>  	skb->dev = dev->net;
>  	skb->protocol = eth_type_trans(skb, dev->net);
>  

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

