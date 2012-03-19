Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab2CSJmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2CSJmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:42:33 -0400
Message-ID: <4F66FF7B.7040000@redhat.com>
Date: Mon, 19 Mar 2012 17:42:19 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V4 PATCH] virtio-net: send gratuitous packet when needed
References: <20120313090841.11110.82654.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120313143331.GE14931@redhat.com> <877gyhxrlu.fsf@rustcorp.com.au> <20120319084449.GF17673@redhat.com>
In-Reply-To: <20120319084449.GF17673@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 04:44 PM, Michael S. Tsirkin wrote:
> On Mon, Mar 19, 2012 at 12:46:29PM +1030, Rusty Russell wrote:
>> On Tue, 13 Mar 2012 16:33:31 +0200, "Michael S. Tsirkin"<mst@redhat.com>  wrote:
>>>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>>>> index 970d5a2..44a38d6 100644
>>>> --- a/include/linux/virtio_net.h
>>>> +++ b/include/linux/virtio_net.h
>>>> @@ -49,8 +49,10 @@
>>>>   #define VIRTIO_NET_F_CTRL_RX	18	/* Control channel RX mode support */
>>>>   #define VIRTIO_NET_F_CTRL_VLAN	19	/* Control channel VLAN filtering */
>>>>   #define VIRTIO_NET_F_CTRL_RX_EXTRA 20	/* Extra RX mode control support */
>>>> +#define VIRTIO_NET_F_GUEST_ANNOUNCE 21  /* Guest can send gratituous packet */
>>>>
>>>>   #define VIRTIO_NET_S_LINK_UP	1	/* Link is up */
>>>> +#define VIRTIO_NET_S_ANNOUNCE   2       /* Announcement is needed */
>>> I would put this in bit 8 (0x100), this way low status byte
>>> is RO, high byte is RW.
>> The whole idea of acking by clearing the bit is unreliable, moving to a
>> separate byte just controls the damage.
>>
>> How about you use bits 8-15 as a counter?  It's still theoretically
>> unreliable if 256 notifications pass before the guest notices, but it's
>> probably better and clearer than this.
>>
>> I leave the final call to MST though.
>>
>> Thanks,
>> Rusty.
> I guess the point was that we want a single packet
> so we don't care if multiple notifications are coalesced
> into a single one.
>

To reduce the possibility of dropping or losing of gratuitous packet by 
the network, qemu usually send the gratuitous packets for many times ( 
currently 5 time with a increment gap between them such as 50ms, 150ms, 
250ms ...). As there's no method can guarantee the gratuitous packet 
were received by switch in guest, no need to care about the coalesced 
notifications in guest. And we may leave the work to qemu or just don't 
care about this.

>> -- 
>>    How could I marry someone with more hair than me?  http://baldalex.org
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

