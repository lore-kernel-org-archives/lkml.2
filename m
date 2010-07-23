Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab0GWUwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:52:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64362 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0GWUv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ORuD2BXp/o9nJJVpSXA4WJjJhet4d+1heiQR1a3EEIqAky+svJD5J77/VYJ2zEqZmA
         4AC1Tf6CcLJLvWH1QYUJQftsEYOaiPyp08trlNQLuhi4Nch5Mmbbeax8nr2B1edDkUlB
         ZZtWnW4Blk+RfNOu7bXaDO6ZFuU6D2dwDPMwM=
MIME-Version: 1.0
In-Reply-To: <4C49EA91.3060908@vlnb.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
	<4C03D5FD.3000202@panasas.com>
	<20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
	<1275398876.21962.6.camel@mulgrave.site>
	<4C078FE2.9000804@vlnb.net>
	<AANLkTinnrsFZ=nkX4QpG2eKOk05uNe5HpV-pP3kd7OF=@mail.gmail.com>
	<4C49EA91.3060908@vlnb.net>
Date: Fri, 23 Jul 2010 16:51:58 -0400
Message-ID: <AANLkTi=OhopP4qud6EVffrNU3jLrA2KzRca=a4T9GhHx@mail.gmail.com>
Subject: Re: Wrong DIF guard tag on ext2 write
From: Gennadiy Nerubayev <parakie@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Boaz Harrosh <bharrosh@panasas.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 3:16 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Gennadiy Nerubayev, on 07/23/2010 09:59 PM wrote:
>>
>> On Thu, Jun 3, 2010 at 7:20 AM, Vladislav Bolkhovitin<vst@vlnb.net>
>>  wrote:
>>>
>>> James Bottomley, on 06/01/2010 05:27 PM wrote:
>>>>
>>>> On Tue, 2010-06-01 at 12:30 +0200, Christof Schmitt wrote:
>>>>>
>>>>> What is the best strategy to continue with the invalid guard tags on
>>>>> write requests? Should this be fixed in the filesystems?
>>>>
>>>> For write requests, as long as the page dirty bit is still set, it's
>>>> safe to drop the request, since it's already going to be repeated.  What
>>>> we probably want is an error code we can return that the layer that sees
>>>> both the request and the page flags can make the call.
>>>>
>>>>> Another idea would be to pass invalid guard tags on write requests
>>>>> down to the hardware, expect an "invalid guard tag" error and report
>>>>> it to the block layer where a new checksum is generated and the
>>>>> request is issued again. Basically implement a retry through the whole
>>>>> I/O stack. But this also sounds complicated.
>>>>
>>>> No, no ... as long as the guard tag is wrong because the fs changed the
>>>> page, the write request for the updated page will already be queued or
>>>> in-flight, so there's no need to retry.
>>>
>>> There's one interesting problem here, at least theoretically, with SCSI
>>> or similar transports which allow to have commands queue depth>1 and allowed
>>> to internally reorder queued requests. I don't know the FS/block layers
>>> sufficiently well to tell if sending several requests for the same page
>>> really possible or not, but we can see a real life problem, which can be
>>> well explained if it's possible.
>>>
>>> The problem could be if the second (rewrite) request (SCSI command) for
>>> the same page queued to the corresponding device before the original request
>>> finished. Since the device allowed to freely reorder requests, there's a
>>> probability that the original write request would hit the permanent storage
>>> *AFTER* the retry request, hence the data changes it's carrying would be
>>> lost, hence welcome data corruption.
>>>
>>> For single parallel SCSI or SAS devices such race may look practically
>>> impossible, but for sophisticated clusters when many nodes pretending to be
>>> a single SCSI device in a load balancing configuration, it becomes very
>>> real.
>>>
>>> The real life problem we can see in an active-active DRBD-setup. In this
>>> configuration 2 nodes act as a single SCST-powered SCSI device and they both
>>> run DRBD to keep their backstorage in-sync. The initiator uses them as a
>>> single multipath device in an active-active round-robin load-balancing
>>> configuration, i.e. sends requests to both nodes in parallel, then DRBD
>>> takes care to replicate the requests to the other node.
>>>
>>> The problem is that sometimes DRBD complies about concurrent local
>>> writes, like:
>>>
>>> kernel: drbd0: scsi_tgt0[12503] Concurrent local write detected! [DISCARD
>>> L] new: 144072784s +8192; pending: 144072784s +8192
>>>
>>> This message means that DRBD detected that both nodes received
>>> overlapping writes on the same block(s) and DRBD can't figure out which one
>>> to store. This is possible only if the initiator sent the second write
>>> request before the first one completed.
>>>
>>> The topic of the discussion could well explain the cause of that. But,
>>> unfortunately, people who reported it forgot to note which OS they run on
>>> the initiator, i.e. I can't say for sure it's Linux.
>>
>> Sorry for the late chime in, but here's some more information of
>> potential interest as I've previously inquired about this to the drbd
>> mailing list:
>>
>> 1. It only happens when using blockio mode in IET or SCST. Fileio,
>> nv_cache, and write_through do not generate the warnings.
>
> Some explanations for those who not familiar with the terminology:
>
>  - "Fileio" means Linux IO stack on the target receives IO via
> vfs_readv()/vfs_writev()
>
>  - "NV_CACHE" means all the cache synchronization requests
> (SYNCHRONIZE_CACHE, FUA) from the initiator are ignored
>
>  - "WRITE_THROUGH" means write through, i.e. the corresponding backend file
> for the device open with O_SYNC flag.
>
>> 2. It happens on active/passive drbd clusters (on the active node
>> obviously), NOT active/active. In fact, I've found that doing round
>> robin on active/active is a Bad Idea (tm) even with a clustered
>> filesystem, until at least the target software is able to synchronize
>> the command state of either node.
>> 3. Linux and ESX initiators can generate the warning, but I've so far
>> only been able to reliably reproduce it using a Windows initiator and
>> sqlio or iometer benchmarks. I'll be trying again using iometer when I
>> have the time.
>> 4. It only happens using a random write io workload (any block size),
>> with initiator threads>1, OR initiator queue depth>1. The higher
>> either of those is, the more spammy the warnings become.
>> 5. The transport does not matter (reproduced with iSCSI and SRP)
>> 6. If DRBD is disconnected (primary/unknown), the warnings are not
>> generated. As soon as it's reconnected (primary/secondary), the
>> warnings will reappear.
>
> It would be great if you prove or disprove our suspicions that Linux can
> produce several write requests for the same blocks simultaneously. To be
> sure we need:
>
> 1. The initiator is Linux. Windows and ESX are not needed for this
> particular case.
>
> 2. If you are able to reproduce it, we will need full description of which
> application used on the initiator to generate the load and in which mode.
>
> Target and DRBD configuration doesn't matter, you can use any.

I just tried, and this particular DRBD warning is not reproducible
with io (iometer) coming from a Linux initiator (2.6.30.10) The same
iometer parameters were used as on windows, and both the base device
as well as filesystem (ext3) were tested, both negative. I'll try a
few more tests, but it seems that this is a nonissue with a Linux
initiator.

Hope that helps,

-Gennadiy
