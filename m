Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab2HWHyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:54:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51715 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab2HWHyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:54:09 -0400
Subject: Re: [PATCH] staging: rtl8192e: use is_zero_ether_addr() instead of
 memcmp()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd-VLPp-tpF77tTc9aj8-VO30jy2yhsi7KyW_NFQOqNqag@mail.gmail.com>
References: <CAPgLHd-VLPp-tpF77tTc9aj8-VO30jy2yhsi7KyW_NFQOqNqag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 09:54:03 +0200
Message-ID: <1345708443.5904.186.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 15:19 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/rtl8192e/rtllib_softmac_wx.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
> index 1bb6b52..3cedfd9 100644
> --- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
> +++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
> @@ -14,6 +14,8 @@
>   */
>  
> 
> +#include <linux/etherdevice.h>
> +
>  #include "rtllib.h"
>  #include "dot11d.h"
>  /* FIXME: add A freqs */
> @@ -137,7 +139,6 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>  {
>  
>  	int ret = 0;
> -	u8 zero[] = {0, 0, 0, 0, 0, 0};
>  	unsigned long flags;
>  
>  	short ifup = ieee->proto_started;
> @@ -157,7 +158,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>  		goto out;
>  	}
>  
> -	if (memcmp(temp->sa_data, zero, ETH_ALEN) == 0) {
> +	if (is_zero_ether_addr(temp->sa_data)) {
>  		spin_lock_irqsave(&ieee->lock, flags);
>  		memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);

BTW this looks suspicious : Why is it using memcpy() if temp->sa_data is
known to be zero ?

>  		ieee->wap_set = 0;
> @@ -177,7 +178,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>  
>  	ieee->cannot_notify = false;
>  	memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
> -	ieee->wap_set = (memcmp(temp->sa_data, zero, ETH_ALEN) != 0);
> +	ieee->wap_set = (!is_zero_ether_addr(temp->sa_data));
>  
	ieee->wap_set = !is_zero_ether_addr(temp->sa_data);

>  	spin_unlock_irqrestore(&ieee->lock, flags);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


