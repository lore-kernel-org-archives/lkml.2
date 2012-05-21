Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2EUGFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:05:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2EUGFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:05:35 -0400
Message-ID: <4FB9DB24.2040408@redhat.com>
Date: Mon, 21 May 2012 14:05:24 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1337100630.8220.4.camel@oc3660625478.ibm.com> <4FB317C8.90002@redhat.com>  <1337181027.10741.13.camel@oc3660625478.ibm.com>  <20120516151444.GC9934@redhat.com>  <1337189525.10741.24.camel@oc3660625478.ibm.com>  <4FB4677A.8020402@redhat.com>  <1337268862.10741.58.camel@oc3660625478.ibm.com>  <4FB61D57.4030103@redhat.com> <1337354974.12999.12.camel@oc3660625478.ibm.com>
In-Reply-To: <1337354974.12999.12.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 11:29 PM, Shirley Ma wrote:
> On Fri, 2012-05-18 at 17:58 +0800, Jason Wang wrote:
>> On 05/17/2012 11:34 PM, Shirley Ma wrote:
>>> On Thu, 2012-05-17 at 10:50 +0800, Jason Wang wrote:
>>>> The problem is we may stop the tx queue when there no enough
>> capacity
>>>> to
>>>> place packets, at this moment  we depends on the tx interrupt to
>>>> re-enable the tx queue. So if we didn't poll the vhost during
>>>> callback,
>>>> guest may lose the tx interrupt to re-enable the tx queue which
>> could
>>>> stall the whole tx queue.
>>> VHOST_MAX_PEND should handle the capacity.
>>>
>>> Hasn't the above situation been handled in handle_tx() code?:
>>> ...
>>>                           if (unlikely(num_pends>   VHOST_MAX_PEND)) {
>>>                                   tx_poll_start(net, sock);
>>>
>> set_bit(SOCK_ASYNC_NOSPACE,&sock->flags);
>>>                                   break;
>>>                           }
>>> ...
>>>
>>> Thanks
>>> Shirley
>> It may not help in because:
>>
>> - tx polling depends on skb_orphan() which is often called by device
>> driver when it place the packet into the queue of the devices instead
>> of  when the packets were sent. So it was too early for vhost to be
>> notified.
> Then do you think it's better to replace with vhost_poll_queue here
> instead?

Just like what does this patch do - calling vhost_poll_queue() in 
vhost_zerocopy_callback().
>> - it only works when the pending DMAs exceeds VHOST_MAX_PEND, it's
>> highly possible that guest needs to be notified when the pending
>> packets
>> isn't so much.
> In which situation the guest needs to be notified when there is no TX
> besides buffers run out?

Consider guest call virtqueue_enable_cb_delayed() which means it only 
need to be notified when 3/4 of pending buffers ( about 178 buffers 
(256-MAX_SKB_FRAGS-2)*3/4 ) were sent by host. So vhost_net would notify 
guest when about 60 buffers were pending. Since tx polling is only 
enabled when pending packets exceeds VHOST_MAX_PEND 128, so tx work 
would not be notified to run and guest would never get the interrupt it 
expected to re-enable the queue.

And just like what we've discussed, tx polling based adding and 
signaling is too early for vhost.
>> So this piece of code may not help and could be removed and we need
>> to
>> poll the virt-queue during zerocopy callback ( through it could be
>> further optimized but may not be easy).
> Thanks
> Shirley
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

