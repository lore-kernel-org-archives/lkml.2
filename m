Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2HWI2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:28:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40098 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2HWI2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:28:07 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 16:28:05 +0800
Message-ID: <CAPgLHd_G18O634x1JZNQCHDK4es2DgqHnQuU7jQhKzjy5iEuBA@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192e: use is_zero_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.dumazet@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 03:54 PM, Eric Dumazet wrote:
> On Thu, 2012-08-23 at 15:19 +0800, Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Using is_zero_ether_addr() instead of directly use
>> memcmp() to determine if the ethernet address is all
>> zeros.
>>
>> spatch with a semantic match is used to found this problem.
>> (http://coccinelle.lip6.fr/)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/staging/rtl8192e/rtllib_softmac_wx.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
>> index 1bb6b52..3cedfd9 100644
>> --- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
>> +++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
>> @@ -14,6 +14,8 @@
>>   */
>>  
>>
>> +#include <linux/etherdevice.h>
>> +
>>  #include "rtllib.h"
>>  #include "dot11d.h"
>>  /* FIXME: add A freqs */
>> @@ -137,7 +139,6 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>>  {
>>  
>>  	int ret = 0;
>> -	u8 zero[] = {0, 0, 0, 0, 0, 0};
>>  	unsigned long flags;
>>  
>>  	short ifup = ieee->proto_started;
>> @@ -157,7 +158,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>>  		goto out;
>>  	}
>>  
>> -	if (memcmp(temp->sa_data, zero, ETH_ALEN) == 0) {
>> +	if (is_zero_ether_addr(temp->sa_data)) {
>>  		spin_lock_irqsave(&ieee->lock, flags);
>>  		memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
> BTW this looks suspicious : Why is it using memcpy() if temp->sa_data is
> known to be zero ?

I see the if (..) is dup of the following memcpy() code, just
used for return -1 for fast path.

rtl8192u does not has this check, and also do memcpy()
temp->sa_data to bssid even if is zero addr.

>
>>  		ieee->wap_set = 0;
>> @@ -177,7 +178,7 @@ int rtllib_wx_set_wap(struct rtllib_device *ieee,
>>  
>>  	ieee->cannot_notify = false;
>>  	memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
>> -	ieee->wap_set = (memcmp(temp->sa_data, zero, ETH_ALEN) != 0);
>> +	ieee->wap_set = (!is_zero_ether_addr(temp->sa_data));
>>  
> 	ieee->wap_set = !is_zero_ether_addr(temp->sa_data);

I will fix this and send the new patch.

>
>>  	spin_unlock_irqrestore(&ieee->lock, flags);
>>  
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>


