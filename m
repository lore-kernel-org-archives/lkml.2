Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0EXGh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab0EXGh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:37:27 -0400
Message-ID: <4BFA1E91.8060706@redhat.com>
Date: Mon, 24 May 2010 09:37:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au> <20100523153134.GA14646@redhat.com> <4BF94CAD.5010504@redhat.com> <20100523155132.GA14733@redhat.com> <4BF951BE.1010402@redhat.com> <20100523163039.GC14733@redhat.com>
In-Reply-To: <20100523163039.GC14733@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 07:30 PM, Michael S. Tsirkin wrote:
>
>    
>>> Maybe we should use atomics on index then?
>>>
>>>        
>> This should only be helpful if you access the cacheline several times in
>> a row.  That's not the case in virtio (or here).
>>      
> So why does it help?
>    

We actually do access the cacheline several times in a row here (but not 
in virtio?):

> 		case SHARE:
> 			while (count<  MAX_BOUNCES) {
> 				/* Spin waiting for other side to change it. */
> 				while (counter->cacheline1 != count);
>    

Broadcast a read request.

> 				count++;
> 				counter->cacheline1 = count;
>    

Broadcast an invalidate request.

> 				count++;
> 			}
> 			break;
>
> 		case LOCKSHARE:
> 			while (count<  MAX_BOUNCES) {
> 				/* Spin waiting for other side to change it. */
> 				while (__sync_val_compare_and_swap(&counter->cacheline1, count, count+1)
> 				       != count);
>    

Broadcast a 'read for ownership' request.

> 				count += 2;
> 			}
> 			break;
>    

So RMW should certainly by faster using single-instruction RMW 
operations (or using prefetchw).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

