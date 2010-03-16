Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680Ab0CPJSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:18:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab0CPJSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:18:18 -0400
Message-ID: <4B9F4CBD.3020805@redhat.com>
Date: Tue, 16 Mar 2010 11:17:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
CC: balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com>
In-Reply-To: <20100315202353.GJ3840@arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 10:23 PM, Chris Webb wrote:
> Avi Kivity<avi@redhat.com>  writes:
>
>    
>> On 03/15/2010 10:07 AM, Balbir Singh wrote:
>>
>>      
>>> Yes, it is a virtio call away, but is the cost of paying twice in
>>> terms of memory acceptable?
>>>        
>> Usually, it isn't, which is why I recommend cache=off.
>>      
> Hi Avi. One observation about your recommendation for cache=none:
>
> We run hosts of VMs accessing drives backed by logical volumes carved out
> from md RAID1. Each host has 32GB RAM and eight cores, divided between (say)
> twenty virtual machines, which pretty much fill the available memory on the
> host. Our qemu-kvm is new enough that IDE and SCSI drives with writeback
> caching turned on get advertised to the guest as having a write-cache, and
> FLUSH gets translated to fsync() by qemu. (Consequently cache=writeback
> isn't acting as cache=neverflush like it would have done a year ago. I know
> that comparing performance for cache=none against that unsafe behaviour
> would be somewhat unfair!)
>
> Wasteful duplication of page cache between guest and host notwithstanding,
> turning on cache=writeback is a spectacular performance win for our guests.
> For example, even IDE with cache=writeback easily beats virtio with
> cache=none in most of the guest filesystem performance tests I've tried. The
> anecdotal feedback from clients is also very strongly in favour of
> cache=writeback.
>    

Is this with qcow2, raw file, or direct volume access?

I can understand it for qcow2, but for direct volume access this 
shouldn't happen.  The guest schedules as many writes as it can, 
followed by a sync.  The host (and disk) can then reschedule them 
whether they are in the writeback cache or in the block layer, and must 
sync in the same way once completed.

Perhaps what we need is bdrv_aio_submit() which can take a number of 
requests.  For direct volume access, this allows easier reordering 
(io_submit() should plug the queues before it starts processing and 
unplug them when done, though I don't see the code for this?).  For 
qcow2, we can coalesce metadata updates for multiple requests into one 
RMW (for example, a sequential write split into multiple 64K-256K write 
requests).

Christoph/Kevin?

> With a host full of cache=none guests, IO contention between guests is
> hugely problematic with non-stop seek from the disks to service tiny
> O_DIRECT writes (especially without virtio), many of which needn't have been
> synchronous if only there had been some way for the guest OS to tell qemu
> that. Running with cache=writeback seems to reduce the frequency of disk
> flush per guest to a much more manageable level, and to allow the host's
> elevator to optimise writing out across the guests in between these flushes.
>    

The host eventually has to turn the writes into synchronous writes, no 
way around that.

-- 
error compiling committee.c: too many arguments to function

