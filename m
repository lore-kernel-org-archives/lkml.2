Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3AIC0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:26:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab3AIC0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:26:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,435,1355068800"; 
   d="scan'208";a="6547155"
Message-ID: <50ECCDF3.9050403@cn.fujitsu.com>
Date: Wed, 09 Jan 2013 09:54:59 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio-net: fix the set affinity bug when CPU
 IDs are not consecutive
References: <1357639660-6660-1-git-send-email-gaowanlong@cn.fujitsu.com> <87k3rn2qwb.fsf@rustcorp.com.au>
In-Reply-To: <87k3rn2qwb.fsf@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/09 09:54:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/09 09:54:04,
	Serialize complete at 2013/01/09 09:54:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 07:31 AM, Rusty Russell wrote:
> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
>>   */
>>  static u16 virtnet_select_queue(struct net_device *dev, struct sk_buff *skb)
>>  {
>> -	int txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
>> -		  smp_processor_id();
>> +	int txq = 0;
>> +
>> +	if (skb_rx_queue_recorded(skb))
>> +		txq = skb_get_rx_queue(skb);
>> +	else if ((txq = per_cpu(vq_index, smp_processor_id())) == -1)
>> +		txq = 0;
> 
> You should use __get_cpu_var() instead of smp_processor_id() here, ie:
> 
>         else if ((txq = __get_cpu_var(vq_index)) == -1)
> 
> And AFAICT, no reason to initialize txq to 0 to start with.
> 
> So:
> 
>         int txq;
> 
>         if (skb_rx_queue_recorded(skb))
> 		txq = skb_get_rx_queue(skb);
>         else {
>                 txq = __get_cpu_var(vq_index);
>                 if (txq == -1)
>                         txq = 0;
>         }

Got it, thank you.

> 
> Now, just to confirm, I assume this can happen even if we use vq_index,
> right, because of races with virtnet_set_channels?

I still can't understand this race, could you explain more? thank you.

Regards,
Wanlong Gao

> 
>   	while (unlikely(txq >= dev->real_num_tx_queues))
>   		txq -= dev->real_num_tx_queues;
> 
> 
> Thanks,
> Rusty.
> 

