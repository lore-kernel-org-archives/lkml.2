Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2EaF6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2EaF6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:58:42 -0400
Message-ID: <4FC708EE.2020908@redhat.com>
Date: Thu, 31 May 2012 14:00:14 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] net: sock: validate data_len before allocating skb in
 sock_alloc_send_pskb()
References: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com> <1338360383.2760.84.camel@edumazet-glaptop> <20120530.030205.1337682162603770949.davem@davemloft.net>
In-Reply-To: <20120530.030205.1337682162603770949.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:02 PM, David Miller wrote:
> From: Eric Dumazet<eric.dumazet@gmail.com>
> Date: Wed, 30 May 2012 08:46:23 +0200
>
>> Why doing this test in the while (1) block, it should be done before the
>> loop...
>>
>> Or even in the caller, note net/unix/af_unix.c does this right.
>>
>>          if (len>  SKB_MAX_ALLOC)
>>                  data_len = min_t(size_t,
>>                                   len - SKB_MAX_ALLOC,
>>                                   MAX_SKB_FRAGS * PAGE_SIZE);
>>
>>          skb = sock_alloc_send_pskb(sk, len - data_len, data_len,
>>                                     msg->msg_flags&  MSG_DONTWAIT,&err);
> My impression is that the callers should be fixed to.  It makes no sense
> to penalize the call sites that get this right.
>
> And yes, if we do check it in sock_alloc_send_pskb() it should be done
> at function entry, not inside the loop.

Sure, so is it ok for me to send a V2 that just do the fixing in 
sock_alloc_sned_pskb() as it's simple and easy to be accepted by stable 
version?

For the fix of callers, I want to post fixes on top as I find there's 
some code duplication of {tun|macvtap|packet}_alloc_skb() and I want to 
unify them to a common helper in sock.c. Then I can fix this issue in 
the new helper.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

