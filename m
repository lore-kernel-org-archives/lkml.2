Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870Ab2DPEgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 00:36:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48209 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2DPEgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 00:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <87iph118pd.fsf@skywalker.in.ibm.com>
References: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com> <87iph118pd.fsf@skywalker.in.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 16 Apr 2012 06:35:47 +0200
Message-ID: <CA+1xoqfgA6DJL7ztMOdfLZedV6YwzZPUfbovFykdSSZy0Aio6w@mail.gmail.com>
Subject: Re: [PATCH] 9p: disconnect channel when PCI device is removed
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: davem@davemloft.net, ericvh@gmail.com, jvrao@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 2:27 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
>
>> When a virtio_9p pci device is being removed, we should close down any
>> active channels and free up resources, we're not supposed to BUG() if there's
>> still an open channel since it's a valid case when removing the PCI device.
>>
>> Otherwise, removing the PCI device with an open channel would cause the
>> following BUG():
>>
> ...
>
>> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
>> index 3d43206..5af18d1 100644
>> --- a/net/9p/trans_virtio.c
>> +++ b/net/9p/trans_virtio.c
>> @@ -615,7 +615,8 @@ static void p9_virtio_remove(struct virtio_device *vdev)
>>  {
>>       struct virtio_chan *chan = vdev->priv;
>>
>> -     BUG_ON(chan->inuse);
>> +     if (chan->inuse)
>> +             p9_virtio_close(chan->client);
>>       vdev->config->del_vqs(vdev);
>>
>>       mutex_lock(&virtio_9p_lock);
>
> But an umount should have resulted in p9_virtio_close ? How are you
> removing the device ? Are you removing the device with file system
> mounted  ?. In that case may be we should return EBUSY ?

I signal the underlying PCI device to remove (echo 1 >
/sys/devices/pci0000\:00/[...]/remove), we can't really prevent that
thing so we must clean up ourselves.
