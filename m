Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2HXQ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:58:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35935 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2HXQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:58:24 -0400
Message-ID: <5037B2AC.50704@lwfinger.net>
Date: Fri, 24 Aug 2012 11:58:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, ncardwell@google.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
References: <50369925.3050705@lwfinger.net>  <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>  <20120824.111948.680531915905273128.davem@davemloft.net>  <5037A4B0.3080208@lwfinger.net>  <1345825095.19483.19.camel@edumazet-glaptop> <1345825432.19483.20.camel@edumazet-glaptop>
In-Reply-To: <1345825432.19483.20.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 11:23 AM, Eric Dumazet wrote:
> On Fri, 2012-08-24 at 18:18 +0200, Eric Dumazet wrote:
>> On Fri, 2012-08-24 at 10:58 -0500, Larry Finger wrote:
>>> On 08/24/2012 10:19 AM, David Miller wrote:
>>>>
>>>> This looks like full-on data corruption to me.
>>>
>>> I agree. The question is why does it happen with r8712u, and only after the
>>> commit in the subject. Drivers for other devices that I have are OK. Thus far, I
>>> have tested b43, rtl8187, ath9k_htc, and rtl8192cu. To my knowledge, there are
>>> no reports posted for this bug with any other device.
>>
>> bugs can sit unnoticed, and one change somewhere can uncover them.
>>
>> Really this driver must have a bug, if not half a dozen of bugs.
>>
>> For example this sequence of code is a clear bug :
>>
>> sub_skb = dev_alloc_skb(nSubframe_Length + 12);
>> skb_reserve(sub_skb, 12);
>>
>>
>> Also the free_recv_skb_queue looks really suspect to me
>>
>> What the hell is doing recv_tasklet() I really wonder.
>>
>> This code, combined with the skb_clone() in recvbuf2recvframe()
>> can clearly reuse an skb passed to upper stacks.
>>
>>
>> queueing one skb in free_recv_skb_queue should be done
>> only if no clone of this skb exist somewhere.
>>
>> Please someone fix this buggy driver.
>>
>
> Try the following patch for a start
>
> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
> index 8e82ce2..88e3ca6 100644
> --- a/drivers/staging/rtl8712/rtl8712_recv.c
> +++ b/drivers/staging/rtl8712/rtl8712_recv.c
> @@ -1127,6 +1127,9 @@ static void recv_tasklet(void *priv)
>   		recvbuf2recvframe(padapter, pskb);
>   		skb_reset_tail_pointer(pskb);
>   		pskb->len = 0;
> -		skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
> +		if (!skb_cloned(pskb))
> +			skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
> +		else
> +			consume_skb(pskb);
>   	}
>   }

This one did not help. There is no doubt it is needed for the case where memory 
is tight, an allocation fails, and the driver clones the skb. In the present 
case, debug statements have shown that the skb_clone() call was not made.

In the long term, this driver will be replaced with one that uses mac80211, but 
in the short term, I am trying to fix it.

As I said earlier, my skb skills are minimal. Could you explain what is wrong 
with the following sequence?

  sub_skb = dev_alloc_skb(nSubframe_Length + 12);
  skb_reserve(sub_skb, 12);

Thanks,

Larry


