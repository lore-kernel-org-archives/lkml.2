Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2GCAiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab2GCAiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:38:05 -0400
Message-ID: <4FF23F4B.2040803@redhat.com>
Date: Tue, 03 Jul 2012 08:39:39 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Sasha Levin <levinsasha928@gmail.com>, dlaor@redhat.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com>  <1340002390-3950-4-git-send-email-asias@redhat.com>  <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>  <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com> <87r4svxcjw.fsf@rustcorp.com.au> <4FF10B31.60609@redhat.com> <8762a6y89v.fsf@rustcorp.com.au>
In-Reply-To: <8762a6y89v.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 02:41 PM, Rusty Russell wrote:
> On Mon, 02 Jul 2012 10:45:05 +0800, Asias He <asias@redhat.com> wrote:
>> On 07/02/2012 07:54 AM, Rusty Russell wrote:
>>> Confused.  So, without merging we get 6k exits (per second?)  How many
>>> do we get when we use the request-based IO path?
>>
>> Sorry for the confusion. The numbers were collected from request-based
>> IO path where we can have the guest block layer merge the requests.
>>
>> With the same workload in guest, the guest fires 200K requests to host
>> with merges enabled in guest (echo 0 > /sys/block/vdb/queue/nomerges),
>> while the guest fires 40000K requests to host with merges disabled in
>> guest (echo 2 > /sys/block/vdb/queue/nomerges). This show that the merge
>> in block layer reduces the total number of requests fire to host a lot
>> (40000K / 200K = 20).
>>
>> The guest fires 200K requests to host with merges enabled in guest (echo
>> 0 > /sys/block/vdb/queue/nomerges), the host fires 6K interrupts in
>> total for the 200K requests. This show that the ratio of interrupts
>> coalesced (200K / 6K = 33).
>
> OK, got it!  Guest merging cuts requests by a factor of 20.  EVENT_IDX
> cuts interrupts by a factor of 33.

Yes.

>
>>> If your device is slow, then you won't be able to make many requests per
>>> second: why worry about exit costs?
>>
>> If a device is slow, the merge would merge more requests and reduce the
>> total number of requests to host. This saves exit costs, no?
>
> Sure, our guest merging might save us 100x as many exits as no merging.
> But since we're not doing many requests, does it matter?

We can still have many requests with slow devices. The number of 
requests depends on the workload in guest. E.g. 512 IO threads in guest 
keeping doing IO.

> Ideally we'd merge requests only if the device queue is full.  But that
> sounds hard.
>
>>> If your device is fast (eg. ram),
>>> you've already shown that your patch is a win, right?
>>
>> Yes. Both on ramdisk and fast SSD device (e.g. FusionIO).
>
> Thanks,
> Rusty.
>


-- 
Asias


