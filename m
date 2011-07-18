Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1GROCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:02:53 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44862 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1GROCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:02:52 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzHuK79
X-RZG-CLASS-ID: mo00
Message-ID: <4E243D09.9020800@hartkopp.net>
Date: Mon, 18 Jul 2011 16:02:49 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH] net: can: remove custom hex_to_bin()
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.2011 10:26, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

> ---
>  drivers/net/can/slcan.c |   26 +++++---------------------
>  1 files changed, 5 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index aa8ad73..65e54fd 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -56,6 +56,7 @@
>  #include <linux/sched.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
>  #include <linux/can.h>
>  
>  static __initdata const char banner[] =
> @@ -142,21 +143,6 @@ static struct net_device **slcan_devs;
>    *			STANDARD SLCAN DECAPSULATION			 *
>    ************************************************************************/
>  
> -static int asc2nibble(char c)
> -{
> -
> -	if ((c >= '0') && (c <= '9'))
> -		return c - '0';
> -
> -	if ((c >= 'A') && (c <= 'F'))
> -		return c - 'A' + 10;
> -
> -	if ((c >= 'a') && (c <= 'f'))
> -		return c - 'a' + 10;
> -
> -	return 16; /* error */
> -}
> -
>  /* Send one completely decapsulated can_frame to the network layer */
>  static void slc_bump(struct slcan *sl)
>  {
> @@ -195,18 +181,16 @@ static void slc_bump(struct slcan *sl)
>  	*(u64 *) (&cf.data) = 0; /* clear payload */
>  
>  	for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
> -
> -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> -		if (tmp > 0x0F)
> +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> +		if (tmp < 0)
>  			return;
>  		cf.data[i] = (tmp << 4);
> -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> -		if (tmp > 0x0F)
> +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> +		if (tmp < 0)
>  			return;
>  		cf.data[i] |= tmp;
>  	}
>  
> -
>  	skb = dev_alloc_skb(sizeof(struct can_frame));
>  	if (!skb)
>  		return;

