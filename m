Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0CQQXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab0CQQWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:22:55 -0400
Message-ID: <4BA101C5.9040406@redhat.com>
Date: Wed, 17 Mar 2010 18:22:29 +0200
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
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com>
In-Reply-To: <20100317152452.GZ31148@arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 05:24 PM, Chris Webb wrote:
> Avi Kivity<avi@redhat.com>  writes:
>
>    
>> On 03/15/2010 10:23 PM, Chris Webb wrote:
>>
>>      
>>> Wasteful duplication of page cache between guest and host notwithstanding,
>>> turning on cache=writeback is a spectacular performance win for our guests.
>>>        
>> Is this with qcow2, raw file, or direct volume access?
>>      
> This is with direct access to logical volumes. No file systems or qcow2 in
> the stack. Our typical host has a couple of SATA disks, combined in md
> RAID1, chopped up into volumes with LVM2 (really just dm linear targets).
> The performance measured outside qemu is excellent, inside qemu-kvm is fine
> too until multiple guests are trying to access their drives at once, but
> then everything starts to grind badly.
>
>    

OK.

>> I can understand it for qcow2, but for direct volume access this
>> shouldn't happen.  The guest schedules as many writes as it can,
>> followed by a sync.  The host (and disk) can then reschedule them
>> whether they are in the writeback cache or in the block layer, and
>> must sync in the same way once completed.
>>      
> I don't really understand what's going on here, but I wonder if the
> underlying problem might be that all the O_DIRECT/O_SYNC writes from the
> guests go down into the same block device at the bottom of the device mapper
> stack, and thus can't be reordered with respect to one another.

They should be reorderable.  Otherwise host filesystems on several 
volumes would suffer the same problems.

Whether the filesystem is in the host or guest shouldn't matter.

> For our
> purposes,
>
>    Guest AA   Guest BB       Guest AA   Guest BB       Guest AA   Guest BB
>    write A1                  write A1                             write B1
>               write B1       write A2                  write A1
>    write A2                             write B1       write A2
>
> are all equivalent, but the system isn't allowed to reorder in this way
> because there isn't a separate request queue for each logical volume, just
> the one at the bottom. (I don't know whether nested request queues would
> behave remotely reasonably either, though!)
>
> Also, if my guest kernel issues (say) three small writes, one at the start
> of the disk, one in the middle, one at the end, and then does a flush, can
> virtio really express this as one non-contiguous O_DIRECT write (the three
> components of which can be reordered by the elevator with respect to one
> another) rather than three distinct O_DIRECT writes which can't be permuted?
> Can qemu issue a write like that? cache=writeback + flush allows this to be
> optimised by the block layer in the normal way.
>    

Guest side virtio will send this as three requests followed by a flush.  
Qemu will issue these as three distinct requests and then flush.  The 
requests are marked, as Christoph says, in a way that limits their 
reorderability, and perhaps if we fix these two problems performance 
will improve.

Something that comes to mind is merging of flush requests.  If N guests 
issue one write and one flush each, we should issue N writes and just 
one flush - a flush for the disk applies to all volumes on that disk.

-- 
error compiling committee.c: too many arguments to function

