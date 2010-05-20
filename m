Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0ETGEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0ETGEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:04:47 -0400
Message-ID: <4BF4D0F5.7050003@redhat.com>
Date: Thu, 20 May 2010 09:04:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <201005071253.53393.rusty@rustcorp.com.au> <4BE9AF9A.8080005@redhat.com> <201005191709.16401.rusty@rustcorp.com.au> <4BF39C12.7090407@redhat.com> <20100519223312.GC4111@redhat.com>
In-Reply-To: <20100519223312.GC4111@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 01:33 AM, Michael S. Tsirkin wrote:
>
>> Virtio is already way too bouncy due to the indirection between the
>> avail/used rings and the descriptor pool.  A device with out of order
>> completion (like virtio-blk) will quickly randomize the unused
>> descriptor indexes, so every descriptor fetch will require a bounce.
>>
>> In contrast, if the rings hold the descriptors themselves instead of
>> pointers, we bounce (sizeof(descriptor)/cache_line_size) cache lines for
>> every descriptor, amortized.
>>      
> On the other hand, consider that on fast path we are never using all
> of the ring. With a good allocator we might be able to keep
> reusing only small part of the ring, instead of wrapping around
> all of it all of the time.
>    

It's still suboptimal, we have to bounce both the avail/used rings and 
the descriptor pool, compared to just the descriptor ring with a direct 
design.  Plus we don't need a fancy allocator.

When amortizing cachelines, simple data structures win.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

