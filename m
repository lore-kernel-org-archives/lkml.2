Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0JJL4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 07:56:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40514 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab0JJL4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 07:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ERzrra0Qx1+zjKGy92uGomQtwGck8S5+h8ONgC4yGhIqcZJHMkEDztUGX8oiYD9SZ1
         t/+KV2txhqfbnogm1qI/cz+tLRh5VBbyXgBeF0i1uPCx01aCWvUSZECRBuGIDeiX5cgB
         szB6THHT2Nat0BIil/NKijS/ZZ3SUd4AAS008=
MIME-Version: 1.0
In-Reply-To: <4CAF4E93.1040101@kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<4CAE1F47.3050105@kernel.org>
	<4CAE29CC.8030702@redhat.com>
	<4CAF4E93.1040101@kernel.org>
Date: Sun, 10 Oct 2010 13:56:07 +0200
Message-ID: <AANLkTika3Ubs6JXtDuetyy74fV+jiyzc-PTSMV3s-kXy@mail.gmail.com>
Subject: Re: [dm-devel] Linux 2.6.36-rc7
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hch@infradead.org, herbert@gondor.hengli.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 7:02 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, again.
>
> On 10/07/2010 10:13 PM, Milan Broz wrote:
>> Yes, XFS is very good to show up problems in dm-crypt:)
>>
>> But there was no change in dm-crypt which can itself cause such problem,
>> planned workqueue changes are not in 2.6.36 yet.
>> Code is basically the same for the last few releases.
>>
>> So it seems that workqueue processing really changed here under memory pressure.
>>
>> Milan
>>
>> p.s.
>> Anyway, if you are able to reproduce it and you think that there is problem
>> in per-device dm-crypt workqueue, there are patches from Andi for shared
>> per-cpu workqueue, maybe it can help here. (But this is really not RC material.)
>>
>> Unfortunately not yet in dm-devel tree, but I have them here ready for review:
>> http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
>> (all 4 patches must be applied, I hope Alasdair will put them in dm quilt soon.)
>
> Okay, spent the whole day reproduing the problem and trying to
> determine what's going on.  In the process, I've found a bug and a
> potential issue (not sure whether it's an actual issue which should be
> fixed for this release yet) but the hang doesn't seem to have anything
> to do with workqueue update.  All the queues are behaving exactly as
> expected during hang.
>
> Also, it isn't a regression.  I can reliably trigger the same deadlock
> on v2.6.35.
>
> Here's the setup, which should be mostly similar to Torsten's setup I
> used to trigger the problem.
>
> The machine is dual quad-core Opteron (8 phys cores) w/ 4GiB memory.
>
> * 80GB raid1 of two SATA disks
> * On top of that, luks encrypted device w/ twofish-cbc-essiv:sha256
> * In the encrypted device, xfs filesystem which hosts 8GiB swapfile
> * 12GiB tmpfs
>
> The workload is v2.6.35 allyesconfig -j 128 build in the tmpfs.  Not
> too long after swap starts being used (several tens of secs), the
> system hangs.  IRQ handling and all are fine but no IO gets through
> with a lot of tasks stuck in bio allocation somewhere.
>
> I suspected that with md and dm stacked together, something in the
> upper layer ended up exhausting a shared bio pool and tried a couple
> of things but haven't succeeded at finding where the culprit is.  It
> probably would be best to run blktrace together and analyze how IO
> gets stuck.
>
> So, well, we seem to be broken the same way as before.  No need to
> delay release for this one.

I instrument mm/mempool.c, trying to find what shared pool gets exhausted.
On the last run, it seemed that the fs_bio_set from fs/bio.c runs dry.

As far as I can see, that pool is used by bio_alloc() and bio_clone().
Above bio_alloc() a dire warning says, that any bio allocated that way
needs to be submitted from IO, otherwise the system could livelock.
bio_clone() does not have this warning, but as it uses the same pool
in the same way, I would expect the same rule applies.

Looking for uses of bio_allow() and bio_clone() in drivers/md it looks
like dm-crypt uses its own pools and not the fs_bio_set.
But drivers/md/raid1.c uses this pool, and in my eyes it does it wrong.

When writing to a RAID1 array the function make_request() in raid1.c
does a bio_clone() for each drive (lines 967-1001 in 2.6.36-rc7) and
only after all bios are allocates they will be merged into the
pending_bio_list.

So a RAID1 with 3 mirrors is a sure way to lock up a system as soon as
the mempool is needed?
(The fs_bio_set pool only allocates BIO_POOL_SIZE entries and that is
defined as 2)

>From the use of atomic_inc(&r1_bio->remaining) and the use of the
spin_lock_irqsave(&conf->device_lock, flags) when merging the bio
list, I would suspect that its even possible that multiple CPUs
concurrently get into this allocation loop, or that the use of
multiple RAID1 devices each with only 2 drives could lock up the same
way.

What am I missing, or is the use of bio_clone() really the wrong thing?

Torsten
