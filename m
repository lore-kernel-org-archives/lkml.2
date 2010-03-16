Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937802Ab0CPLJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937749Ab0CPLI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:08:58 -0400
Message-ID: <4B9F66AC.5080400@redhat.com>
Date: Tue, 16 Mar 2010 13:08:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Chris Webb <chris@arachsys.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100316102637.GA23584@lst.de> <4B9F5F2F.8020501@redhat.com> <20100316104422.GA24258@lst.de>
In-Reply-To: <20100316104422.GA24258@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:44 PM, Christoph Hellwig wrote:
> On Tue, Mar 16, 2010 at 12:36:31PM +0200, Avi Kivity wrote:
>    
>> Are you talking about direct volume access or qcow2?
>>      
> Doesn't matter.
>
>    
>> For direct volume access, I still don't get it.  The number of barriers
>> issues by the host must equal (or exceed, but that's pointless) the
>> number of barriers issued by the guest.  cache=writeback allows the host
>> to reorder writes, but so does cache=none.  Where does the difference
>> come from?
>>
>> Put it another way.  In an unvirtualized environment, if you implement a
>> write cache in a storage driver (not device), and sync it on a barrier
>> request, would you expect to see a performance improvement?
>>      
> cache=none only allows very limited reorderning in the host.  O_DIRECT
> is synchronous on the host, so there's just some very limited reordering
> going on in the elevator if we have other I/O going on in parallel.
>    

Presumably there is lots of I/O going on, or we wouldn't be having this 
conversation.

> In addition to that the disk writecache can perform limited reodering
> and caching, but the disk cache has a rather limited size.  The host
> pagecache gives a much wieder opportunity to reorder, especially if
> the guest workload is not cache flush heavy.  If the guest workload
> is extremly cache flush heavy the usefulness of the pagecache is rather
> limited, as we'll only use very little of it, but pay by having to do
> a data copy.  If the workload is not cache flush heavy, and we have
> multiple guests doing I/O to the same spindles it will allow the host
> do do much more efficient data writeout by beeing able to do better
> ordered (less seeky) and bigger I/O (especially if the host has real
> storage compared to ide for the guest).
>    

Let's assume the guest has virtio (I agree with IDE we need reordering 
on the host).  The guest sends batches of I/O separated by cache 
flushes.  If the batches are smaller than the virtio queue length, 
ideally things look like:

  io_submit(..., batch_size_1);
  io_getevents(..., batch_size_1);
  fdatasync();
  io_submit(..., batch_size_2);
   io_getevents(..., batch_size_2);
   fdatasync();
   io_submit(..., batch_size_3);
   io_getevents(..., batch_size_3);
   fdatasync();

(certainly that won't happen today, but it could in principle).

How does a write cache give any advantage?  The host kernel sees 
_exactly_ the same information as it would from a bunch of threaded 
pwritev()s followed by fdatasync().

(wish: IO_CMD_ORDERED_FDATASYNC)

If the batch size is larger than the virtio queue size, or if there are 
no flushes at all, then yes the huge write cache gives more opportunity 
for reordering.  But we're already talking hundreds of requests here.

Let's say the virtio queue size was unlimited.  What merging/reordering 
opportunity are we missing on the host?  Again we have exactly the same 
information: either the pagecache lru + radix tree that identifies all 
dirty pages in disk order, or the block queue with pending requests that 
contains exactly the same information.

Something is wrong.  Maybe it's my understanding, but on the other hand 
it may be a piece of kernel code.

-- 
error compiling committee.c: too many arguments to function

