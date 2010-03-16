Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab0CPQBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0CPQBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:01:17 -0400
Message-ID: <4B9FAAEC.1040604@redhat.com>
Date: Tue, 16 Mar 2010 17:59:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Christoph Hellwig <hch@lst.de>, Chris Webb <chris@arachsys.com>,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100316102637.GA23584@lst.de> <4B9F5F2F.8020501@redhat.com> <20100316104422.GA24258@lst.de> <4B9F66AC.5080400@redhat.com> <20100316142739.GM18054@balbir.in.ibm.com>
In-Reply-To: <20100316142739.GM18054@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 04:27 PM, Balbir Singh wrote:
>
>> Let's assume the guest has virtio (I agree with IDE we need
>> reordering on the host).  The guest sends batches of I/O separated
>> by cache flushes.  If the batches are smaller than the virtio queue
>> length, ideally things look like:
>>
>>   io_submit(..., batch_size_1);
>>   io_getevents(..., batch_size_1);
>>   fdatasync();
>>   io_submit(..., batch_size_2);
>>    io_getevents(..., batch_size_2);
>>    fdatasync();
>>    io_submit(..., batch_size_3);
>>    io_getevents(..., batch_size_3);
>>    fdatasync();
>>
>> (certainly that won't happen today, but it could in principle).
>>
>> How does a write cache give any advantage?  The host kernel sees
>> _exactly_ the same information as it would from a bunch of threaded
>> pwritev()s followed by fdatasync().
>>
>>      
> Are you suggesting that the model with cache=writeback gives us the
> same I/O pattern as cache=none, so there are no opportunities for
> optimization?
>    

Yes.  The guest also has a large cache with the same optimization algorithm.

>
>    
>> (wish: IO_CMD_ORDERED_FDATASYNC)
>>
>> If the batch size is larger than the virtio queue size, or if there
>> are no flushes at all, then yes the huge write cache gives more
>> opportunity for reordering.  But we're already talking hundreds of
>> requests here.
>>
>> Let's say the virtio queue size was unlimited.  What
>> merging/reordering opportunity are we missing on the host?  Again we
>> have exactly the same information: either the pagecache lru + radix
>> tree that identifies all dirty pages in disk order, or the block
>> queue with pending requests that contains exactly the same
>> information.
>>
>> Something is wrong.  Maybe it's my understanding, but on the other
>> hand it may be a piece of kernel code.
>>
>>      
> I assume you are talking of dedicated disk partitions and not
> individual disk images residing on the same partition.
>    

Correct. Images in files introduce new writes which can be optimized.

-- 
error compiling committee.c: too many arguments to function

