Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab1FWSiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777Ab1FWSit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:38:49 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: allow groups preemption for sync-noidle workloads
References: <20110623162159.3192.87699.stgit@localhost6>
	<20110623172632.GB20763@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 23 Jun 2011 14:38:43 -0400
In-Reply-To: <20110623172632.GB20763@redhat.com> (Vivek Goyal's message of
	"Thu, 23 Jun 2011 13:26:32 -0400")
Message-ID: <x49vcvwe6ks.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Jun 23, 2011 at 08:21:59PM +0400, Konstantin Khlebnikov wrote:
>> commit v2.6.32-102-g8682e1f "blkio: Provide some isolation between groups" break
>> fast switching between task and journal-thread for very common write-fsync workload.
>> cfq wait idle slice at each cfqq switch, if this task is from non-root blkio cgroup.
>> 
>> This patch move idling sync-noidle preempting check little bit upwards and update
>> new service_tree->count check for case with two different groups.
>> I do not quite understand what means these check for new_cfqq, but now it even works.
>> 
>> Without patch I got 49 iops and with this patch 798, for this trivial fio script:
>> 
>> [write-fsync]
>> cgroup=test
>> cgroup_weight=1000
>> rw=write
>> fsync=1
>> size=100m
>> runtime=10s
>> 
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
>> ---
>>  block/cfq-iosched.c |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>> 
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 3c7b537..c71533e 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3318,19 +3318,19 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>  	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
>>  		return true;
>>  
>> -	if (new_cfqq->cfqg != cfqq->cfqg)
>> -		return false;
>> -
>> -	if (cfq_slice_used(cfqq))
>> -		return true;
>> -
>>  	/* Allow preemption only if we are idling on sync-noidle tree */
>>  	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
>>  	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
>> -	    new_cfqq->service_tree->count == 2 &&
>> +	    new_cfqq->service_tree->count == 1+(new_cfqq->cfqg == cfqq->cfqg) &&
>
> I think this will completely break the isolation between groups. So now
> your a cgroup might be serving a cfqq from SYNC_NOIDLE_WORKLOAD and a
> SYNC_NOIDLE_WORKLOAD queue gets queued in a separate group, it will
> immediately preempt queue in other group.
>
> This problem is arising due to dependency between fsync and journalling
> threads which are in different cgroups.
>
> We had similar problem in root group also when one thread will show up
> on sync-idle tree and other thread will show up on sync-noidle tree
> and idling will kill throughput. I can't seem to remember how did we
> fix that. I know Jeff moyer was working on some slice yield patches
> but that never made in.  This patch also will not help if we run into
> this situation when a dependent thread is on a sync-idle tree.
>
> I guess we need a way to know the dependency between IO operations
> and if some dependent IO operation is waiting in other group and
> existing group has no IO to do, we can afford not to idle.
>
> Jeff, would you remember how did we fix the fsync issue?

In the absence of cgroups, it was this patch:

commit 749ef9f8423054e326f3a246327ed2db4b6d395f
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Mon Sep 20 15:24:50 2010 +0200

    cfq: improve fsync performance for small files
    
    Fsync performance for small files achieved by cfq on high-end disks is
    lower than what deadline can achieve, due to idling introduced between
    the sync write happening in process context and the journal commit.
    
    Moreover, when competing with a sequential reader, a process writing
    small files and fsync-ing them is starved.
    
    This patch fixes the two problems by:
    - marking journal commits as WRITE_SYNC, so that they get the REQ_NOIDLE
      flag set,
    - force all queues that have REQ_NOIDLE requests to be put in the noidle
      tree.
    
    Having the queue associated to the fsync-ing process and the one associated
     to journal commits in the noidle tree allows:
    - switching between them without idling,
    - fairness vs. competing idling queues, since they will be serviced only
      after the noidle tree expires its slice.
    
    Acked-by: Vivek Goyal <vgoyal@redhat.com>
    Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
    Tested-by: Jeff Moyer <jmoyer@redhat.com>
    Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

If you need a mechanism to explicitly yield the I/O scheduler, I had
written several iterations of patches to provide that functionality.  I
believe this was the latest variant:
  https://lkml.org/lkml/2010/7/2/277

Cheers,
Jeff
