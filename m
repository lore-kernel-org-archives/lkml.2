Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab2EQCus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab2EQCur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:50:47 -0400
Message-ID: <4FB4677A.8020402@redhat.com>
Date: Thu, 17 May 2012 10:50:34 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1337100630.8220.4.camel@oc3660625478.ibm.com> <4FB317C8.90002@redhat.com>  <1337181027.10741.13.camel@oc3660625478.ibm.com>  <20120516151444.GC9934@redhat.com> <1337189525.10741.24.camel@oc3660625478.ibm.com>
In-Reply-To: <1337189525.10741.24.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 01:32 AM, Shirley Ma wrote:
> On Wed, 2012-05-16 at 18:14 +0300, Michael S. Tsirkin wrote:
>> On Wed, May 16, 2012 at 08:10:27AM -0700, Shirley Ma wrote:
>>> On Wed, 2012-05-16 at 10:58 +0800, Jason Wang wrote:
>>>>>>    drivers/vhost/vhost.c |    1 +
>>>>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>>>>> index 947f00d..7b75fdf 100644
>>>>>> --- a/drivers/vhost/vhost.c
>>>>>> +++ b/drivers/vhost/vhost.c
>>>>>> @@ -1604,6 +1604,7 @@ void vhost_zerocopy_callback(void *arg)
>>>>>>           struct vhost_ubuf_ref *ubufs = ubuf->arg;
>>>>>>           struct vhost_virtqueue *vq = ubufs->vq;
>>>>>>
>>>>>> +       vhost_poll_queue(&vq->poll);
>>>>>>           /* set len = 1 to mark this desc buffers done DMA */
>>>>>>           vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
>>>>>>           kref_put(&ubufs->kref, vhost_zerocopy_done_signal);
>>>>> Doing so, we might have redundant vhost_poll_queue(). Do you
>> know in
>>>>> which scenario there might be missing of adding and signaling
>> during
>>>>> zerocopy?
>>>> Yes, as we only do signaling and adding during tx work, if there's
>> no
>>>> tx
>>>> work when the skb were sent, we may lose the opportunity to let
>> guest
>>>> know about the completion. It's easy to be reproduced with netperf
>>>> test.
>>> The reason which host signals guest is to free guest tx buffers, if
>>> there is no tx work, then it's not necessary to signal the guest
>> unless
>>> guest runs out of memory. The pending buffers will be released
>>> virtio_net device gone.

Looks like we only free the skbs in .ndo_start_xmit().
>>>
>>> What's the behavior of netperf test when you hit this situation?
>>>
>>> Thanks
>>> Shirley
>> IIRC guest networking seems to be lost.
> It seems vhost_enable_notify is missing in somewhere else?
>
> Thanks
> Shirley
>

The problem is we may stop the tx queue when there no enough capacity to 
place packets, at this moment  we depends on the tx interrupt to 
re-enable the tx queue. So if we didn't poll the vhost during callback, 
guest may lose the tx interrupt to re-enable the tx queue which could 
stall the whole tx queue.

Thanks
