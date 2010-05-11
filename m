Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab0EKT15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0EKT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:27:56 -0400
Message-ID: <4BE9AF9A.8080005@redhat.com>
Date: Tue, 11 May 2010 22:27:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
  ring itself
References: <20100505205814.GA7090@redhat.com> <4BE29320.5090506@redhat.com> <201005071253.53393.rusty@rustcorp.com.au>
In-Reply-To: <201005071253.53393.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 06:23 AM, Rusty Russell wrote:
> On Thu, 6 May 2010 07:30:00 pm Avi Kivity wrote:
>    
>> On 05/05/2010 11:58 PM, Michael S. Tsirkin wrote:
>>      
>>> +	/* We publish the last-seen used index at the end of the available ring.
>>> +	 * It is at the end for backwards compatibility. */
>>> +	vr->last_used_idx =&(vr)->avail->ring[num];
>>> +	/* Verify that last used index does not spill over the used ring. */
>>> +	BUG_ON((void *)vr->last_used_idx +
>>> +	       sizeof *vr->last_used_idx>   (void *)vr->used);
>>>    }
>>>
>>>        
>> Shouldn't this be on its own cache line?
>>      
> It's next to the available ring; because that's where the guest publishes
> its data.  That whole page is guest-write, host-read.
>
> Putting it on a cacheline by itself would be a slight pessimization; the host
> cpu would have to get the last_used_idx cacheline and the avail descriptor
> cacheline every time.  This way, they are sometimes the same cacheline.
>    

If one peer writes the tail of the available ring, while the other reads 
last_used_idx, it's a false bounce, no?

Having things on the same cacheline is only worthwhile if they are 
accessed at the same time.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

