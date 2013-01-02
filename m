Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3ABE5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 23:57:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55516 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3ABE5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:57:13 -0500
Message-ID: <50E3BE23.3010102@lwfinger.net>
Date: Tue, 01 Jan 2013 22:57:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix skb leaks
References: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net> <20707.47067.474241.813195@gargle.gargle.HOWL>
In-Reply-To: <20707.47067.474241.813195@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 10:30 PM, Sujith Manoharan wrote:
> Larry Finger wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> index 4a9570d..a304748 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> @@ -278,10 +278,12 @@ int htc_connect_service(struct htc_target *target,
>>   	if (!time_left) {
>>   		dev_err(target->dev, "Service connection timeout for: %d\n",
>>   			service_connreq->service_id);
>> -		return -ETIMEDOUT;
>> +		ret = -ETIMEDOUT;
>> +		goto err;
>>   	}
>>
>>   	*conn_rsp_epid = target->conn_rsp_epid;
>> +	kfree_skb(skb);
>>   	return 0;
>>   err:
>>   	kfree_skb(skb);
> ath9k_htc_txcompletion_cb()
> The allocated skb should be freed in the TX completion hander,
> ath9k_htc_txcompletion_cb() - doing it in htc_connect_service() is wrong, I think.

My only counter argument is that none of the other paths that get to 
ath9k_htc_txcompletion_cb() leak the skb. It only happens for the path that goes 
through htc_connect_service().

Larry

