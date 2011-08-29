Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1H2H4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:56:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56071 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1H2H4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:56:10 -0400
Message-ID: <4E5B460F.7070707@gmail.com>
Date: Mon, 29 Aug 2011 15:55:59 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: wanlong.gao@gmail.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: fix size computation according to the definition
 of struct vring_used in vring_size
References: <4E584365.1010806@gmail.com> <1314413399.1913.1.camel@Allen> <4E58BA41.6050503@gmail.com> <4E58BE42.8030700@gmail.com> <87fwkl2ajr.fsf@rustcorp.com.au>
In-Reply-To: <87fwkl2ajr.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月29日 10:53, Rusty Russell wrote:
> On Sat, 27 Aug 2011 17:52:02 +0800, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
>> On 2011年08月27日 17:34, Wang Sheng-Hui wrote:
>> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
>> index 4a32cb6..300af76 100644
>> --- a/include/linux/virtio_ring.h
>> +++ b/include/linux/virtio_ring.h
>> @@ -135,13 +135,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
>>  	vr->num = num;
>>  	vr->desc = p;
>>  	vr->avail = p + num*sizeof(struct vring_desc);
>> -	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
>> -			    & ~(align - 1));
>> +	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + 16
>> +		+ align-1) & ~(align - 1));
>>  }
> 
> This + 16 should be + sizeof(__u16), right?  It's just the
> used_event_idx which has been added:
> 
>  *	__u16 available[num];
>  *	__u16 used_event_idx;
>  *
>  *	// Padding to the next align boundary.
>  *	char pad[];
>  *
>  * [USED]
> 
>>  static inline unsigned vring_size(unsigned int num, unsigned long align)
>>  {
>> -	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
>> +	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
>>  		 + align - 1) & ~(align - 1))
>>  		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
> 
> This is correct.
> 
> And, yes, since align is always 4096, it's currently just a cleanup, but
> it makes things much less confusing!
> 
> Thanks,
> Rusty.

Patch regerated to use sizeof(__u16) instead of 16 in vring_init.
Please check it.


[PATCH] virtio: modify vring_init and vring_size to take account of the layout containing *_event_idx

The patch is against 3.1-rc3.

Based on the layout description in the comments, take account of
the *_event_idx in functions vring_init and vring_size.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/virtio_ring.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 4a32cb6..2a731bd 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -135,13 +135,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
-			    & ~(align - 1));
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__16)
+		+ align-1) & ~(align - 1));
 }
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
+	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
 		 + align - 1) & ~(align - 1))
 		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
 }
-- 
1.7.1


