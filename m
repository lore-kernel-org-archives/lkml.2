Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2D1SQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 14:16:41 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39574 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2D1SQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 14:16:39 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: davem@davemloft.net, ericvh@gmail.com, jvrao@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] 9p: disconnect channel when PCI device is removed
In-Reply-To: <CA+1xoqfQ0Cj5pibxN8ZTXbksezH4NqOERaiYav=D7BA+v86m3A@mail.gmail.com>
References: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com> <87iph118pd.fsf@skywalker.in.ibm.com> <CA+1xoqfgA6DJL7ztMOdfLZedV6YwzZPUfbovFykdSSZy0Aio6w@mail.gmail.com> <87ehrodjt6.fsf@skywalker.in.ibm.com> <CA+1xoqfQ0Cj5pibxN8ZTXbksezH4NqOERaiYav=D7BA+v86m3A@mail.gmail.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 28 Apr 2012 23:46:26 +0530
Message-ID: <87d36rafid.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12042808-1396-0000-0000-0000010F645D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On Mon, Apr 16, 2012 at 12:59 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> Sasha Levin <levinsasha928@gmail.com> writes:
>>
>>> On Sun, Apr 15, 2012 at 2:27 PM, Aneesh Kumar K.V
>>> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>>> Sasha Levin <levinsasha928@gmail.com> writes:
>>>>
>>>>> When a virtio_9p pci device is being removed, we should close down any
>>>>> active channels and free up resources, we're not supposed to BUG() if there's
>>>>> still an open channel since it's a valid case when removing the PCI device.
>>>>>
>>>>> Otherwise, removing the PCI device with an open channel would cause the
>>>>> following BUG():
>>>>>
>>>> ...
>>>>
>>>>> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
>>>>> index 3d43206..5af18d1 100644
>>>>> --- a/net/9p/trans_virtio.c
>>>>> +++ b/net/9p/trans_virtio.c
>>>>> @@ -615,7 +615,8 @@ static void p9_virtio_remove(struct virtio_device *vdev)
>>>>>  {
>>>>>       struct virtio_chan *chan = vdev->priv;
>>>>>
>>>>> -     BUG_ON(chan->inuse);
>>>>> +     if (chan->inuse)
>>>>> +             p9_virtio_close(chan->client);
>>>>>       vdev->config->del_vqs(vdev);
>>>>>
>>>>>       mutex_lock(&virtio_9p_lock);
>>>>
>>>> But an umount should have resulted in p9_virtio_close ? How are you
>>>> removing the device ? Are you removing the device with file system
>>>> mounted  ?. In that case may be we should return EBUSY ?
>>>
>>> I signal the underlying PCI device to remove (echo 1 >
>>> /sys/devices/pci0000\:00/[...]/remove), we can't really prevent that
>>> thing so we must clean up ourselves.
>>
>> What does that mean for the mounted file system ? What would happen to
>> the pending fs operations in that case ?
>
> I'm guessing that all of them should be canceled.

Pending operation we can cancel, but what about dirty pages in cached
mode ? Also how does virtio-blk handle this ? 

> virtio-pci simulates
> a PCI device, if the PCI device is unplugged there's not much to do
> about the filesystem or pending requests.

Ideal thing to do would be to make remove return -EBUSY; let the user
umount. But looking at the code, I guess there is no easy way to return
error from remove callback ?

-aneesh

