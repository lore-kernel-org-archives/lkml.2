Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab3AJGwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:52:37 -0500
Received: from ozlabs.org ([203.10.76.45]:39658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab3AJGwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:52:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio-net: fix the set affinity bug when CPU IDs are not consecutive
In-Reply-To: <50ECCDF3.9050403@cn.fujitsu.com>
References: <1357639660-6660-1-git-send-email-gaowanlong@cn.fujitsu.com> <87k3rn2qwb.fsf@rustcorp.com.au> <50ECCDF3.9050403@cn.fujitsu.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 10 Jan 2013 11:19:09 +1030
Message-ID: <87a9sh3lru.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
> On 01/09/2013 07:31 AM, Rusty Russell wrote:
>> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
>>>   */
>>>  static u16 virtnet_select_queue(struct net_device *dev, struct sk_buff *skb)
>>>  {
>>> -	int txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
>>> -		  smp_processor_id();
>>> +	int txq = 0;
>>> +
>>> +	if (skb_rx_queue_recorded(skb))
>>> +		txq = skb_get_rx_queue(skb);
>>> +	else if ((txq = per_cpu(vq_index, smp_processor_id())) == -1)
>>> +		txq = 0;
>> 
>> You should use __get_cpu_var() instead of smp_processor_id() here, ie:
>> 
>>         else if ((txq = __get_cpu_var(vq_index)) == -1)
>> 
>> And AFAICT, no reason to initialize txq to 0 to start with.
>> 
>> So:
>> 
>>         int txq;
>> 
>>         if (skb_rx_queue_recorded(skb))
>> 		txq = skb_get_rx_queue(skb);
>>         else {
>>                 txq = __get_cpu_var(vq_index);
>>                 if (txq == -1)
>>                         txq = 0;
>>         }
>
> Got it, thank you.
>
>> 
>> Now, just to confirm, I assume this can happen even if we use vq_index,
>> right, because of races with virtnet_set_channels?
>
> I still can't understand this race, could you explain more? thank you.

I assume that someone can call virtnet_set_channels() while we are
inside virtnet_select_queue(), so they reduce dev->real_num_tx_queues,
causing virtnet_set_channels to do:

	while (unlikely(txq >= dev->real_num_tx_queues))
		txq -= dev->real_num_tx_queues;

Otherwise, when is this loop called?

Thanks,
Rusty.
