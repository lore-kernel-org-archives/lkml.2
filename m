Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3AJJ0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:26:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3AJJ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:26:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,444,1355068800"; 
   d="scan'208";a="6559019"
Message-ID: <50EE893E.8020107@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 17:26:22 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Eric Dumazet <erdnetdev@gmail.com>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio-net: fix the set affinity bug when CPU
 IDs are not consecutive
References: <1357639660-6660-1-git-send-email-gaowanlong@cn.fujitsu.com> <87k3rn2qwb.fsf@rustcorp.com.au> <50ECCDF3.9050403@cn.fujitsu.com> <87a9sh3lru.fsf@rustcorp.com.au>
In-Reply-To: <87a9sh3lru.fsf@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 17:25:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 17:25:25,
	Serialize complete at 2013/01/10 17:25:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 08:49 AM, Rusty Russell wrote:
> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
>> On 01/09/2013 07:31 AM, Rusty Russell wrote:
>>> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
>>>>   */
>>>>  static u16 virtnet_select_queue(struct net_device *dev, struct sk_buff *skb)
>>>>  {
>>>> -	int txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
>>>> -		  smp_processor_id();
>>>> +	int txq = 0;
>>>> +
>>>> +	if (skb_rx_queue_recorded(skb))
>>>> +		txq = skb_get_rx_queue(skb);
>>>> +	else if ((txq = per_cpu(vq_index, smp_processor_id())) == -1)
>>>> +		txq = 0;
>>>
>>> You should use __get_cpu_var() instead of smp_processor_id() here, ie:
>>>
>>>         else if ((txq = __get_cpu_var(vq_index)) == -1)
>>>
>>> And AFAICT, no reason to initialize txq to 0 to start with.
>>>
>>> So:
>>>
>>>         int txq;
>>>
>>>         if (skb_rx_queue_recorded(skb))
>>> 		txq = skb_get_rx_queue(skb);
>>>         else {
>>>                 txq = __get_cpu_var(vq_index);
>>>                 if (txq == -1)
>>>                         txq = 0;
>>>         }
>>
>> Got it, thank you.
>>
>>>
>>> Now, just to confirm, I assume this can happen even if we use vq_index,
>>> right, because of races with virtnet_set_channels?
>>
>> I still can't understand this race, could you explain more? thank you.
> 
> I assume that someone can call virtnet_set_channels() while we are
> inside virtnet_select_queue(), so they reduce dev->real_num_tx_queues,
> causing virtnet_set_channels to do:
> 
> 	while (unlikely(txq >= dev->real_num_tx_queues))
> 		txq -= dev->real_num_tx_queues;
> 
> Otherwise, when is this loop called?

How about just remove this loop? 

Eric, can you give a help here?

Thanks,
Wanlong Gao

> 
> Thanks,
> Rusty.
> 

