Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2GFHnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2GFHnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:43:42 -0400
Message-ID: <4FF697A2.2000502@redhat.com>
Date: Fri, 06 Jul 2012 15:45:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Amos Kong <akong@redhat.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-5-git-send-email-jasowang@redhat.com> <4FF5F2F2.9050307@redhat.com>
In-Reply-To: <4FF5F2F2.9050307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 04:02 AM, Amos Kong wrote:
> On 07/05/2012 06:29 PM, Jason Wang wrote:
>> This patch converts virtio_net to a multi queue device. After negotiated
>> VIRTIO_NET_F_MULTIQUEUE feature, the virtio device has many tx/rx queue pairs,
>> and driver could read the number from config space.
>>
>> The driver expects the number of rx/tx queue paris is equal to the number of
>> vcpus. To maximize the performance under this per-cpu rx/tx queue pairs, some
>> optimization were introduced:
>>
>> - Txq selection is based on the processor id in order to avoid contending a lock
>>    whose owner may exits to host.
>> - Since the txq/txq were per-cpu, affinity hint were set to the cpu that owns
>>    the queue pairs.
>>
>> Signed-off-by: Krishna Kumar<krkumar2@in.ibm.com>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
> ...
>
>>
>>   static int virtnet_probe(struct virtio_device *vdev)
>>   {
>> -	int err;
>> +	int i, err;
>>   	struct net_device *dev;
>>   	struct virtnet_info *vi;
>> +	u16 num_queues, num_queue_pairs;
>> +
>> +	/* Find if host supports multiqueue virtio_net device */
>> +	err = virtio_config_val(vdev, VIRTIO_NET_F_MULTIQUEUE,
>> +				offsetof(struct virtio_net_config,
>> +				num_queues),&num_queues);
>> +
>> +	/* We need atleast 2 queue's */
>
> s/atleast/at least/
>
>
>> +	if (err || num_queues<  2)
>> +		num_queues = 2;
>> +	if (num_queues>  MAX_QUEUES * 2)
>> +		num_queues = MAX_QUEUES;
>                  num_queues = MAX_QUEUES * 2;
>
> MAX_QUEUES is the limitation of RX or TX.

Right, it's a typo, thanks.
>> +
>> +	num_queue_pairs = num_queues / 2;
> ...
>

