Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2CLEgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:36:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28057 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2CLEga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:36:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="169235493"
X-IronPort-AV: E=Sophos;i="4.73,568,1325491200"; 
   d="scan'208";a="175923519"
Message-ID: <4F5D7D47.102@qca.qualcomm.com>
Date: Mon, 12 Mar 2012 10:06:23 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Willy Tarreau <w@1wt.eu>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
References: <20120312002046.282831520@1wt.eu> <1331517472.3022.150.camel@deadeye>
In-Reply-To: <1331517472.3022.150.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Monday 12 March 2012 07:27 AM, Ben Hutchings wrote:
> On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
>> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> commit 8617b093d0031837a7be9b32bc674580cfb5f6b5 upstream.
>>
>> rate control algorithms concludes the rate as invalid
>> with rate[i].idx<  -1 , while they do also check for rate[i].count is
>> non-zero. it would be safer to zero initialize the 'count' field.
>> recently we had a ath9k rate control crash where the ath9k rate control
>> in ath_tx_status assumed to check only for rate[i].count being non-zero
>> in one instance and ended up in using invalid rate index for
>> 'connection monitoring NULL func frames' which eventually lead to the crash.
>> thanks to Pavel Roskin for fixing it and finding the root cause.
>> https://bugzilla.redhat.com/show_bug.cgi?id=768639
>
> In 2.6.32, ath_tx_status() checks that rates[i].idx>= 0, so it properly
> ignores these dummy entries.  Further, there is code further down the
> rate_control_get_rate() function that sets .idx only and appears to
> depend on the initialisation of .count = 1.
>
> So I'm pretty sure this patch is wrong for 2.6.32; it could be
> backported but I don't think the change is necessary anyway.

true, but i think its better to initialize the count = 0 rather than 
count = 1, though the older version driver checks for rate[i].idx >= 0 
in ath_rc_tx_status. while the ath_tx_status has no such iteration in 
the older driver code.

>
> Ben.
>
>> Cc: stable@vger.kernel.org
>> Cc: Pavel Roskin<proski@gnu.org>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> Signed-off-by: John W. Linville<linville@tuxdriver.com>
>>
>> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
>> index ad64f4d..f9b8e81 100644
>> --- a/net/mac80211/rate.c
>> +++ b/net/mac80211/rate.c
>> @@ -344,7 +344,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
>>   	for (i = 0; i<  IEEE80211_TX_MAX_RATES; i++) {
>>   		info->control.rates[i].idx = -1;
>>   		info->control.rates[i].flags = 0;
>> -		info->control.rates[i].count = 1;
>> +		info->control.rates[i].count = 0;
>>   	}
>>
>>   	if (sdata->local->hw.flags&  IEEE80211_HW_HAS_RATE_CONTROL)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe stable" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>


-- 
thanks,
shafi
