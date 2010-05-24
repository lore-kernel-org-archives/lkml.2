Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0EXIJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0EXIJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:09:43 -0400
Date: Mon, 24 May 2010 11:05:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
	ring itself
Message-ID: <20100524080518.GA16115@redhat.com>
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au> <20100523153134.GA14646@redhat.com> <4BF94CAD.5010504@redhat.com> <20100523155132.GA14733@redhat.com> <4BF951BE.1010402@redhat.com> <20100523163039.GC14733@redhat.com> <4BFA1E91.8060706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA1E91.8060706@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:37:05AM +0300, Avi Kivity wrote:
> On 05/23/2010 07:30 PM, Michael S. Tsirkin wrote:
>>
>>    
>>>> Maybe we should use atomics on index then?
>>>>
>>>>        
>>> This should only be helpful if you access the cacheline several times in
>>> a row.  That's not the case in virtio (or here).
>>>      
>> So why does it help?
>>    
>
> We actually do access the cacheline several times in a row here (but not  
> in virtio?):
>
>> 		case SHARE:
>> 			while (count<  MAX_BOUNCES) {
>> 				/* Spin waiting for other side to change it. */
>> 				while (counter->cacheline1 != count);
>>    
>
> Broadcast a read request.
>
>> 				count++;
>> 				counter->cacheline1 = count;
>>    
>
> Broadcast an invalidate request.
>
>> 				count++;
>> 			}
>> 			break;
>>
>> 		case LOCKSHARE:
>> 			while (count<  MAX_BOUNCES) {
>> 				/* Spin waiting for other side to change it. */
>> 				while (__sync_val_compare_and_swap(&counter->cacheline1, count, count+1)
>> 				       != count);
>>    
>
> Broadcast a 'read for ownership' request.
>
>> 				count += 2;
>> 			}
>> 			break;
>>    
>
> So RMW should certainly by faster using single-instruction RMW  
> operations (or using prefetchw).

Okay, but why is lockunshare faster than unshare?

> -- 
> Do not meddle in the internals of kernels, for they are subtle and quick to panic.
